<% request.setAttribute("pageTitle", "Customer Login"); %>
<%@ include file="header.jsp" %>

<div class="auth-wrapper">
    <div class="card">
        <div class="auth-header">
            <div class="auth-icon-badge">
                <i class="fa-solid fa-user-lock"></i>
            </div>
            <h2>Customer Login</h2>
            <p>Enter your credentials to access your account &amp; bookings</p>
        </div>

        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% }
           if (request.getParameter("signup") != null) { %>
            <div class="alert alert-success" data-autohide>Account created successfully! Please log in.</div>
        <% }
           if (request.getParameter("resetSuccess") != null) { %>
            <div class="alert alert-success" data-autohide>Password reset successfully! Please log in.</div>
        <% } %>

        <form action="<%=request.getContextPath()%>/LoginServlet" method="post">
            <div class="form-group">
                <label><i class="fa-solid fa-envelope"></i> Email Address</label>
                <input type="email" name="email" placeholder="name@example.com" required autofocus>
            </div>
            <div class="form-group">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
                    <label style="margin:0;"><i class="fa-solid fa-key"></i> Password</label>
                    <a href="<%=request.getContextPath()%>/forgotPassword.jsp" style="font-size:0.82rem;">Forgot?</a>
                </div>
                <input type="password" name="password" placeholder="Enter your password" required>
            </div>
            <button type="submit" class="btn btn-lg" style="width:100%;">
                <span>Sign In</span> <i class="fa-solid fa-arrow-right"></i>
            </button>
        </form>

        <div class="auth-links">
            Don't have an account? <a href="<%=request.getContextPath()%>/signup.jsp">Create one here</a>
            <div style="margin-top:14px;display:flex;justify-content:center;gap:16px;font-size:0.84rem;">
                <a href="<%=request.getContextPath()%>/vendorLogin.jsp"><i class="fa-solid fa-store"></i> Vendor Login</a>
                <span>&bull;</span>
                <a href="<%=request.getContextPath()%>/adminLogin.jsp"><i class="fa-solid fa-shield-halved"></i> Admin Login</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
