/* ============================================================
   OnlineEventManagement - script.js
   Client-side UX helpers only.
   IMPORTANT: The server NEVER trusts these numbers. Every
   servlet (CartServlet, BookingServlet, PaymentServlet) re-reads
   price/stock from MySQL and recalculates totals itself.
   ============================================================ */

function recalcItemTotals() {
  var inputs = document.querySelectorAll(".qty-input");
  var grandTotal = 0;

  inputs.forEach(function (input) {
    var price = parseFloat(input.getAttribute("data-price")) || 0;
    var stock = parseInt(input.getAttribute("data-stock"), 10) || 0;
    var row = input.getAttribute("data-row");
    var qty = parseInt(input.value, 10);

    if (isNaN(qty) || qty < 0) {
      qty = 0;
      input.value = 0;
    }
    if (qty > stock) {
      qty = stock;
      input.value = stock;
      showQtyWarning(row);
    } else {
      hideQtyWarning(row);
    }

    var subtotal = qty * price;
    grandTotal += subtotal;

    var subtotalEl = document.getElementById("subtotal-" + row);
    if (subtotalEl) {
      subtotalEl.textContent = formatCurrency(subtotal);
    }
  });

  var totalEl = document.getElementById("grand-total");
  if (totalEl) {
    totalEl.textContent = formatCurrency(grandTotal);
  }
}

function showQtyWarning(row) {
  var warn = document.getElementById("warn-" + row);
  if (warn) warn.style.display = "block";
}

function hideQtyWarning(row) {
  var warn = document.getElementById("warn-" + row);
  if (warn) warn.style.display = "none";
}

function formatCurrency(amount) {
  return amount.toLocaleString("en-IN", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function confirmAction(message) {
  return window.confirm(message);
}

document.addEventListener("DOMContentLoaded", function () {
  var qtyInputs = document.querySelectorAll(".qty-input");
  if (qtyInputs.length > 0) {
    qtyInputs.forEach(function (input) {
      input.addEventListener("input", recalcItemTotals);
    });
    recalcItemTotals();
  }

  // Prevent selecting dates in the past
  var dateInputs = document.querySelectorAll('input[type="date"][name="eventDate"]');
  var today = new Date().toISOString().split("T")[0];
  dateInputs.forEach(function (d) {
    if (!d.getAttribute("min")) {
      d.setAttribute("min", today);
    }
  });

  var alerts = document.querySelectorAll(".alert[data-autohide]");
  alerts.forEach(function (a) {
    setTimeout(function () {
      a.style.transition = "opacity 0.5s";
      a.style.opacity = "0";
      setTimeout(function () { a.style.display = "none"; }, 500);
    }, 5000);
  });
});
