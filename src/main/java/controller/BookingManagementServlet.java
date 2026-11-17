package controller;

import dao.BookingDAO;
import dao.UserDAO;
import model.Booking;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/** Admin: View all bookings + registered customers ("View Customers"). */
public class BookingManagementServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Booking> bookings = bookingDAO.getAllBookings();
            for (Booking b : bookings) {
                b.setItems(bookingDAO.getItemsForBooking(b.getBookingId()));
            }
            List<User> customers = userDAO.getAllUsers();

            request.setAttribute("bookings", bookings);
            request.setAttribute("customers", customers);
            request.getRequestDispatcher("/manageBookings.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while loading bookings.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
