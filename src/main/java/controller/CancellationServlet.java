package controller;

import dao.BankAccountDAO;
import dao.BookingDAO;
import dao.DBConnection;
import dao.PaymentDAO;
import dao.RefundDAO;
import dao.VendorDAO;
import dao.VendorItemDAO;
import model.Booking;
import model.BookingItem;
import model.Payment;
import model.Vendor;
import util.BookingRules;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.util.UUID;

public class CancellationServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final BankAccountDAO bankAccountDAO = new BankAccountDAO();
    private final VendorDAO vendorDAO = new VendorDAO();
    private final VendorItemDAO vendorItemDAO = new VendorItemDAO();
    private final RefundDAO refundDAO = new RefundDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        String role = (String) session.getAttribute("role");
        boolean loggedInCustomer = Boolean.TRUE.equals(session.getAttribute("loggedIn"));
        if (!"VENDOR".equals(role) && !loggedInCustomer) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(request.getParameter("bookingId"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/MyBookingsServlet");
            return;
        }
        String reason = request.getParameter("reason");
        if (reason == null || reason.trim().isEmpty()) {
            request.setAttribute("errorMessage", "A cancellation reason is required.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        reason = reason.trim();
        boolean customer = !"VENDOR".equalsIgnoreCase(role);
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);
            Booking booking = bookingDAO.getBookingForUpdate(connection, bookingId);
            if (booking == null) throw new Exception("Booking not found.");
            if (customer) {
                Integer userId = (Integer) session.getAttribute("userId");
                if (userId == null || booking.getUserId() != userId) throw new Exception("You cannot cancel this booking.");
            } else {
                Integer vendorId = (Integer) session.getAttribute("vendorId");
                if (vendorId == null || booking.getVendorId() != vendorId) throw new Exception("You cannot cancel this booking.");
            }
            if (!"CONFIRMED".equals(booking.getBookingStatus())) throw new Exception("Only confirmed bookings can be cancelled.");
            if (!BookingRules.canCancel(booking.getEventDate())) throw new Exception("Cancellation is allowed only when at least 5 days remain before the event.");
            if (refundDAO.exists(connection, bookingId)) throw new Exception("This booking has already been refunded.");

            Payment payment = paymentDAO.getPaymentByBookingForUpdate(connection, bookingId);
            if (payment == null) throw new Exception("Successful payment not found.");
            BigDecimal total = payment.getAmount();
            BigDecimal customerRefund = customer
                    ? total.multiply(new BigDecimal("0.70")).setScale(2, RoundingMode.HALF_UP)
                    : total.multiply(new BigDecimal("0.90")).setScale(2, RoundingMode.HALF_UP);
                BigDecimal vendorDeduction = customerRefund;
            BigDecimal adminRetained = payment.getAdminAmount();

            if (!bankAccountDAO.debit(connection, payment.getCustomerAccountId(), BigDecimal.ZERO)) {
                throw new Exception("Customer account check failed.");
            }
            if (!bankAccountDAO.credit(connection, payment.getCustomerAccountId(), customerRefund)) {
                throw new Exception("Customer refund failed.");
            }
            Vendor vendor = vendorDAO.getVendorById(connection, booking.getVendorId());
            if (vendor == null || !bankAccountDAO.debit(connection, vendor.getBankAccountId(), vendorDeduction)) {
                throw new Exception("Vendor refund deduction failed.");
            }
            for (BookingItem item : booking.getItems()) {
                if (!vendorItemDAO.restoreStock(connection, booking.getVendorId(), item.getItemId(), item.getQuantity())) {
                    throw new Exception("Could not restore item stock.");
                }
            }

            String cancelledBy = customer ? "CUSTOMER" : "VENDOR";
            String status = customer ? "CUSTOMER_CANCELLED" : "VENDOR_CANCELLED";
            if (!bookingDAO.cancelBooking(connection, bookingId, status, cancelledBy, reason, customerRefund)) {
                throw new Exception("Booking cancellation failed.");
            }
            String transactionId = "REF" + UUID.randomUUID().toString().replace("-", "").substring(0, 12).toUpperCase();
            refundDAO.insert(connection, bookingId, payment.getPaymentId(), cancelledBy,
                    total, customerRefund, vendorDeduction, adminRetained, "SUCCESS", transactionId, reason);
            connection.commit();

            session.setAttribute("flashMessage", "Booking B" + bookingId + " has been cancelled. Reason: "
                    + reason + ". Refund: INR " + customerRefund
                    + ". The cancellation is visible to the customer, vendor, and admin.");
            String destination = customer ? "/MyBookingsServlet" : "/VendorBookingServlet";
            response.sendRedirect(request.getContextPath() + destination);
        } catch (Exception e) {
            try { if (connection != null) connection.rollback(); } catch (Exception ignored) { }
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } finally {
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                    connection.close();
                }
            } catch (Exception ignored) { }
        }
    }
}
