package controller;

import dao.VendorDAO;
import dao.VendorItemDAO;
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
import java.sql.SQLException;
import java.util.List;
import util.BookingRules;

/**
 * "Proceed to Booking" from cart.jsp -> re-validates every item's live
 * price/stock from MySQL one more time and shows bookingSummary.jsp.
 * The actual booking row is only inserted inside PaymentServlet's
 * transaction (a booking should not exist until payment is attempted).
 */
public class BookingServlet extends HttpServlet {

    private final VendorDAO vendorDAO = new VendorDAO();
    private final VendorItemDAO vendorItemDAO = new VendorItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        Integer vendorId = (Integer) session.getAttribute("vendorId");
        String eventType = (String) session.getAttribute("eventType");
        String eventDate = (String) session.getAttribute("eventDate");
        String location = (String) session.getAttribute("location");
        Integer days = (Integer) session.getAttribute("bookingDays");

        if (cart == null || cart.isEmpty() || vendorId == null || eventDate == null
            || !BookingRules.isValidLocation(location) || days == null || !BookingRules.isValidDays(days)) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }

        try {
            Vendor vendor = vendorDAO.getVendorById(vendorId);
            BigDecimal total = BigDecimal.ZERO;

            for (CartItem ci : cart) {
                VendorItem vi = vendorItemDAO.getVendorItem(vendorId, ci.getItemId());
                if (vi == null || ci.getQuantity() > vi.getStock()) {
                    request.setAttribute("error",
                        "Stock changed for '" + ci.getItemName() + "'. Please update your cart.");
                    request.getRequestDispatcher("/cart.jsp").forward(request, response);
                    return;
                }
                // Recalculate from the DB price, ignoring whatever the session cached earlier.
                ci.setUnitPrice(vi.getPrice());
                ci.setSubtotal(vi.getPrice().multiply(BigDecimal.valueOf(ci.getQuantity()))
                    .multiply(BigDecimal.valueOf(days)));
                total = total.add(ci.getSubtotal());
            }

            request.setAttribute("vendor", vendor);
            request.setAttribute("eventType", eventType);
            request.setAttribute("eventDate", eventDate);
            request.setAttribute("location", location);
            request.setAttribute("bookingDays", days);
            request.setAttribute("cart", cart);
            request.setAttribute("totalAmount", total);
            session.setAttribute("bookingTotal", total);

            request.getRequestDispatcher("/bookingSummary.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while preparing the booking summary.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
