<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vendor Partner Registration | EventArrange</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Outfit:wght@400;500;600;700;800;900&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="container" style="max-width:820px;padding-top:40px;padding-bottom:40px;">
    <div class="card" style="box-shadow:var(--shadow-lg);">
        <div class="auth-header">
            <div class="auth-icon-badge" style="background:#fffbeb;color:#f59e0b;">
                <i class="fa-solid fa-handshake"></i>
            </div>
            <h2>Vendor Partner Registration</h2>
            <p>Join our event equipment &amp; service vendor network and start receiving customer bookings</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="<%=request.getContextPath()%>/VendorSignupServlet" method="post">
            <h4 style="margin:20px 0 12px;color:var(--primary);"><i class="fa-solid fa-building"></i> 1. Business Profile</h4>
            <div class="grid-2">
                <div class="form-group">
                    <label>Vendor / Company Name</label>
                    <input name="vendorName" placeholder="e.g. Royal Decorators" required autofocus>
                </div>
                <div class="form-group">
                    <label>Business Email</label>
                    <input type="email" name="email" placeholder="vendor@example.com" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Create strong password" required>
                </div>
                <div class="form-group">
                    <label>Contact Phone</label>
                    <input name="contact" placeholder="10-digit mobile number" required>
                </div>
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label>Operational Address / City</label>
                    <input name="address" placeholder="e.g. Asansol, West Bengal">
                </div>
                <div class="form-group">
                    <label>Services Description</label>
                    <input name="description" placeholder="e.g. Chairs, Lighting, Stage, Sounds">
                </div>
            </div>

            <h4 style="margin:20px 0 12px;color:var(--primary);"><i class="fa-solid fa-shield-halved"></i> 2. Security Recovery</h4>
            <div class="grid-2">
                <div class="form-group">
                    <label><i class="fa-solid fa-shield-halved"></i> Security Question (for password recovery)</label>
                    <select name="securityQuestion" required>
                        <option value="">-- Choose a security question --</option>
                        <option value="What is your pet's name?">What is your pet's name?</option>
                        <option value="What is your mother's maiden name?">What is your mother's maiden name?</option>
                        <option value="What was the name of your first school?">What was the name of your first school?</option>
                        <option value="What city were you born in?">What city were you born in?</option>
                        <option value="What is your favorite food?">What is your favorite food?</option>
                        <option value="What was your first business name?">What was your first business name?</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fa-solid fa-key"></i> Security Answer</label>
                    <input name="securityAnswer" placeholder="Your secret answer" required>
                </div>
            </div>

            <h4 style="margin:20px 0 12px;color:var(--primary);"><i class="fa-solid fa-building-columns"></i> 3. Payout Bank Account Details</h4>
            <div class="grid-2">
                <div class="form-group">
                    <label>Bank Account Number</label>
                    <input name="accountNumber" placeholder="Demo Bank Account No." required>
                </div>
                <div class="form-group">
                    <label>Account Holder Name</label>
                    <input name="accountHolder" placeholder="Name on account" required>
                </div>
                <div class="form-group">
                    <label>Bank Name</label>
                    <input name="bankName" value="Demo Bank" required>
                </div>
                <div class="form-group">
                    <label>Account PIN</label>
                    <input type="password" name="pin" placeholder="Bank PIN" required>
                </div>
            </div>

            <button class="btn btn-accent btn-lg" type="submit" style="width:100%;margin-top:16px;">
                <i class="fa-solid fa-circle-check"></i> Complete Registration &amp; Create Vendor Account
            </button>
        </form>

        <div class="auth-links">
            Already a registered vendor? <a href="<%=request.getContextPath()%>/vendorLogin.jsp">Vendor Login</a> &bull;
            <a href="<%=request.getContextPath()%>/index.jsp">Back to Home</a>
        </div>
    </div>
</div>
</body>
</html>