<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vendor Portal Login | EventArrange</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Outfit:wght@400;500;600;700;800;900&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="container" style="display:flex;align-items:center;justify-content:center;min-height:90vh;">
    <div class="auth-wrapper">
        <div class="card">
            <div class="auth-header">
                <div class="auth-icon-badge" style="background:#fffbeb;color:#f59e0b;">
                    <i class="fa-solid fa-store"></i>
                </div>
                <h2>Vendor Portal</h2>
                <p>Manage your rental catalog, bookings &amp; payouts</p>
            </div>

            <% if ("true".equals(request.getParameter("resetSuccess"))) { %>
                <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Password reset successfully! Please sign in with your new password.</div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="<%=request.getContextPath()%>/VendorLoginServlet" method="post">
                <div class="form-group">
                    <label><i class="fa-solid fa-envelope"></i> Vendor Email</label>
                    <input type="email" name="email" placeholder="vendor@example.com" required autofocus>
                </div>
                <div class="form-group">
                    <div style="display:flex;justify-content:space-between;align-items:center;">
                        <label style="margin:0;"><i class="fa-solid fa-lock"></i> Password</label>
                        <a href="<%=request.getContextPath()%>/forgotPassword.jsp?role=vendor" style="font-size:0.84rem;color:var(--primary);font-weight:600;">
                            Forgot Password?
                        </a>
                    </div>
                    <input type="password" name="password" placeholder="Enter your password" required style="margin-top:6px;">
                </div>
                <button class="btn btn-accent btn-lg" type="submit" style="width:100%;margin-top:10px;">
                    <span>Access Vendor Dashboard</span> <i class="fa-solid fa-arrow-right"></i>
                </button>
            </form>

            <div class="auth-links">
                New vendor? <a href="<%=request.getContextPath()%>/vendorSignup.jsp">Register as a Partner</a>
                <div style="margin-top:14px;display:flex;justify-content:center;gap:16px;font-size:0.84rem;">
                    <a href="<%=request.getContextPath()%>/login.jsp"><i class="fa-solid fa-user"></i> Customer Login</a>
                    <span>&bull;</span>
                    <a href="<%=request.getContextPath()%>/index.jsp"><i class="fa-solid fa-house"></i> Home</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>