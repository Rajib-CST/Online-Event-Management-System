<%@ page import="java.util.List, model.VendorItem, model.Vendor" %>
<% request.setAttribute("pageTitle", "Select Equipment Items"); %>
<%@ include file="header.jsp" %>
<%
    Vendor vendor = (Vendor) request.getAttribute("vendor");
    List<VendorItem> inventory = (List<VendorItem>) request.getAttribute("inventory");
%>

<!-- Professional 6-Step Stepper -->
<jsp:include page="bookingStepper.jsp">
    <jsp:param name="step" value="3"/>
</jsp:include>

<div class="card" style="margin-bottom:20px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);">
    <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:14px;">
        <div style="display:flex;align-items:center;gap:14px;">
            <div style="width:54px;height:54px;border-radius:14px;background:var(--primary-subtle);color:var(--primary);display:flex;align-items:center;justify-content:center;font-size:1.5rem;">
                <i class="fa-solid fa-boxes-stacked"></i>
            </div>
            <div>
                <div style="display:flex;align-items:center;gap:10px;">
                    <h2 style="margin:0;"><%= vendor != null ? vendor.getVendorName() : "Vendor Equipment Catalog" %></h2>
                    <span class="badge badge-success"><i class="fa-solid fa-circle-check"></i> Verified Partner</span>
                </div>
                <p class="text-muted" style="margin:4px 0 0 0;">Step 3: Browse visual equipment items below, specify needed quantities, and watch your live total update.</p>
            </div>
        </div>
        <div>
            <span class="badge badge-info"><i class="fa-solid fa-layer-group"></i> Step 3 of 6: Choose Items</span>
        </div>
    </div>
</div>

<% String error = (String) request.getAttribute("error");
   if (error != null) { %>
    <div class="alert alert-error"><%= error %></div>
<% } %>

<!-- Visual Category Filter Bar -->
<div class="catalog-filter-bar">
    <button type="button" class="filter-chip active" onclick="filterCatalog('all', this)">
        <i class="fa-solid fa-border-all"></i> All Equipment
    </button>
    <button type="button" class="filter-chip" onclick="filterCatalog('chairs', this)">
        <i class="fa-solid fa-chair"></i> Chairs
    </button>
    <button type="button" class="filter-chip" onclick="filterCatalog('tables', this)">
        <i class="fa-solid fa-table"></i> Tables
    </button>
    <button type="button" class="filter-chip" onclick="filterCatalog('lighting', this)">
        <i class="fa-solid fa-lightbulb"></i> Lighting
    </button>
    <button type="button" class="filter-chip" onclick="filterCatalog('sound', this)">
        <i class="fa-solid fa-volume-high"></i> Sound Systems
    </button>
    <button type="button" class="filter-chip" onclick="filterCatalog('decor', this)">
        <i class="fa-solid fa-wand-magic-sparkles"></i> Stage &amp; Decor
    </button>
</div>

