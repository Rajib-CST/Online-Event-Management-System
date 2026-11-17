<%@ page import="java.util.List, model.Item, model.Vendor, model.VendorItem" %>
<% request.setAttribute("pageTitle", "Manage Items & Catalog"); %>
<%@ include file="adminHeader.jsp" %>
<%
    List<Item> items = (List<Item>) request.getAttribute("items");
    List<Vendor> vendors = (List<Vendor>) request.getAttribute("vendors");
    Integer selectedVendorId = (Integer) request.getAttribute("selectedVendorId");
    List<VendorItem> inventory = (List<VendorItem>) request.getAttribute("inventory");
%>

<div class="card" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:14px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);">
    <div>
        <h2 style="margin:0;"><i class="fa-solid fa-boxes-stacked" style="color:var(--primary);"></i> Catalog &amp; Inventory Management</h2>
        <p class="text-muted" style="margin:4px 0 0 0;">Create global equipment items and assign vendor stock quantities and pricing.</p>
    </div>
    <div>
        <a class="btn btn-secondary btn-sm" href="<%=request.getContextPath()%>/adminDashboard.jsp">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</div>

<div class="grid-2">
    <!-- Add Catalog Item Form -->
    <div class="card">
        <h3 style="margin-bottom:18px;"><i class="fa-solid fa-circle-plus" style="color:var(--primary);"></i> Add Global Catalog Item</h3>
        <form action="<%=request.getContextPath()%>/ItemManagementServlet" method="post">
            <input type="hidden" name="action" value="addItem">
            <div class="form-group">
                <label>Item Name</label>
                <input type="text" name="itemName" required placeholder="e.g. VIP Banquet Chair">
            </div>
            <div class="form-group">
                <label>Description / Specification</label>
                <input type="text" name="description" placeholder="e.g. Cushioned chair with golden rim">
            </div>
            <button type="submit" class="btn btn-accent">
                <i class="fa-solid fa-plus"></i> Add to Master Catalog
            </button>
        </form>
    </div>

    <!-- Master Catalog Items List -->
    <div class="card">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;">
            <h3 style="margin:0;"><i class="fa-solid fa-list" style="color:var(--primary);"></i> Master Items</h3>
            <span class="badge badge-neutral"><%= items != null ? items.size() : 0 %> Items</span>
        </div>
        <div class="table-wrap" style="max-height:280px;overflow-y:auto;margin:0;">
        <table>
            <thead>
                <tr>
                    <th>Image</th>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <% if (items != null) for (Item i : items) { %>
                <tr>
                    <td>
                        <img class="item-photo" src="https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=240&q=80"
                             alt="<%= i.getItemName() %>" loading="lazy">
                    </td>
                    <td><strong>#<%= i.getItemId() %></strong></td>
                    <td><strong><%= i.getItemName() %></strong></td>
                    <td class="text-muted"><%= i.getDescription() != null ? i.getDescription() : "-" %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        </div>
    </div>
</div>

<!-- Vendor Specific Stock Allocation -->
<div class="card">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;flex-wrap:wrap;gap:12px;">
        <h3 style="margin:0;"><i class="fa-solid fa-sliders" style="color:var(--primary);"></i> Vendor Inventory Allocation</h3>
        <div style="min-width:260px;">
            <form method="get" action="<%=request.getContextPath()%>/ItemManagementServlet" style="margin:0;">
                <select name="vendorId" onchange="this.form.submit()" style="padding:8px 14px;font-weight:600;">
                    <option value="">-- Choose Vendor to Manage --</option>
                    <% if (vendors != null) for (Vendor v : vendors) { %>
                    <option value="<%= v.getVendorId() %>" <%= (selectedVendorId != null && selectedVendorId == v.getVendorId()) ? "selected" : "" %>>
                        <%= v.getVendorName() %>
                    </option>
                    <% } %>
                </select>
            </form>
        </div>
    </div>

    <% if (selectedVendorId != null) { %>
    <div class="table-wrap">
    <table>
        <thead>
            <tr>
                <th>Item Name</th>
                <th>Price / Day (&#8377;)</th>
                <th>Current Stock</th>
                <th style="text-align:right;">Save Allocation</th>
            </tr>
        </thead>
        <tbody>
            <% if (inventory != null && !inventory.isEmpty()) for (VendorItem vi : inventory) { %>
            <tr>
                <td><strong><%= vi.getItemName() %></strong></td>
                <td>&#8377;<%= vi.getPrice() %></td>
                <td><span class="badge badge-neutral"><%= vi.getStock() %> units</span></td>
                <td style="text-align:right;">
                    <form action="<%=request.getContextPath()%>/ItemManagementServlet" method="post" style="display:inline-flex;gap:8px;align-items:center;">
                        <input type="hidden" name="action" value="setVendorPrice">
                        <input type="hidden" name="vendorId" value="<%= selectedVendorId %>">
                        <input type="hidden" name="itemId" value="<%= vi.getItemId() %>">
                        <input type="number" step="0.01" name="price" value="<%= vi.getPrice() %>" style="width:100px;padding:6px 10px;" placeholder="Price">
                        <input type="number" name="stock" value="<%= vi.getStock() %>" style="width:85px;padding:6px 10px;" placeholder="Stock">
                        <button type="submit" class="btn btn-sm btn-secondary" title="Save rates">
                            <i class="fa-solid fa-floppy-disk"></i> Save
                        </button>
                    </form>
                </td>
            </tr>
            <% } %>

            <!-- Add new item to vendor inventory row -->
            <tr style="background:#f8fafc;">
                <td colspan="4">
                    <form action="<%=request.getContextPath()%>/ItemManagementServlet" method="post" style="display:flex;gap:12px;align-items:center;flex-wrap:wrap;padding:8px 0;">
                        <input type="hidden" name="action" value="setVendorPrice">
                        <input type="hidden" name="vendorId" value="<%= selectedVendorId %>">
                        <div style="font-weight:600;font-size:0.88rem;color:var(--primary);">
                            <i class="fa-solid fa-plus-circle"></i> Add New Item to this Vendor:
                        </div>
                        <select name="itemId" required style="width:200px;padding:6px 10px;">
                            <% if (items != null) for (Item i : items) { %>
                            <option value="<%= i.getItemId() %>"><%= i.getItemName() %></option>
                            <% } %>
                        </select>
                        <input type="number" step="0.01" name="price" placeholder="Price (&#8377;)" style="width:110px;padding:6px 10px;" required>
                        <input type="number" name="stock" placeholder="Stock Qty" style="width:100px;padding:6px 10px;" required>
                        <button type="submit" class="btn btn-sm btn-accent">
                            <i class="fa-solid fa-circle-check"></i> Assign to Vendor
                        </button>
                    </form>
                </td>
            </tr>
        </tbody>
    </table>
    </div>
    <% } else { %>
        <p class="text-muted" style="text-align:center;padding:24px;">Please select a vendor from the dropdown above to view and configure their inventory pricing and stock.</p>
    <% } %>
</div>

<%@ include file="footer.jsp" %>
