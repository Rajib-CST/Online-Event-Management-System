<%@ page import="java.util.List, java.math.BigDecimal, model.Booking, dao.BookingDAO" %>
<% request.setAttribute("pageTitle", "Customer Dashboard"); %>
<%@ include file="header.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    List<Booking> userBookings = null;
    int upcomingCount = 0;
    BigDecimal totalSpend = BigDecimal.ZERO;
    String nextEventDateStr = "No events scheduled";

    if (userId != null) {
        try {
            userBookings = new BookingDAO().getBookingsForUser(userId);
            if (userBookings != null) {
                for (Booking b : userBookings) {
                    if (b.getTotalAmount() != null) {
                        totalSpend = totalSpend.add(b.getTotalAmount());
                    }
                    if ("CONFIRMED".equalsIgnoreCase(b.getBookingStatus())) {
                        upcomingCount++;
                        if (nextEventDateStr.equals("No events scheduled") && b.getEventDate() != null) {
                            nextEventDateStr = b.getEventDate().toString();
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!-- Hero Welcome Section with Prominent Book an Event CTA -->
<div class="cust-hero">
    <div class="cust-hero-left">
        <div class="cust-avatar-badge">
            <i class="fa-solid fa-champagne-glasses"></i>
        </div>
        <div>
            <h2>Welcome back, <%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "Guest" %>!</h2>
            <p>Plan celebrations, rent premium equipment, and monitor all your reservations in one place.</p>
        </div>
    </div>
    <div>
        <a href="#booking-section" class="btn-book-hero">
            <i class="fa-solid fa-calendar-plus"></i>
            <span>Book an Event</span>
        </a>
    </div>
</div>

<!-- Schedulo-Style Metric Stats Cards -->
<div class="cust-stats-row">
    <div class="cust-stat-card">
        <div class="cust-stat-icon blue">
            <i class="fa-solid fa-calendar-check"></i>
        </div>
        <div>
            <div class="cust-stat-val"><%= upcomingCount %></div>
            <div class="cust-stat-label">Upcoming Bookings</div>
        </div>
    </div>

    <div class="cust-stat-card">
        <div class="cust-stat-icon amber">
            <i class="fa-solid fa-clock"></i>
        </div>
        <div>
            <div class="cust-stat-val" style="font-size:1.15rem;font-weight:700;"><%= nextEventDateStr %></div>
            <div class="cust-stat-label">Next Event Date</div>
        </div>
    </div>

    <div class="cust-stat-card">
        <div class="cust-stat-icon green">
            <i class="fa-solid fa-indian-rupee-sign"></i>
        </div>
        <div>
            <div class="cust-stat-val">&#8377;<%= totalSpend %></div>
            <div class="cust-stat-label">Total Investment</div>
        </div>
    </div>
</div>

<!-- Upcoming Bookings Section -->
<div class="card" style="margin-bottom:28px;">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;flex-wrap:wrap;gap:12px;">
        <div>
            <h3 style="margin:0;"><i class="fa-solid fa-calendar-days" style="color:var(--primary);"></i> Upcoming &amp; Recent Bookings</h3>
            <p class="text-muted" style="margin:2px 0 0 0;font-size:0.88rem;">Track event dates, vendor assignments, total price, and real-time status.</p>
        </div>
        <div>
            <a class="btn btn-secondary btn-sm" href="<%=request.getContextPath()%>/MyBookingsServlet">
                <span>View All Invoices</span> <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>
    </div>

    <% if (userBookings == null || userBookings.isEmpty()) { %>
        <div style="text-align:center;padding:36px 16px;background:#f8fafc;border-radius:14px;border:1px dashed #cbd5e1;">
            <div style="font-size:2.8rem;color:var(--text-light);margin-bottom:12px;">
                <i class="fa-solid fa-calendar-xmark"></i>
            </div>
            <h4 style="margin:0 0 6px;">No Bookings Scheduled Yet</h4>
            <p class="text-muted" style="max-width:440px;margin:0 auto 16px;font-size:0.9rem;">
                You don't have any event equipment reservations right now. Start by choosing your celebration date below!
            </p>
            <a href="#booking-section" class="btn btn-accent btn-sm">
                <i class="fa-solid fa-plus-circle"></i> Book Your First Event
            </a>
        </div>
    <% } else {
         int shown = 0;
         for (Booking b : userBookings) {
             if (shown >= 4) break;
             shown++;
    %>
    <div class="upcoming-booking-card">
        <div style="display:flex;align-items:center;gap:16px;">
            <div style="width:48px;height:48px;border-radius:14px;background:var(--primary-subtle);color:var(--primary);display:flex;align-items:center;justify-content:center;font-size:1.3rem;flex-shrink:0;">
                <% if (b.getEventType() != null && b.getEventType().toLowerCase().contains("wedding")) { %>
                    <i class="fa-solid fa-ring"></i>
                <% } else if (b.getEventType() != null && b.getEventType().toLowerCase().contains("birth")) { %>
                    <i class="fa-solid fa-cake-candles"></i>
                <% } else if (b.getEventType() != null && b.getEventType().toLowerCase().contains("corp")) { %>
                    <i class="fa-solid fa-briefcase"></i>
                <% } else { %>
                    <i class="fa-solid fa-champagne-glasses"></i>
                <% } %>
            </div>
            <div>
                <div style="display:flex;align-items:center;gap:8px;">
                    <span class="badge badge-info" style="font-size:0.78rem;">#B<%= b.getBookingId() %></span>
                    <strong style="font-size:1.05rem;color:var(--text);"><%= b.getEventType() %></strong>
                </div>
                <div style="display:flex;gap:16px;flex-wrap:wrap;margin-top:6px;font-size:0.86rem;color:var(--text-secondary);">
                    <span><i class="fa-solid fa-calendar-day" style="color:var(--primary);"></i> <strong>Event Date:</strong> <%= b.getEventDate() %></span>
                    <span><i class="fa-solid fa-store" style="color:var(--primary);"></i> <strong>Vendor:</strong> <%= b.getVendorName() %></span>
                </div>
            </div>
        </div>

        <div style="display:flex;align-items:center;gap:24px;flex-wrap:wrap;">
            <div style="text-align:right;">
                <div style="font-size:0.75rem;text-transform:uppercase;color:var(--text-muted);font-weight:700;">Total Price</div>
                <div style="font-family:'Outfit',sans-serif;font-weight:800;font-size:1.35rem;color:var(--primary-dark);">
                    &#8377;<%= b.getTotalAmount() %>
                </div>
            </div>

            <div>
                <% if ("CONFIRMED".equalsIgnoreCase(b.getBookingStatus())) { %>
                    <span class="badge badge-success"><i class="fa-solid fa-circle-check"></i> CONFIRMED</span>
                <% } else if ("COMPLETED".equalsIgnoreCase(b.getBookingStatus()) || "COMPLETE".equalsIgnoreCase(b.getBookingStatus())) { %>
                    <span class="badge badge-completed"><i class="fa-solid fa-circle-check"></i> COMPLETED</span>
                <% } else { %>
                    <span class="badge badge-danger"><i class="fa-solid fa-circle-xmark"></i> <%= b.getBookingStatus() %></span>
                <% } %>
            </div>

            <div>
                <a class="btn btn-secondary btn-sm" href="<%=request.getContextPath()%>/BookingDetailsServlet?bookingId=<%= b.getBookingId() %>">
                    <i class="fa-solid fa-file-invoice"></i> Receipt
                </a>
            </div>
        </div>
    </div>
    <%   }
       } %>
</div>

<!-- Prominent Book an Event Flow (Step 1 of 6) -->
<div id="booking-section">
    <!-- Professional 6-Step Stepper -->
    <jsp:include page="bookingStepper.jsp">
        <jsp:param name="step" value="1"/>
    </jsp:include>

    <div class="card" style="box-shadow:var(--shadow-lg);">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;flex-wrap:wrap;gap:10px;">
            <div>
                <h3 style="margin:0;"><i class="fa-solid fa-wand-magic-sparkles" style="color:var(--primary);"></i> Plan &amp; Book an Event</h3>
                <p class="text-muted" style="margin:4px 0 0 0;font-size:0.9rem;">Step 1: Choose your event type, date, location, and celebration duration.</p>
            </div>
            <span class="badge badge-info"><i class="fa-solid fa-clock"></i> Step 1 of 6: Choose Date</span>
        </div>
        
        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>
        
        <form action="<%=request.getContextPath()%>/AvailabilityServlet" method="post">
            <div class="grid-2">
                <div class="form-group">
                    <label><i class="fa-solid fa-cake-candles"></i> Event Type</label>
                    <select name="eventType" required>
                        <option value="Birthday">&#127874; Birthday Celebration</option>
                        <option value="Marriage">&#128141; Wedding / Reception</option>
                        <option value="Party">&#127881; Party / Gathering</option>
                        <option value="Corporate Program">&#128188; Corporate Program</option>
                        <option value="Cultural Program">&#127917; Cultural Program</option>
                        <option value="Other">&#10024; Other Occasion</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fa-solid fa-calendar-day"></i> Event Date</label>
                    <input type="date" name="eventDate" required id="bookingEventDate">
                </div>
                <div class="form-group">
                    <label><i class="fa-solid fa-location-dot"></i> City / Location</label>
                    <select name="location" required>
                        <option value="">Select event location</option>
                        <option value="Asansol">Asansol</option>
                        <option value="Durgapur">Durgapur</option>
                        <option value="Bardhaman">Bardhaman</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fa-solid fa-hourglass-half"></i> Event Duration</label>
                    <select name="days" required>
                        <option value="">Select duration (days)</option>
                        <% for (int day = 1; day <= 7; day++) { %>
                        <option value="<%= day %>"><%= day %> day<%= day == 1 ? "" : "s" %></option>
                        <% } %>
                    </select>
                </div>
            </div>
            <div class="btn-row" style="margin-top:16px;">
                <button type="submit" class="btn btn-accent btn-lg" style="box-shadow:0 8px 20px rgba(245, 158, 11, 0.35);">
                    <span>Find Available Vendors</span> <i class="fa-solid fa-arrow-right"></i>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Ensure date picker minimum is tomorrow
    document.addEventListener('DOMContentLoaded', function() {
        const dateInput = document.getElementById('bookingEventDate');
        if (dateInput) {
            const today = new Date();
            today.setDate(today.getDate() + 1);
            dateInput.min = today.toISOString().split('T')[0];
        }
    });
</script>

<%@ include file="footer.jsp" %>
