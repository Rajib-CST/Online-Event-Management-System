package controller;

import dao.VendorDAO;	
import model.Vendor;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/** Admin: Add / Update / Delete vendors. GET lists, POST performs the action named by "action". */
public class VendorManagementServlet extends HttpServlet {

    private final VendorDAO vendorDAO = new VendorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Vendor> vendors = vendorDAO.getAllVendors();
            request.setAttribute("vendors", vendors);

            String editId = request.getParameter("editVendorId");
            if (editId != null) {
                request.setAttribute("editVendor", vendorDAO.getVendorById(Integer.parseInt(editId)));
            }
            request.getRequestDispatcher("/manageVendors.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while loading vendors.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                Vendor v = new Vendor();
                v.setVendorName(request.getParameter("vendorName"));
                v.setEmail(request.getParameter("email"));
                v.setPassword(request.getParameter("password"));
                v.setContact(request.getParameter("contact"));
                v.setAddress(request.getParameter("address"));
                v.setDescription(request.getParameter("description"));
                v.setSecurityQuestion(request.getParameter("securityQuestion"));
                v.setSecurityAnswer(request.getParameter("securityAnswer"));
                v.setBankAccountId(Integer.parseInt(request.getParameter("bankAccountId")));
                vendorDAO.addVendor(v);

            } else if ("update".equals(action)) {
                Vendor v = new Vendor();
                v.setVendorId(Integer.parseInt(request.getParameter("vendorId")));
                v.setVendorName(request.getParameter("vendorName"));
                v.setEmail(request.getParameter("email"));
                v.setPassword(request.getParameter("password"));
                v.setContact(request.getParameter("contact"));
                v.setAddress(request.getParameter("address"));
                v.setDescription(request.getParameter("description"));
                v.setSecurityQuestion(request.getParameter("securityQuestion"));
                v.setSecurityAnswer(request.getParameter("securityAnswer"));
                v.setBankAccountId(Integer.parseInt(request.getParameter("bankAccountId")));
                vendorDAO.updateVendor(v);

            } else if ("delete".equals(action)) {
                vendorDAO.deleteVendor(Integer.parseInt(request.getParameter("vendorId")));
            }
            response.sendRedirect(request.getContextPath() + "/VendorManagementServlet");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while managing vendors.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
