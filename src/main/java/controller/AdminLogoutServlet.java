package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AdminLogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            // Only clear admin attributes - if this browser also has a customer
            // session active, that one is left untouched (separate sessions in
            // practice, but defensive either way).
            session.removeAttribute("adminId");
            session.removeAttribute("adminName");
            session.removeAttribute("adminLoggedIn");
        }
        response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
    }
}
