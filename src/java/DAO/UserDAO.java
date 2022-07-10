/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import Model.Entity.*;
import Utils.ConnectJDBC;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.io.PrintWriter;
import java.io.StringWriter;
import org.apache.log4j.Logger;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author ADMIN
 */
public class UserDAO extends ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(UserDAO.class);
    private static UserDAO instance;

    public static UserDAO getInstance() {
        if (UserDAO.instance == null) {
            UserDAO.instance = new UserDAO();
        }
        return UserDAO.instance;
    }

    private UserDAO() {
    }

    public User checkRollNumber(String rollNum) {
        String sql = "select * from `studentmanagement`.`user` where `roll_number` = "+rollNum;
        User ojb = null;
        ResultSet rs = getData(sql);
        try {
            if (rs.next()) {
                int user_id = rs.getInt("user_id");
                String roll_number = rs.getString("roll_number");
                String full_name = rs.getString("full_name");
                String password = rs.getString("password");
                boolean gender = rs.getBoolean("gender");
                String email = rs.getString("email");
                String date_of_birth = rs.getString("date_of_birth");
                String mobile = rs.getString("mobile");
                String avatar_link = rs.getString("avatar_link");
                String facebook_link = rs.getString("facebook_link");
                int role_id = rs.getInt("role_id");
                boolean status = rs.getBoolean("status");
                ojb = new User(user_id, roll_number, full_name, gender, date_of_birth, email, password, mobile, avatar_link, facebook_link, role_id, status);

            }
            rs.close();
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return ojb;
    }

    public boolean updateImage(int id, String avaLink) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`user` SET `avatar_link` = ? WHERE (`user_id` = ?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, avaLink);
            pre.setInt(2, id);
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateUser(User u) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`user` SET `roll_number` = ?, `full_name` = ?, `gender` = ?, `date_of_birth` = ?, `mobile` = ?, `facebook_link` = ?, `role_id` = ? WHERE (`user_id` = ?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, u.getRoll_number());
            pre.setString(2, u.getFull_name());
            pre.setBoolean(3, u.isGender());
            pre.setString(4, u.getDate_of_birth());
            pre.setString(5, u.getMobile());
            pre.setString(6, u.getFacebook_link());
            pre.setInt(7, u.getRole_id());
            pre.setInt(8, u.getUser_id());
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateStatus(int id, boolean status) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`user` SET `status` = ? WHERE (`user_id` = ?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setBoolean(1, status);
            pre.setInt(2, id);
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean setUUID(String inputEmail, String uuid) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`user` SET `uuid` = ? WHERE (`email` = ?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, uuid);
            pre.setString(2, inputEmail);
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public String getEmail(String uuid) {
        String sql = "select email from `studentmanagement`.`user` where uuid='"+uuid+"'";
        String ojb = "";
        ResultSet rs = getData(sql);
        try {
            if (rs.next()) {
                ojb = rs.getString(1);

            }
            rs.close();
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return ojb;
    }
    
    public User getUser(String inputEmail) {
        String sql = "CALL studentmanagement.getUserByEmail('" + inputEmail + "')";
        User ojb = null;
        ResultSet rs = getData(sql);
        try {
            if (rs.next()) {
                int user_id = rs.getInt("user_id");
                String roll_number = rs.getString("roll_number");
                String full_name = rs.getString("full_name");
                String password = rs.getString("password");
                boolean gender = rs.getBoolean("gender");
                String date_of_birth = rs.getString("date_of_birth");
                String mobile = rs.getString("mobile");
                String avatar_link = rs.getString("avatar_link");
                String facebook_link = rs.getString("facebook_link");
                int role_id = rs.getInt("role_id");
                boolean status = rs.getBoolean("status");
                ojb = new User(user_id, roll_number, full_name, gender, date_of_birth, inputEmail, password, mobile, avatar_link, facebook_link, role_id, status);

            }
            rs.close();
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return ojb;
    }

    @Override
    public int countRows(String table, String search, String addCondition) {
        int te = 0;
        String sql = "SELECT count(*) from `studentmanagement`.`user` where (`avatar_link` like '%" + search + "%' or `email` like '%" + search + "%' or`facebook_link` like '%" + search + "%' or`full_name` like '%" + search + "%' or`mobile` like '%" + search + "%' or `roll_number` like '%" + search + "%') " + addCondition;
        ResultSet rs1 = getData(sql);
        try {
            while (rs1.next()) {
                te = rs1.getInt(1);
            }
            rs1.close();
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return te;
    }

    public List<User> getList(int id, String search, String sort, boolean statusSort, int start, int limit, Integer statusFilter) {
        String sql = "SELECT * from `studentmanagement`.`user` where (`avatar_link` like '%" + search + "%' or `email` like '%" + search + "%' or`facebook_link` like '%" + search + "%' or`full_name` like '%" + search + "%' or`mobile` like '%" + search + "%' or `roll_number` like '%" + search + "%')" + (statusFilter == null ? "" : " and status=" + statusFilter) + (id > 0 ? " and role_id=" + id : "")
                + (sort == null ? "" : " order by " + sort + (statusSort ? "" : " desc")) + " limit " + start + ", " + limit;
        List<User> list = new ArrayList<>();
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int user_id = rs.getInt("user_id");
                String password = rs.getString("password");
                String roll_number = rs.getString("roll_number");
                String full_name = rs.getString("full_name");
                boolean gender = rs.getBoolean("gender");
                String date_of_birth = rs.getString("date_of_birth");
                String email = rs.getString("email");
                String mobile = rs.getString("mobile");
                String avatar_link = rs.getString("avatar_link");
                String facebook_link = rs.getString("facebook_link");
                int role_id = rs.getInt("role_id");
                boolean status = rs.getBoolean("status");
                list.add(new User(user_id, roll_number, full_name, gender, date_of_birth, email, password, mobile, avatar_link, facebook_link, role_id, status));
            }
            rs.close();
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public User getUser(int id, boolean admin) {
        String sql = "SELECT * from `studentmanagement`.`user` where user_id=" + id + (!admin ? " and status=1" : "");
        User ojb = null;
        ResultSet rs = getData(sql);
        try {
            if (rs.next()) {
                int user_id = rs.getInt("user_id");
                String roll_number = rs.getString("roll_number");
                String full_name = rs.getString("full_name");
                boolean gender = rs.getBoolean("gender");
                String date_of_birth = rs.getString("date_of_birth");
                String email = rs.getString("email");
                String mobile = rs.getString("mobile");
                String avatar_link = rs.getString("avatar_link");
                String facebook_link = rs.getString("facebook_link");
                int role_id = rs.getInt("role_id");
                boolean status = rs.getBoolean("status");
                String password = rs.getString("password");
                ojb = new User(user_id, roll_number, full_name, gender, date_of_birth, email, password, mobile, avatar_link, facebook_link, role_id, status);
            }
            rs.close();
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return ojb;
    }

    public boolean changePW(String inputMail, String password) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`user` SET `password` = ? WHERE (`email` = ?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, BCrypt.hashpw(password, BCrypt.gensalt(5)));
            pre.setString(2, inputMail);
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public User login(String inputEmail, String inputPassword) {
        String sql = "CALL studentmanagement.getUserByEmail('" + inputEmail + "')";
        User ojb = null;
        ResultSet rs = getData(sql);
        try {

            if (rs.next()) {
                String password = rs.getString("password");
                boolean checkpass = BCrypt.checkpw(inputPassword, password);
                if (checkpass) {
                    int user_id = rs.getInt("user_id");
                    String roll_number = rs.getString("roll_number");
                    String full_name = rs.getString("full_name");
                    boolean gender = rs.getBoolean("gender");
                    String date_of_birth = rs.getString("date_of_birth");
                    String mobile = rs.getString("mobile");
                    String avatar_link = rs.getString("avatar_link");
                    String facebook_link = rs.getString("facebook_link");
                    int role_id = rs.getInt("role_id");
                    boolean status = rs.getBoolean("status");
                    ojb = new User(user_id, roll_number, full_name, gender, date_of_birth, inputEmail, password, mobile, avatar_link, facebook_link, role_id, status);
                }
                rs.close();
            }
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return ojb;
    }

    public boolean deleteUser(String mail) {
        boolean check = false;
        String sql = "Delete from `studentmanagement`.`user` where email = '" + mail + "'";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean addUser(User u) {
        boolean check = false;
        String sql = "INSERT INTO `studentmanagement`.`user` "
                + "(`roll_number`, `full_name`, `gender`, `date_of_birth`, `email`, `password`, `mobile`, `role_id`, `status`,`Avatar_link`) "
                + "VALUES (?,?, ?, ?,?, ?,?, ?, ?,?);";
        try {
            //encrypt password
            String encryptPw = BCrypt.hashpw(u.getPassword(), BCrypt.gensalt(5));
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, u.getRoll_number());
            pre.setString(2, u.getFull_name());
            pre.setBoolean(3, u.isGender());
            pre.setString(4, u.getDate_of_birth());
            pre.setString(5, u.getEmail());
            pre.setString(6, encryptPw);
            pre.setString(7, u.getMobile());
            pre.setInt(8, u.getRole_id());
            pre.setBoolean(9, u.isStatus());
            pre.setString(10, u.getAvatar_link());
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

}
