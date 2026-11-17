package dao;

import model.Payment;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    /** Must run on the SAME connection as the rest of the payment transaction. */
    public int insertPayment(Connection con, int bookingId, int userId, int vendorId, int customerAccountId,
                              BigDecimal amount, BigDecimal vendorAmount, BigDecimal adminAmount,
                              String transactionId, String status) throws SQLException {
        String sql = "INSERT INTO payments (booking_id, user_id, vendor_id, customer_account_id, amount, " +
                     "vendor_amount, admin_amount, transaction_id, payment_status) VALUES (?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            ps.setInt(3, vendorId);
            ps.setInt(4, customerAccountId);
            ps.setBigDecimal(5, amount);
            ps.setBigDecimal(6, vendorAmount);
            ps.setBigDecimal(7, adminAmount);
            ps.setString(8, transactionId);
            ps.setString(9, status);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        return -1;
    }

    public List<Payment> getAllPayments() throws SQLException {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, r.refund_id, r.customer_refund, r.vendor_deduction, r.admin_retained, " +
                     "r.refund_transaction_id, r.cancelled_by, r.reason AS refund_reason, r.refund_date " +
                     "FROM payments p " +
                     "LEFT JOIN refunds r ON p.payment_id = r.payment_id AND r.refund_status = 'SUCCESS' " +
                     "ORDER BY p.payment_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Gross payment volume collected from all successful bookings. */
    public BigDecimal getTotalGrossVolume() throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount),0) FROM payments WHERE payment_status='SUCCESS'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getBigDecimal(1);
        }
    }

    /** Gross 90% vendor share before any refund deductions. */
    public BigDecimal getTotalVendorGrossEarnings(int vendorId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(vendor_amount),0) FROM payments WHERE vendor_id = ? AND payment_status='SUCCESS'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getBigDecimal(1);
            }
        }
    }

    /** Total gross 90% vendor share across all vendors. */
    public BigDecimal getTotalVendorGrossEarningsAll() throws SQLException {
        String sql = "SELECT COALESCE(SUM(vendor_amount),0) FROM payments WHERE payment_status='SUCCESS'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getBigDecimal(1);
        }
    }

    /** Net vendor earnings: Gross vendor share minus refund deductions from cancelled reservations. */
    public BigDecimal getTotalVendorEarnings(int vendorId) throws SQLException {
        String sql = "SELECT (COALESCE(SUM(p.vendor_amount), 0) - " +
                     "COALESCE((SELECT SUM(r.vendor_deduction) FROM refunds r JOIN payments p2 ON r.payment_id = p2.payment_id WHERE p2.vendor_id = ? AND r.refund_status = 'SUCCESS'), 0)) " +
                     "FROM payments p WHERE p.vendor_id = ? AND p.payment_status = 'SUCCESS'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, vendorId);
            ps.setInt(2, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getBigDecimal(1);
            }
        }
    }

    public BigDecimal getTotalAdminCommission() throws SQLException {
        String sql = "SELECT COALESCE(SUM(admin_amount),0) FROM payments WHERE payment_status='SUCCESS'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getBigDecimal(1);
        }
    }

    private Payment mapRow(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("payment_id"));
        p.setBookingId(rs.getInt("booking_id"));
        p.setUserId(rs.getInt("user_id"));
        p.setVendorId(rs.getInt("vendor_id"));
        p.setCustomerAccountId(rs.getInt("customer_account_id"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setVendorAmount(rs.getBigDecimal("vendor_amount"));
        p.setAdminAmount(rs.getBigDecimal("admin_amount"));
        p.setTransactionId(rs.getString("transaction_id"));
        p.setPaymentStatus(rs.getString("payment_status"));
        p.setPaymentDate(rs.getTimestamp("payment_date"));

        try {
            int refId = rs.getInt("refund_id");
            if (refId > 0) {
                p.setRefunded(true);
                p.setCustomerRefund(rs.getBigDecimal("customer_refund"));
                p.setVendorDeduction(rs.getBigDecimal("vendor_deduction"));
                p.setAdminRetained(rs.getBigDecimal("admin_retained"));
                p.setRefundTransactionId(rs.getString("refund_transaction_id"));
                p.setCancelledBy(rs.getString("cancelled_by"));
                p.setRefundReason(rs.getString("refund_reason"));
                p.setRefundDate(rs.getTimestamp("refund_date"));
            }
        } catch (SQLException ignored) {
            // column not present in other queries
        }
        return p;
    }

    public model.Payment getPaymentByBookingForUpdate(Connection con, int bookingId) throws SQLException {
        String sql = "SELECT * FROM payments WHERE booking_id=? AND payment_status='SUCCESS' FOR UPDATE";
        try (PreparedStatement p = con.prepareStatement(sql)) {
            p.setInt(1, bookingId);
            try (ResultSet r = p.executeQuery()) {
                if (r.next()) {
                    model.Payment x = new model.Payment();
                    x.setPaymentId(r.getInt("payment_id"));
                    x.setBookingId(r.getInt("booking_id"));
                    x.setUserId(r.getInt("user_id"));
                    x.setVendorId(r.getInt("vendor_id"));
                    x.setCustomerAccountId(r.getInt("customer_account_id"));
                    x.setAmount(r.getBigDecimal("amount"));
                    x.setVendorAmount(r.getBigDecimal("vendor_amount"));
                    x.setAdminAmount(r.getBigDecimal("admin_amount"));
                    x.setTransactionId(r.getString("transaction_id"));
                    x.setPaymentStatus(r.getString("payment_status"));
                    x.setPaymentDate(r.getTimestamp("payment_date"));
                    return x;
                }
            }
        }
        return null;
    }
}
