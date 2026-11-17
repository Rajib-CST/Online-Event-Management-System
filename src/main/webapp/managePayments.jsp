<%@ page import="java.util.List, java.util.Map, java.math.BigDecimal, model.Payment, model.Vendor, dao.RefundDAO.RefundRecord" %>
<% request.setAttribute("pageTitle", "Financial Settlements & Payments"); %>
<%@ include file="adminHeader.jsp" %>
<%
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    List<Vendor> vendors = (List<Vendor>) request.getAttribute("vendors");
    List<RefundRecord> refunds = (List<RefundRecord>) request.getAttribute("refunds");

    Map<Integer, BigDecimal> vendorGrossEarnings = (Map<Integer, BigDecimal>) request.getAttribute("vendorGrossEarnings");
    Map<Integer, BigDecimal> vendorDeductions = (Map<Integer, BigDecimal>) request.getAttribute("vendorDeductions");
    Map<Integer, BigDecimal> vendorEarnings = (Map<Integer, BigDecimal>) request.getAttribute("vendorEarnings");

    BigDecimal totalGrossVolume = (BigDecimal) request.getAttribute("totalGrossVolume");
    BigDecimal totalRefundsIssued = (BigDecimal) request.getAttribute("totalRefundsIssued");
    BigDecimal netPlatformVolume = (BigDecimal) request.getAttribute("netPlatformVolume");
    BigDecimal totalAdminCommission = (BigDecimal) request.getAttribute("totalAdminCommission");
    BigDecimal totalVendorGross = (BigDecimal) request.getAttribute("totalVendorGross");
    BigDecimal totalVendorDeductions = (BigDecimal) request.getAttribute("totalVendorDeductions");
    BigDecimal totalVendorNet = (BigDecimal) request.getAttribute("totalVendorNet");

    if (totalGrossVolume == null) totalGrossVolume = BigDecimal.ZERO;
    if (totalRefundsIssued == null) totalRefundsIssued = BigDecimal.ZERO;
    if (netPlatformVolume == null) netPlatformVolume = BigDecimal.ZERO;
    if (totalAdminCommission == null) totalAdminCommission = BigDecimal.ZERO;
    if (totalVendorGross == null) totalVendorGross = BigDecimal.ZERO;
    if (totalVendorDeductions == null) totalVendorDeductions = BigDecimal.ZERO;
    if (totalVendorNet == null) totalVendorNet = BigDecimal.ZERO;
%>

<!-- Header Card -->
<div class="card" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:14px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);margin-bottom:24px;">
    <div>
        <h2 style="margin:0;"><i class="fa-solid fa-wallet" style="color:var(--accent);"></i> Payments, Refunds &amp; Financial Settlement</h2>
        <p class="text-muted" style="margin:4px 0 0 0;">Transaction ledger, customer refunds, vendor deduction audits, and reconciled platform revenue.</p>
    </div>
    <div>
        <a class="btn btn-secondary btn-sm" href="<%=request.getContextPath()%>/adminDashboard.jsp">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</div>

