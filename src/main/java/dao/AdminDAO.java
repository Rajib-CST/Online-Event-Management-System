package dao;

import java.sql.*;

/**
 * Not in the original DAO list (section 20) but needed so the admin login
 * authenticates against the admin_account table instead of hardcoded
 * credentials in a servlet.
 */
public class AdminDAO {

    public static class AdminInfo {
        public int adminId;
        public String adminName;
        public String email;
        public int bankAccountId;
    }

    public AdminInfo validateLogin(String email, String password) throws SQLException {
        String sql = "SELECT * FROM admin_account WHERE email = ? AND password = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AdminInfo a = new AdminInfo();
                    a.adminId = rs.getInt("admin_id");
                    a.adminName = rs.getString("admin_name");
                    a.email = rs.getString("email");
                    a.bankAccountId = rs.getInt("bank_account_id");
                    return a;
                }
            }
        }
        return null;
    }
}
