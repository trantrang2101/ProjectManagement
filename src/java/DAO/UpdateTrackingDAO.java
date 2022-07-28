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
public class UpdateTrackingDAO extends Utils.ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(UpdateTrackingDAO.class);

    private static UpdateTrackingDAO instance;

    public static UpdateTrackingDAO getInstance() {
        if (UpdateTrackingDAO.instance == null) {
            UpdateTrackingDAO.instance = new UpdateTrackingDAO();
        }
        return UpdateTrackingDAO.instance;
    }

    public boolean deleteTracking(int id) {
        boolean check = false;
        String sql = "Delete from `update_tracking` WHERE (`update_id`=?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(2, id);
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }
    
    public boolean updateTracking(UpdateTracking c) {
        boolean check = false;
        String sql = "UPDATE `update_tracking` SET `Update_note`=?,`Update_date`=now() WHERE (`update_id`=?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, c.getUpdate_note());
            pre.setInt(2, c.getUpdate_id());
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean addTracking(UpdateTracking c) {
        boolean check = false;
        String sql = "INSERT INTO `update_tracking` (`milestone_id`,`tracking_id`,`Update_note`)"
                + "VALUES (?,?,?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, c.getMilestone_id());
            pre.setInt(2, c.getTracking_id());
            pre.setString(3, c.getUpdate_note());
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public UpdateTracking checkTracking(int milestone_id, int tracking_id) {
        UpdateTracking tracking = null;
        String sql = "select * from `update_tracking` where milestone_id =" + milestone_id + " and tracking_id =" + tracking_id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int update_id =rs.getInt(1);
                String update_date = rs.getString(3);
                String tracking_note = rs.getString(5);
                tracking = new UpdateTracking(update_id, tracking_id, update_date, milestone_id, tracking_note);
            }
        } catch (Exception e) {
        }
        return tracking;
    }

    public UpdateTracking getUpdateTracking(int update_id) {
        UpdateTracking tracking = null;
        String sql = "select * from `update_tracking` where update_id=" + update_id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int tracking_id = rs.getInt(2);
                String update_date = rs.getString(3);
                int milestone_id = rs.getInt(4);
                String tracking_note = rs.getString(5);
                tracking = new UpdateTracking(update_id, tracking_id, update_date, milestone_id, tracking_note);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return tracking;
    }

    public List<UpdateTracking> getList(Integer team, Integer milestone, Integer tracking, Integer feature, int start, int limit, User user, String sort, boolean statusSort) {
        List<UpdateTracking> list = new ArrayList<>();
        String sql = "CALL search('\\'%%\\'','update_tracking','" + (milestone != null ? " and milestone_id=" + milestone : "") + (tracking != null ? " and tracking_id=" + tracking : "")
                + (team != null ? " and tracking_id in (select tracking_id from `function`, tracking where function.function_id=tracking.function_id and team_id=" + team + ")" : "") + (feature != null ? " and tracking_id in (select tracking_id from `tracking`,`function` where function.function_id=tracking.function_id and feature_id=" + feature + ")" : "")
                + (user.getRole_id() == 1 ? "" : user.getRole_id() == 2 ? " and milestone_id in (select milestone_id from `milestone`,`class` where milestone.class_id = class.class_id and trainer_id=" + user.getUser_id() + ")" : (user.getRole_id() == 4 ? " and milestone_id in (select milestone_id from `milestone`,`class_user` where class_user.class_id=milestone.class_id and user_id=" + user.getUser_id() + ")" : " and milestone_id in (select milestone_id from `milestone`,`class`,`subject` where class.class_id=milestone.class_id and class.subject_id=subject.subject_id and author_id=" + user.getUser_id() + ")"))
                + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs1 = getData(sql);
        try {
            while (rs1.next()) {
                String sql1 = rs1.getString(1);
                ResultSet rs = getData(sql1);
                while (rs.next()) {
                    int update_id = rs.getInt(1);
                    int tracking_id = rs.getInt(2);
                    String update_date = rs.getString(3);
                    int milestone_id = rs.getInt(4);
                    String tracking_note = rs.getString(5);
                    list.add(new UpdateTracking(update_id, tracking_id, update_date, milestone_id, tracking_note));
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
