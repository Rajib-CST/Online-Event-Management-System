<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Portal Login | EventArrange</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Outfit:wght@400;500;600;700;800;900&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="container" style="display:flex;align-items:center;justify-content:center;min-height:90vh;">
    <div class="auth-wrapper">
        <div class="card" style="box-shadow:var(--shadow-lg);">
            <div class="auth-header">
                <div class="auth-icon-badge" style="background:#1e1b4b;color:#f59e0b;">
                    <i class="fa-solid fa-shield-halved"></i>
                </div>
                <h2>Admin Portal</h2>
                <p>Authorized access only &bull; System management console</p>
            </div>

            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>

            <form action="<%=request.getContextPath()%>/AdminLoginServlet" method="post">
                <div class="form-group">
                    <label><i class="fa-solid fa-envelope"></i> Administrator Email</label>
                    <input type="email" name="email" placeholder="admin@eventarrange.com" required autofocus>
                </div>
                <div class="form-group">
                    <label><i class="fa-solid fa-lock"></i> Security Password</label>
                    <input type="password" name="password" placeholder="Enter administrative password" required>
                </div>
                <button type="submit" class="btn btn-lg" style="width:100%;background:linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);">
                    <i class="fa-solid fa-key"></i> Authenticate &amp; Enter
                </button>
            </form>

            <div class="auth-links">
                <a href="<%=request.getContextPath()%>/index.jsp"><i class="fa-solid fa-arrow-left"></i> Return to Main Website</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
