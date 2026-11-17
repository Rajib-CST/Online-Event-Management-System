package dao;

import model.VendorItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VendorItemDAO {

    /** All inventory rows for a vendor, joined with item name - used by items.jsp. */
    public List<VendorItem> getInventoryByVendor(int vendorId) throws SQLException {
        List<VendorItem> list = new ArrayList<>();
        String sql = "SELECT vi.*, i.item_name FROM vendor_items vi " +
                     "JOIN items i ON vi.item_id = i.item_id " +
                     "WHERE vi.vendor_id = ? AND vi.is_available = TRUE ORDER BY i.item_name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    /**
     * Authoritative server-side lookup of price+stock for one vendor/item pair.
     * Used by CartServlet/BookingServlet/PaymentServlet - the browser-submitted
     * price is NEVER trusted (section 8/23).
     */
    public VendorItem getVendorItem(int vendorId, int itemId) throws SQLException {
        String sql = "SELECT vi.*, i.item_name FROM vendor_items vi " +
                     "JOIN items i ON vi.item_id = i.item_id " +
                     "WHERE vi.vendor_id = ? AND vi.item_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, vendorId);
            ps.setInt(2, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /** Reduces stock as part of the payment transaction. Must run on the SAME connection. */
    public boolean reduceStock(Connection con, int vendorId, int itemId, int quantity) throws SQLException {
        String sql = "UPDATE vendor_items SET stock = stock - ? " +
                     "WHERE vendor_id = ? AND item_id = ? AND stock >= ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, vendorId);
            ps.setInt(3, itemId);
            ps.setInt(4, quantity);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean upsertVendorItem(int vendorId, int itemId, java.math.BigDecimal price, int stock) throws SQLException {
        String sql = "INSERT INTO vendor_items (vendor_id, item_id, price, stock, is_available) VALUES (?,?,?,?,?) " +
                     "ON DUPLICATE KEY UPDATE price = VALUES(price), stock = VALUES(stock), is_available = VALUES(is_available)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, vendorId);
            ps.setInt(2, itemId);
            ps.setBigDecimal(3, price);
            ps.setInt(4, stock);
            ps.setBoolean(5, stock > 0);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateVendorItem(int vendorId,int itemId,java.math.BigDecimal price,int stock,boolean available)throws SQLException{
        String sql="UPDATE vendor_items SET price=?, stock=?, is_available=? WHERE vendor_id=? AND item_id=?";
        try(Connection con=DBConnection.getConnection();PreparedStatement ps=con.prepareStatement(sql)){ps.setBigDecimal(1,price);ps.setInt(2,stock);ps.setBoolean(3,available && stock>0);ps.setInt(4,vendorId);ps.setInt(5,itemId);return ps.executeUpdate()>0;}
    }
    public boolean restoreStock(Connection con,int vendorId,int itemId,int quantity)throws SQLException{
        String sql="UPDATE vendor_items SET stock=stock+?, is_available=TRUE WHERE vendor_id=? AND item_id=?";
        try(PreparedStatement ps=con.prepareStatement(sql)){ps.setInt(1,quantity);ps.setInt(2,vendorId);ps.setInt(3,itemId);return ps.executeUpdate()>0;}
    }

    private VendorItem mapRow(ResultSet rs) throws SQLException {
        VendorItem vi = new VendorItem();
        vi.setVendorItemId(rs.getInt("vendor_item_id"));
        vi.setVendorId(rs.getInt("vendor_id"));
        vi.setItemId(rs.getInt("item_id"));
        vi.setItemName(rs.getString("item_name"));
        vi.setPrice(rs.getBigDecimal("price"));
        vi.setStock(rs.getInt("stock"));
        try { vi.setAvailable(rs.getBoolean("is_available")); } catch (SQLException ignored) {}
        return vi;
    }
}
