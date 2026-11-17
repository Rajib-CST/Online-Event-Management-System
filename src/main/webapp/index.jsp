<% request.setAttribute("pageTitle", "Welcome"); %>
<%@ include file="header.jsp" %>

<div class="hero">
    <div class="hero-pill">
        <i class="fa-solid fa-sparkles"></i> The Modern Way to Organize Events
    </div>
    <h1>Plan &amp; Celebrate Your Perfect Event</h1>
    <p>Rent premium chairs, tables, lighting, DJ systems, and exquisite decor from verified local vendors. Compare availability in real time, customize your items, and book with seamless digital checkout.</p>
    
    <div class="btn-row" style="justify-content:center;gap:16px;">
        <a class="btn btn-lg btn-accent" href="<%=request.getContextPath()%>/signup.jsp">
            <i class="fa-solid fa-rocket"></i> Get Started Free
        </a>
        <a class="btn btn-lg btn-secondary" href="<%=request.getContextPath()%>/login.jsp">
            <i class="fa-solid fa-arrow-right-to-bracket"></i> Customer Login
        </a>
    </div>

    <div class="feature-grid">
        <div class="feature-box">
            <div class="feature-icon">
                <i class="fa-solid fa-shield-check"></i>
            </div>
            <h4>Verified Vendors</h4>
            <p>Quality-checked local equipment suppliers ready for any event scale.</p>
        </div>
        <div class="feature-box">
            <div class="feature-icon">
                <i class="fa-solid fa-calendar-days"></i>
            </div>
            <h4>Live Availability</h4>
            <p>Check dates and real-time inventory instantly without phone calls.</p>
        </div>
        <div class="feature-box">
            <div class="feature-icon">
                <i class="fa-solid fa-tags"></i>
            </div>
            <h4>Transparent Pricing</h4>
            <p>Clear per-day rates with no hidden fees and detailed receipt summaries.</p>
        </div>
        <div class="feature-box">
            <div class="feature-icon">
                <i class="fa-solid fa-lock"></i>
            </div>
            <h4>Secure Checkout</h4>
            <p>Automated payment processing with instant booking confirmation.</p>
        </div>
    </div>
</div>

<div class="card" style="margin-top:32px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:20px;background:linear-gradient(135deg, rgba(79,70,229,0.05) 0%, rgba(124,58,237,0.05) 100%);">
    <div>
        <h3 style="margin:0;color:var(--text);"><i class="fa-solid fa-store" style="color:var(--primary);"></i> Are you an event supplier or vendor?</h3>
        <p class="text-muted" style="margin:4px 0 0 0;">Partner with EventArrange to manage your inventory, accept customer orders, and grow your rentals.</p>
    </div>
    <div style="display:flex;gap:12px;">
        <a class="btn btn-outline btn-sm" href="<%=request.getContextPath()%>/vendorLogin.jsp">Vendor Portal</a>
        <a class="btn btn-sm" href="<%=request.getContextPath()%>/vendorSignup.jsp">Vendor Register</a>
    </div>
</div>

<%@ include file="footer.jsp" %>
