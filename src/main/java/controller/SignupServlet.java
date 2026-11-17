package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

public class SignupServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = trim(request.getParameter("name"));
        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");
        String contact = trim(request.getParameter("contact"));
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String securityQuestion = request.getParameter("securityQuestion");
        String securityAnswer = trim(request.getParameter("securityAnswer"));

        if (isBlank(name) || isBlank(email) || isBlank(password) || isBlank(contact)
                || isBlank(securityQuestion) || isBlank(securityAnswer)) {
            forwardWithError(request, response, "All required fields must be filled in.");
            return;
        }

        try {
            if (userDAO.emailExists(email)) {
                forwardWithError(request, response, "An account with this email already exists.");
                return;
            }

            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password); // Demo project: stored as plain text, clearly noted.
            user.setContact(contact);
            user.setGender(gender);
            if (dobStr != null && !dobStr.isEmpty()) {
                user.setDob(LocalDate.parse(dobStr));
            }
            user.setSecurityQuestion(securityQuestion);
            user.setSecurityAnswer(securityAnswer);

            int newId = userDAO.registerUser(user);
            if (newId > 0) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?signup=success");
            } else {
                forwardWithError(request, response, "Signup failed. Please try again.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred during signup.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/signup.jsp").forward(request, response);
    }

    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
    private String trim(String s) { return s == null ? null : s.trim(); }
}
