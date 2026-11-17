<% request.setAttribute("pageTitle", "Payment"); %>
<%@ include file="header.jsp" %>

<!-- Professional 6-Step Stepper -->
<jsp:include page="bookingStepper.jsp">
    <jsp:param name="step" value="5"/>
</jsp:include>

<div class="card" style="max-width:680px;margin:0 auto;box-shadow:var(--shadow-lg);">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;flex-wrap:wrap;gap:10px;">
        <div>
            <h2 style="margin:0;"><i class="fa-solid fa-lock" style="color:var(--primary);"></i> Confirm Booking &amp; Secure Payment</h2>
            <p class="text-muted" style="margin:4px 0 0 0;">Step 5: Authorize and settle payment from your linked demo bank account to finalize reservation.</p>
        </div>
        <span class="badge badge-info" style="font-size:0.85rem;padding:6px 14px;">
            <i class="fa-solid fa-credit-card"></i> Step 5 of 6: Confirm Booking
        </span>
    </div>

    <% String error = (String) request.getAttribute("error");
       if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
    <% } %>

    <!-- Card Visual Mockup -->
    <div style="background:linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #4338ca 100%);color:#ffffff;border-radius:16px;padding:24px;margin-bottom:24px;box-shadow:0 8px 24px rgba(30, 27, 75, 0.35);position:relative;overflow:hidden;">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:24px;">
            <span style="font-family:'Outfit',sans-serif;font-weight:800;letter-spacing:1px;font-size:1.1rem;color:#f8fafc;">DEMO BANK PAY</span>
            <i class="fa-solid fa-credit-card" style="font-size:1.6rem;color:var(--accent);"></i>
        </div>
        <div style="font-family:monospace;font-size:1.25rem;letter-spacing:2px;margin-bottom:20px;color:#e2e8f0;">
            &bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull; DEMO
        </div>
        <div style="display:flex;justify-content:space-between;align-items:flex-end;">
            <div>
                <div style="font-size:0.7rem;text-transform:uppercase;color:#94a3b8;letter-spacing:0.05em;">Cardholder</div>
                <div style="font-weight:700;font-size:0.95rem;"><%= session.getAttribute("userName") %></div>
            </div>
            <div style="text-align:right;">
                <div style="font-size:0.7rem;text-transform:uppercase;color:#94a3b8;letter-spacing:0.05em;">Amount Due</div>
                <div style="font-family:'Outfit',sans-serif;font-weight:800;font-size:1.4rem;color:#38bdf8;">
                    &#8377;<%= session.getAttribute("bookingTotal") %>
                </div>
            </div>
        </div>
    </div>

    <!-- Booking Summary Pills -->
    <div style="display:grid;grid-template-columns:repeat(3, 1fr);gap:10px;margin-bottom:24px;text-align:center;">
        <div style="background:#f8fafc;padding:10px;border-radius:8px;border:1px solid var(--border);">
            <div style="font-size:0.75rem;color:var(--text-muted);">Event Date</div>
            <strong style="font-size:0.9rem;"><%= session.getAttribute("eventDate") %></strong>
        </div>
        <div style="background:#f8fafc;padding:10px;border-radius:8px;border:1px solid var(--border);">
            <div style="font-size:0.75rem;color:var(--text-muted);">Location</div>
            <strong style="font-size:0.9rem;"><%= session.getAttribute("location") %></strong>
        </div>
        <div style="background:#f8fafc;padding:10px;border-radius:8px;border:1px solid var(--border);">
            <div style="font-size:0.75rem;color:var(--text-muted);">Duration</div>
            <strong style="font-size:0.9rem;"><%= session.getAttribute("bookingDays") %> Day(s)</strong>
        </div>
    </div>

    <form action="<%=request.getContextPath()%>/PaymentServlet" method="post">
        <div class="form-group">
            <label><i class="fa-solid fa-building-columns"></i> Bank Account Number</label>
            <input type="text" name="accountNumber" placeholder="Enter your demo bank account number" required autofocus>
        </div>
        <div class="form-group">
            <label><i class="fa-solid fa-key"></i> Secret Security PIN</label>
            <input type="password" name="pin" placeholder="Enter your 4-digit bank PIN" required>
        </div>
        <button type="submit" class="btn btn-success btn-lg" style="width:100%;margin-top:10px;">
            <i class="fa-solid fa-shield-check"></i> Authorize &amp; Pay &#8377;<%= session.getAttribute("bookingTotal") %>
        </button>
    </form>

    <div style="text-align:center;margin-top:20px;padding-top:16px;border-top:1px solid var(--border);color:var(--text-muted);font-size:0.85rem;">
        <i class="fa-solid fa-flask"></i> Demo Banking Simulation &bull; For academic demonstration only &bull; No actual funds are charged
    </div>
</div>

<%@ include file="footer.jsp" %>
