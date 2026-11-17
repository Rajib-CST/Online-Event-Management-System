<% request.setAttribute("pageTitle", "Payment Failed"); %>
<%@ include file="header.jsp" %>

<div class="card" style="max-width:580px;margin:40px auto;text-align:center;box-shadow:var(--shadow-lg);">
    <div style="width:84px;height:84px;border-radius:50%;background:var(--danger-bg);color:var(--danger);display:inline-flex;align-items:center;justify-content:center;font-size:2.8rem;margin-bottom:16px;box-shadow:0 0 25px rgba(239, 68, 68, 0.3);border:2px solid var(--danger-border);">
        <i class="fa-solid fa-circle-exclamation"></i>
    </div>

    <h2 style="color:var(--danger-dark);font-size:1.85rem;margin-bottom:6px;">Payment Unsuccessful</h2>
    <p class="text-muted" style="margin-bottom:20px;">We were unable to process your payment transaction.</p>

    <% String error = (String) request.getAttribute("error");
       if (error != null) { %>
        <div class="alert alert-error" style="text-align:left;"><%= error %></div>
    <% } %>

    <div style="background:#f8fafc;border:1px solid var(--border);border-radius:12px;padding:20px;text-align:left;margin-bottom:24px;">
        <h4 style="margin:0 0 10px;color:var(--text);"><i class="fa-solid fa-circle-question" style="color:var(--primary);"></i> Common reasons for failure:</h4>
        <ul style="list-style:none;padding:0;margin:0;font-size:0.92rem;color:var(--text-secondary);display:flex;flex-direction:column;gap:8px;">
            <li><i class="fa-solid fa-circle-xmark" style="color:var(--danger);margin-right:8px;"></i> Insufficient demo bank account balance</li>
            <li><i class="fa-solid fa-circle-xmark" style="color:var(--danger);margin-right:8px;"></i> Incorrect Account Number or 4-digit PIN</li>
            <li><i class="fa-solid fa-circle-xmark" style="color:var(--danger);margin-right:8px;"></i> Inventory stock availability has changed</li>
            <li><i class="fa-solid fa-circle-xmark" style="color:var(--danger);margin-right:8px;"></i> Session timeout or connection interruption</li>
        </ul>
    </div>

    <div class="btn-row" style="justify-content:center;gap:16px;">
        <a class="btn btn-accent btn-lg" href="<%=request.getContextPath()%>/payment.jsp">
            <i class="fa-solid fa-rotate-right"></i> Try Again
        </a>
        <a class="btn btn-secondary btn-lg" href="<%=request.getContextPath()%>/home.jsp">
            <i class="fa-solid fa-house"></i> Return Home
        </a>
    </div>
</div>

<%@ include file="footer.jsp" %>
