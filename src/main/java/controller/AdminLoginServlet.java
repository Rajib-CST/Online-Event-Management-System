package controller;

import dao.AdminDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

public class AdminLoginServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            AdminDAO.AdminInfo admin = adminDAO.validateLogin(email, password);
            if (admin != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("adminId", admin.adminId);
                session.setAttribute("adminName", admin.adminName);
                session.setAttribute("adminLoggedIn", true);
                response.sendRedirect(request.getContextPath() + "/adminDashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid admin email or password.");
                request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred during admin login.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
