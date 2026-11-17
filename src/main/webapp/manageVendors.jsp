<%@ page import="java.util.List, model.Vendor" %>
<% request.setAttribute("pageTitle", "Manage Vendors"); %>
<%@ include file="adminHeader.jsp" %>
<%
    List<Vendor> vendors = (List<Vendor>) request.getAttribute("vendors");
    Vendor editVendor = (Vendor) request.getAttribute("editVendor");
%>

<div class="card" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:14px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);">
    <div>
        <h2 style="margin:0;"><i class="fa-solid fa-store" style="color:var(--primary);"></i> Vendor Network Management</h2>
        <p class="text-muted" style="margin:4px 0 0 0;">Register new partner vendors, edit contact profiles, or manage system access.</p>
    </div>
    <div>
        <a class="btn btn-secondary btn-sm" href="<%=request.getContextPath()%>/adminDashboard.jsp">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</div>

<div class="card">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
        <h3 style="margin:0;">
            <i class="fa-solid <%= editVendor != null ? "fa-pen-to-square" : "fa-plus-circle" %>" style="color:var(--primary);"></i>
            <%= editVendor != null ? "Edit Vendor Profile" : "Register New Vendor" %>
        </h3>
        <% if (editVendor != null) { %>
            <a class="btn btn-secondary btn-sm" href="<%=request.getContextPath()%>/VendorManagementServlet">
                <i class="fa-solid fa-xmark"></i> Cancel Edit
            </a>
        <% } %>
    </div>

    <form action="<%=request.getContextPath()%>/VendorManagementServlet" method="post">
        <input type="hidden" name="action" value="<%= editVendor != null ? "update" : "add" %>">
        <% if (editVendor != null) { %>
            <input type="hidden" name="vendorId" value="<%= editVendor.getVendorId() %>">
        <% } %>

        <div class="grid-2">
            <div class="form-group">
                <label><i class="fa-solid fa-building"></i> Vendor Business Name</label>
                <input type="text" name="vendorName" required placeholder="e.g. Asansol Event Suppliers"
                       value="<%= editVendor != null ? editVendor.getVendorName() : "" %>">
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-envelope"></i> Email Address</label>
                <input type="email" name="email" required placeholder="vendor@example.com"
                       value="<%= editVendor != null ? editVendor.getEmail() : "" %>">
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-lock"></i> <%= editVendor != null ? "New Password (leave blank to keep current)" : "Access Password" %></label>
                <input type="password" name="password" placeholder="<%= editVendor != null ? "Enter to change" : "Password" %>" <%= editVendor == null ? "required" : "" %>>
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-phone"></i> Contact Number</label>
                <input type="text" name="contact" required placeholder="Mobile phone"
                       value="<%= editVendor != null ? editVendor.getContact() : "" %>">
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-building-columns"></i> Bank Account ID</label>
                <input type="number" name="bankAccountId" min="1" required placeholder="Linked bank account record ID"
                       value="<%= editVendor != null ? editVendor.getBankAccountId() : "" %>">
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-location-dot"></i> City / Address</label>
                <input type="text" name="address" placeholder="e.g. Asansol, West Bengal"
                       value="<%= editVendor != null && editVendor.getAddress() != null ? editVendor.getAddress() : "" %>">
            </div>
        </div>

        <div class="form-group">
            <label><i class="fa-solid fa-file-lines"></i> Description &amp; Services Offered</label>
            <input type="text" name="description" placeholder="e.g. Chairs, Tables, DJ System, Generators, Lightings"
                   value="<%= editVendor != null && editVendor.getDescription() != null ? editVendor.getDescription() : "" %>">
        </div>

        <div class="grid-2">
            <div class="form-group">
                <label><i class="fa-solid fa-shield-halved"></i> Security Question</label>
                <% String currentSecQ = editVendor != null && editVendor.getSecurityQuestion() != null ? editVendor.getSecurityQuestion() : ""; %>
                <select name="securityQuestion" required>
                    <option value="">-- Select a security question --</option>
                    <option value="What is your pet's name?" <%= "What is your pet's name?".equals(currentSecQ) ? "selected" : "" %>>What is your pet's name?</option>
                    <option value="What is your mother's maiden name?" <%= "What is your mother's maiden name?".equals(currentSecQ) ? "selected" : "" %>>What is your mother's maiden name?</option>
                    <option value="What was the name of your first school?" <%= "What was the name of your first school?".equals(currentSecQ) ? "selected" : "" %>>What was the name of your first school?</option>
                    <option value="What city were you born in?" <%= "What city were you born in?".equals(currentSecQ) ? "selected" : "" %>>What city were you born in?</option>
                    <option value="What is your favorite food?" <%= "What is your favorite food?".equals(currentSecQ) ? "selected" : "" %>>What is your favorite food?</option>
                    <option value="What was your first business name?" <%= "What was your first business name?".equals(currentSecQ) ? "selected" : "" %>>What was your first business name?</option>
                    <% if (!currentSecQ.isEmpty() && !currentSecQ.equals("What is your pet's name?") && !currentSecQ.equals("What is your mother's maiden name?") && !currentSecQ.equals("What was the name of your first school?") && !currentSecQ.equals("What city were you born in?") && !currentSecQ.equals("What is your favorite food?") && !currentSecQ.equals("What was your first business name?")) { %>
                    <option value="<%= currentSecQ %>" selected><%= currentSecQ %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-key"></i> Security Answer</label>
                <input type="text" name="securityAnswer" required placeholder="Answer"
                       value="<%= editVendor != null && editVendor.getSecurityAnswer() != null ? editVendor.getSecurityAnswer() : "" %>">
            </div>
        </div>

        <button type="submit" class="btn btn-accent btn-lg">
            <i class="fa-solid <%= editVendor != null ? "fa-floppy-disk" : "fa-plus" %>"></i>
            <%= editVendor != null ? "Update Vendor Profile" : "Register Vendor Partner" %>
        </button>
    </form>
</div>

<div class="card">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
        <h3 style="margin:0;"><i class="fa-solid fa-list" style="color:var(--primary);"></i> Registered Vendor Partners</h3>
        <span class="badge badge-neutral"><%= vendors != null ? vendors.size() : 0 %> Active Vendors</span>
    </div>

    <div class="table-wrap">
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Vendor Name</th>
                <th>Email</th>
                <th>Contact</th>
                <th>Address</th>
                <th style="text-align:right;">Actions</th>
            </tr>
        </thead>
        <tbody>
            <% if (vendors != null && !vendors.isEmpty()) {
                 for (Vendor v : vendors) { %>
            <tr>
                <td><strong>#<%= v.getVendorId() %></strong></td>
                <td>
                    <div style="display:flex;align-items:center;gap:8px;">
                        <i class="fa-solid fa-store" style="color:var(--primary);font-size:0.85rem;"></i>
                        <strong><%= v.getVendorName() %></strong>
                    </div>
                </td>
                <td><%= v.getEmail() %></td>
                <td><%= v.getContact() %></td>
                <td><%= v.getAddress() != null ? v.getAddress() : "-" %></td>
                <td style="text-align:right;">
                    <a class="btn btn-sm btn-secondary" href="<%=request.getContextPath()%>/VendorManagementServlet?editVendorId=<%= v.getVendorId() %>">
                        <i class="fa-solid fa-pen-to-square"></i> Edit
                    </a>
                    <form action="<%=request.getContextPath()%>/VendorManagementServlet" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="vendorId" value="<%= v.getVendorId() %>">
                        <button type="submit" class="btn btn-sm btn-danger"
                                onclick="return confirmAction('Delete this vendor? All related records may be affected.');">
                            <i class="fa-solid fa-trash-can"></i> Delete
                        </button>
                    </form>
                </td>
            </tr>
            <% } } else { %>
            <tr>
                <td colspan="6" style="text-align:center;padding:32px;color:var(--text-muted);">
                    No vendors registered in the system yet.
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    </div>
</div>

<%@ include file="footer.jsp" %>
