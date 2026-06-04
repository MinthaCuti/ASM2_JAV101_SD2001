package context;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {

    private static final String SERVER_NAME = "localhost";
    private static final String PORT = "1433";
    private static final String DATABASE_NAME = "HotelManagement";
    private static final String USER_ID = "sa";
    private static final String PASSWORD = "Mint1234";

    public static Connection getConnection() throws Exception {
        String url = "jdbc:sqlserver://" + SERVER_NAME + ":" + PORT + ";databaseName=" + DATABASE_NAME
                + ";encrypt=true;trustServerCertificate=true;";
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, USER_ID, PASSWORD);
    }
}