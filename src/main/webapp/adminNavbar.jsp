<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String adminName = (String) session.getAttribute("adminName");
    Boolean adminLoggedIn = (Boolean) session.getAttribute("adminLoggedIn");
    String uri = request.getRequestURI();
%>
<div class="navbar">
    <a href="<%=request.getContextPath()%>/adminDashboard.jsp" class="brand">
        <i class="fa-solid fa-shield-halved"></i>
        <span>EventArrange</span>
        <span class="role-badge">ADMIN</span>
    </a>
    <ul>
        <% if (adminLoggedIn != null && adminLoggedIn) { %>
            <li><a href="<%=request.getContextPath()%>/adminDashboard.jsp"
                   class="<%= uri.endsWith("adminDashboard.jsp") ? "active" : "" %>"><i class="fa-solid fa-chart-pie"></i> Dashboard</a></li>
            <li><a href="<%=request.getContextPath()%>/VendorManagementServlet"
                   class="<%= uri.contains("VendorManagement") ? "active" : "" %>"><i class="fa-solid fa-store"></i> Vendors</a></li>
            <li><a href="<%=request.getContextPath()%>/ItemManagementServlet"
                   class="<%= uri.contains("ItemManagement") ? "active" : "" %>"><i class="fa-solid fa-boxes-stacked"></i> Items</a></li>
            <li><a href="<%=request.getContextPath()%>/BookingManagementServlet"
                   class="<%= uri.contains("BookingManagement") ? "active" : "" %>"><i class="fa-solid fa-calendar-check"></i> Bookings</a></li>
            <li><a href="<%=request.getContextPath()%>/PaymentManagementServlet"
                   class="<%= uri.contains("PaymentManagement") ? "active" : "" %>"><i class="fa-solid fa-credit-card"></i> Payments</a></li>
            <li><a href="<%=request.getContextPath()%>/AdminLogoutServlet"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout (<%= adminName %>)</a></li>
        <% } %>
    </ul>
</div>
