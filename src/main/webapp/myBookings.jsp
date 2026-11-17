<%@ page import="java.util.List, model.Booking, model.BookingItem" %>
<% request.setAttribute("pageTitle", "My Bookings"); %>
<%@ include file="header.jsp" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>

<div class="card" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:14px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);">
    <div>
        <h2 style="margin:0;"><i class="fa-solid fa-calendar-check" style="color:var(--primary);"></i> My Event Bookings</h2>
        <p class="text-muted" style="margin:4px 0 0 0;">View current reservations, track event equipment details, and manage cancellations.</p>
    </div>
    <div>
        <a class="btn btn-accent" href="<%=request.getContextPath()%>/home.jsp">
            <i class="fa-solid fa-plus-circle"></i> Create New Booking
        </a>
    </div>
</div>

<% String flashMessage = (String) request.getAttribute("flashMessage");
   if (flashMessage != null) { %>
    <div class="alert alert-success"><%= flashMessage %></div>
<% } %>

<% if (bookings == null || bookings.isEmpty()) { %>
    <div class="card" style="text-align:center;padding:48px 20px;">
        <div style="font-size:3.5rem;color:var(--text-light);margin-bottom:16px;">
            <i class="fa-solid fa-calendar-xmark"></i>
        </div>
        <h3>No Bookings Found</h3>
        <p class="text-muted">You haven't booked any event equipment yet. Create your first booking now!</p>
        <div class="btn-row" style="justify-content:center;margin-top:20px;">
            <a class="btn btn-accent btn-lg" href="<%=request.getContextPath()%>/home.jsp">
                <i class="fa-solid fa-wand-magic-sparkles"></i> Plan an Event
            </a>
        </div>
    </div>
<% } else {
     for (Booking b : bookings) { %>
<div class="card" style="margin-bottom:24px;">
    <div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:12px;padding-bottom:16px;border-bottom:1px solid var(--border);">
        <div>
            <div style="display:flex;align-items:center;gap:10px;">
                <span class="badge badge-info" style="font-size:0.9rem;padding:6px 12px;">#B<%= b.getBookingId() %></span>
                <h3 style="margin:0;"><%= b.getEventType() %></h3>
            </div>
            <div style="display:flex;gap:16px;flex-wrap:wrap;margin-top:8px;font-size:0.88rem;color:var(--text-secondary);">
                <span><i class="fa-solid fa-store" style="color:var(--primary);"></i> <strong><%= b.getVendorName() %></strong></span>
                <span><i class="fa-solid fa-calendar-day" style="color:var(--primary);"></i> <%= b.getEventDate() %></span>
            </div>
        </div>
        <div style="text-align:right;">
            <% if ("CONFIRMED".equalsIgnoreCase(b.getBookingStatus())) { %>
                <span class="badge badge-success" style="font-size:0.85rem;"><i class="fa-solid fa-circle-check"></i> CONFIRMED</span>
            <% } else if ("COMPLETED".equalsIgnoreCase(b.getBookingStatus()) || "COMPLETE".equalsIgnoreCase(b.getBookingStatus())) { %>
                <span class="badge badge-completed" style="font-size:0.85rem;"><i class="fa-solid fa-circle-check"></i> COMPLETED</span>
            <% } else { %>
                <span class="badge badge-danger" style="font-size:0.85rem;"><i class="fa-solid fa-circle-xmark"></i> <%= b.getBookingStatus() %></span>
            <% } %>
            <div style="font-family:'Outfit',sans-serif;font-weight:800;font-size:1.35rem;color:var(--primary-dark);margin-top:4px;">
                &#8377;<%= b.getTotalAmount() %>
            </div>
        </div>
    </div>

    <div class="table-wrap" style="margin:16px 0;">
    <table>
        <thead>
            <tr>
                <th>Reserved Item</th>
                <th>Quantity</th>
                <th style="text-align:right;">Subtotal</th>
            </tr>
        </thead>
        <tbody>
            <% if (b.getItems() != null) for (BookingItem bi : b.getItems()) { %>
            <tr>
                <td><%= bi.getItemName() %></td>
                <td><%= bi.getQuantity() %></td>
                <td style="text-align:right;">&#8377;<%= bi.getSubtotal() %></td>
            </tr>
            <% } %>
        </tbody>
    </table>
    </div>

    <% if (b.getCancellationReason() != null) { 
        String byWhom = b.getCancelledBy();
        if ("CUSTOMER".equalsIgnoreCase(byWhom)) {
            byWhom = "you";
        }
    %>
    <div style="background:var(--danger-bg);border:1px solid var(--danger-border);border-radius:10px;padding:14px 18px;margin:14px 0;font-size:0.9rem;">
        <div><strong><i class="fa-solid fa-ban" style="color:var(--danger);"></i> Cancelled by:</strong> <%= byWhom %></div>
        <div style="margin-top:4px;"><strong>Reason:</strong> <%= b.getCancellationReason() %></div>
        <div style="margin-top:4px;"><strong>Refund Issued:</strong> &#8377;<%= b.getRefundAmount() %></div>
    </div>
    <% } %>

    <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;margin-top:14px;padding-top:14px;border-top:1px solid var(--border);">
        <div>
            <% if ("CONFIRMED".equals(b.getBookingStatus())) { %>
            <form action="<%=request.getContextPath()%>/CancellationServlet" method="post" style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">
                <input type="hidden" name="bookingId" value="<%=b.getBookingId()%>">
                <input type="text" name="reason" placeholder="Reason for cancellation" required style="max-width:240px;padding:6px 12px;font-size:0.86rem;">
                <button class="btn btn-sm btn-danger" type="submit" onclick="return confirm('Cancel this booking? Note: 70% refund if customer cancels.');">
                    <i class="fa-solid fa-ban"></i> Cancel Booking
                </button>
            </form>
            <% } %>
        </div>
        <div>
            <a class="btn btn-sm btn-secondary" href="<%=request.getContextPath()%>/BookingDetailsServlet?bookingId=<%= b.getBookingId() %>">
                <i class="fa-solid fa-file-invoice"></i> View Invoice Details
            </a>
        </div>
    </div>
</div>
<% } } %>

<%@ include file="footer.jsp" %>
