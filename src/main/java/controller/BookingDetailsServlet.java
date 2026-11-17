package controller;

import dao.BookingDAO;
import model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Loads one booking's full detail. Passes BOTH bookingId and the session
 * userId to the DAO so a customer can never view another customer's
 * booking by guessing the bookingId in the URL.
 */
public class BookingDetailsServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(request.getParameter("bookingId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/MyBookingsServlet");
            return;
        }

        try {
            Booking booking = bookingDAO.getBookingByIdForUser(bookingId, userId);
            if (booking == null) {
                // Either doesn't exist or belongs to someone else - identical response either way.
                request.setAttribute("errorMessage", "Booking not found.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/bookingDetails.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while loading booking details.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
