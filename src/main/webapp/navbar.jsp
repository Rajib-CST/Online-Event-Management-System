<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    boolean isLoggedIn = (loggedIn != null && loggedIn);
    String uri = request.getRequestURI();
%>
<div class="navbar">
    <a href="<%=request.getContextPath()%>/index.jsp" class="brand">
        <i class="fa-solid fa-wand-magic-sparkles"></i>
        <span>EventArrange</span>
    </a>
    <ul>
        <% if (isLoggedIn) { %>
            <li><a href="<%=request.getContextPath()%>/home.jsp"
                   class="<%= uri.endsWith("home.jsp") ? "active" : "" %>"><i class="fa-solid fa-house"></i> Home</a></li>
            <li><a href="<%=request.getContextPath()%>/MyBookingsServlet"
                   class="<%= uri.contains("MyBookings") || uri.contains("bookingDetails") ? "active" : "" %>"><i class="fa-solid fa-calendar-check"></i> My Bookings</a></li>
            <li><a href="<%=request.getContextPath()%>/vendors.jsp"
                   class="<%= uri.endsWith("vendors.jsp") ? "active" : "" %>"><i class="fa-solid fa-circle-plus"></i> New Booking</a></li>
            <li><a href="<%=request.getContextPath()%>/LogoutServlet"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout (<%= userName %>)</a></li>
        <% } else if (Boolean.TRUE.equals(session.getAttribute("vendorLoggedIn"))) { %>
            <li><a href="<%=request.getContextPath()%>/VendorDashboardServlet"><i class="fa-solid fa-gauge-high"></i> Dashboard</a></li>
            <li><a href="<%=request.getContextPath()%>/VendorItemServlet"><i class="fa-solid fa-boxes-stacked"></i> Items</a></li>
            <li><a href="<%=request.getContextPath()%>/VendorBookingServlet"><i class="fa-solid fa-calendar-check"></i> Bookings</a></li>
            <li><a href="<%=request.getContextPath()%>/VendorProfileServlet"><i class="fa-solid fa-user-tie"></i> Profile</a></li>
            <li><a href="<%=request.getContextPath()%>/VendorLogoutServlet"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout (<%= session.getAttribute("vendorName") %>)</a></li>
        <% } else { %>
            <li><a href="<%=request.getContextPath()%>/login.jsp"><i class="fa-solid fa-user"></i> Customer Login</a></li>
            <li><a href="<%=request.getContextPath()%>/signup.jsp"><i class="fa-solid fa-user-plus"></i> Sign Up</a></li>
            <li><a href="<%=request.getContextPath()%>/vendorLogin.jsp"><i class="fa-solid fa-store"></i> Vendor Portal</a></li>
        <% } %>
    </ul>
</div>
