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
import java.util.List;

/** Always scoped to the logged-in user's userId from the session - never a request parameter. */
public class MyBookingsServlet extends HttpServlet {

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

        try {
            List<Booking> bookings = bookingDAO.getBookingsForUser(userId);
            for (Booking b : bookings) {
                b.setItems(bookingDAO.getItemsForBooking(b.getBookingId()));
            }
            request.setAttribute("bookings", bookings);
            request.setAttribute("flashMessage", session.getAttribute("flashMessage"));
            session.removeAttribute("flashMessage");
            request.getRequestDispatcher("/myBookings.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while loading your bookings.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
