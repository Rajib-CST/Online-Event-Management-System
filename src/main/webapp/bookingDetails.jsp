<%@ page import="model.Booking, model.BookingItem, java.util.List" %>
<% request.setAttribute("pageTitle", "Booking Details"); %>
<%@ include file="header.jsp" %>
<%
    Booking booking = (Booking) request.getAttribute("booking");
%>

<!-- Professional 6-Step Stepper -->
<jsp:include page="bookingStepper.jsp">
    <jsp:param name="step" value="6"/>
</jsp:include>

<div class="card" style="max-width:850px;margin:0 auto;box-shadow:var(--shadow-lg);">
    <div class="receipt-header">
        <div>
            <div style="display:flex;align-items:center;gap:10px;">
                <span class="badge badge-info" style="font-size:0.9rem;padding:6px 14px;">Invoice #B<%= booking.getBookingId() %></span>
                <% if ("CONFIRMED".equalsIgnoreCase(booking.getBookingStatus())) { %>
                    <span class="badge badge-success"><i class="fa-solid fa-circle-check"></i> CONFIRMED</span>
                <% } else if ("COMPLETED".equalsIgnoreCase(booking.getBookingStatus()) || "COMPLETE".equalsIgnoreCase(booking.getBookingStatus())) { %>
                    <span class="badge badge-completed"><i class="fa-solid fa-circle-check"></i> COMPLETED</span>
                <% } else { %>
                    <span class="badge badge-danger"><i class="fa-solid fa-circle-xmark"></i> <%= booking.getBookingStatus() %></span>
                <% } %>
            </div>
            <h2 style="margin:10px 0 4px;"><i class="fa-solid fa-file-invoice" style="color:var(--primary);"></i> Reservation Order Invoice</h2>
            <p class="text-muted" style="margin:0;">Created on: <%= booking.getCreatedAt() %></p>
        </div>
        <div>
            <button onclick="window.print()" class="btn btn-secondary btn-sm">
                <i class="fa-solid fa-print"></i> Print Receipt
            </button>
        </div>
    </div>

    <div class="receipt-grid" style="background:#f8fafc;padding:20px;border-radius:12px;border:1px solid var(--border);margin-bottom:24px;">
        <div class="receipt-item">
            <span><i class="fa-solid fa-store"></i> Assigned Vendor</span>
            <span><%= booking.getVendorName() %></span>
        </div>
        <div class="receipt-item">
            <span><i class="fa-solid fa-cake-candles"></i> Event Type</span>
            <span><%= booking.getEventType() %></span>
        </div>
        <div class="receipt-item">
            <span><i class="fa-solid fa-calendar-day"></i> Reserved Event Date</span>
            <span><%= booking.getEventDate() %></span>
        </div>
        <div class="receipt-item">
            <span><i class="fa-solid fa-clock-rotate-left"></i> Booking Placed</span>
            <span><%= booking.getCreatedAt() %></span>
        </div>
    </div>

    <% if (booking.getCancellationReason() != null) { 
        String byWhom = booking.getCancelledBy();
        if ("CUSTOMER".equalsIgnoreCase(byWhom) && (session.getAttribute("userId") != null || "CUSTOMER".equalsIgnoreCase((String) session.getAttribute("role")))) {
            byWhom = "you";
        }
    %>
    <div style="background:var(--danger-bg);border:1px solid var(--danger-border);border-radius:10px;padding:16px 20px;margin-bottom:24px;">
        <h4 style="color:var(--danger-dark);margin:0 0 6px;"><i class="fa-solid fa-ban"></i> Cancellation Information</h4>
        <p style="margin:0 0 4px;"><strong>Cancelled by:</strong> <%= byWhom %></p>
        <p style="margin:0 0 4px;"><strong>Reason:</strong> <%= booking.getCancellationReason() %></p>
        <p style="margin:0;"><strong>Refund Processed:</strong> &#8377;<%= booking.getRefundAmount() %></p>
    </div>
    <% } %>

    <h4 style="margin:0 0 12px;color:var(--text);"><i class="fa-solid fa-boxes-stacked" style="color:var(--primary);"></i> Equipment &amp; Service Items</h4>
    
    <div class="table-wrap">
    <table>
        <thead>
            <tr>
                <th>Item Description</th>
                <th>Quantity</th>
                <th>Price / Day</th>
                <th style="text-align:right;">Subtotal</th>
            </tr>
        </thead>
        <tbody>
            <% List<BookingItem> items = booking.getItems();
               if (items != null) for (BookingItem bi : items) { %>
            <tr>
                <td><strong><%= bi.getItemName() %></strong></td>
                <td><%= bi.getQuantity() %></td>
                <td>&#8377;<%= bi.getUnitPrice() %> / day</td>
                <td style="text-align:right;"><strong>&#8377;<%= bi.getSubtotal() %></strong></td>
            </tr>
            <% } %>
        </tbody>
    </table>
    </div>

    <div class="summary-total" style="font-size:1.6rem;padding-top:16px;">
        Grand Total Amount: <span style="color:var(--primary);">&#8377;<%= booking.getTotalAmount() %></span>
    </div>

    <div class="btn-row" style="justify-content:flex-start;margin-top:24px;">
        <a class="btn btn-secondary" href="<%=request.getContextPath()%>/MyBookingsServlet">
            <i class="fa-solid fa-arrow-left"></i> Back to My Bookings
        </a>
    </div>
</div>

<%@ include file="footer.jsp" %>
