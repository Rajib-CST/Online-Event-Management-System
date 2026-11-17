<%@ page import="java.util.*,model.Booking" %>
<% request.setAttribute("pageTitle","Vendor Dashboard"); %>
<%@ include file="header.jsp" %>

<div class="card" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:20px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);">
    <div style="display:flex;align-items:center;gap:18px;">
        <div style="width:60px;height:60px;border-radius:16px;background:#fffbeb;color:#f59e0b;display:flex;align-items:center;justify-content:center;font-size:1.8rem;box-shadow:0 4px 12px rgba(245,158,11,0.2);">
            <i class="fa-solid fa-store"></i>
        </div>
        <div>
            <div style="display:flex;align-items:center;gap:10px;">
                <h2 style="margin:0;"><%= session.getAttribute("vendorName") %></h2>
                <span class="badge badge-success"><i class="fa-solid fa-circle-check"></i> Vendor Partner</span>
            </div>
            <p class="text-muted" style="margin:4px 0 0 0;">Manage your inventory catalog, inspect incoming event reservations, and track earnings.</p>
        </div>
    </div>
    <div>
        <a class="btn btn-secondary btn-sm" href="<%=request.getContextPath()%>/VendorLogoutServlet">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Vendor Logout
        </a>
    </div>
</div>

<div class="grid-3" style="margin-bottom:24px;">
    <div class="stat-card">
        <div>
            <div class="stat-icon purple">
                <i class="fa-solid fa-boxes-stacked"></i>
            </div>
            <h3>Equipment Catalog</h3>
            <p>Set daily rental prices, manage stock quantities, and toggle availability.</p>
        </div>
        <a class="btn btn-sm" href="<%=request.getContextPath()%>/VendorItemServlet">
            <span>Manage Inventory</span> <i class="fa-solid fa-arrow-right"></i>
        </a>
    </div>

    <div class="stat-card">
        <div>
            <div class="stat-icon emerald">
                <i class="fa-solid fa-calendar-check"></i>
            </div>
            <h3>Bookings &amp; Orders</h3>
            <p>Review customer reservations, track event dates, and handle cancellations.</p>
        </div>
        <a class="btn btn-sm" href="<%=request.getContextPath()%>/VendorBookingServlet">
            <span>View Bookings</span> <i class="fa-solid fa-arrow-right"></i>
        </a>
    </div>

    <div class="stat-card">
        <div>
            <div class="stat-icon amber">
                <i class="fa-solid fa-wallet"></i>
            </div>
            <h3>Profile &amp; Bank Account</h3>
            <p>Review business address, contact info, and linked payout account balance.</p>
        </div>
        <a class="btn btn-sm btn-accent" href="<%=request.getContextPath()%>/VendorProfileServlet">
            <span>View Profile &amp; Earnings</span> <i class="fa-solid fa-arrow-right"></i>
        </a>
    </div>
</div>

<% List<Booking> b = (List<Booking>) request.getAttribute("bookings"); 
   if (b != null && !b.isEmpty()) { %>
<div class="card">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
        <h3 style="margin:0;"><i class="fa-solid fa-list-check" style="color:var(--primary);"></i> Recent Bookings</h3>
        <span class="badge badge-neutral"><%= b.size() %> Total Bookings</span>
    </div>
    
    <div class="table-wrap">
    <table>
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>Event Type</th>
                <th>Event Date</th>
                <th>Total Value</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <% for (Booking x : b) { %>
            <tr>
                <td><strong>#B<%= x.getBookingId() %></strong></td>
                <td><%= x.getEventType() %></td>
                <td><%= x.getEventDate() %></td>
                <td><strong style="color:var(--primary-dark);">&#8377;<%= x.getTotalAmount() %></strong></td>
                <td>
                    <% if ("CONFIRMED".equalsIgnoreCase(x.getBookingStatus())) { %>
                        <span class="badge badge-success"><i class="fa-solid fa-circle-check"></i> CONFIRMED</span>
                    <% } else if ("COMPLETED".equalsIgnoreCase(x.getBookingStatus()) || "COMPLETE".equalsIgnoreCase(x.getBookingStatus())) { %>
                        <span class="badge badge-completed"><i class="fa-solid fa-circle-check"></i> COMPLETED</span>
                    <% } else { %>
                        <span class="badge badge-danger"><i class="fa-solid fa-circle-xmark"></i> <%= x.getBookingStatus() %></span>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    </div>
</div>
<% } %>

<%@ include file="footer.jsp" %>