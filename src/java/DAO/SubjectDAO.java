/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import Model.Entity.Subject;
import Model.Entity.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.io.PrintWriter;
import java.io.StringWriter;
import org.apache.log4j.Logger;

/**
 *
 * @author ADMIN
 */
public class SubjectDAO extends Utils.ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(SubjectDAO.class);

    private static SubjectDAO instance;

    public static SubjectDAO getInstance() {
        if (SubjectDAO.instance == null) {

            SubjectDAO.instance = new SubjectDAO();

        }
        return SubjectDAO.instance;
    }

    private SubjectDAO() {

    }

    public Subject getSubject(int id) {
        String sql = "SELECT * FROM subject where subject_id=" + id;
        Subject sub = null;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int subject_id = rs.getInt("subject_id");
                String subject_code = rs.getString("subject_code").toUpperCase();
                String subject_name = rs.getString("subject_name");
                int author_id = rs.getInt("author_id");
                String description = rs.getString("description");
                boolean status = rs.getBoolean("status");
                sub = new Subject(subject_id, subject_code, subject_name, author_id, description, status);
            }
            rs.close();
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return sub;
    }

    public boolean checkAddSubject(String code) {
        boolean check = false;
        String sql = "SELECT * FROM subject where subject_code = '" + code + "'";
        ResultSet rs = getData(sql);
        try {
            if (rs.next()) {
                check = true;
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public List<Subject> getList(String search, User login, int start, int limit, String sort, boolean statusSort, Integer statusFilter, int authorFilter) {
        List<Subject> list = new ArrayList<>();
        String sql = "CALL search('\\'%" + search + "%\\'','subject',"
                + "'" + (statusFilter == null ? "" : " and status= " + statusFilter) + (authorFilter > 0 ? " and author_id=" + authorFilter : "") + " and author_id in (select user_id from user where `email` like \\'%" + search + "%\\' or `full_name` like \\'%" + search + "%\\' or `mobile` like \\'%" + search + "%\\' or `roll_number` like \\'%" + search + "%\\')"
                + (login == null || login.getRole_id() == 1 ? "" : " and status=1 ".concat(login.getRole_id() == 2 ? " and author_id = " + login.getUser_id() : login.getRole_id() == 3 ? " and subject_id in (select distinct subject_id " + "from `class` where trainer_id=" + login.getUser_id() + ")" : " and subject_id in (select distinct subject_id from `class`,`class_user`" + " where class.class_id = class_user.class_id and user_id=" + login.getUser_id() + ")"))
                + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs1 = getData(sql);
        try {
            while (rs1.next()) {
                String sql1 = rs1.getString(1);
                ResultSet rs = getData(sql1);
                while (rs.next()) {
                    int subject_id = rs.getInt("subject_id");
                    String subject_code = rs.getString("subject_code").toUpperCase();
                    String subject_name = rs.getString("subject_name");
                    int author_id = rs.getInt("author_id");
                    String description = rs.getString("description");
                    boolean status = rs.getBoolean("status");
                    list.add(new Subject(subject_id, subject_code, subject_name, author_id, description, status));
                }
            }
            rs1.close();
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public int addSubject(Subject subject) {
        int check = -1;
        String sql = "INSERT INTO `subject`"
                + "("
                + "`subject_code`,"
                + "`subject_name`,"
                + "`author_id`,"
                + "`description`,"
                + "`status`)"
                + "VALUES "
                + "(?,?,?,?,?)";

        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, subject.getSubject_code());
            pre.setString(2, subject.getSubject_name());
            pre.setInt(3, subject.getAuthor_id());
            pre.setString(4, subject.getDescription());
            pre.setBoolean(5, subject.isStatus());

            if (pre.executeUpdate() > 0) {
                ResultSet rs = getData("SELECT subject_id from `subject` order by subject_id desc limit 1");
                if (rs.next()) {
                    check = rs.getInt(1);
                }
            }

        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;

    }

    public boolean updateStatus(int id, boolean status) {
        boolean check = false;
        String sql = "UPDATE `subject`\n"
                + "SET "
                + "`status` = ? "
                + "WHERE `subject_id` = ? ;";
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

    public boolean updateSubject(Subject s) {
        boolean check = false;
        String sql = "UPDATE `subject` "
                + "SET `subject_code` = ?, "
                + "`subject_name` = ?, "
                + "`author_id` = ?,  "
                + " `description` = ?, "
                + "`status` = ?  "
                + "WHERE `subject_id` = ? ;";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, s.getSubject_code());
            pre.setString(2, s.getSubject_name());
            pre.setInt(3, s.getAuthor_id());
            pre.setString(4, s.getDescription());
            pre.setBoolean(5, s.isStatus());
            pre.setInt(6, s.getSubject_id());

            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }
}
