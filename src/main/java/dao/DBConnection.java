package dao;

import java.sql.Connection;

import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
        "jdbc:mysql://localhost:3306/event_management?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = System.getenv("OEM_DB_PASSWORD");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found. Check WEB-INF/lib.", e);
        }
    }

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        if (PASSWORD == null || PASSWORD.trim().isEmpty()) {
            throw new SQLException("OEM_DB_PASSWORD environment variable is not set.");
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
