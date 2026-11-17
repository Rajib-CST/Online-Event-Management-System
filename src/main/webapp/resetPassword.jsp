<% request.setAttribute("pageTitle", "Reset Password"); %>
<%@ include file="header.jsp" %>

<div class="auth-wrapper">
    <div class="card">
        <div class="auth-header">
            <div class="auth-icon-badge" style="background:#ecfdf5;color:#059669;">
                <i class="fa-solid fa-lock-open"></i>
            </div>
            <h2>Set New Password</h2>
            <p>Create a fresh, secure password for your account</p>
        </div>

        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% }
           String email = (String) request.getAttribute("email");
           String accountType = (String) request.getAttribute("accountType");
           boolean isVendor = "VENDOR".equalsIgnoreCase(accountType);
        %>

        <form action="<%=request.getContextPath()%>/ResetPasswordServlet" method="post">
            <input type="hidden" name="email" value="<%= email %>">
            <input type="hidden" name="accountType" value="<%= accountType != null ? accountType : "" %>">
            <div class="form-group">
                <label><i class="fa-solid fa-lock"></i> New Password</label>
                <input type="password" name="newPassword" placeholder="Enter new password" required autofocus>
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-shield-check"></i> Confirm New Password</label>
                <input type="password" name="confirmPassword" placeholder="Re-enter new password" required>
            </div>
            <button type="submit" class="btn btn-success btn-lg" style="width:100%;">
                <i class="fa-solid fa-check-double"></i> Update Password &amp; Login
            </button>
        </form>

        <div class="auth-links">
            <% if (isVendor) { %>
                <a href="<%=request.getContextPath()%>/vendorLogin.jsp"><i class="fa-solid fa-store"></i> Return to Vendor Login</a>
            <% } else { %>
                <a href="<%=request.getContextPath()%>/login.jsp"><i class="fa-solid fa-user"></i> Return to Customer Login</a>
            <% } %>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