<!-- Financial Summary KPIs -->
<div class="grid-4" style="margin-bottom:24px;">
    <!-- Gross Payments -->
    <div class="card" style="margin-bottom:0;display:flex;flex-direction:column;justify-content:space-between;">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
            <span style="font-size:0.75rem;text-transform:uppercase;letter-spacing:0.06em;color:var(--text-light);font-weight:700;">Gross Volume</span>
            <div style="width:36px;height:36px;border-radius:10px;background:#eef2ff;color:var(--primary);display:flex;align-items:center;justify-content:center;font-size:1.1rem;">
                <i class="fa-solid fa-receipt"></i>
            </div>
        </div>
        <div style="font-family:'Outfit',sans-serif;font-size:2rem;font-weight:800;color:var(--text);line-height:1.1;">
            &#8377;<%= totalGrossVolume %>
        </div>
        <p style="margin:8px 0 0;font-size:0.8rem;color:var(--text-muted);">
            <i class="fa-solid fa-circle-check" style="color:var(--success);"></i> Total collections from all reservations
        </p>
    </div>

    <!-- Refunds Issued -->
    <div class="card" style="margin-bottom:0;display:flex;flex-direction:column;justify-content:space-between;border-left:4px solid #f59e0b;">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
            <span style="font-size:0.75rem;text-transform:uppercase;letter-spacing:0.06em;color:#b45309;font-weight:700;">Refunds Processed</span>
            <div style="width:36px;height:36px;border-radius:10px;background:#fffbeb;color:#f59e0b;display:flex;align-items:center;justify-content:center;font-size:1.1rem;">
                <i class="fa-solid fa-rotate-left"></i>
            </div>
        </div>
        <div style="font-family:'Outfit',sans-serif;font-size:2rem;font-weight:800;color:#d97706;line-height:1.1;">
            -&#8377;<%= totalRefundsIssued %>
        </div>
        <p style="margin:8px 0 0;font-size:0.8rem;color:var(--text-muted);">
            <i class="fa-solid fa-user-xmark" style="color:#d97706;"></i> <%= refunds != null ? refunds.size() : 0 %> cancellation refund(s) issued
        </p>
    </div>

    <!-- Net Platform Volume -->
    <div class="card" style="margin-bottom:0;display:flex;flex-direction:column;justify-content:space-between;border-left:4px solid #10b981;">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
            <span style="font-size:0.75rem;text-transform:uppercase;letter-spacing:0.06em;color:#047857;font-weight:700;">Net Volume</span>
            <div style="width:36px;height:36px;border-radius:10px;background:#ecfdf5;color:#10b981;display:flex;align-items:center;justify-content:center;font-size:1.1rem;">
                <i class="fa-solid fa-scale-balanced"></i>
            </div>
        </div>
        <div style="font-family:'Outfit',sans-serif;font-size:2rem;font-weight:800;color:#059669;line-height:1.1;">
            &#8377;<%= netPlatformVolume %>
        </div>
        <p style="margin:8px 0 0;font-size:0.8rem;color:var(--text-muted);">
            <i class="fa-solid fa-shield-halved" style="color:#059669;"></i> Net retained pool (Gross &minus; Refunds)
        </p>
    </div>

    <!-- Admin Commission Card -->
    <div class="card" style="margin-bottom:0;background:linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);color:#ffffff;display:flex;flex-direction:column;justify-content:space-between;">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
            <span style="font-size:0.75rem;text-transform:uppercase;letter-spacing:0.06em;color:#cbd5e1;font-weight:700;">Platform Revenue</span>
            <div style="width:36px;height:36px;border-radius:10px;background:rgba(245,158,11,0.25);color:var(--accent);display:flex;align-items:center;justify-content:center;font-size:1.1rem;">
                <i class="fa-solid fa-coins"></i>
            </div>
        </div>
        <div style="font-family:'Outfit',sans-serif;font-size:2rem;font-weight:900;color:#38bdf8;line-height:1.1;">
            &#8377;<%= totalAdminCommission %>
        </div>
        <p style="margin:8px 0 0;font-size:0.8rem;color:#94a3b8;">
            <i class="fa-solid fa-percent"></i> 10% standard maintenance revenue
        </p>
    </div>
</div>

