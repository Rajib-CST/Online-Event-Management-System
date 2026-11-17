package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RefundDAO {

    public static class RefundRecord {
        private int refundId;
        private int bookingId;
        private int paymentId;
        private String cancelledBy;
        private BigDecimal originalAmount;
        private BigDecimal customerRefund;
        private BigDecimal vendorDeduction;
        private BigDecimal adminRetained;
        private String refundStatus;
        private String refundTransactionId;
        private Timestamp refundDate;
        private String reason;

        public int getRefundId() { return refundId; }
        public void setRefundId(int refundId) { this.refundId = refundId; }
        public int getBookingId() { return bookingId; }
        public void setBookingId(int bookingId) { this.bookingId = bookingId; }
        public int getPaymentId() { return paymentId; }
        public void setPaymentId(int paymentId) { this.paymentId = paymentId; }
        public String getCancelledBy() { return cancelledBy; }
        public void setCancelledBy(String cancelledBy) { this.cancelledBy = cancelledBy; }
        public BigDecimal getOriginalAmount() { return originalAmount; }
        public void setOriginalAmount(BigDecimal originalAmount) { this.originalAmount = originalAmount; }
        public BigDecimal getCustomerRefund() { return customerRefund; }
        public void setCustomerRefund(BigDecimal customerRefund) { this.customerRefund = customerRefund; }
        public BigDecimal getVendorDeduction() { return vendorDeduction; }
        public void setVendorDeduction(BigDecimal vendorDeduction) { this.vendorDeduction = vendorDeduction; }
        public BigDecimal getAdminRetained() { return adminRetained; }
        public void setAdminRetained(BigDecimal adminRetained) { this.adminRetained = adminRetained; }
        public String getRefundStatus() { return refundStatus; }
        public void setRefundStatus(String refundStatus) { this.refundStatus = refundStatus; }
        public String getRefundTransactionId() { return refundTransactionId; }
        public void setRefundTransactionId(String refundTransactionId) { this.refundTransactionId = refundTransactionId; }
        public Timestamp getRefundDate() { return refundDate; }
        public void setRefundDate(Timestamp refundDate) { this.refundDate = refundDate; }
        public String getReason() { return reason; }
        public void setReason(String reason) { this.reason = reason; }
    }

    public boolean exists(Connection c, int bookingId) throws SQLException {
        try (PreparedStatement p = c.prepareStatement("SELECT 1 FROM refunds WHERE booking_id=?")) {
            p.setInt(1, bookingId);
            try (ResultSet r = p.executeQuery()) {
                return r.next();
            }
        }
    }

    public void insert(Connection c, int bookingId, int paymentId, String by, BigDecimal original,
                       BigDecimal customer, BigDecimal vendor, BigDecimal admin, String status,
                       String txn, String reason) throws SQLException {
        String s = "INSERT INTO refunds(booking_id,payment_id,cancelled_by,original_amount,customer_refund," +
                   "vendor_deduction,admin_retained,refund_status,refund_transaction_id,reason) VALUES(?,?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement p = c.prepareStatement(s)) {
            p.setInt(1, bookingId);
            p.setInt(2, paymentId);
            p.setString(3, by);
            p.setBigDecimal(4, original);
            p.setBigDecimal(5, customer);
            p.setBigDecimal(6, vendor);
            p.setBigDecimal(7, admin);
            p.setString(8, status);
            p.setString(9, txn);
            p.setString(10, reason);
            p.executeUpdate();
        }
    }

    public List<RefundRecord> getAllRefunds() throws SQLException {
        List<RefundRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM refunds ORDER BY refund_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public BigDecimal getTotalCustomerRefunds() throws SQLException {
        String sql = "SELECT COALESCE(SUM(customer_refund), 0) FROM refunds WHERE refund_status = 'SUCCESS'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getBigDecimal(1);
        }
    }

    public BigDecimal getTotalVendorDeductions() throws SQLException {
        String sql = "SELECT COALESCE(SUM(vendor_deduction), 0) FROM refunds WHERE refund_status = 'SUCCESS'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getBigDecimal(1);
        }
    }

    public BigDecimal getTotalVendorDeductions(int vendorId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(r.vendor_deduction), 0) " +
                     "FROM refunds r " +
                     "JOIN payments p ON r.payment_id = p.payment_id " +
                     "WHERE p.vendor_id = ? AND r.refund_status = 'SUCCESS'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getBigDecimal(1);
            }
        }
    }

    public BigDecimal getTotalAdminRetained() throws SQLException {
        String sql = "SELECT COALESCE(SUM(admin_retained), 0) FROM refunds WHERE refund_status = 'SUCCESS'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getBigDecimal(1);
        }
    }

    private RefundRecord mapRow(ResultSet rs) throws SQLException {
        RefundRecord r = new RefundRecord();
        r.setRefundId(rs.getInt("refund_id"));
        r.setBookingId(rs.getInt("booking_id"));
        r.setPaymentId(rs.getInt("payment_id"));
        r.setCancelledBy(rs.getString("cancelled_by"));
        r.setOriginalAmount(rs.getBigDecimal("original_amount"));
        r.setCustomerRefund(rs.getBigDecimal("customer_refund"));
        r.setVendorDeduction(rs.getBigDecimal("vendor_deduction"));
        r.setAdminRetained(rs.getBigDecimal("admin_retained"));
        r.setRefundStatus(rs.getString("refund_status"));
        r.setRefundTransactionId(rs.getString("refund_transaction_id"));
        r.setRefundDate(rs.getTimestamp("refund_date"));
        r.setReason(rs.getString("reason"));
        return r;
    }
}
