package controller;

import dao.*;
import model.BankAccount;
import model.CartItem;
import model.Vendor;
import model.VendorItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import util.BookingRules;

/**
 * Runs the entire booking + payment as a single JDBC transaction.
 * If ANY step fails, the whole transaction is rolled back and the
 * customer is sent to paymentFailed.jsp - nothing partially commits.
 */
public class PaymentServlet extends HttpServlet {

    private final VendorDAO vendorDAO = new VendorDAO();
    private final VendorItemDAO vendorItemDAO = new VendorItemDAO();
    private final BankAccountDAO bankAccountDAO = new BankAccountDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    private static final BigDecimal VENDOR_SHARE = new BigDecimal("0.90");
    private static final BigDecimal ADMIN_SHARE = new BigDecimal("0.10");
    private static final int ADMIN_BANK_ACCOUNT_ID = 7; // seeded admin bank_accounts row

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Integer vendorId = (Integer) session.getAttribute("vendorId");
        String eventType = (String) session.getAttribute("eventType");
        String eventDateStr = (String) session.getAttribute("eventDate");
        String location = (String) session.getAttribute("location");
        Integer days = (Integer) session.getAttribute("bookingDays");
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        String accountNumber = request.getParameter("accountNumber");
        String pin = request.getParameter("pin");

        if (userId == null || vendorId == null || cart == null || cart.isEmpty() || eventDateStr == null
            || !BookingRules.isValidLocation(location) || days == null || !BookingRules.isValidDays(days)) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Verify customer bank account + PIN.
            BankAccount account = bankAccountDAO.getByAccountNumberAndPin(con, accountNumber, pin);
            if (account == null || !"CUSTOMER".equals(account.getAccountType())) {
                fail(request, response, con, "Invalid account number or PIN.");
                return;
            }

            // 2. Verify vendor still exists and is still available on this date.
            Vendor vendor = vendorDAO.getVendorById(con, vendorId);
            Date eventDate = Date.valueOf(eventDateStr);
            if (vendor == null || !vendorDAO.isVendorAvailable(con, vendorId, eventDate)) {
                fail(request, response, con, "This vendor is no longer available for the selected date.");
                return;
            }

            // 3. Re-check every item's live price+stock inside the transaction (authoritative).
            BigDecimal total = BigDecimal.ZERO;
            for (CartItem ci : cart) {
                VendorItem vi = vendorItemDAO.getVendorItem(vendorId, ci.getItemId());
                if (vi == null || ci.getQuantity() > vi.getStock()) {
                    fail(request, response, con, "Stock for '" + ci.getItemName() + "' changed. Please update your cart.");
                    return;
                }
                ci.setUnitPrice(vi.getPrice());
                ci.setSubtotal(vi.getPrice().multiply(BigDecimal.valueOf(ci.getQuantity()))
                    .multiply(BigDecimal.valueOf(days)));
                total = total.add(ci.getSubtotal());
            }

            // 4. Verify sufficient balance.
            if (account.getBalance().compareTo(total) < 0) {
                fail(request, response, con, "Insufficient balance.");
                return;
            }

            // 5. Insert booking (CONFIRMED) + booking_items.
            int bookingId = bookingDAO.insertBooking(con, userId, vendorId, eventType, eventDate, total, "CONFIRMED");
            if (bookingId <= 0) {
                fail(request, response, con, "Could not create booking.");
                return;
            }
            for (CartItem ci : cart) {
                bookingDAO.insertBookingItem(con, bookingId, ci);
                boolean reduced = vendorItemDAO.reduceStock(con, vendorId, ci.getItemId(), ci.getQuantity());
                if (!reduced) {
                    fail(request, response, con, "Stock update failed for '" + ci.getItemName() + "'.");
                    return;
                }
            }

            // 6. Compute 90/10 split.
            BigDecimal vendorAmount = total.multiply(VENDOR_SHARE).setScale(2, RoundingMode.HALF_UP);
            BigDecimal adminAmount = total.subtract(vendorAmount).setScale(2, RoundingMode.HALF_UP);

            // 7. Move money: customer -100%, vendor +90%, admin +10%.
            if (!bankAccountDAO.debit(con, account.getAccountId(), total)) {
                fail(request, response, con, "Payment debit failed.");
                return;
            }
            if (!bankAccountDAO.credit(con, vendor.getBankAccountId(), vendorAmount)) {
                fail(request, response, con, "Vendor credit failed.");
                return;
            }
            if (!bankAccountDAO.credit(con, ADMIN_BANK_ACCOUNT_ID, adminAmount)) {
                fail(request, response, con, "Admin commission credit failed.");
                return;
            }

            // 8. Insert payment record.
            String transactionId = "TXN" + UUID.randomUUID().toString().substring(0, 10).toUpperCase();
            int paymentId = paymentDAO.insertPayment(con, bookingId, userId, vendorId, account.getAccountId(),
                    total, vendorAmount, adminAmount, transactionId, "SUCCESS");
            if (paymentId <= 0) {
                fail(request, response, con, "Could not record payment.");
                return;
            }

            // 9. Commit - all-or-nothing.
            con.commit();

            // Clear the session cart/booking-in-progress state.
            session.removeAttribute("cart");
            session.removeAttribute("vendorId");

            request.setAttribute("transactionId", transactionId);
            request.setAttribute("bookingId", bookingId);
            request.setAttribute("vendorName", vendor.getVendorName());
            request.setAttribute("eventDate", eventDateStr);
            request.setAttribute("location", location);
            request.setAttribute("bookingDays", days);
            request.setAttribute("totalAmount", total);
            request.setAttribute("vendorAmount", vendorAmount);
            request.setAttribute("adminAmount", adminAmount);
            request.getRequestDispatcher("/paymentSuccess.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            rollbackQuietly(con);
            request.setAttribute("error", "A database error occurred during payment. No amount was deducted.");
            try {
                request.getRequestDispatcher("/paymentFailed.jsp").forward(request, response);
            } catch (ServletException se) {
                se.printStackTrace();
            }
        } finally {
            closeQuietly(con);
        }
    }

    private void fail(HttpServletRequest request, HttpServletResponse response, Connection con, String message)
            throws ServletException, IOException {
        rollbackQuietly(con);
        request.setAttribute("error", message);
        request.getRequestDispatcher("/paymentFailed.jsp").forward(request, response);
    }

    private void rollbackQuietly(Connection con) {
        if (con != null) {
            try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }

    private void closeQuietly(Connection con) {
        if (con != null) {
            try { con.setAutoCommit(true); con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }
}
