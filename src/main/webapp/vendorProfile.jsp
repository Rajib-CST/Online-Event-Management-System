<%@ page import="model.BankAccount,model.Vendor" %>
<%
    if (request.getAttribute("vendorProfile") == null) {
        response.sendRedirect(request.getContextPath() + "/VendorProfileServlet");
        return;
    }
    request.setAttribute("pageTitle","Vendor Profile");
%>
<%@ include file="header.jsp" %>

<%
    Vendor vendorProfile = (Vendor) request.getAttribute("vendorProfile");
    BankAccount vendorBankAccount = (BankAccount) request.getAttribute("vendorBankAccount");
%>

<div class="card" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:14px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);">
    <div style="display:flex;align-items:center;gap:18px;">
        <div style="width:60px;height:60px;border-radius:16px;background:var(--primary-subtle);color:var(--primary);display:flex;align-items:center;justify-content:center;font-size:1.8rem;box-shadow:0 4px 12px rgba(79,70,229,0.15);">
            <i class="fa-solid fa-id-badge"></i>
        </div>
        <div>
            <h2 style="margin:0;"><%= vendorProfile != null && vendorProfile.getVendorName() != null ? vendorProfile.getVendorName() : "Vendor Profile" %></h2>
            <p class="text-muted" style="margin:4px 0 0 0;">Partner identification, registered contact information, and payout balance.</p>
        </div>
    </div>
    <div>
        <a class="btn btn-secondary btn-sm" href="<%=request.getContextPath()%>/VendorDashboardServlet">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</div>

<div class="grid-2">
    <!-- Business Profile Info -->
    <div class="card">
        <h3 style="margin-bottom:18px;color:var(--text);"><i class="fa-solid fa-briefcase" style="color:var(--primary);"></i> Business Information</h3>
        <div class="receipt-grid" style="grid-template-columns:1fr;gap:10px;">
            <div class="receipt-item">
                <span><i class="fa-solid fa-building"></i> Company Name</span>
                <span><%= vendorProfile != null && vendorProfile.getVendorName() != null ? vendorProfile.getVendorName() : "Not available" %></span>
            </div>
            <div class="receipt-item">
                <span><i class="fa-solid fa-envelope"></i> Business Email</span>
                <span><%= vendorProfile != null && vendorProfile.getEmail() != null ? vendorProfile.getEmail() : "Not available" %></span>
            </div>
            <div class="receipt-item">
                <span><i class="fa-solid fa-phone"></i> Contact Number</span>
                <span><%= vendorProfile != null && vendorProfile.getContact() != null ? vendorProfile.getContact() : "Not provided" %></span>
            </div>
            <div class="receipt-item">
                <span><i class="fa-solid fa-location-dot"></i> Operational Address</span>
                <span><%= vendorProfile != null && vendorProfile.getAddress() != null ? vendorProfile.getAddress() : "Not provided" %></span>
            </div>
            <div class="receipt-item">
                <span><i class="fa-solid fa-file-lines"></i> Description</span>
                <span><%= vendorProfile != null && vendorProfile.getDescription() != null ? vendorProfile.getDescription() : "Not provided" %></span>
            </div>
        </div>
    </div>

    <!-- Linked Bank Account & Earnings -->
    <div class="card">
        <h3 style="margin-bottom:18px;color:var(--text);"><i class="fa-solid fa-wallet" style="color:var(--accent);"></i> Linked Bank Account</h3>
        <div style="background:linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);color:#ffffff;border-radius:14px;padding:24px;margin-bottom:20px;box-shadow:0 8px 20px rgba(30,27,75,0.25);">
            <div style="font-size:0.75rem;text-transform:uppercase;color:#94a3b8;letter-spacing:0.05em;margin-bottom:6px;">Current Available Balance</div>
            <div style="font-family:'Outfit',sans-serif;font-size:2.2rem;font-weight:900;color:#38bdf8;">
                <% if (vendorBankAccount != null && vendorBankAccount.getBalance() != null) { %>
                    &#8377;<%= vendorBankAccount.getBalance().toPlainString() %>
                <% } else { %>
                    &#8377;0.00
                <% } %>
            </div>
            <div style="margin-top:16px;font-size:0.82rem;color:#cbd5e1;display:flex;align-items:center;gap:6px;">
                <i class="fa-solid fa-building-columns"></i>
                <span><%= vendorBankAccount != null && vendorBankAccount.getBankName() != null ? vendorBankAccount.getBankName() : "Demo Bank" %></span>
                <span>&bull;</span>
                <span>Acct #<%= vendorBankAccount != null && vendorBankAccount.getAccountNumber() != null ? vendorBankAccount.getAccountNumber() : "Demo" %></span>
            </div>
        </div>

        <div style="font-size:0.86rem;color:var(--text-muted);background:#f8fafc;padding:14px;border-radius:8px;border:1px solid var(--border);">
            <i class="fa-solid fa-circle-info" style="color:var(--primary);"></i> Automatically receives 90% of every completed customer event booking immediately upon payment authorization.
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>