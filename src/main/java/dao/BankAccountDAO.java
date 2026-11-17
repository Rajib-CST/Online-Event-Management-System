package dao;

import model.BankAccount;

import java.math.BigDecimal;
import java.sql.*;

public class BankAccountDAO {

    public BankAccount getByAccountNumberAndPin(String accountNumber, String pin) throws SQLException {
        String sql = "SELECT * FROM bank_accounts WHERE account_number = ? AND pin = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, accountNumber);
            ps.setString(2, pin);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public BankAccount getByAccountNumber(String accountNumber) throws SQLException {
        String sql = "SELECT * FROM bank_accounts WHERE account_number = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, accountNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public BankAccount getById(int accountId) throws SQLException {
        String sql = "SELECT * FROM bank_accounts WHERE account_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public BankAccount getByAccountNumberAndPin(Connection con,String accountNumber,String pin)throws SQLException {
        String sql="SELECT * FROM bank_accounts WHERE account_number=? AND pin=? FOR UPDATE";
        try(PreparedStatement ps=con.prepareStatement(sql)){ps.setString(1,accountNumber);ps.setString(2,pin);try(ResultSet rs=ps.executeQuery()){return rs.next()?mapRow(rs):null;}}
    }

    /** Must be called using the SAME connection/transaction as the rest of PaymentServlet. */
    public boolean debit(Connection con, int accountId, BigDecimal amount) throws SQLException {
        String sql = "UPDATE bank_accounts SET balance = balance - ? WHERE account_id = ? AND balance >= ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBigDecimal(1, amount);
            ps.setInt(2, accountId);
            ps.setBigDecimal(3, amount);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean credit(Connection con, int accountId, BigDecimal amount) throws SQLException {
        String sql = "UPDATE bank_accounts SET balance = balance + ? WHERE account_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBigDecimal(1, amount);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        }
    }

    private BankAccount mapRow(ResultSet rs) throws SQLException {
        BankAccount b = new BankAccount();
        b.setAccountId(rs.getInt("account_id"));
        b.setAccountNumber(rs.getString("account_number"));
        b.setAccountHolder(rs.getString("account_holder"));
        b.setBankName(rs.getString("bank_name"));
        b.setBalance(rs.getBigDecimal("balance"));
        b.setPin(rs.getString("pin"));
        b.setAccountType(rs.getString("account_type"));
        return b;
    }
}
