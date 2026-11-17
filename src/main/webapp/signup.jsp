<% request.setAttribute("pageTitle", "Sign Up"); %>
<%@ include file="header.jsp" %>

<div class="auth-wrapper" style="max-width:580px;">
    <div class="card">
        <div class="auth-header">
            <div class="auth-icon-badge">
                <i class="fa-solid fa-user-plus"></i>
            </div>
            <h2>Create Your Account</h2>
            <p>Join EventArrange to discover verified vendors and book event supplies</p>
        </div>

        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>

        <form action="<%=request.getContextPath()%>/SignupServlet" method="post">
            <div class="grid-2">
                <div class="form-group">
                    <label><i class="fa-solid fa-user"></i> Full Name</label>
                    <input type="text" name="name" placeholder="John Doe" required autofocus>
                </div>
                <div class="form-group">
                    <label><i class="fa-solid fa-envelope"></i> Email Address</label>
                    <input type="email" name="email" placeholder="john@example.com" required>
                </div>
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label><i class="fa-solid fa-lock"></i> Password</label>
                    <input type="password" name="password" placeholder="Create a strong password" required>
                </div>
                <div class="form-group">
                    <label><i class="fa-solid fa-phone"></i> Contact Number</label>
                    <input type="tel" name="contact" placeholder="10-digit mobile number" required>
                </div>
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label><i class="fa-solid fa-venus-mars"></i> Gender</label>
                    <select name="gender">
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fa-solid fa-cake-candles"></i> Date of Birth</label>
                    <input type="date" name="dob">
                </div>
            </div>

            <div class="form-group">
                <label><i class="fa-solid fa-shield-halved"></i> Security Question (for password recovery)</label>
                <select name="securityQuestion" required>
                    <option value="What is your favourite color?">What is your favourite color?</option>
                    <option value="What is your birthplace?">What is your birthplace?</option>
                    <option value="What is your favourite food?">What is your favourite food?</option>
                </select>
            </div>

            <div class="form-group">
                <label><i class="fa-solid fa-key"></i> Security Answer</label>
                <input type="text" name="securityAnswer" placeholder="Your secret answer" required>
            </div>

            <button type="submit" class="btn btn-lg" style="width:100%;">
                <span>Register Account</span> <i class="fa-solid fa-arrow-right"></i>
            </button>
        </form>

        <div class="auth-links">
            Already have an account? <a href="<%=request.getContextPath()%>/login.jsp">Sign in here</a>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