<div class="grid-2" style="margin-bottom:24px;">
    <!-- Platform Financial Settlement Breakdown -->
    <div class="card" style="display:flex;flex-direction:column;justify-content:space-between;">
        <div>
            <h3 style="margin-bottom:14px;"><i class="fa-solid fa-calculator" style="color:var(--primary);"></i> Platform Settlement Reconciliation</h3>
            <p class="text-muted" style="font-size:0.86rem;margin-bottom:16px;">
                Transparent reconciliation of gross payments, customer refund deductions, platform maintenance fees, and net vendor distributions.
            </p>

            <div style="display:flex;flex-direction:column;gap:10px;">
                <div style="display:flex;justify-content:space-between;align-items:center;padding:8px 12px;background:#f8fafc;border-radius:8px;">
                    <span style="font-weight:600;color:var(--text-secondary);"><i class="fa-solid fa-plus" style="color:var(--primary);margin-right:6px;"></i> Gross Customer Payments</span>
                    <strong style="color:var(--text);font-size:1.05rem;">&#8377;<%= totalGrossVolume %></strong>
                </div>

                <div style="display:flex;justify-content:space-between;align-items:center;padding:8px 12px;background:#fef2f2;border-radius:8px;">
                    <span style="font-weight:600;color:#b91c1c;"><i class="fa-solid fa-minus" style="color:#b91c1c;margin-right:6px;"></i> Less Customer Refunds Issued</span>
                    <strong style="color:#dc2626;font-size:1.05rem;">-&#8377;<%= totalRefundsIssued %></strong>
                </div>

                <div style="display:flex;justify-content:space-between;align-items:center;padding:10px 12px;background:#f0fdf4;border-radius:8px;border:1px solid #bbf7d0;">
                    <span style="font-weight:700;color:#15803d;"><i class="fa-solid fa-equals" style="margin-right:6px;"></i> Net Platform Volume</span>
                    <strong style="color:#15803d;font-size:1.15rem;">&#8377;<%= netPlatformVolume %></strong>
                </div>

                <div style="display:flex;justify-content:space-between;align-items:center;padding:8px 12px;border-top:1px dashed var(--border);margin-top:6px;">
                    <span style="color:var(--text-muted);font-size:0.88rem;"><i class="fa-solid fa-store" style="color:var(--primary);margin-right:6px;"></i> Total Net Vendor Disbursements (90%)</span>
                    <strong style="color:var(--success-dark);">&#8377;<%= totalVendorNet %></strong>
                </div>

                <div style="display:flex;justify-content:space-between;align-items:center;padding:8px 12px;">
                    <span style="color:var(--text-muted);font-size:0.88rem;"><i class="fa-solid fa-building-columns" style="color:var(--accent);margin-right:6px;"></i> Platform Commission Retained (10%)</span>
                    <strong style="color:var(--primary);">&#8377;<%= totalAdminCommission %></strong>
                </div>
            </div>
        </div>

        <div style="margin-top:16px;padding:10px 14px;background:#f1f5f9;border-radius:8px;font-size:0.8rem;color:var(--text-muted);">
            <i class="fa-solid fa-circle-info" style="color:var(--primary);"></i>
            <strong>Settlement Rule:</strong> On cancellation, customer refunds are debited directly from the vendor's bank balance, while the platform maintains its 10% fee. Net vendor payout = Gross (90%) &minus; Refund Deductions.
        </div>
    </div>

    <!-- Vendor Earnings & Deductions Summary -->
    <div class="card">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;">
            <h3 style="margin:0;"><i class="fa-solid fa-store" style="color:var(--primary);"></i> Vendor Earnings (90% Share)</h3>
            <span class="badge badge-neutral"><%= vendors != null ? vendors.size() : 0 %> Vendors</span>
        </div>
        <div class="table-wrap" style="max-height:300px;overflow-y:auto;margin:0;">
        <table>
            <thead>
                <tr>
                    <th>Vendor Business</th>
                    <th style="text-align:right;">Gross Share (90%)</th>
                    <th style="text-align:right;">Refund Deductions</th>
                    <th style="text-align:right;">Net Payout</th>
                </tr>
            </thead>
            <tbody>
                <% if (vendors != null && !vendors.isEmpty()) {
                     for (Vendor v : vendors) {
                         int vid = v.getVendorId();
                         BigDecimal gross = vendorGrossEarnings != null && vendorGrossEarnings.get(vid) != null ? vendorGrossEarnings.get(vid) : BigDecimal.ZERO;
                         BigDecimal deduction = vendorDeductions != null && vendorDeductions.get(vid) != null ? vendorDeductions.get(vid) : BigDecimal.ZERO;
                         BigDecimal net = vendorEarnings != null && vendorEarnings.get(vid) != null ? vendorEarnings.get(vid) : BigDecimal.ZERO;
                %>
                <tr>
                    <td>
                        <strong><%= v.getVendorName() %></strong>
                        <div style="font-size:0.75rem;color:var(--text-light);">ID #<%= v.getVendorId() %> &bull; <%= v.getEmail() %></div>
                    </td>
                    <td style="text-align:right;color:var(--text-secondary);">&#8377;<%= gross %></td>
                    <td style="text-align:right;color:<%= deduction.compareTo(BigDecimal.ZERO) > 0 ? "var(--danger)" : "var(--text-light)" %>;">
                        <%= deduction.compareTo(BigDecimal.ZERO) > 0 ? "-&#8377;" + deduction : "&#8377;0.00" %>
                    </td>
                    <td style="text-align:right;">
                        <strong style="color:var(--success-dark);font-size:1.05rem;">
                            &#8377;<%= net %>
                        </strong>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="4" style="text-align:center;color:var(--text-muted);padding:24px;">No active vendors found.</td>
                </tr>
                <% } %>
            </tbody>
            <tfoot>
                <tr style="background:#f8fafc;font-weight:700;">
                    <td>Total All Vendors</td>
                    <td style="text-align:right;">&#8377;<%= totalVendorGross %></td>
                    <td style="text-align:right;color:<%= totalVendorDeductions.compareTo(BigDecimal.ZERO) > 0 ? "var(--danger)" : "var(--text-muted)" %>;">
                        <%= totalVendorDeductions.compareTo(BigDecimal.ZERO) > 0 ? "-&#8377;" + totalVendorDeductions : "&#8377;0.00" %>
                    </td>
                    <td style="text-align:right;color:var(--success-dark);font-size:1.1rem;">&#8377;<%= totalVendorNet %></td>
                </tr>
            </tfoot>
        </table>
        </div>
    </div>
</div>

<!-- Transaction History Audit Table -->
<div class="card" style="margin-bottom:24px;">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
        <div>
            <h3 style="margin:0;"><i class="fa-solid fa-clock-rotate-left" style="color:var(--primary);"></i> Transaction History Audit</h3>
            <p class="text-muted" style="margin:2px 0 0 0;font-size:0.85rem;">Complete record of client checkout payments with live refund adjustment tracking.</p>
        </div>
        <span class="badge badge-neutral"><%= payments != null ? payments.size() : 0 %> Transactions</span>
    </div>

    <div class="table-wrap">
    <table>
        <thead>
            <tr>
                <th>Txn ID</th>
                <th>Booking Ref</th>
                <th>Total Paid</th>
                <th>Vendor Share (90%)</th>
                <th>Platform (10%)</th>
                <th>Payment Status</th>
                <th style="text-align:right;">Timestamp</th>
            </tr>
        </thead>
        <tbody>
            <% if (payments != null && !payments.isEmpty()) {
                 for (Payment p : payments) { %>
            <tr style="<%= p.isRefunded() ? "background-color:rgba(254, 242, 242, 0.35);" : "" %>">
                <td><strong style="font-family:monospace;"><%= p.getTransactionId() %></strong></td>
                <td><span class="badge badge-info">#B<%= p.getBookingId() %></span></td>
                <td>
                    <strong style="color:var(--text);">&#8377;<%= p.getAmount() %></strong>
                    <% if (p.isRefunded()) { %>
                        <div style="font-size:0.75rem;color:var(--text-muted);">
                            Net: &#8377;<%= p.getAmount().subtract(p.getCustomerRefund()) %>
                        </div>
                    <% } %>
                </td>
                <td>
                    <% if (p.isRefunded()) {
                         BigDecimal netV = p.getVendorAmount().subtract(p.getVendorDeduction());
                         if (netV.compareTo(BigDecimal.ZERO) < 0) netV = BigDecimal.ZERO;
                    %>
                        <strong style="color:var(--success-dark);">&#8377;<%= netV %></strong>
                        <div style="font-size:0.74rem;color:var(--danger);font-weight:600;">
                            -&#8377;<%= p.getVendorDeduction() %> deducted
                        </div>
                    <% } else { %>
                        <span style="color:var(--success-dark);font-weight:600;">&#8377;<%= p.getVendorAmount() %></span>
                    <% } %>
                </td>
                <td style="color:var(--primary);font-weight:600;">&#8377;<%= p.getAdminAmount() %></td>
                <td>
                    <% if (p.isRefunded()) { %>
                        <span class="badge badge-warning" title="Refund ID: <%= p.getRefundTransactionId() %>">
                            <i class="fa-solid fa-rotate-left"></i> REFUNDED
                        </span>
                        <div style="font-size:0.74rem;color:#b45309;margin-top:3px;">
                            &#8377;<%= p.getCustomerRefund() %> (<%= p.getCancelledBy() %>)
                        </div>
                    <% } else if ("SUCCESS".equals(p.getPaymentStatus())) { %>
                        <span class="badge badge-success"><i class="fa-solid fa-check"></i> SUCCESS</span>
                    <% } else { %>
                        <span class="badge badge-danger"><i class="fa-solid fa-xmark"></i> FAILED</span>
                    <% } %>
                </td>
                <td style="text-align:right;" class="text-muted"><%= p.getPaymentDate() %></td>
            </tr>
            <% } } else { %>
            <tr>
                <td colspan="7" style="text-align:center;padding:32px;color:var(--text-muted);">
                    No financial transactions recorded yet.
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    </div>
</div>

<!-- Refunds & Cancellations Ledger Table -->
<div class="card">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
        <div>
            <h3 style="margin:0;"><i class="fa-solid fa-rotate-left" style="color:var(--accent);"></i> Refunds &amp; Cancellation Deductions Ledger</h3>
            <p class="text-muted" style="margin:2px 0 0 0;font-size:0.85rem;">Detailed ledger of all customer refunds debited from vendors upon booking cancellation.</p>
        </div>
        <span class="badge badge-neutral"><%= refunds != null ? refunds.size() : 0 %> Refunds</span>
    </div>

    <div class="table-wrap">
    <table>
        <thead>
            <tr>
                <th>Refund Txn ID</th>
                <th>Booking Ref</th>
                <th>Cancelled By</th>
                <th>Original Paid</th>
                <th>Customer Refund</th>
                <th>Vendor Deduction</th>
                <th>Admin Retained</th>
                <th>Reason</th>
                <th style="text-align:right;">Refund Date</th>
            </tr>
        </thead>
        <tbody>
            <% if (refunds != null && !refunds.isEmpty()) {
                 for (RefundRecord r : refunds) { %>
            <tr>
                <td><strong style="font-family:monospace;color:#b45309;"><%= r.getRefundTransactionId() %></strong></td>
                <td><span class="badge badge-info">#B<%= r.getBookingId() %></span></td>
                <td>
                    <% if ("CUSTOMER".equalsIgnoreCase(r.getCancelledBy())) { %>
                        <span class="badge badge-neutral"><i class="fa-solid fa-user"></i> CUSTOMER</span>
                    <% } else { %>
                        <span class="badge badge-neutral"><i class="fa-solid fa-store"></i> VENDOR</span>
                    <% } %>
                </td>
                <td style="color:var(--text-secondary);">&#8377;<%= r.getOriginalAmount() %></td>
                <td style="color:var(--danger);font-weight:700;">&#8377;<%= r.getCustomerRefund() %></td>
                <td style="color:var(--danger);font-weight:700;">-&#8377;<%= r.getVendorDeduction() %></td>
                <td style="color:var(--primary);font-weight:600;">&#8377;<%= r.getAdminRetained() %></td>
                <td style="font-size:0.85rem;color:var(--text-secondary);max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="<%= r.getReason() != null ? r.getReason() : "" %>">
                    <%= r.getReason() != null ? r.getReason() : "<em>No reason specified</em>" %>
                </td>
                <td style="text-align:right;" class="text-muted"><%= r.getRefundDate() %></td>
            </tr>
            <% } } else { %>
            <tr>
                <td colspan="9" style="text-align:center;padding:32px;color:var(--text-muted);">
                    No cancellation refunds recorded in the system.
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    </div>
</div>

<%@ include file="footer.jsp" %>
