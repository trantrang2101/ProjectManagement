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
public class TrackingDAO extends Utils.ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(TrackingDAO.class);

    private static TrackingDAO instance;

    public static TrackingDAO getInstance() {
        if (TrackingDAO.instance == null) {
            TrackingDAO.instance = new TrackingDAO();
        }
        return TrackingDAO.instance;
    }

    public boolean updateTracking(Tracking c) {
        boolean check = false;
        String sql = "UPDATE `tracking` "
                + "SET `tracking_note`=?,`status`=?,assignee_id=? WHERE (`tracking_id`=?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, c.getTracking_note());
            pre.setInt(2, c.getStatus());
            pre.setInt(3, c.getAssignee_id());
            pre.setInt(4, c.getTracking_id());
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateChangeStatus(int id, int status) {
        boolean check = false;
        String sql = "UPDATE `tracking` SET `status`=? WHERE (`tracking_id`=?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, status);
            pre.setInt(2, id);
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean addTracking(Tracking c) {
        boolean check = false;
        String sql = "INSERT INTO `tracking` (`milestone_id`,`function_id`,`assigner_id`,`assignee_id`,`tracking_note`,`status`)"
                + "VALUES (?,?,?,?,?,?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, c.getMilestone_id());
            pre.setInt(2, c.getFunction_id());
            pre.setInt(3, c.getAssigner_id());
            pre.setInt(4, c.getAssignee_id());
            pre.setString(5, c.getTracking_note());
            pre.setInt(6, c.getStatus());
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public Tracking checkTracking(int milestone_id, int function_id) {
        Tracking tracking = null;
        String sql = "select * from `tracking` where milestone_id =" + milestone_id + " and function_id =" + function_id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int tracking_id = rs.getInt(1);
                int assigner_id = rs.getInt(4);
                int assignee_id = rs.getInt(5);
                String tracking_note = rs.getString(6);
                int status = rs.getInt(7);
                tracking = new Tracking(tracking_id, milestone_id, function_id, assigner_id, assignee_id, tracking_note, status);
            }
        } catch (Exception e) {
        }
        return tracking;
    }

    public Tracking getTracking(int tracking_id) {
        Tracking tracking = null;
        String sql = "select * from `tracking` where tracking_id=" + tracking_id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int milestone_id = rs.getInt(2);
                int function_id = rs.getInt(3);
                int assigner_id = rs.getInt(4);
                int assignee_id = rs.getInt(5);
                String tracking_note = rs.getString(6);
                int status = rs.getInt(7);
                tracking = new Tracking(tracking_id, milestone_id, function_id, assigner_id, assignee_id, tracking_note, status);
            }
        } catch (Exception e) {
        }
        return tracking;
    }

    public List<Tracking> getList(Integer type, Integer statusChoose, Integer assignee, Integer function, Integer feature, int start, int limit, User user, String sort, boolean statusSort,Boolean notClosed) {
        List<Tracking> list = new ArrayList<>();
        String sql = "CALL search('\\'%%\\'','tracking','" + (assignee != null ? " and assignee_id=" + assignee : "") + (notClosed==null?"":" and status in (select setting_id from class_setting where setting_title != \\'closed\\')")
                + (type != null ? " and function_id in (select function_id from `function` where team_id=" + type + ")" : "") + (statusChoose != null ? " and status = " + statusChoose : "")
                + (user.getRole_id() == 1 ? "" : user.getRole_id() == 2 ? " and milestone_id in (select milestone_id from `milestone`,`class` where milestone.class_id = class.class_id and trainer_id=" + user.getUser_id() + ")" : (user.getRole_id() == 4 ? " and function_id in (select function_id from `function`,`class_user` where class_user.team_id=function.team_id and user_id=" + user.getUser_id() + ")" : " and milestone_id in (select milestone_id from `milestone`,`class`,`subject` where class.class_id=milestone.class_id and class.subject_id=subject.subject_id and author_id=" + user.getUser_id() + ")"))
                + (function != null ? " and function_id=" + function : "") + (feature != null ? " and function_id in (select function_id from `function` where feature_id=" + feature + ")" : "")
                + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs1 = getData(sql);
        try {
            while (rs1.next()) {
                String sql1 = rs1.getString(1);
                ResultSet rs = getData(sql1);
                while (rs.next()) {
                    int tracking_id = rs.getInt(1);
                    int milestone_id = rs.getInt(2);
                    int function_id = rs.getInt(3);
                    int assigner_id = rs.getInt(4);
                    int assignee_id = rs.getInt(5);
                    String tracking_note = rs.getString(6);
                    int status = rs.getInt(7);
                    list.add(new Tracking(tracking_id, milestone_id, function_id, assigner_id, assignee_id, tracking_note, status));
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
