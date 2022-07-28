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
public class FunctionDAO extends ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(FunctionDAO.class);

    private static FunctionDAO instance;

    public static FunctionDAO getInstance() {
        if (FunctionDAO.instance == null) {
            FunctionDAO.instance = new FunctionDAO();
        }
        return FunctionDAO.instance;
    }

    public Function getFunction(int id) {
        Function func = null;
        String sql = "SELECT * from `function` where function_id=" + id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int function_id = rs.getInt(1);
                int team_id = rs.getInt(2);
                String function_name = rs.getString(3);
                int feature_id = rs.getInt(4);
                String access_roles = rs.getString(5);
                String description = rs.getString(6);
                int complexity_id = rs.getInt(7);
                int owner_id = rs.getInt(8);
                int priority = rs.getInt(9);
                int status = rs.getInt(10);
                func = new Function(function_id, team_id, feature_id, complexity_id, owner_id, priority, function_name, description, access_roles, status);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return func;
    }

    public List<Function> getList(Integer teamId, Integer featureId, User login, String search, int start, int limit, String sort, boolean statusSort, Integer statusFilter, Integer complexityFilter, Integer priorityFilter, Integer ownerFilter) {
        List<Function> list = new ArrayList<>();
        String sql = "CALL search('\\'%" + search + "%\\'','function','"
                + (login.getRole_id() == 4 ? "and team_id = (select team_id from class_user where user_id=" + login.getUser_id() + " )" : "".concat(login.getRole_id() == 2 ? "and team_id in (select team_id from `team` where class_id in (select class_id from class where subject_id in (select subject_id from subject where author_id=" + login.getUser_id() + ")))" : "").concat(login.getRole_id() == 3 ? "and team_id in (select team_id from `team` where class_id in (select class_id from class where trainer_id in (select trainer_id from class where trainer_id=" + login.getUser_id() + ")))" : ""))
                + (teamId == null || teamId == 0 ? "" : " and team_id = " + teamId)
                + (featureId == null ? "" : " and feature_id = " + featureId)
                + (complexityFilter == null ? "" : " and complexity_id = " + complexityFilter)
                + (priorityFilter == null ? "" : " and priority = " + priorityFilter)
                + (ownerFilter == null ? "" : " and owner_id = " + ownerFilter)
                + (statusFilter == null ? "" : " and status = " + statusFilter)
                + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                String sql1 = rs.getString(1);
                ResultSet rs1 = getData(sql1);
                while (rs1.next()) {
                    try {
                        int function_id = rs1.getInt(1);
                        int team_id = rs1.getInt(2);
                        String function_name = rs1.getString(3);
                        int feature_id = rs1.getInt(4);
                        String access_roles = rs1.getString(5);
                        String description = rs1.getString(6);
                        int complexity_id = rs1.getInt(7);
                        int owner_id = rs1.getInt(8);
                        int priority = rs1.getInt(9);
                        int status = rs1.getInt(10);
                        list.add(new Function(function_id, team_id, feature_id, complexity_id, owner_id, priority, function_name, description, access_roles, status));
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

    public int addFunction(Function func) {
        int id = -1;
        String sql = "insert into `function` (`function_id`, `team_id`,`function_name`,`feature_id`, `access_roles`, `description`, `complexity_id`,`owner_id`,`priority`,`status`)\n"
                + "values (?,?,?, ?, ?, ?, ?,?,?,?);";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, func.getFunction_id());
            pre.setInt(2, func.getTeam_id());
            pre.setString(3, func.getFunction_name());
            pre.setInt(4, func.getFeature_id());
            pre.setString(5, func.getAccess_roles());
            pre.setString(6, func.getDescription());
            pre.setInt(7, func.getComplexity_id());
            pre.setInt(8, func.getOwner_id());
            pre.setInt(9, func.getPriority());
            pre.setInt(10, func.isStatus());

            if (pre.executeUpdate() > 0) {
                ResultSet rs = getData("SELECT function_id from `function` order by function_id desc limit 1");
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

    public int checkAddFunction(String team_id, Integer feature_id, String function_name) {
        int check = -1;
        String sql = "SELECT * from `function` where team_id = '" + team_id
                + (feature_id == null || feature_id == 0 ? "" : " and feature_id = " + feature_id)
                + "'and function_name='" + function_name + "'";

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

    public boolean updateStatus(int funcId, int status) {
        boolean check = false;
        String sql = "UPDATE `function` \n"
                + "SET status=?\n"
                + "where function_id=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, status);
            pre.setInt(2, funcId);
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateFunction(Function func) {
        boolean check = false;
        String sql = "UPDATE `function` \n"
                + "SET `team_id`=?,`function_name`=?, `feature_id`=?,`access_roles`=?, `description`=?, `complexity_id`=?, `owner_id`=?, `priority`=?, `status`=?\n"
                + "where `function_id`=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(10, func.getFunction_id());
            pre.setInt(1, func.getTeam_id());
            pre.setString(2, func.getFunction_name());
            pre.setInt(3, func.getFeature_id());
//            pre.setString(4, func.getAccess_roles().toString().replaceAll("\\[|\\]", ""));
            pre.setString(4, func.getAccess_roles());
            pre.setString(5, func.getDescription());
            pre.setInt(6, func.getComplexity_id());
            pre.setInt(7, func.getOwner_id());
            pre.setInt(8, func.getPriority());
            pre.setInt(9, func.isStatus());
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public List<Function> getList(int featureId) {
        List<Function> list = new ArrayList<>();
        String sql = "select * from `function` where feature_Id = " + featureId + " and status in (select setting_id from class_setting where setting_title != 'closed') and function_id not in (select function_id from `tracking`)";
        ResultSet rs1 = getData(sql);
        try {
            while (rs1.next()) {
                try {
                    int function_id = rs1.getInt(1);
                    int team_id = rs1.getInt(2);
                    String function_name = rs1.getString(3);
                    int feature_id = rs1.getInt(4);
                    String access_roles = rs1.getString(5);
                    String description = rs1.getString(6);
                    int complexity_id = rs1.getInt(7);
                    int owner_id = rs1.getInt(8);
                    int priority = rs1.getInt(9);
                    int status = rs1.getInt(10);
                    list.add(new Function(function_id, team_id, feature_id, complexity_id, owner_id, priority, function_name, description, access_roles, status));
                } catch (Exception e) {
                }
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

}
