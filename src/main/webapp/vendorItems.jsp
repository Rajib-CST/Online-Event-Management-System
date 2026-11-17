<%@ page import="java.util.*,model.VendorItem" %>
<% request.setAttribute("pageTitle","My Inventory Items"); %>
<%@ include file="header.jsp" %>

<div class="card" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:14px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);">
    <div>
        <h2 style="margin:0;"><i class="fa-solid fa-boxes-stacked" style="color:var(--primary);"></i> My Rental Inventory</h2>
        <p class="text-muted" style="margin:4px 0 0 0;">Update equipment daily rental rates, stock quantities, and availability status.</p>
    </div>
    <div>
        <a class="btn btn-secondary btn-sm" href="<%=request.getContextPath()%>/VendorDashboardServlet">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</div>

<div class="card">
    <% List<VendorItem> l = (List<VendorItem>) request.getAttribute("inventory");
       if (l == null || l.isEmpty()) { %>
        <p class="text-muted" style="text-align:center;padding:32px;">No equipment catalog currently assigned. Contact administrator to allocate catalog items.</p>
    <% } else { %>
        <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Item Name</th>
                    <th>Daily Rate (&#8377;)</th>
                    <th>Stock Qty</th>
                    <th>Availability</th>
                    <th style="text-align:right;">Save Changes</th>
                </tr>
            </thead>
            <tbody>
                <% for (VendorItem v : l) {
                    String itemNameLower = v.getItemName() != null ? v.getItemName().toLowerCase() : "";
                    String itemImage = "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=240&q=80";
                    if (itemNameLower.contains("chair")) itemImage = "https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=240&q=80";
                    else if (itemNameLower.contains("table")) itemImage = "https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=240&q=80";
                    else if (itemNameLower.contains("light")) itemImage = "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=240&q=80";
                    else if (itemNameLower.contains("music") || itemNameLower.contains("sound")) itemImage = "https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?auto=format&fit=crop&w=240&q=80";
                    else if (itemNameLower.contains("decoration") || itemNameLower.contains("decor")) itemImage = "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=240&q=80";
                %>
                <tr>
                    <td>
                        <div style="display:flex;align-items:center;gap:10px;">
                            <img class="item-photo" src="<%= itemImage %>" alt="<%= v.getItemName() %>" loading="lazy">
                            <strong style="color:var(--text);"><%= v.getItemName() %></strong>
                        </div>
                    </td>
                    <form action="<%=request.getContextPath()%>/VendorItemServlet" method="post">
                        <input type="hidden" name="itemId" value="<%= v.getItemId() %>">
                        <td>
                            <input name="price" type="number" step="0.01" value="<%= v.getPrice() %>" required style="width:110px;padding:6px 10px;">
                        </td>
                        <td>
                            <input name="stock" type="number" min="0" value="<%= v.getStock() %>" required style="width:90px;padding:6px 10px;">
                        </td>
                        <td>
                            <select name="available" style="width:130px;padding:6px 10px;">
                                <option value="true" <%= v.isAvailable() ? "selected" : "" %>>Available</option>
                                <option value="false" <%= !v.isAvailable() ? "selected" : "" %>>Unavailable</option>
                            </select>
                        </td>
                        <td style="text-align:right;">
                            <button class="btn btn-sm btn-accent" type="submit">
                                <i class="fa-solid fa-floppy-disk"></i> Save
                            </button>
                        </td>
                    </form>
                </tr>
                <% } %>
            </tbody>
        </table>
        </div>
    <% } %>
</div>

<%@ include file="footer.jsp" %>