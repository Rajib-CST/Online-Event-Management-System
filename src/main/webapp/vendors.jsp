<%@ page import="java.util.List, model.Vendor" %>
<% request.setAttribute("pageTitle", "Select Partner Vendor"); %>
<%@ include file="header.jsp" %>
<%
    List<Vendor> vendors = (List<Vendor>) request.getAttribute("vendors");
%>

<!-- Professional 6-Step Stepper -->
<jsp:include page="bookingStepper.jsp">
    <jsp:param name="step" value="2"/>
</jsp:include>

<div class="card" style="margin-bottom:24px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);">
    <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:14px;margin-bottom:14px;">
        <div>
            <h2 style="margin:0;"><i class="fa-solid fa-store" style="color:var(--primary);"></i> Available Event Vendors</h2>
            <p class="text-muted" style="margin:4px 0 0 0;">Step 2: Choose a verified vendor partner providing services for your date &amp; city.</p>
        </div>
        <span class="badge badge-info"><i class="fa-solid fa-circle-check"></i> Step 2 of 6: Select Vendor</span>
    </div>
    
    <div style="display:flex;flex-wrap:wrap;gap:10px;align-items:center;background:#f8fafc;padding:12px 16px;border-radius:12px;border:1px solid var(--border);">
        <span class="badge badge-neutral" style="font-size:0.86rem;padding:6px 14px;">
            <i class="fa-solid fa-cake-candles" style="color:var(--primary);"></i> <%= session.getAttribute("eventType") %>
        </span>
        <span class="badge badge-neutral" style="font-size:0.86rem;padding:6px 14px;">
            <i class="fa-solid fa-calendar-day" style="color:var(--primary);"></i> <%= session.getAttribute("eventDate") %>
        </span>
        <span class="badge badge-neutral" style="font-size:0.86rem;padding:6px 14px;">
            <i class="fa-solid fa-location-dot" style="color:var(--primary);"></i> <%= session.getAttribute("location") %>
        </span>
        <span class="badge badge-neutral" style="font-size:0.86rem;padding:6px 14px;">
            <i class="fa-solid fa-clock" style="color:var(--primary);"></i> <%= session.getAttribute("bookingDays") %> Day(s) Duration
        </span>
        <a href="<%=request.getContextPath()%>/home.jsp" class="btn btn-secondary btn-sm" style="margin-left:auto;">
            <i class="fa-solid fa-pen-to-square"></i> Change Filters
        </a>
    </div>
</div>

<% String error = (String) request.getAttribute("error");
   if (error != null) { %>
    <div class="alert alert-error"><%= error %></div>
<% } %>

<% if (vendors == null || vendors.isEmpty()) { %>
    <div class="card" style="text-align:center;padding:50px 20px;">
        <div style="font-size:3.5rem;color:var(--text-light);margin-bottom:16px;">
            <i class="fa-solid fa-shop-slash"></i>
        </div>
        <h3>No Vendors Available for This Date</h3>
        <p class="text-muted" style="max-width:480px;margin:0 auto 20px;">
            All partner vendors are currently fully booked in <strong><%= session.getAttribute("location") %></strong> for <strong><%= session.getAttribute("eventDate") %></strong>.
        </p>
        <div class="btn-row" style="justify-content:center;">
            <a class="btn btn-accent" href="<%=request.getContextPath()%>/home.jsp">
                <i class="fa-solid fa-arrow-left"></i> Change Event Date or City
            </a>
        </div>
    </div>
<% } else { %>
    <!-- Visual Vendor Cards Grid -->
    <div class="catalog-cards-grid" style="grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));">
        <% for (Vendor v : vendors) { %>
        <div class="card" style="margin:0;display:flex;flex-direction:column;justify-content:space-between;border:1px solid var(--border);border-radius:18px;transition:var(--transition);position:relative;">
            <div>
                <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:14px;">
                    <div style="display:flex;align-items:center;gap:12px;">
                        <div style="width:52px;height:52px;border-radius:14px;background:var(--primary-subtle);color:var(--primary);display:flex;align-items:center;justify-content:center;font-size:1.4rem;">
                            <i class="fa-solid fa-store"></i>
                        </div>
                        <div>
                            <h3 style="margin:0;font-size:1.15rem;"><%= v.getVendorName() %></h3>
                            <div style="font-size:0.82rem;color:var(--text-muted);margin-top:2px;">
                                <i class="fa-solid fa-location-dot" style="color:var(--primary);"></i> <%= v.getAddress() != null ? v.getAddress() : session.getAttribute("location") %>
                            </div>
                        </div>
                    </div>

                    <% if (v.isAvailable()) { %>
                        <span class="badge badge-success"><i class="fa-solid fa-circle-check"></i> Available</span>
                    <% } else { %>
                        <span class="badge badge-danger"><i class="fa-solid fa-circle-xmark"></i> Booked</span>
                    <% } %>
                </div>

                <p style="font-size:0.88rem;color:var(--text-secondary);min-height:42px;margin-bottom:14px;">
                    <%= v.getDescription() != null && !v.getDescription().trim().isEmpty() 
                        ? v.getDescription() 
                        : "Premium event equipment provider: Chairs, Tables, Ambient Lighting, Sound Systems & Stage decor." %>
                </p>

                <div style="display:flex;flex-wrap:wrap;gap:6px;margin-bottom:18px;">
                    <span class="badge badge-neutral" style="font-size:0.75rem;"><i class="fa-solid fa-chair"></i> Chairs &amp; Tables</span>
                    <span class="badge badge-neutral" style="font-size:0.75rem;"><i class="fa-solid fa-lightbulb"></i> Lighting</span>
                    <span class="badge badge-neutral" style="font-size:0.75rem;"><i class="fa-solid fa-volume-high"></i> Sound &amp; DJ</span>
                </div>
            </div>

            <div style="padding-top:14px;border-top:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;">
                <div style="font-size:0.84rem;color:var(--text-muted);">
                    <i class="fa-solid fa-phone"></i> <%= v.getContact() %>
                </div>
                <div>
                    <% if (v.isAvailable()) { %>
                        <a class="btn btn-accent btn-sm" href="<%=request.getContextPath()%>/VendorServlet?vendorId=<%= v.getVendorId() %>">
                            <span>Browse Catalog</span> <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    <% } else { %>
                        <button class="btn btn-sm btn-secondary" disabled>Fully Booked</button>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </div>
<% } %>

<%@ include file="footer.jsp" %>
