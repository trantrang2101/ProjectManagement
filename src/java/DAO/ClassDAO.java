/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import Controller.SignupServlet;
import java.util.*;
import Model.Entity.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.io.PrintWriter;
import java.io.StringWriter;
import org.apache.log4j.Logger;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author win
 */
public class ClassDAO extends Utils.ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(ClassDAO.class);

    private static ClassDAO instance;

    public static ClassDAO getInstance() {
        if (ClassDAO.instance == null) {
            ClassDAO.instance = new ClassDAO();
        }
        return ClassDAO.instance;
    }

//    public static List<Subject> getSubject(User login) {
//        if (ClassDAO.listSubject == null) {
//            getClass(login);
//        }
//        return listSubject;
//    }
//
//    public static List<User> getTrainer(User login) {
//        if (ClassDAO.listTeacher == null) {
//            getClass(login);
//        }
//        return listTeacher;
//    }
//
//    private static void getClass(User user) {
//        listTeacher = new ArrayList<>();
//        listSubject = new ArrayList<>();
//        String sql = "select trainer_id,subject_id from `studentmanagement`.`class`"
//                + (user.getRole_id() == 1 ? "" : user.getRole_id() == 3 ? "where trainer_id=" + user.getUser_id() : " status=1".concat(user.getRole_id() == 4 ? "where class_id in (select class_id from `studentmanagement`.`class_user` where user_id=" + user.getUser_id() + ")" : "where subject_id in (select subject_id from `studentmanagement`.`subject` where author_id=" + user.getUser_id() + ")"));
//        try {
//            Connection conn = getConnection();
//            Statement stm = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
//            ResultSet rs1 = stm.executeQuery(sql);
//            while (rs1.next()) {
//                listTeacher.add(DAO.UserDAO.getInstance().getUser(rs1.getInt(1), false));
//                listSubject.add(DAO.SubjectDAO.getInstance().getSubject(rs1.getInt(2)));
//            }
//            rs1.close();
//        } catch (Exception ex) {
//            ex.printStackTrace(new PrintWriter(errors));
//            logger.error(errors.toString());
//        }
//    }
    public boolean updateClassroom(Classroom c) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`class` SET `class_code` = ?, `trainer_id` = ?, `subject_id` = ?, `Class_year` = ?, `class_term` = ?, "
                + "`block5_class` = ?, `status` = ?,`description`=?,`gitlab_url`=?,`apiToken`=? WHERE (`class_id` = ?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, c.getClass_code().toUpperCase());
            pre.setInt(2, c.getTrainer().getUser_id());
            pre.setInt(3, c.getSubject().getSubject_id());
            pre.setInt(4, c.getClass_year());
            pre.setInt(5, c.getClass_term());
            pre.setBoolean(6, c.isBlock5_class());
            pre.setBoolean(7, c.isStatus());
            pre.setString(8, c.getDescription());
            pre.setString(9, c.getGitlab_url());
            pre.setString(10, c.getApiToken());
            pre.setInt(11, c.getClass_id());
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateChangeStatus(int id, boolean status) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`class` SET `status` = ? WHERE (`class_id` = ?);";
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

    public boolean addClass(Classroom c) {
        boolean check = false;
        String sql = "INSERT INTO `studentmanagement`.`class` (`class_code`, `trainer_id`, `subject_id`, `class_year`, `class_term`, `block5_class`, `status`, `description`,`apiToken`,`gitlab_url`)"
                + "VALUES (?,?, ?, ?,?, ?,?,?,?,?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, c.getClass_code().toUpperCase());
            pre.setInt(2, c.getTrainer().getUser_id());
            pre.setInt(3, c.getSubject().getSubject_id());
            pre.setInt(4, c.getClass_year());
            pre.setInt(5, c.getClass_term());
            pre.setBoolean(6, c.isBlock5_class());
            pre.setBoolean(7, c.isStatus());
            pre.setString(8, c.getDescription());
            pre.setString(9, c.getApiToken());
            pre.setString(10, c.getGitlab_url());
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean checkClass(String code, int subject_id, int year, int term, boolean block5) {
        boolean check = false;
        String sql = "select * from studentmanagement.class where class_id= '" + code + "' and subject_id=" + subject_id + " and class_year = " + year + " and class_term=" + term + " block5_class=" + (block5 ? "1" : "0");
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                check = true;
                break;
            }
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public Classroom getClass(User user, int id) {
        Classroom list = null;
        String sql = "select * from studentmanagement.class where class_id=" + id
                + (user == null || user.getRole_id() == 1 ? "" : user.getRole_id() == 3 ? " and trainer_id=" + user.getUser_id() : " and status=1".concat(user.getRole_id() == 4 ? " and class_id in (select class_id from `studentmanagement`.`class_user` where user_id=" + user.getUser_id() + ")" : " and subject_id in (select subject_id from `studentmanagement`.`subject` where author_id=" + user.getUser_id() + ")"));
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int class_id = rs.getInt(1);
                String code = rs.getString(2).toUpperCase();
                int subject_id = rs.getInt(4);
                int email = rs.getInt(3);
                int year = rs.getInt(5);
                int term = rs.getInt(6);
                boolean block = rs.getBoolean(7);
                String description = rs.getString(8);
                boolean status = rs.getBoolean(9);
                String url = rs.getString(10);
                String api = rs.getString(11);
                list = new Classroom(class_id, code, email, subject_id, year, term, block, status, description, url, api);
            }
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public List<Classroom> getList(String search, int start, int limit, User user, Integer type, Integer trainer, Integer statusFilter, String sort, boolean statusSort) {
        List<Classroom> list = new ArrayList<>();
        String sql = "CALL `studentmanagement`.search('\\'%" + search + "%\\'','studentmanagement','class','" + (type != null ? " and subject_id=" + type : "").concat(trainer != null ? " and trainer_id=" + trainer : "").concat(statusFilter != null ? " and status=" + statusFilter : "")
                + (user.getRole_id() == 1 ? "" : user.getRole_id() == 3 ? " and trainer_id=" + user.getUser_id() : " and status=1".concat(user.getRole_id() == 4 ? " and class_id in (select class_id from `studentmanagement`.`class_user` where user_id=" + user.getUser_id() + ")" : " and subject_id in (select subject_id from `studentmanagement`.`subject` where author_id=" + user.getUser_id() + ")"))
                + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs1 = getData(sql);
        try {
            while (rs1.next()) {
                String sql1 = rs1.getString(1);
                ResultSet rs = getData(sql1);
                while (rs.next()) {
                    int class_id = rs.getInt(1);
                    String code = rs.getString(2).toUpperCase();
                    int subject_id = rs.getInt(4);
                    int email = rs.getInt(3);
                    int year = rs.getInt(5);
                    int term = rs.getInt(6);
                    boolean block = rs.getBoolean(7);
                    String description = rs.getString(8);
                    boolean status = rs.getBoolean(9);
                    String url = rs.getString(10);
                    String api = rs.getString(11);
                    list.add(new Classroom(class_id, code, email, subject_id, year, term, block, status, description, url, api));
                }
            }
            rs1.close();
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }
}
