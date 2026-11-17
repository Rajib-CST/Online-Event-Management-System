<%@ page import="java.util.List, model.CartItem, model.Vendor" %>
<% request.setAttribute("pageTitle", "Booking Summary"); %>
<%@ include file="header.jsp" %>
<%
    Vendor vendor = (Vendor) request.getAttribute("vendor");
    List<CartItem> cart = (List<CartItem>) request.getAttribute("cart");
    java.math.BigDecimal totalAmount = new java.math.BigDecimal(String.valueOf(request.getAttribute("totalAmount")));
    boolean meetsMinimum = totalAmount.compareTo(new java.math.BigDecimal("5000.00")) >= 0;
%>

<!-- Professional 6-Step Stepper -->
<jsp:include page="bookingStepper.jsp">
    <jsp:param name="step" value="4"/>
</jsp:include>

<div class="card" style="max-width:850px;margin:0 auto;box-shadow:var(--shadow-lg);">
    <div class="receipt-header">
        <div>
            <span class="badge badge-warning" style="margin-bottom:8px;">
                <i class="fa-solid fa-clock"></i> Step 4 of 6: Pre-payment Price Review
            </span>
            <h2 style="margin:0;"><i class="fa-solid fa-receipt" style="color:var(--primary);"></i> Booking Summary</h2>
            <p class="text-muted" style="margin:4px 0 0 0;">Please review your order details before continuing to secure payment.</p>
        </div>
        <div class="receipt-pill">
            <i class="fa-solid fa-shield-halved"></i> Verified Order
        </div>
    </div>

    <div class="receipt-grid" style="background:#f8fafc;padding:20px;border-radius:12px;border:1px solid var(--border);">
        <div class="receipt-item">
            <span><i class="fa-solid fa-user"></i> Customer</span>
            <span><%= session.getAttribute("userName") %></span>
        </div>
        <div class="receipt-item">
            <span><i class="fa-solid fa-store"></i> Vendor</span>
            <span><%= vendor != null ? vendor.getVendorName() : "Selected Vendor" %></span>
        </div>
        <div class="receipt-item">
            <span><i class="fa-solid fa-cake-candles"></i> Event Type</span>
            <span><%= request.getAttribute("eventType") %></span>
        </div>
        <div class="receipt-item">
            <span><i class="fa-solid fa-calendar-day"></i> Event Date</span>
            <span><%= request.getAttribute("eventDate") %></span>
        </div>
        <div class="receipt-item">
            <span><i class="fa-solid fa-location-dot"></i> Location</span>
            <span><%= request.getAttribute("location") %></span>
        </div>
        <div class="receipt-item">
            <span><i class="fa-solid fa-hourglass-half"></i> Duration</span>
            <span><%= request.getAttribute("bookingDays") %> day(s)</span>
        </div>
    </div>

    <h4 style="margin:24px 0 12px;color:var(--text);"><i class="fa-solid fa-boxes-stacked" style="color:var(--primary);"></i> Selected Equipment Breakdown</h4>
    
    <div class="table-wrap">
    <table>
        <thead>
            <tr>
                <th>Item</th>
                <th>Quantity</th>
                <th>Price / Day</th>
                <th style="text-align:right;">Subtotal for Selected Days</th>
            </tr>
        </thead>
        <tbody>
            <% if (cart != null) for (CartItem ci : cart) { %>
            <tr>
                <td>
                    <strong><%= ci.getItemName() %></strong>
                </td>
                <td><%= ci.getQuantity() %></td>
                <td>&#8377;<%= ci.getUnitPrice() %> <span style="font-size:0.75rem;color:var(--text-muted);">/ day</span></td>
                <td style="text-align:right;"><strong>&#8377;<%= ci.getSubtotal() %></strong></td>
            </tr>
            <% } %>
        </tbody>
    </table>
    </div>

    <div class="summary-total" style="font-size:1.6rem;padding:20px 0 0;">
        Grand Total: <span style="color:var(--primary);">&#8377;<%= request.getAttribute("totalAmount") %></span>
    </div>
    <p class="<%= meetsMinimum ? "text-muted" : "minimum-checkout-warning" %>" style="text-align:right;margin-top:6px;">
        Minimum checkout amount: <strong>&#8377;5,000</strong>
        <% if (!meetsMinimum) { %>
            — add <strong>&#8377;<%= new java.math.BigDecimal("5000.00").subtract(totalAmount) %></strong> to continue.
        <% } %>
    </p>

    <div class="btn-row" style="justify-content:flex-end;margin-top:24px;">
        <a class="btn btn-secondary" href="<%=request.getContextPath()%>/cart.jsp">
            <i class="fa-solid fa-arrow-left"></i> Edit Cart
        </a>
        <% if (meetsMinimum) { %>
        <a class="btn btn-accent btn-lg" href="<%=request.getContextPath()%>/payment.jsp">
            <i class="fa-solid fa-credit-card"></i> Proceed to Payment
        </a>
        <% } else { %>
        <button class="btn btn-accent btn-lg" type="button" disabled title="Booking total must be at least ₹5,000">
            <i class="fa-solid fa-lock"></i> Minimum ₹5,000 Required
        </button>
        <% } %>
    </div>
</div>

<%@ include file="footer.jsp" %>
