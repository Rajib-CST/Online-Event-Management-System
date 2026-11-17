<% request.setAttribute("pageTitle", "Payment Successful"); %>
<%@ include file="header.jsp" %>

<!-- Professional 6-Step Stepper -->
<jsp:include page="bookingStepper.jsp">
    <jsp:param name="step" value="6"/>
</jsp:include>

<div class="card" style="max-width:640px;margin:30px auto;text-align:center;box-shadow:var(--shadow-lg);">
    <!-- Glowing Animated-style Success Icon -->
    <div style="width:84px;height:84px;border-radius:50%;background:var(--success-bg);color:var(--success);display:inline-flex;align-items:center;justify-content:center;font-size:2.8rem;margin-bottom:16px;box-shadow:0 0 25px rgba(16, 185, 129, 0.35);border:2px solid var(--success-border);">
        <i class="fa-solid fa-circle-check"></i>
    </div>

    <span class="badge badge-success" style="margin-bottom:10px;"><i class="fa-solid fa-file-invoice"></i> Step 6 of 6: Official Booking Receipt</span>
    <h2 style="color:var(--success-dark);font-size:2rem;margin-bottom:6px;">Booking Confirmed!</h2>
    <p class="text-muted" style="font-size:1.05rem;margin-bottom:24px;">Your event equipment reservation and payment have been successfully confirmed and receipt generated.</p>

    <!-- Receipt Table -->
    <div class="table-wrap" style="text-align:left;margin-bottom:24px;">
    <table>
        <tbody>
            <tr>
                <th style="width:45%;"><i class="fa-solid fa-hashtag"></i> Transaction ID</th>
                <td><strong style="color:var(--text);font-family:monospace;"><%= request.getAttribute("transactionId") %></strong></td>
            </tr>
            <tr>
                <th><i class="fa-solid fa-ticket"></i> Booking Reference</th>
                <td><span class="badge badge-info">B<%= request.getAttribute("bookingId") %></span></td>
            </tr>
            <tr>
                <th><i class="fa-solid fa-store"></i> Assigned Vendor</th>
                <td><strong><%= request.getAttribute("vendorName") %></strong></td>
            </tr>
            <tr>
                <th><i class="fa-solid fa-calendar-day"></i> Reserved Event Date</th>
                <td><%= request.getAttribute("eventDate") %></td>
            </tr>
            <tr>
                <th><i class="fa-solid fa-indian-rupee-sign"></i> Total Paid</th>
                <td><strong style="font-size:1.2rem;color:var(--primary-dark);">&#8377;<%= request.getAttribute("totalAmount") %></strong></td>
            </tr>
            <tr>
                <th><i class="fa-solid fa-chart-pie"></i> Payment Status</th>
                <td><span class="badge badge-success"><i class="fa-solid fa-check"></i> SETTLED</span></td>
            </tr>
            <tr>
                <th><i class="fa-solid fa-handshake"></i> Vendor Share (90%)</th>
                <td>&#8377;<%= request.getAttribute("vendorAmount") %></td>
            </tr>
            <tr>
                <th><i class="fa-solid fa-shield-halved"></i> Platform Commission (10%)</th>
                <td>&#8377;<%= request.getAttribute("adminAmount") %></td>
            </tr>
        </tbody>
    </table>
    </div>

    <div class="btn-row" style="justify-content:center;gap:16px;">
        <a class="btn btn-secondary" href="<%=request.getContextPath()%>/home.jsp">
            <i class="fa-solid fa-house"></i> Go to Home
        </a>
        <a class="btn btn-accent btn-lg" href="<%=request.getContextPath()%>/MyBookingsServlet">
            <i class="fa-solid fa-calendar-check"></i> View in My Bookings
        </a>
    </div>
</div>

<%@ include file="footer.jsp" %>