<form id="itemsForm" action="<%=request.getContextPath()%>/ItemServlet" method="post">
    <!-- Visual Rental Cards Grid -->
    <div class="catalog-cards-grid" id="catalogGrid">
        <% if (inventory != null && !inventory.isEmpty()) {
             int index = 0;
             for (VendorItem vi : inventory) {
                 index++;
                 String name = vi.getItemName() != null ? vi.getItemName() : "Rental Item";
                 String nameLower = name.toLowerCase();

                 String category = "decor";
                 String categoryDisplay = "Decor & Stage";
                 String imageUrl = "https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=600&q=80";

                 if (nameLower.contains("chair")) {
                     category = "chairs";
                     categoryDisplay = "Chairs";
                     imageUrl = "https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=600&q=80";
                 } else if (nameLower.contains("table")) {
                     category = "tables";
                     categoryDisplay = "Tables";
                     imageUrl = "https://images.unsplash.com/photo-1533090161767-e6ffed986c88?auto=format&fit=crop&w=600&q=80";
                 } else if (nameLower.contains("light") || nameLower.contains("lamp") || nameLower.contains("led") || nameLower.contains("spot")) {
                     category = "lighting";
                     categoryDisplay = "Lighting";
                     imageUrl = "https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&w=600&q=80";
                 } else if (nameLower.contains("sound") || nameLower.contains("music") || nameLower.contains("mic") || nameLower.contains("speaker") || nameLower.contains("dj")) {
                     category = "sound";
                     categoryDisplay = "Sound System";
                     imageUrl = "https://images.unsplash.com/photo-1545128485-c400e7702796?auto=format&fit=crop&w=600&q=80";
                 }
        %>
        <div class="catalog-item-card" data-category="<%= category %>">
            <div class="catalog-item-media">
                <img src="<%= imageUrl %>" alt="<%= name %>" class="catalog-item-img" loading="lazy">
                <span class="catalog-category-tag"><%= categoryDisplay %></span>
                <span class="catalog-stock-tag">
                    <i class="fa-solid fa-boxes-stacked"></i> <%= vi.getStock() %> available
                </span>
            </div>

            <div class="catalog-item-body">
                <h4 class="catalog-item-title"><%= name %></h4>

                <div class="catalog-item-rate">
                    <span class="catalog-price-val">&#8377;<%= vi.getPrice() %></span>
                    <span class="catalog-price-sub">/ day</span>
                </div>

                <input type="hidden" name="itemId" value="<%= vi.getItemId() %>">

                <div class="catalog-stepper-box">
                    <div class="qty-control-row">
                        <span style="font-size:0.84rem;font-weight:600;color:var(--text-secondary);">Quantity:</span>
                        <div class="stepper-btn-group">
                            <button type="button" class="stepper-btn" onclick="adjustQty(<%= index %>, -1)">
                                <i class="fa-solid fa-minus"></i>
                            </button>
                            <input type="number" id="qty-<%= index %>" name="quantity" class="stepper-val-input"
                                   value="0" min="0" max="<%= vi.getStock() %>"
                                   data-price="<%= vi.getPrice() %>" data-stock="<%= vi.getStock() %>" data-index="<%= index %>"
                                   onchange="validateAndRecalc(<%= index %>)" oninput="validateAndRecalc(<%= index %>)">
                            <button type="button" class="stepper-btn" onclick="adjustQty(<%= index %>, 1)">
                                <i class="fa-solid fa-plus"></i>
                            </button>
                        </div>
                    </div>
                    <div id="subtotal-box-<%= index %>" class="card-subtotal-disp">
                        Subtotal: &#8377;<span id="subtotal-val-<%= index %>">0.00</span>
                    </div>
                </div>
            </div>
        </div>
        <%   }
           } else { %>
        <div style="grid-column: 1 / -1; text-align:center; padding:50px 20px; background:#fff; border-radius:18px; border:1px solid var(--border);">
            <div style="font-size:3rem;color:var(--text-light);margin-bottom:14px;">
                <i class="fa-solid fa-boxes-packing"></i>
            </div>
            <h3>No Equipment Items Available</h3>
            <p class="text-muted">This vendor does not currently have any equipment items assigned to their inventory catalog.</p>
            <a href="<%=request.getContextPath()%>/home.jsp" class="btn btn-secondary mt-10">
                <i class="fa-solid fa-arrow-left"></i> Back to Vendor Search
            </a>
        </div>
        <% } %>
    </div>

    <!-- Floating Sticky Bottom Live Summary Bar -->
    <div class="sticky-summary-bar">
        <div class="sticky-summary-left">
            <div class="summary-metric-pill">
                <i class="fa-solid fa-cart-flatbed" style="color:#38bdf8;font-size:1.2rem;"></i>
                <span>Selected: <strong id="selected-units-count">0</strong> units (<strong id="selected-items-count">0</strong> items)</span>
            </div>
            <div class="summary-metric-pill" style="border-left:1px solid rgba(255,255,255,0.2);padding-left:16px;">
                <span>Daily Total:</span>
                <span class="summary-live-total">&#8377;<span id="grand-total-val">0.00</span></span>
            </div>
        </div>

        <div style="display:flex;align-items:center;gap:12px;">
            <a href="<%=request.getContextPath()%>/home.jsp" class="btn btn-secondary btn-sm" style="background:rgba(255,255,255,0.15);color:#ffffff;border:1px solid rgba(255,255,255,0.25);">
                <i class="fa-solid fa-arrow-left"></i> Change Vendor
            </a>
            <button type="submit" class="btn btn-accent btn-lg" style="box-shadow:0 8px 24px rgba(245, 158, 11, 0.45);">
                <span>Proceed to Review Price</span> <i class="fa-solid fa-arrow-right"></i>
            </button>
        </div>
    </div>
</form>

<script>
    function adjustQty(index, delta) {
        const input = document.getElementById('qty-' + index);
        if (!input) return;
        const currentVal = parseInt(input.value) || 0;
        const maxStock = parseInt(input.dataset.stock) || 0;
        let nextVal = currentVal + delta;
        if (nextVal < 0) nextVal = 0;
        if (nextVal > maxStock) nextVal = maxStock;
        input.value = nextVal;
        validateAndRecalc(index);
    }

    function validateAndRecalc(index) {
        const input = document.getElementById('qty-' + index);
        if (!input) return;
        const maxStock = parseInt(input.dataset.stock) || 0;
        const price = parseFloat(input.dataset.price) || 0;
        let qty = parseInt(input.value) || 0;

        if (qty < 0) qty = 0;
        if (qty > maxStock) qty = maxStock;
        input.value = qty;

        const subtotal = qty * price;
        const subtotalSpan = document.getElementById('subtotal-val-' + index);
        if (subtotalSpan) {
            subtotalSpan.textContent = subtotal.toFixed(2);
        }

        recalculateOverall();
    }

    function recalculateOverall() {
        const inputs = document.querySelectorAll('.stepper-val-input');
        let totalItems = 0;
        let totalUnits = 0;
        let grandTotal = 0.0;

        inputs.forEach(input => {
            const qty = parseInt(input.value) || 0;
            const price = parseFloat(input.dataset.price) || 0;
            if (qty > 0) {
                totalItems++;
                totalUnits += qty;
                grandTotal += (qty * price);
            }
        });

        document.getElementById('selected-items-count').textContent = totalItems;
        document.getElementById('selected-units-count').textContent = totalUnits;
        document.getElementById('grand-total-val').textContent = grandTotal.toFixed(2);
    }

    function filterCatalog(category, btn) {
        document.querySelectorAll('.filter-chip').forEach(c => c.classList.remove('active'));
        btn.classList.add('active');

        const cards = document.querySelectorAll('.catalog-item-card');
        cards.forEach(card => {
            if (category === 'all' || card.dataset.category === category) {
                card.style.display = 'flex';
            } else {
                card.style.display = 'none';
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        recalculateOverall();
    });
</script>

<%@ include file="footer.jsp" %>
