/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import Utils.ConnectJDBC;
import Model.Entity.*;
import static Utils.ConnectJDBC.getConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.io.PrintWriter;
import java.io.StringWriter;
import org.apache.log4j.Logger;

/**
 *
 * @author nashd
 */
public class FeatureDAO extends ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(FeatureDAO.class);

    private static FeatureDAO instance;

    public static FeatureDAO getInstance() {
        if (FeatureDAO.instance == null) {
            FeatureDAO.instance = new FeatureDAO();
        }
        return FeatureDAO.instance;
    }

    public Feature getFeature(Integer id) {
        Feature fea = null;
        String sql = "SELECT * from `studentmanagement`.`feature` where feature_id=" + id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int feature_id = rs.getInt(1);
                int team_id = rs.getInt(2);
                String feature_name = rs.getString(3);
                boolean status = rs.getBoolean(4);
                String description = rs.getString(5);
                fea = new Feature(feature_id, team_id, feature_name, description, status);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return fea;
    }

    public List<Feature> getListNot(int team_id) {
        List<Feature> list = new ArrayList<>();
        String sql = "select * from `studentmanagement`.`feature` where team_id="+team_id+" and status = 1 and feature_id in (select distinct feature_id from `studentmanagement`.`function` where function_id in (select function_id from `studentmanagement`.`tracking`))";
        ResultSet rs1 = getData(sql);
        try {
            while (rs1.next()) {
                try {
                    int feature_id = rs1.getInt(1);
                    String feature_name = rs1.getString(3);
                    boolean status = rs1.getBoolean(4);
                    String description = rs1.getString(5);
                    list.add(new Feature(feature_id, team_id, feature_name, description, status));
                } catch (Exception e) {
                }
            }

        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }
    
    public List<Feature> getList(int team_id) {
        List<Feature> list = new ArrayList<>();
        String sql = "select * from `studentmanagement`.`feature` where team_id="+team_id+" and status = 1 and feature_id in (select feature_id from `studentmanagement`.`function` where function_id not in (select function_id from `studentmanagement`.`tracking`))";
        ResultSet rs1 = getData(sql);
        try {
            while (rs1.next()) {
                try {
                    int feature_id = rs1.getInt(1);
                    String feature_name = rs1.getString(3);
                    boolean status = rs1.getBoolean(4);
                    String description = rs1.getString(5);
                    list.add(new Feature(feature_id, team_id, feature_name, description, status));
                } catch (Exception e) {
                }
            }

        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public List<Feature> getList(Integer team_id, User login, String search, int start, int limit, String sort, boolean statusSort, Boolean statusFilter) {
        List<Feature> list = new ArrayList<>();
        String sql = "CALL `studentmanagement`.search('\\'%" + search + "%\\'','studentmanagement','feature','"
                + (login.getRole_id() == 4 ? "and team_id = (select team_id from class_user where user_id=" + login.getUser_id() + " )" : "".concat(login.getRole_id() == 2 ? "and team_id in (select team_id from `studentmanagement`.`team` where class_id in (select class_id from class where subject_id in (select subject_id from subject where author_id=" + login.getUser_id() + ")))" : "").concat(login.getRole_id() == 3 ? "and team_id in (select team_id from `studentmanagement`.`team` where class_id in (select class_id from class where trainer_id in (select trainer_id from class where trainer_id=" + login.getUser_id() + ")))" : ""))
                + (team_id == 0 ? "" : " and team_id = " + team_id)
                + (statusFilter == null ? "" : " and status = " + statusFilter)
                + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                String sql1 = rs.getString(1);
                ResultSet rs1 = getData(sql1);
                while (rs1.next()) {
                    try {
                        int feature_id = rs1.getInt(1);
                        int team_id1 = rs1.getInt(2);
                        String feature_name = rs1.getString(3);
                        boolean status = rs1.getBoolean(4);
                        String description = rs1.getString(5);
                        list.add(new Feature(feature_id, team_id1, feature_name, description, status));
                    } catch (Exception e) {
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public int addFeature(Feature feature) {
        int id = -1;
        String sql = "INSERT INTO `studentmanagement`.`feature` (`feature_id`, `team_id`, `feature_name`,`description`, `status`) VALUES (?, ?,?, ?, ?);";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, feature.getFeature_id());
            pre.setInt(2, feature.getTeam_id());
            pre.setString(3, feature.getFeature_name());
            pre.setString(4, feature.getDescription());
            pre.setBoolean(5, feature.isStatus());

            if (pre.executeUpdate() > 0) {
                ResultSet rs = getData("SELECT feature_id from `studentmanagement`.`feature` order by feature_id desc limit 1");
                if (rs.next()) {
                    id = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return id;
    }

    public int checkAddFeature(int teamId, String featureName) {
        int check = -1;
        String sql = "SELECT * FROM studentmanagement.feature where team_id = '" + teamId + "'and feature_name='" + featureName + "'";

        try {
            ResultSet rs = getData(sql);
            if (rs.next()) {
                check = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateStatus(int featureId, boolean status) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`feature` \n"
                + "SET status=?\n"
                + "where feature_id=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setBoolean(1, status);
            pre.setInt(2, featureId);
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateFeature(Feature s) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`feature` \n"
                + "            SET `team_id`=?,`feature_name`=?,`status`=?,`description`=?\n"
                + "             where `feature_id`=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, s.getTeam_id());
            pre.setString(2, s.getFeature_name());
            pre.setBoolean(3, s.isStatus());
            pre.setString(4, s.getDescription());
            pre.setInt(5, s.getFeature_id());
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

}
