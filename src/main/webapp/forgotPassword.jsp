<% request.setAttribute("pageTitle", "Forgot Password"); %>
<%@ include file="header.jsp" %>

<%
    String roleParam = request.getParameter("role");
    if (roleParam == null) roleParam = (String) request.getAttribute("role");
    String accountType = (String) request.getAttribute("accountType");
    boolean isVendor = "vendor".equalsIgnoreCase(roleParam) || "VENDOR".equalsIgnoreCase(accountType);
%>

<div class="auth-wrapper">
    <div class="card">
        <div class="auth-header">
            <div class="auth-icon-badge" style="background:<%= isVendor ? "#fffbeb" : "#fef3c7" %>;color:<%= isVendor ? "#f59e0b" : "#d97706" %>;">
                <i class="fa-solid <%= isVendor ? "fa-store" : "fa-key" %>"></i>
            </div>
            <h2><%= isVendor ? "Vendor Password Recovery" : "Password Recovery" %></h2>
            <p>Verify your security answer to recover and reset your password</p>
        </div>

        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% }
           String securityQuestion = (String) request.getAttribute("securityQuestion");
           String email = (String) request.getAttribute("email");
           if (securityQuestion == null) { %>
            <!-- Step 1: ask for email -->
            <form action="<%=request.getContextPath()%>/ForgotPasswordServlet" method="post">
                <input type="hidden" name="step" value="findEmail">
                <input type="hidden" name="role" value="<%= roleParam != null ? roleParam : "" %>">
                <div class="form-group">
                    <label><i class="fa-solid fa-envelope"></i> <%= isVendor ? "Vendor Business Email" : "Registered Email Address" %></label>
                    <input type="email" name="email" placeholder="name@example.com" required autofocus>
                </div>
                <button type="submit" class="btn btn-lg <%= isVendor ? "btn-accent" : "" %>" style="width:100%;">
                    <span>Find Account &amp; Retrieve Security Question</span> <i class="fa-solid fa-arrow-right"></i>
                </button>
            </form>
        <% } else { %>
            <!-- Step 2: show security question, ask for answer -->
            <form action="<%=request.getContextPath()%>/ForgotPasswordServlet" method="post">
                <input type="hidden" name="step" value="verifyAnswer">
                <input type="hidden" name="email" value="<%= email %>">
                <input type="hidden" name="accountType" value="<%= accountType != null ? accountType : "" %>">
                <input type="hidden" name="role" value="<%= roleParam != null ? roleParam : "" %>">
                <div class="alert alert-info">
                    <strong>Account found:</strong> <%= email %> (<%= isVendor ? "Vendor Account" : "Customer Account" %>)
                </div>
                <div class="form-group">
                    <label style="font-weight:700;color:var(--text);font-size:0.95rem;">
                        <i class="fa-solid fa-circle-question" style="color:var(--primary);"></i> <%= securityQuestion %>
                    </label>
                    <input type="text" name="securityAnswer" placeholder="Type your security answer" required autofocus>
                </div>
                <button type="submit" class="btn btn-lg btn-accent" style="width:100%;">
                    <i class="fa-solid fa-circle-check"></i> Verify &amp; Proceed to Reset Password
                </button>
            </form>
        <% } %>

        <div class="auth-links">
            Remembered your credentials?
            <% if (isVendor) { %>
                <a href="<%=request.getContextPath()%>/vendorLogin.jsp">Back to Vendor Login</a>
            <% } else { %>
                <a href="<%=request.getContextPath()%>/login.jsp">Back to Login</a>
            <% } %>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
