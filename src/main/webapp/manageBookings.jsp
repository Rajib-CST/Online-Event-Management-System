<%@ page import="java.util.List, model.Booking, model.BookingItem, model.User" %>
<% request.setAttribute("pageTitle", "Bookings & Customers"); %>
<%@ include file="adminHeader.jsp" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    List<User> customers = (List<User>) request.getAttribute("customers");
%>

<div class="card" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:14px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);">
    <div>
        <h2 style="margin:0;"><i class="fa-solid fa-calendar-check" style="color:var(--primary);"></i> Reservations &amp; Customer Accounts</h2>
        <p class="text-muted" style="margin:4px 0 0 0;">Monitor all event orders placed across the platform and registered customer profiles.</p>
    </div>
    <div>
        <a class="btn btn-secondary btn-sm" href="<%=request.getContextPath()%>/adminDashboard.jsp">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</div>

<!-- All Bookings Section -->
<div class="card">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
        <h3 style="margin:0;"><i class="fa-solid fa-receipt" style="color:var(--primary);"></i> All Platform Bookings</h3>
        <span class="badge badge-neutral"><%= bookings != null ? bookings.size() : 0 %> Orders</span>
    </div>

    <div class="table-wrap">
    <table>
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>Customer</th>
                <th>Vendor</th>
                <th>Event Type</th>
                <th>Event Date</th>
                <th>Total Value</th>
                <th>Status</th>
                <th>Cancellation Log</th>
                <th style="text-align:right;">Refund</th>
            </tr>
        </thead>
        <tbody>
            <% if (bookings != null && !bookings.isEmpty()) {
                 for (Booking b : bookings) { %>
            <tr>
                <td><strong>#B<%= b.getBookingId() %></strong></td>
                <td><span class="badge badge-neutral"><i class="fa-solid fa-user"></i> User #<%= b.getUserId() %></span></td>
                <td><strong><%= b.getVendorName() %></strong></td>
                <td><%= b.getEventType() %></td>
                <td><%= b.getEventDate() %></td>
                <td><strong style="color:var(--primary-dark);">&#8377;<%= b.getTotalAmount() %></strong></td>
                <td>
                    <% if ("CONFIRMED".equalsIgnoreCase(b.getBookingStatus())) { %>
                        <span class="badge badge-success"><i class="fa-solid fa-circle-check"></i> CONFIRMED</span>
                    <% } else if ("COMPLETED".equalsIgnoreCase(b.getBookingStatus()) || "COMPLETE".equalsIgnoreCase(b.getBookingStatus())) { %>
                        <span class="badge badge-completed"><i class="fa-solid fa-circle-check"></i> COMPLETED</span>
                    <% } else { %>
                        <span class="badge badge-danger"><i class="fa-solid fa-circle-xmark"></i> <%= b.getBookingStatus() %></span>
                    <% } %>
                </td>
                <td style="font-size:0.85rem;color:var(--text-secondary);">
                    <%= b.getCancellationReason() != null ? "<strong>" + b.getCancelledBy() + ":</strong> " + b.getCancellationReason() : "-" %>
                </td>
                <td style="text-align:right;">
                    &#8377;<%= b.getRefundAmount() != null ? b.getRefundAmount() : "0.00" %>
                </td>
            </tr>
            <% } } else { %>
            <tr>
                <td colspan="9" style="text-align:center;padding:32px;color:var(--text-muted);">
                    No bookings recorded in the system yet.
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    </div>
</div>

<!-- Registered Customers Section -->
<div class="card">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
        <h3 style="margin:0;"><i class="fa-solid fa-users" style="color:var(--primary);"></i> Registered Customers</h3>
        <span class="badge badge-neutral"><%= customers != null ? customers.size() : 0 %> Customers</span>
    </div>

    <div class="table-wrap">
    <table>
        <thead>
            <tr>
                <th>Customer ID</th>
                <th>Full Name</th>
                <th>Email Address</th>
                <th>Contact Phone</th>
                <th style="text-align:right;">Registration Date</th>
            </tr>
        </thead>
        <tbody>
            <% if (customers != null && !customers.isEmpty()) {
                 for (User u : customers) { %>
            <tr>
                <td><strong>#<%= u.getUserId() %></strong></td>
                <td>
                    <div style="display:flex;align-items:center;gap:8px;">
                        <div style="width:30px;height:30px;border-radius:50%;background:var(--primary-subtle);color:var(--primary);display:flex;align-items:center;justify-content:center;font-size:0.8rem;">
                            <i class="fa-solid fa-user"></i>
                        </div>
                        <strong><%= u.getName() %></strong>
                    </div>
                </td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getContact() %></td>
                <td style="text-align:right;" class="text-muted"><%= u.getCreatedAt() %></td>
            </tr>
            <% } } else { %>
            <tr>
                <td colspan="5" style="text-align:center;padding:32px;color:var(--text-muted);">
                    No customers registered yet.
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    </div>
</div>

<%@ include file="footer.jsp" %>
