<%@ page import="java.util.List, model.Booking" %>
<% request.setAttribute("pageTitle", "Vendor Bookings"); %>
<%@ include file="header.jsp" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String flashMessage = (String) request.getAttribute("flashMessage");
%>

<div class="card" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:14px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);">
    <div>
        <h2 style="margin:0;"><i class="fa-solid fa-calendar-check" style="color:var(--primary);"></i> Vendor Event Bookings</h2>
        <p class="text-muted" style="margin:4px 0 0 0;">Inspect orders booked for your inventory and manage order cancellations if necessary.</p>
    </div>
    <div>
        <a class="btn btn-secondary btn-sm" href="<%=request.getContextPath()%>/VendorDashboardServlet">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</div>

<% if (flashMessage != null) { %>
    <div class="alert alert-success"><%= flashMessage %></div>
<% } %>

<% if (bookings == null || bookings.isEmpty()) { %>
    <div class="card" style="text-align:center;padding:48px 20px;">
        <div style="font-size:3.5rem;color:var(--text-light);margin-bottom:16px;">
            <i class="fa-solid fa-calendar-xmark"></i>
        </div>
        <h3>No Customer Bookings Yet</h3>
        <p class="text-muted">Your equipment bookings will appear here once customers place orders.</p>
    </div>
<% } else {
     for (Booking booking : bookings) { %>
    <div class="card" style="margin-bottom:20px;">
        <div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:12px;padding-bottom:14px;border-bottom:1px solid var(--border);">
            <div>
                <div style="display:flex;align-items:center;gap:10px;">
                    <span class="badge badge-info" style="font-size:0.9rem;">#B<%= booking.getBookingId() %></span>
                    <h3 style="margin:0;"><%= booking.getEventType() %></h3>
                </div>
                <div style="display:flex;gap:16px;flex-wrap:wrap;margin-top:6px;font-size:0.88rem;color:var(--text-secondary);">
                    <span><i class="fa-solid fa-calendar-day" style="color:var(--primary);"></i> <%= booking.getEventDate() %></span>
                </div>
            </div>
            <div style="text-align:right;">
                <% if ("CONFIRMED".equalsIgnoreCase(booking.getBookingStatus())) { %>
                    <span class="badge badge-success"><i class="fa-solid fa-circle-check"></i> CONFIRMED</span>
                <% } else if ("COMPLETED".equalsIgnoreCase(booking.getBookingStatus()) || "COMPLETE".equalsIgnoreCase(booking.getBookingStatus())) { %>
                    <span class="badge badge-completed"><i class="fa-solid fa-circle-check"></i> COMPLETED</span>
                <% } else { %>
                    <span class="badge badge-danger"><i class="fa-solid fa-circle-xmark"></i> <%= booking.getBookingStatus() %></span>
                <% } %>
                <div style="font-family:'Outfit',sans-serif;font-weight:800;font-size:1.35rem;color:var(--primary-dark);margin-top:4px;">
                    &#8377;<%= booking.getTotalAmount() %>
                </div>
            </div>
        </div>

        <% if (booking.getCancellationReason() != null) { %>
        <div style="background:var(--danger-bg);border:1px solid var(--danger-border);border-radius:10px;padding:14px 18px;margin-top:14px;font-size:0.9rem;">
            <div><strong><i class="fa-solid fa-ban" style="color:var(--danger);"></i> Cancelled by:</strong> <%= booking.getCancelledBy() %></div>
            <div style="margin-top:4px;"><strong>Reason:</strong> <%= booking.getCancellationReason() %></div>
            <div style="margin-top:4px;"><strong>Customer Refund:</strong> &#8377;<%= booking.getRefundAmount() %></div>
        </div>
        <% } %>

        <% if ("CONFIRMED".equals(booking.getBookingStatus())) { %>
        <div style="margin-top:16px;padding-top:14px;border-top:1px solid var(--border);">
            <form action="<%=request.getContextPath()%>/CancellationServlet" method="post" style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
                <input type="hidden" name="bookingId" value="<%=booking.getBookingId()%>">
                <input name="reason" placeholder="Reason for vendor cancellation" required style="max-width:280px;padding:6px 12px;font-size:0.86rem;">
                <button class="btn btn-sm btn-danger" type="submit" onclick="return confirm('Cancel this booking and refund 90% to the customer?')">
                    <i class="fa-solid fa-ban"></i> Cancel Booking &amp; Refund
                </button>
            </form>
        </div>
        <% } %>
    </div>
<% } } %>

<%@ include file="footer.jsp" %>
