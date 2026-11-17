package controller;

import dao.ItemDAO;
import dao.VendorDAO;
import dao.VendorItemDAO;
import model.Item;
import model.Vendor;
import model.VendorItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/** Admin: Add items to the catalog, and add/update vendor-specific price+stock (vendor_items). */
public class ItemManagementServlet extends HttpServlet {

    private final ItemDAO itemDAO = new ItemDAO();
    private final VendorDAO vendorDAO = new VendorDAO();
    private final VendorItemDAO vendorItemDAO = new VendorItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Item> items = itemDAO.getAllItems();
            List<Vendor> vendors = vendorDAO.getAllVendors();
            request.setAttribute("items", items);
            request.setAttribute("vendors", vendors);

            String vendorIdParam = request.getParameter("vendorId");
            if (vendorIdParam != null) {
                int vendorId = Integer.parseInt(vendorIdParam);
                List<VendorItem> inventory = vendorItemDAO.getInventoryByVendor(vendorId);
                request.setAttribute("selectedVendorId", vendorId);
                request.setAttribute("inventory", inventory);
            }
            request.getRequestDispatcher("/manageItems.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while loading items.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        try {
            if ("addItem".equals(action)) {
                Item item = new Item();
                item.setItemName(request.getParameter("itemName"));
                item.setDescription(request.getParameter("description"));
                itemDAO.addItem(item);

            } else if ("setVendorPrice".equals(action)) {
                int vendorId = Integer.parseInt(request.getParameter("vendorId"));
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                int stock = Integer.parseInt(request.getParameter("stock"));
                vendorItemDAO.upsertVendorItem(vendorId, itemId, price, stock);
                response.sendRedirect(request.getContextPath() + "/ItemManagementServlet?vendorId=" + vendorId);
                return;
            }
            response.sendRedirect(request.getContextPath() + "/ItemManagementServlet");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while managing items.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
