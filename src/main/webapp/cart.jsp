<%@ page import="java.util.List, model.CartItem, java.math.BigDecimal" %>
<% request.setAttribute("pageTitle", "Your Cart"); %>
<%@ include file="header.jsp" %>
<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    BigDecimal total = BigDecimal.ZERO;
    if (cart != null) for (CartItem ci : cart) total = total.add(ci.getSubtotal());
    int bookingDays = session.getAttribute("bookingDays") != null
            ? Integer.parseInt(session.getAttribute("bookingDays").toString()) : 1;
    BigDecimal estimatedTotal = total.multiply(BigDecimal.valueOf(bookingDays));
    BigDecimal minimumCheckoutAmount = new BigDecimal("5000.00");
    boolean meetsMinimum = estimatedTotal.compareTo(minimumCheckoutAmount) >= 0;
%>

<!-- Professional 6-Step Stepper -->
<jsp:include page="bookingStepper.jsp">
    <jsp:param name="step" value="4"/>
</jsp:include>

<div class="card" style="margin-bottom:20px;background:linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);">
    <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:14px;">
        <div>
            <h2 style="margin:0;"><i class="fa-solid fa-cart-shopping" style="color:var(--primary);"></i> Review Equipment Cart &amp; Price</h2>
            <p class="text-muted" style="margin:4px 0 0 0;">
                Step 4: Check item quantities and review daily pricing for <strong><%= session.getAttribute("eventDate") %></strong> in <strong><%= session.getAttribute("location") %></strong>.
            </p>
        </div>
        <div>
            <span class="badge badge-info" style="font-size:0.88rem;padding:6px 14px;">
                <i class="fa-solid fa-receipt"></i> Step 4 of 6: Review Price
            </span>
        </div>
    </div>
</div>

<div class="card">
    <% String error = (String) request.getAttribute("error");
       if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
    <% } %>

    <% if (cart == null || cart.isEmpty()) { %>
        <div style="text-align:center;padding:48px 20px;">
            <div style="font-size:3.5rem;color:var(--text-light);margin-bottom:16px;">
                <i class="fa-solid fa-cart-arrow-down"></i>
            </div>
            <h3>Your Cart is Empty</h3>
            <p class="text-muted">You haven't added any event equipment to your cart yet.</p>
            <div class="btn-row" style="justify-content:center;margin-top:20px;">
                <a class="btn btn-accent" href="<%=request.getContextPath()%>/home.jsp">
                    <i class="fa-solid fa-plus-circle"></i> Start New Booking
                </a>
            </div>
        </div>
    <% } else { %>
        <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Item Description</th>
                    <th style="width:220px;">Quantity</th>
                    <th>Rate / Day</th>
                    <th>Subtotal</th>
                    <th style="text-align:right;">Remove</th>
                </tr>
            </thead>
            <tbody>
                <% for (CartItem ci : cart) { %>
                <tr>
                    <td>
                        <div style="display:flex;align-items:center;gap:10px;">
                            <div style="width:36px;height:36px;border-radius:8px;background:var(--primary-subtle);color:var(--primary);display:flex;align-items:center;justify-content:center;font-size:0.9rem;">
                                <i class="fa-solid fa-box-open"></i>
                            </div>
                            <strong style="color:var(--text);font-size:0.96rem;"><%= ci.getItemName() %></strong>
                        </div>
                    </td>
                    <td>
                        <form action="<%=request.getContextPath()%>/CartServlet" method="post" style="display:flex;gap:8px;align-items:center;">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="itemId" value="<%= ci.getItemId() %>">
                            <input type="number" name="quantity" value="<%= ci.getQuantity() %>" min="0" style="width:85px;padding:6px 10px;font-weight:700;">
                            <button type="submit" class="btn btn-sm btn-secondary" title="Save updated quantity">
                                <i class="fa-solid fa-check"></i>
                            </button>
                        </form>
                    </td>
                    <td>&#8377;<%= ci.getUnitPrice() %> <span style="font-size:0.75rem;color:var(--text-muted);">/ day</span></td>
                    <td><strong style="color:var(--text);font-size:1.05rem;">&#8377;<%= ci.getSubtotal() %></strong></td>
                    <td style="text-align:right;">
                        <form action="<%=request.getContextPath()%>/CartServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="itemId" value="<%= ci.getItemId() %>">
                            <button type="submit" class="btn btn-sm btn-danger"
                                    onclick="return confirmAction('Remove this item from your cart?');">
                                <i class="fa-solid fa-trash-can"></i>
                            </button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        </div>

        <div class="summary-box mt-20">
            <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;">
                <div>
                    <h4 style="margin:0;color:var(--text);">One-Day Item Total</h4>
                    <p class="text-muted" style="margin:2px 0 0 0;font-size:0.85rem;">
                        Note: The final booking total will be: <strong>One-day total &times; <%= session.getAttribute("bookingDays") %> day(s)</strong>.
                    </p>
                    <p class="<%= meetsMinimum ? "text-muted" : "minimum-checkout-warning" %>" style="margin:5px 0 0 0;font-size:0.85rem;">
                        Minimum checkout: <strong>&#8377;5,000</strong>.
                        Estimated booking total: <strong>&#8377;<%= estimatedTotal %></strong>
                        <% if (!meetsMinimum) { %>
                            — add <strong>&#8377;<%= minimumCheckoutAmount.subtract(estimatedTotal) %></strong> to continue.
                        <% } %>
                    </p>
                </div>
                <div class="summary-total" style="margin:0;border:none;padding:0;">
                    &#8377;<%= total %>
                </div>
            </div>
        </div>

        <div class="btn-row" style="justify-content:flex-end;margin-top:24px;">
            <a class="btn btn-secondary" href="<%=request.getContextPath()%>/home.jsp">
                <i class="fa-solid fa-arrow-left"></i> Change Event Details
            </a>
            <% if (meetsMinimum) { %>
            <a class="btn btn-accent btn-lg" href="<%=request.getContextPath()%>/BookingServlet">
                <span>Proceed to Summary &amp; Checkout</span> <i class="fa-solid fa-arrow-right"></i>
            </a>
            <% } else { %>
            <button class="btn btn-accent btn-lg" type="button" disabled title="Cart total must be at least ₹5,000">
                <span>Minimum ₹5,000 Required</span> <i class="fa-solid fa-lock"></i>
            </button>
            <% } %>
        </div>
    <% } %>
</div>

<%@ include file="footer.jsp" %>
