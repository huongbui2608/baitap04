package vn.iotstar.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Kết nối cơ sở dữ liệu SQL Server.
 * *** SỬA PASSWORD bên dưới cho phù hợp với máy của bạn ***
 */
public class DBConnection {
    private static final String SERVER   = "localhost";
    private static final String PORT     = "1433";
    private static final String DATABASE = "ShoppingServiceMVC";
    private static final String USER     = "sa";
    // *** SỬA MẬT KHẨU Ở ĐÂY - Mật khẩu SQL Server của bạn ***
    private static final String PASSWORD = "123456";

    private static final String URL =
        "jdbc:sqlserver://" + SERVER + ":" + PORT
        + ";databaseName=" + DATABASE
        + ";encrypt=false"
        + ";trustServerCertificate=true";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server JDBC driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
