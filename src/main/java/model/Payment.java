package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
    private int paymentId;
    private int bookingId;
    private int userId;
    private int vendorId;
    private int customerAccountId;
    private BigDecimal amount;
    private BigDecimal vendorAmount;
    private BigDecimal adminAmount;
    private String transactionId;
    private String paymentStatus; // SUCCESS / FAILED
    private Timestamp paymentDate;

    // Refund tracking fields (populated when payment has an associated refund)
    private boolean refunded;
    private BigDecimal customerRefund;
    private BigDecimal vendorDeduction;
    private BigDecimal adminRetained;
    private String refundTransactionId;
    private String cancelledBy;
    private String refundReason;
    private Timestamp refundDate;

    public Payment() {}

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getVendorId() { return vendorId; }
    public void setVendorId(int vendorId) { this.vendorId = vendorId; }

    public int getCustomerAccountId() { return customerAccountId; }
    public void setCustomerAccountId(int customerAccountId) { this.customerAccountId = customerAccountId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public BigDecimal getVendorAmount() { return vendorAmount; }
    public void setVendorAmount(BigDecimal vendorAmount) { this.vendorAmount = vendorAmount; }

    public BigDecimal getAdminAmount() { return adminAmount; }
    public void setAdminAmount(BigDecimal adminAmount) { this.adminAmount = adminAmount; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Timestamp getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Timestamp paymentDate) { this.paymentDate = paymentDate; }

    public boolean isRefunded() { return refunded; }
    public void setRefunded(boolean refunded) { this.refunded = refunded; }

    public BigDecimal getCustomerRefund() { return customerRefund; }
    public void setCustomerRefund(BigDecimal customerRefund) { this.customerRefund = customerRefund; }

    public BigDecimal getVendorDeduction() { return vendorDeduction; }
    public void setVendorDeduction(BigDecimal vendorDeduction) { this.vendorDeduction = vendorDeduction; }

    public BigDecimal getAdminRetained() { return adminRetained; }
    public void setAdminRetained(BigDecimal adminRetained) { this.adminRetained = adminRetained; }

    public String getRefundTransactionId() { return refundTransactionId; }
    public void setRefundTransactionId(String refundTransactionId) { this.refundTransactionId = refundTransactionId; }

    public String getCancelledBy() { return cancelledBy; }
    public void setCancelledBy(String cancelledBy) { this.cancelledBy = cancelledBy; }

    public String getRefundReason() { return refundReason; }
    public void setRefundReason(String refundReason) { this.refundReason = refundReason; }

    public Timestamp getRefundDate() { return refundDate; }
    public void setRefundDate(Timestamp refundDate) { this.refundDate = refundDate; }

    @Override
    public String toString() {
        return "Payment{transactionId='" + transactionId + "', amount=" + amount + ", status='" + paymentStatus +
               "', refunded=" + refunded + "}";
    }
}
