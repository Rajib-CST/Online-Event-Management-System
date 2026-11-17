<% request.setAttribute("pageTitle", "Admin Dashboard"); %>
<%@ include file="adminHeader.jsp" %>

<div class="card" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:20px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);">
    <div style="display:flex;align-items:center;gap:18px;">
        <div style="width:60px;height:60px;border-radius:16px;background:var(--primary-subtle);color:var(--primary);display:flex;align-items:center;justify-content:center;font-size:1.8rem;box-shadow:0 4px 12px rgba(79,70,229,0.15);">
            <i class="fa-solid fa-user-shield"></i>
        </div>
        <div>
            <div style="display:flex;align-items:center;gap:10px;">
                <h2 style="margin:0;">Welcome back, <%= session.getAttribute("adminName") %></h2>
                <span class="badge badge-success"><i class="fa-solid fa-circle-check"></i> System Active</span>
            </div>
            <p class="text-muted" style="margin:4px 0 0 0;">Control center for managing vendors, catalog inventory, customer bookings, and financial settlements.</p>
        </div>
    </div>
    <div>
        <a class="btn btn-secondary btn-sm" href="<%=request.getContextPath()%>/BookingManagementServlet">
            <i class="fa-solid fa-list-check"></i> View Live Bookings
        </a>
    </div>
</div>

<div class="grid-2">
    <div class="stat-card">
        <div>
            <div class="stat-icon blue">
                <i class="fa-solid fa-store"></i>
            </div>
            <h3>Vendor Network</h3>
            <p>Add, edit, or remove partner vendors, manage profiles, contact details, and linked banking accounts.</p>
        </div>
        <div>
            <a class="btn btn-sm" href="<%=request.getContextPath()%>/VendorManagementServlet">
                <span>Manage Vendors</span>
                <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>
    </div>

    <div class="stat-card">
        <div>
            <div class="stat-icon purple">
                <i class="fa-solid fa-boxes-stacked"></i>
            </div>
            <h3>Items &amp; Inventory</h3>
            <p>Create global catalog items, configure per-vendor stock allocations, and set daily rental price rates.</p>
        </div>
        <div>
            <a class="btn btn-sm" href="<%=request.getContextPath()%>/ItemManagementServlet">
                <span>Manage Items</span>
                <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>
    </div>

    <div class="stat-card">
        <div>
            <div class="stat-icon emerald">
                <i class="fa-solid fa-calendar-check"></i>
            </div>
            <h3>Bookings &amp; Customers</h3>
            <p>Monitor event schedules, manage confirmed reservations, track cancellations, and view registered user profiles.</p>
        </div>
        <div>
            <a class="btn btn-sm" href="<%=request.getContextPath()%>/BookingManagementServlet">
                <span>View Bookings / Customers</span>
                <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>
    </div>

    <div class="stat-card">
        <div>
            <div class="stat-icon amber">
                <i class="fa-solid fa-wallet"></i>
            </div>
            <h3>Payments &amp; Revenue</h3>
            <p>Audit transaction logs, monitor 10% admin commissions, and track 90% vendor payout disbursements.</p>
        </div>
        <div>
            <a class="btn btn-sm btn-accent" href="<%=request.getContextPath()%>/PaymentManagementServlet">
                <span>View Payments</span>
                <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
