/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import java.util.*;
import Model.Entity.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.PrintWriter;
import java.io.StringWriter;
import org.apache.log4j.Logger;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author win
 */
public class ClassUserDAO extends Utils.ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(ClassUserDAO.class);

    private static ClassUserDAO instance;

    public static ClassUserDAO getInstance() {
        if (ClassUserDAO.instance == null) {
            ClassUserDAO.instance = new ClassUserDAO();
        }
        return ClassUserDAO.instance;
    }

    public boolean checkAllow(int team, User user) {
        if (user.getRole_id()==1) {
            return true;
        }
        boolean check = false;
        String sql = "select * from `class_user` " + (("where team_id=" + team).concat(user.getRole_id() == 3 ? " and class_id in (select class_id from `class` where trainer_id=" + user.getUser_id() + ")" : (user.getRole_id() == 4 ? " and user_id=" + user.getUser_id() : " and class_id in (select class_id from `class`,`subject` where class.subject_id=subject.subject_id and author_id=" + user.getUser_id() + ")")));
        ResultSet rs = getData(sql);
        try {
            if (rs.next()) {
                check = true;
            }
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public ClassUser checkClassUser(String class_code, String email) {
        ClassUser check = null;
        String sql = "select * from `class_user`,`class`,`user` where email= '" + email + "' and user.status=1 and class.status=1 and class_user.status=1 and user.user_id=class_user.user_id and class.class_id=class_user.class_id and class_code='" + class_code + "'";
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int class_id = rs.getInt(1);
                int team_id = rs.getInt(2);
                int user_id = rs.getInt(3);
                boolean team_leader = rs.getBoolean(4);
                String dropout_date = rs.getString(5);
                String user_notess = rs.getString(6);
                double ongoing_eval = rs.getDouble(7);
                double final_pres_eval = rs.getDouble(8);
                double final_topic_eval = rs.getDouble(9);
                boolean status = rs.getBoolean(10);
                check = new ClassUser(class_id, team_id, user_id, team_leader, dropout_date, user_notess, ongoing_eval, final_pres_eval, final_topic_eval, status);
                break;
            }
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateClassUser(ClassUser c) {
        boolean check = false;
        String sql = "UPDATE `class_user` SET `team_id`=?,`dropout_date`=?,`user_notes`=?,`team_leader`=?, `status` = ? WHERE (`class_id` = ? and `user_id`=?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, c.getTeam_id());
            pre.setString(2, c.getDropout_date());
            pre.setString(3, c.getUser_notes());
            pre.setBoolean(4, c.isTeam_leader());
            pre.setBoolean(5, c.isStatus());
            pre.setInt(6, c.getClass_id());
            pre.setInt(7, c.getUser_id());
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateChangeStatus(int id, int classId, boolean status) {
        boolean check = false;
        String sql = "UPDATE `class_user` SET `status` = ? WHERE (`class_id` = ? and `user_id` = ?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setBoolean(1, status);
            pre.setInt(2, classId);
            pre.setInt(3, id);
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public ClassUser getLeader(int team_id) {
        ClassUser check = null;
        String sql = "select * from `class_user` where team_id=" + team_id + " and team_leader=1 and status=1";
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int class_id = rs.getInt(1);
                int user_id = rs.getInt(3);
                boolean team_leader = rs.getBoolean(4);
                String dropout_date = rs.getString(5);
                String user_notess = rs.getString(6);
                double ongoing_eval = rs.getDouble(7);
                double final_pres_eval = rs.getDouble(8);
                double final_topic_eval = rs.getDouble(9);
                boolean status = rs.getBoolean(10);
                check = new ClassUser(class_id, team_id, user_id, team_leader, dropout_date, user_notess, ongoing_eval, final_pres_eval, final_topic_eval, status);
                break;
            }
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean addClassUser(ClassUser c) {
        boolean check = false;
        String sql = "INSERT INTO `class_user` (`class_id`,`team_id`,`user_id`,`team_leader`,`user_notes`,`dropout_date`,`status`)"
                + "VALUES (?,?,?,?,?,?,?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, c.getClass_id());
            pre.setInt(2, c.getTeam_id());
            pre.setInt(3, c.getUser_id());
            pre.setBoolean(4, c.isTeam_leader());
            pre.setString(5, c.getUser_notes());
            pre.setString(6, c.getDropout_date());
            pre.setBoolean(7, c.isStatus());
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public int getClassNumber(int class_id) {
        int check = -1;
        String sql = "select count(user_id) from `class_user` where status=1 and class_id=" + class_id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                check = rs.getInt(1);
                break;
            }
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean checkClass(String code, int subject_id, int year, int term, boolean block5) {
        boolean check = false;
        String sql = "select * from class where class_id= '" + code + "' and subject_id=" + subject_id + " and class_year = " + year + " and class_term=" + term + " block5_class=" + (block5 ? "1" : "0");
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

    public ClassUser getClassUser(int class_id, int user_id) {
        ClassUser classUser = null;
        String sql = "select * from `class_user` where class_id=" + class_id + " and user_id=" + user_id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int team_id = rs.getInt(2);
                boolean team_leader = rs.getBoolean(4);
                String dropout_date = rs.getString(5);
                String user_notess = rs.getString(6);
                double ongoing_eval = rs.getDouble(7);
                double final_pres_eval = rs.getDouble(8);
                double final_topic_eval = rs.getDouble(9);
                boolean status = rs.getBoolean(10);
                classUser = new ClassUser(class_id, team_id, user_id, team_leader, dropout_date, user_notess, ongoing_eval, final_pres_eval, final_topic_eval, status);
            }
        } catch (Exception e) {
        }
        return classUser;
    }

    public List<ClassUser> getList(Integer type, Integer statusChoose, String search, int start, int limit, User user, int classID, String sort, boolean statusSort) {
        List<ClassUser> list = new ArrayList<>();
        String sql = "CALL search('\\'%" + search + "%\\'','class_user','" + (search.isEmpty() ? "" : " or user_id in (select user_id from `user` where (`email` like \"%" + search + "%\" or `full_name` like \"%" + search + "%\" or `roll_number` like \"%" + search + "%\"))") + " and class_id=" + classID + (type != null ? " and team_id=" + type : "") + (statusChoose != null ? " and status = " + statusChoose : "")
                + (user.getRole_id() == 1 ? "" : user.getRole_id() == 3 ? " and class_id in (select class_id from `class` where trainer_id=" + user.getUser_id() + ")" : (user.getRole_id() == 4 ? "" : " and class_id in (select class_id from `class`,`subject` where class.subject_id=subject.subject_id and author_id=" + user.getUser_id() + ")")) 
                + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs1 = getData(sql);
        try {
            while (rs1.next()) {
                String sql1 = rs1.getString(1);
                ResultSet rs = getData(sql1);
                while (rs.next()) {
                    int class_id = rs.getInt(1);
                    int team_id = rs.getInt(2);
                    int user_id = rs.getInt(3);
                    boolean team_leader = rs.getBoolean(4);
                    String dropout_date = rs.getString(5);
                    String user_notess = rs.getString(6);
                    double ongoing_eval = rs.getDouble(7);
                    double final_pres_eval = rs.getDouble(8);
                    double final_topic_eval = rs.getDouble(9);
                    boolean status = rs.getBoolean(10);
                    list.add(new ClassUser(class_id, team_id, user_id, team_leader, dropout_date, user_notess, ongoing_eval, final_pres_eval, final_topic_eval, status));
                }
                rs.close();
            }
            rs1.close();
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }
}
