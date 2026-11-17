package controller;

import dao.VendorDAO;


import model.Vendor;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import util.BookingRules;

public class AvailabilityServlet extends HttpServlet {

    private final VendorDAO vendorDAO = new VendorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String eventType = request.getParameter("eventType");
        String eventDateStr = request.getParameter("eventDate");
        String location = request.getParameter("location");
        int days;
        try {
            days = Integer.parseInt(request.getParameter("days"));
        } catch (NumberFormatException e) {
            days = 0;
        }

        if (eventType == null || eventType.isEmpty() || eventDateStr == null || eventDateStr.isEmpty()
                || !BookingRules.isValidLocation(location) || !BookingRules.isValidDays(days)) {
            request.setAttribute("error", "Please select an event type, date, location, and 1 to 7 days.");
            request.getRequestDispatcher("/home.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("eventType", eventType);
        session.setAttribute("eventDate", eventDateStr);
        session.setAttribute("location", location);
        session.setAttribute("bookingDays", days);

        try {
            Date eventDate = Date.valueOf(eventDateStr);
            List<Vendor> vendors = vendorDAO.getAllVendors();
            for (Vendor v : vendors) {
                v.setAvailable(vendorDAO.isVendorAvailable(v.getVendorId(), eventDate));
            }
            request.setAttribute("vendors", vendors);
            request.getRequestDispatcher("/vendors.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while checking availability.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
