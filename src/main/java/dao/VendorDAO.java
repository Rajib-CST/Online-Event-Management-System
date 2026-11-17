package dao;
import model.Vendor;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Date;  // Make sure this is the only Date import
import java.util.ArrayList;
import java.util.List;

public class VendorDAO {
    public List<Vendor> getAllVendors() throws SQLException {
        List<Vendor> l = new ArrayList<>();
        String s = "SELECT * FROM vendors ORDER BY vendor_id"; 
        try(Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(s);
            ResultSet r = p.executeQuery()) {
            while(r.next()) l.add(mapRow(r));
        }
        return l;
    }
    
    public Vendor getVendorById(int id) throws SQLException {
        try(Connection c = DBConnection.getConnection()) {
            return getVendorById(c, id);
        }
    }
    
    public Vendor getVendorById(Connection c, int id) throws SQLException {
        String s = "SELECT * FROM vendors WHERE vendor_id=?";
        try(PreparedStatement p = c.prepareStatement(s)) {
            p.setInt(1, id);
            try(ResultSet r = p.executeQuery()) {
                return r.next() ? mapRow(r) : null;
            }
        }
    }
    
    public Vendor login(String email, String password) throws SQLException {
        String s = "SELECT * FROM vendors WHERE email=? AND password=? AND vendor_status='ACTIVE'";
        try(Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(s)) {
            p.setString(1, email);
            p.setString(2, password);
            try(ResultSet r = p.executeQuery()) {
                return r.next() ? mapRow(r) : null;
            }
        }
    }
    
    public boolean emailExists(String email) throws SQLException {
        String s = "SELECT 1 FROM vendors WHERE email=?";
        try(Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(s)) {
            p.setString(1, email);
            try(ResultSet r = p.executeQuery()) {
                return r.next();
            }
        }
    }

    public Vendor findByEmail(String email) throws SQLException {
        String s = "SELECT * FROM vendors WHERE email=?";
        try(Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(s)) {
            p.setString(1, email);
            try(ResultSet r = p.executeQuery()) {
                return r.next() ? mapRow(r) : null;
            }
        }
    }

    public boolean updatePassword(String email, String newPassword) throws SQLException {
        String s = "UPDATE vendors SET password=? WHERE email=?";
        try(Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(s)) {
            p.setString(1, newPassword);
            p.setString(2, email);
            return p.executeUpdate() > 0;
        }
    }
    
    public int registerVendor(Vendor v, int bankId) throws SQLException {
        String s = "INSERT INTO vendors(vendor_name,email,password,contact,address,description,security_question,security_answer,vendor_status,bank_account_id) VALUES(?,?,?,?,?,?,?,?, 'ACTIVE',?)";
        try(Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(s, Statement.RETURN_GENERATED_KEYS)) {
            p.setString(1, v.getVendorName());
            p.setString(2, v.getEmail());
            p.setString(3, v.getPassword());
            p.setString(4, v.getContact());
            p.setString(5, v.getAddress());
            p.setString(6, v.getDescription());
            p.setString(7, v.getSecurityQuestion());
            p.setString(8, v.getSecurityAnswer());
            p.setInt(9, bankId);
            p.executeUpdate();
            try(ResultSet k = p.getGeneratedKeys()) {
                return k.next() ? k.getInt(1) : -1;
            }
        }
    }

    public void addVendor(Vendor v) throws SQLException {
        String s = "INSERT INTO vendors(vendor_name,email,password,contact,address,description,security_question,security_answer,vendor_status,bank_account_id) VALUES(?,?,?,?,?,?,?,?, 'ACTIVE',?)";
        try(Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(s)) {
            p.setString(1, v.getVendorName());
            p.setString(2, v.getEmail());
            p.setString(3, v.getPassword());
            p.setString(4, v.getContact());
            p.setString(5, v.getAddress());
            p.setString(6, v.getDescription());
            p.setString(7, v.getSecurityQuestion());
            p.setString(8, v.getSecurityAnswer());
            p.setInt(9, v.getBankAccountId());
            p.executeUpdate();
        }
    }

    public void updateVendor(Vendor v) throws SQLException {
        boolean updatePassword = v.getPassword() != null && !v.getPassword().isEmpty();
        String s = updatePassword
            ? "UPDATE vendors SET vendor_name=?,email=?,password=?,contact=?,address=?,description=?,security_question=?,security_answer=?,bank_account_id=? WHERE vendor_id=?"
            : "UPDATE vendors SET vendor_name=?,email=?,contact=?,address=?,description=?,security_question=?,security_answer=?,bank_account_id=? WHERE vendor_id=?";
        try(Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(s)) {
            int i = 1;
            p.setString(i++, v.getVendorName());
            p.setString(i++, v.getEmail());
            if (updatePassword) p.setString(i++, v.getPassword());
            p.setString(i++, v.getContact());
            p.setString(i++, v.getAddress());
            p.setString(i++, v.getDescription());
            p.setString(i++, v.getSecurityQuestion());
            p.setString(i++, v.getSecurityAnswer());
            p.setInt(i++, v.getBankAccountId());
            p.setInt(i, v.getVendorId());
            p.executeUpdate();
        }
    }

    public void deleteVendor(int id) throws SQLException {
        String s = "DELETE FROM vendors WHERE vendor_id=?";
        try(Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(s)) {
            p.setInt(1, id);
            p.executeUpdate();
        }
    }
    
    // Use java.sql.Date explicitly
    public boolean isVendorAvailable(int id, java.sql.Date d) throws SQLException {
        String s = "SELECT COUNT(*) FROM bookings WHERE vendor_id=? AND event_date=? AND booking_status='CONFIRMED'";
        try(Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(s)) {
            p.setInt(1, id);
            p.setDate(2, d);
            try(ResultSet r = p.executeQuery()) {
                r.next();
                return r.getInt(1) == 0;
            }
        }
    }
    
    // Use java.sql.Date explicitly
    public boolean isVendorAvailable(Connection c, int id, java.sql.Date d) throws SQLException {
        String s = "SELECT COUNT(*) FROM bookings WHERE vendor_id=? AND event_date=? AND booking_status='CONFIRMED'";
        try(PreparedStatement p = c.prepareStatement(s)) {
            p.setInt(1, id);
            p.setDate(2, d);
            try(ResultSet r = p.executeQuery()) {
                r.next();
                return r.getInt(1) == 0;
            }
        }
    }
    
    // Rest of your methods...
    
    private Vendor mapRow(ResultSet r) throws SQLException {
        Vendor v = new Vendor();
        v.setVendorId(r.getInt("vendor_id"));
        v.setVendorName(r.getString("vendor_name"));
        v.setEmail(r.getString("email"));
        v.setPassword(get(r, "password"));
        v.setContact(r.getString("contact"));
        v.setAddress(r.getString("address"));
        v.setDescription(r.getString("description"));
        v.setBankAccountId(r.getInt("bank_account_id"));
        v.setSecurityQuestion(get(r, "security_question"));
        v.setSecurityAnswer(get(r, "security_answer"));
        String st = get(r, "vendor_status");
        if(st != null) v.setVendorStatus(st);
        return v;
    }
    
    private String get(ResultSet r, String n) {
        try {
            return r.getString(n);
        } catch(Exception e) {
            return null;
        }
    }
}