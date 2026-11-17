package controller;

import dao.UserDAO;
import dao.VendorDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class ResetPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final VendorDAO vendorDAO = new VendorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String accountType = request.getParameter("accountType");

        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("email", email);
            request.setAttribute("accountType", accountType);
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            return;
        }

        try {
            boolean updated = false;
            if ("VENDOR".equalsIgnoreCase(accountType)) {
                updated = vendorDAO.updatePassword(email, newPassword);
            } else {
                updated = userDAO.updatePassword(email, newPassword);
                if (!updated) {
                    // Try vendor as fallback
                    updated = vendorDAO.updatePassword(email, newPassword);
                    if (updated) accountType = "VENDOR";
                }
            }

            if (updated) {
                if ("VENDOR".equalsIgnoreCase(accountType)) {
                    response.sendRedirect(request.getContextPath() + "/vendorLogin.jsp?resetSuccess=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/login.jsp?resetSuccess=true");
                }
            } else {
                request.setAttribute("error", "Could not reset password. Please try again.");
                request.setAttribute("email", email);
                request.setAttribute("accountType", accountType);
                request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
