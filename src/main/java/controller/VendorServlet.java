package controller;

import dao.VendorDAO;

import dao.VendorItemDAO;
import model.Vendor;
import model.VendorItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/** Handles "Select Vendor" from vendors.jsp -> loads items.jsp with that vendor's live inventory. */
public class VendorServlet extends HttpServlet {

    private final VendorDAO vendorDAO = new VendorDAO();
    private final VendorItemDAO vendorItemDAO = new VendorItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int vendorId;
        try {
            vendorId = Integer.parseInt(request.getParameter("vendorId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/vendors.jsp");
            return;
        }

        HttpSession session = request.getSession();
        String eventDateStr = (String) session.getAttribute("eventDate");
        if (eventDateStr == null) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }

        try {
            // Re-verify availability server-side - never trust that the link wasn't tampered with.
            boolean available = vendorDAO.isVendorAvailable(vendorId, Date.valueOf(eventDateStr));
            if (!available) {
                request.setAttribute("error", "This vendor is no longer available on the selected date.");
                request.getRequestDispatcher("/vendors.jsp").forward(request, response);
                return;
            }

            Vendor vendor = vendorDAO.getVendorById(vendorId);
            List<VendorItem> inventory = vendorItemDAO.getInventoryByVendor(vendorId);

            session.setAttribute("vendorId", vendorId);
            request.setAttribute("vendor", vendor);
            request.setAttribute("inventory", inventory);
            request.getRequestDispatcher("/items.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while loading vendor items.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
