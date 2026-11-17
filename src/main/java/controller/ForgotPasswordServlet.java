package controller;

import dao.UserDAO;
import dao.VendorDAO;
import model.User;
import model.Vendor;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Two-step flow, both POSTs land here distinguished by the "step" hidden field:
 *   step=findEmail   -> look up the security question for the given email (User or Vendor)
 *   step=verifyAnswer -> check the answer, then forward to resetPassword.jsp
 */
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final VendorDAO vendorDAO = new VendorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String step = request.getParameter("step");
        String role = request.getParameter("role");

        try {
            if ("findEmail".equals(step)) {
                String email = request.getParameter("email");
                String question = null;
                String accountType = "USER";

                User user = userDAO.findByEmail(email);
                if (user != null) {
                    question = user.getSecurityQuestion();
                    accountType = "USER";
                } else {
                    Vendor vendor = vendorDAO.findByEmail(email);
                    if (vendor != null) {
                        question = vendor.getSecurityQuestion();
                        accountType = "VENDOR";
                    }
                }

                if (question == null) {
                    request.setAttribute("error", "No customer or vendor account found with that email address.");
                    request.setAttribute("role", role);
                    request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
                    return;
                }

                request.setAttribute("email", email);
                request.setAttribute("securityQuestion", question);
                request.setAttribute("accountType", accountType);
                request.setAttribute("role", role);
                request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);

            } else if ("verifyAnswer".equals(step)) {
                String email = request.getParameter("email");
                String answer = request.getParameter("securityAnswer");
                String accountType = request.getParameter("accountType");

                boolean verified = false;
                String currentQuestion = null;

                if ("VENDOR".equalsIgnoreCase(accountType)) {
                    Vendor vendor = vendorDAO.findByEmail(email);
                    if (vendor != null) {
                        currentQuestion = vendor.getSecurityQuestion();
                        if (vendor.getSecurityAnswer() != null && vendor.getSecurityAnswer().equalsIgnoreCase(answer != null ? answer.trim() : "")) {
                            verified = true;
                        }
                    }
                } else {
                    User user = userDAO.findByEmail(email);
                    if (user != null) {
                        currentQuestion = user.getSecurityQuestion();
                        if (user.getSecurityAnswer() != null && user.getSecurityAnswer().equalsIgnoreCase(answer != null ? answer.trim() : "")) {
                            verified = true;
                        }
                    } else {
                        // Fallback check vendor
                        Vendor vendor = vendorDAO.findByEmail(email);
                        if (vendor != null) {
                            accountType = "VENDOR";
                            currentQuestion = vendor.getSecurityQuestion();
                            if (vendor.getSecurityAnswer() != null && vendor.getSecurityAnswer().equalsIgnoreCase(answer != null ? answer.trim() : "")) {
                                verified = true;
                            }
                        }
                    }
                }

                if (!verified) {
                    request.setAttribute("error", "Incorrect security answer. Please try again.");
                    request.setAttribute("securityQuestion", currentQuestion);
                    request.setAttribute("email", email);
                    request.setAttribute("accountType", accountType);
                    request.setAttribute("role", role);
                    request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
                    return;
                }

                request.setAttribute("email", email);
                request.setAttribute("accountType", accountType);
                request.setAttribute("role", role);
                request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);

            } else {
                response.sendRedirect(request.getContextPath() + "/forgotPassword.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
