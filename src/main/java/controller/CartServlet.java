package controller;

import model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/** Handles "Update Cart" (change quantity) and "Remove" from cart.jsp. */
public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }

        String action = request.getParameter("action");
        int itemId;
        try {
            itemId = Integer.parseInt(request.getParameter("itemId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
            return;
        }

        if ("remove".equals(action)) {
            cart.removeIf(ci -> ci.getItemId() == itemId);
        } else if ("update".equals(action)) {
            int newQty;
            try {
                newQty = Integer.parseInt(request.getParameter("quantity"));
            } catch (NumberFormatException e) {
                newQty = 0;
            }
            final int qty = newQty;
            for (CartItem ci : cart) {
                if (ci.getItemId() == itemId) {
                    if (qty <= 0) {
                        cart.remove(ci);
                    } else {
                        ci.setQuantity(qty);
                        ci.setSubtotal(ci.getUnitPrice().multiply(BigDecimal.valueOf(qty)));
                    }
                    break;
                }
            }
        }

        session.setAttribute("cart", cart);
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
    }
}
