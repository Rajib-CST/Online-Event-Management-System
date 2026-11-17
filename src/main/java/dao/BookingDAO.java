package dao;

import model.Booking;
import model.BookingItem;
import model.CartItem;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    /** Inserts the booking header. Must run on the SAME connection as the payment transaction. */
    public int insertBooking(Connection con, int userId, int vendorId, String eventType,
                              Date eventDate, BigDecimal totalAmount, String status) throws SQLException {
        String sql = "INSERT INTO bookings (user_id, vendor_id, event_type, event_date, total_amount, booking_status) " +
                     "VALUES (?,?,?,?,?,?)";
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, vendorId);
            ps.setString(3, eventType);
            ps.setDate(4, eventDate);
            ps.setBigDecimal(5, totalAmount);
            ps.setString(6, status);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        return -1;
    }

    public void insertBookingItem(Connection con, int bookingId, CartItem item) throws SQLException {
        String sql = "INSERT INTO booking_items (booking_id, item_id, quantity, unit_price, subtotal) " +
                     "VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, item.getItemId());
            ps.setInt(3, item.getQuantity());
            ps.setBigDecimal(4, item.getUnitPrice());
            ps.setBigDecimal(5, item.getSubtotal());
            ps.executeUpdate();
        }
    }

    public boolean updateBookingStatus(Connection con, int bookingId, String status) throws SQLException {
        String sql = "UPDATE bookings SET booking_status = ? WHERE booking_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Only ever returns bookings belonging to this user (never another customer's). */
    public List<Booking> getBookingsForUser(int userId) throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, v.vendor_name FROM bookings b " +
                     "JOIN vendors v ON b.vendor_id = v.vendor_id " +
                     "WHERE b.user_id = ? ORDER BY b.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    /**
     * Fetches one booking IF it belongs to the given userId - callers (BookingDetailsServlet)
     * MUST pass the logged-in user's id and treat a null return as "not found / not yours".
     */
    public Booking getBookingByIdForUser(int bookingId, int userId) throws SQLException {
        String sql = "SELECT b.*, v.vendor_name FROM bookings b " +
                     "JOIN vendors v ON b.vendor_id = v.vendor_id " +
                     "WHERE b.booking_id = ? AND b.user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking b = mapRow(rs);
                    b.setItems(getItemsForBooking(bookingId));
                    return b;
                }
            }
        }
        return null;
    }

    /** Admin-only: fetch any booking regardless of owner. */
    public Booking getBookingByIdAdmin(int bookingId) throws SQLException {
        String sql = "SELECT b.*, v.vendor_name FROM bookings b " +
                     "JOIN vendors v ON b.vendor_id = v.vendor_id WHERE b.booking_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking b = mapRow(rs);
                    b.setItems(getItemsForBooking(bookingId));
                    return b;
                }
            }
        }
        return null;
    }

    public List<Booking> getAllBookings() throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, v.vendor_name FROM bookings b " +
                     "JOIN vendors v ON b.vendor_id = v.vendor_id ORDER BY b.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<BookingItem> getItemsForBooking(int bookingId) throws SQLException {
        List<BookingItem> list = new ArrayList<>();
        String sql = "SELECT bi.*, i.item_name FROM booking_items bi " +
                     "JOIN items i ON bi.item_id = i.item_id WHERE bi.booking_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new BookingItem(
                        rs.getInt("item_id"), rs.getString("item_name"),
                        rs.getInt("quantity"), rs.getBigDecimal("unit_price"), rs.getBigDecimal("subtotal")));
                }
            }
        }
        return list;
    }

    private Booking mapRow(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setBookingId(rs.getInt("booking_id"));
        b.setUserId(rs.getInt("user_id"));
        b.setVendorId(rs.getInt("vendor_id"));
        b.setVendorName(rs.getString("vendor_name"));
        b.setEventType(rs.getString("event_type"));
        b.setEventDate(rs.getDate("event_date"));
        b.setTotalAmount(rs.getBigDecimal("total_amount"));
        b.setBookingStatus(rs.getString("booking_status"));
        try { b.setCancelledBy(rs.getString("cancelled_by")); b.setCancellationReason(rs.getString("cancellation_reason")); b.setCancelledAt(rs.getTimestamp("cancelled_at")); b.setRefundAmount(rs.getBigDecimal("refund_amount")); } catch(SQLException ignored) {}
        b.setCreatedAt(rs.getTimestamp("created_at"));
        return b;
    }

    public Booking getBookingForUpdate(Connection con,int bookingId)throws SQLException{
        String sql="SELECT b.*, v.vendor_name FROM bookings b JOIN vendors v ON b.vendor_id=v.vendor_id WHERE b.booking_id=? FOR UPDATE";
        try(PreparedStatement ps=con.prepareStatement(sql)){ps.setInt(1,bookingId);try(ResultSet rs=ps.executeQuery()){if(rs.next()){Booking b=mapRow(rs);b.setItems(getItemsForBooking(con,bookingId));return b;}}} return null;
    }
    public Booking getBookingForVendor(int bookingId,int vendorId)throws SQLException{
        String sql="SELECT b.*,v.vendor_name FROM bookings b JOIN vendors v ON b.vendor_id=v.vendor_id WHERE b.booking_id=? AND b.vendor_id=?";
        try(Connection c=DBConnection.getConnection();PreparedStatement p=c.prepareStatement(sql)){p.setInt(1,bookingId);p.setInt(2,vendorId);try(ResultSet r=p.executeQuery()){if(r.next()){Booking b=mapRow(r);b.setItems(getItemsForBooking(bookingId));return b;}}}return null;
    }
    public List<Booking> getBookingsForVendor(int vendorId)throws SQLException{List<Booking> l=new ArrayList<>();String s="SELECT b.*,v.vendor_name FROM bookings b JOIN vendors v ON b.vendor_id=v.vendor_id WHERE b.vendor_id=? ORDER BY b.event_date";try(Connection c=DBConnection.getConnection();PreparedStatement p=c.prepareStatement(s)){p.setInt(1,vendorId);try(ResultSet r=p.executeQuery()){while(r.next())l.add(mapRow(r));}}return l;}
    public List<BookingItem> getItemsForBooking(Connection con,int bookingId)throws SQLException{List<BookingItem> l=new ArrayList<>();String s="SELECT bi.*,i.item_name FROM booking_items bi JOIN items i ON bi.item_id=i.item_id WHERE bi.booking_id=?";try(PreparedStatement p=con.prepareStatement(s)){p.setInt(1,bookingId);try(ResultSet r=p.executeQuery()){while(r.next())l.add(new BookingItem(r.getInt("item_id"),r.getString("item_name"),r.getInt("quantity"),r.getBigDecimal("unit_price"),r.getBigDecimal("subtotal")));}}return l;}
    public boolean cancelBooking(Connection con,int id,String status,String by,String reason,java.math.BigDecimal refund)throws SQLException{String s="UPDATE bookings SET booking_status=?,cancelled_by=?,cancellation_reason=?,cancelled_at=CURRENT_TIMESTAMP,refund_amount=? WHERE booking_id=? AND booking_status='CONFIRMED'";try(PreparedStatement p=con.prepareStatement(s)){p.setString(1,status);p.setString(2,by);p.setString(3,reason);p.setBigDecimal(4,refund);p.setInt(5,id);return p.executeUpdate()>0;}}
}
