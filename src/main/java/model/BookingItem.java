package model;

import java.math.BigDecimal;

public class BookingItem {
    private int bookingItemId;
    private int bookingId;
    private int itemId;
    private String itemName;  // convenience (joined)
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal subtotal;

    public BookingItem() {}

    public BookingItem(int itemId, String itemName, int quantity, BigDecimal unitPrice, BigDecimal subtotal) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = subtotal;
    }

    public int getBookingItemId() { return bookingItemId; }
    public void setBookingItemId(int bookingItemId) { this.bookingItemId = bookingItemId; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    @Override
    public String toString() {
        return "BookingItem{itemName='" + itemName + "', quantity=" + quantity + ", subtotal=" + subtotal + "}";
    }
}
