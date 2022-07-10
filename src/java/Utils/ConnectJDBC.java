/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.io.PrintWriter;
import java.io.StringWriter;
import org.apache.log4j.Logger;

/**
 * q
 *
 * @author AD
 */
public class ConnectJDBC {

    
    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(ConnectJDBC.class);
    private static final String DB_URL = "jdbc:mysql://localhost:3306/StudentManagement?allowPublicKeyRetrieval=true&autoReconnect=true&useSSL=false";
    private static final String USER_NAME = "sa";
    private static final String PASSWORD = "123456";

    public Connection conn = getConnection();

    public ResultSet getData(String sql) {
        ResultSet rs = null;
        try {
            Statement stm = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            rs = stm.executeQuery(sql);
        } catch (SQLException e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return rs;
    }

    public int countRows(String table, String search, String addCondition) {
        int te = 0;
        String sql = "CALL `studentmanagement`.countRows('\\'%" + search + "%\\'','studentmanagement','" + table + "','" + addCondition + "')";
        ResultSet rs1 = getData(sql);
        try {
            while (rs1.next()) {
                String sql1 = rs1.getString(1);
                ResultSet rs = getData(sql1);
                while (rs.next()) {
                    te = rs.getInt(1);
                }
            }
            rs1.close();
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return te;
    }

    /**
     * create connection
     *
     * @author viettuts.vn
     * @param dbURL: database's url
     * @param userName: username is used to login
     * @param password: password is used to login
     * @return connection
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, USER_NAME, PASSWORD);
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return conn;
    }

}
