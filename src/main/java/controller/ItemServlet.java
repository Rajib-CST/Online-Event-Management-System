package controller;

import dao.VendorItemDAO;
import model.CartItem;
import model.VendorItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Receives the quantities submitted from items.jsp. Re-reads price/stock from
 * MySQL for every line (never trusts the browser-submitted price/subtotal),
 * builds the session cart, then forwards to cart.jsp.
 */
public class ItemServlet extends HttpServlet {

    private final VendorItemDAO vendorItemDAO = new VendorItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer vendorId = (Integer) session.getAttribute("vendorId");
        if (vendorId == null) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }

        String[] itemIds = request.getParameterValues("itemId");
        String[] quantities = request.getParameterValues("quantity");

        if (itemIds == null || quantities == null) {
            response.sendRedirect(request.getContextPath() + "/vendors.jsp");
            return;
        }

        try {
            List<CartItem> cart = new ArrayList<>();
            for (int i = 0; i < itemIds.length; i++) {
                int itemId = Integer.parseInt(itemIds[i]);
                int qty;
                try {
                    qty = Integer.parseInt(quantities[i]);
                } catch (NumberFormatException e) {
                    qty = 0;
                }
                if (qty <= 0) continue;

                VendorItem vi = vendorItemDAO.getVendorItem(vendorId, itemId);
                if (vi == null) continue;

                // Server-side stock cap - never trust the client-side JS cap alone.
                if (qty > vi.getStock()) qty = vi.getStock();
                if (qty <= 0) continue;

                cart.add(new CartItem(itemId, vi.getItemName(), qty, vi.getPrice()));
            }

            if (cart.isEmpty()) {
                request.setAttribute("error", "Please select at least one item with a valid quantity.");
                doGetInventory(request, response, vendorId);
                return;
            }

            session.setAttribute("cart", cart);
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while processing items.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void doGetInventory(HttpServletRequest request, HttpServletResponse response, int vendorId)
            throws ServletException, IOException, SQLException {
        request.setAttribute("inventory", vendorItemDAO.getInventoryByVendor(vendorId));
        request.getRequestDispatcher("/items.jsp").forward(request, response);
    }
}
