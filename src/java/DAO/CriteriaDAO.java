/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import Model.Entity.Criteria;
import Model.Entity.User;
import static Utils.ConnectJDBC.getConnection;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.apache.log4j.Logger;

/**
 *
 * @author ADMIN
 */
public class CriteriaDAO extends Utils.ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(CriteriaDAO.class);

    private static CriteriaDAO instance;

    public static CriteriaDAO getInstance() {
        if (CriteriaDAO.instance == null) {
            CriteriaDAO.instance = new CriteriaDAO();
        }
        return CriteriaDAO.instance;
    }

    private CriteriaDAO() {
    }

    public Criteria getCriteria(int id) {
        String sql = "SELECT * FROM evaluation_criteria where Criteria_id=" + id;
        Criteria crit = null;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int criteria_id = rs.getInt("criteria_id");
                int iteration_id = rs.getInt("iteration_id");
                String criteria_title = rs.getString("criteria_title");
                String criteria_description = rs.getString("criteria_description");
                double evaluation_weight = rs.getDouble("evaluation_weight");
                boolean team_evaluation = rs.getBoolean("team_evaluation");
                int criteria_order = rs.getInt("criteria_order");
                int max_loc = rs.getInt("max_loc");
                boolean status = rs.getBoolean("status");
                crit = new Criteria(criteria_id, iteration_id, criteria_title, criteria_description, evaluation_weight, team_evaluation, criteria_order, max_loc, status);
            }
            rs.close();
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return crit;
    }

    public boolean updateStatus(int id, boolean status) {
        boolean check = false;
        double result = 0;
        String sql = "CALL `updateCriteriaStatus`( ? , ? );";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setBoolean(2, status);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
            if (result != -1) {
                check = true;
            }

        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateTeamEval(int id, boolean teamEval) {
        boolean check = false;
        String sql = "UPDATE `evaluation_criteria` SET `team_evaluation` = ? WHERE (`criteria_id` = ?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setBoolean(1, teamEval);
            pre.setInt(2, id);
            check = pre.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public List<Criteria> getList(int type, String search, User login, int start, int limit, String sort, boolean statusSort, Integer statusFilter, Integer iteration_id) {
        List<Criteria> list = new ArrayList<>();
        String sql = "CALL search('\\'%" + search + "%\\'','evaluation_criteria','"
                + "" + (iteration_id == null ? "" : " and iteration_id= " + iteration_id)
                + (statusFilter == null ? "" : " and status= " + statusFilter) + (login.getRole_id() == 2 ? (type == 0 ? " and iteration_id in (select iteration_id from iteration join subject on subject.subject_id = iteration.subject_id"
                + " where subject.author_id = " + login.getUser_id() + ")"
                : " and iteration_id in (select iteration_id from iteration join subject on subject.subject_id = iteration.subject_id"
                + " where iteration.subject_id = " + type + " and subject.author_id = " + login.getUser_id() + ")") : (type == 0 ? ""
                : " and iteration_id in (select iteration_id from iteration join subject on subject.subject_id = iteration.subject_id where iteration.subject_id =  " + type + ")"))
                + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";

        ResultSet rs = getData(sql);
        try {

            while (rs.next()) {
                String sql1 = rs.getString(1);
                ResultSet rs1 = getData(sql1);
                while (rs1.next()) {
                    int criteria_id = rs1.getInt("criteria_id");
                    int iteration_id1 = rs1.getInt("iteration_id");
                    String criteria_title = rs1.getString("criteria_title");
                    String criteria_description = rs1.getString("criteria_description");
                    double evaluation_weight = rs1.getDouble("evaluation_weight");
                    boolean team_evaluation = rs1.getBoolean("team_evaluation");
                    int criteria_order = rs1.getInt("criteria_order");
                    int max_loc = rs1.getInt("max_loc");
                    boolean status = rs1.getBoolean("status");
                    list.add(new Criteria(criteria_id, iteration_id1, criteria_title, criteria_description, evaluation_weight, team_evaluation, criteria_order, max_loc, status));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public boolean addCriteria(Criteria crit) {
        boolean check = false;
        double result = 0;
        String sql = "CALL `addCriteria`(? , ?, ?, ? , ? , ? , ?, ?)";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, crit.getIteration_id());
            pre.setString(2, crit.getCriteria_title());
            pre.setString(3, crit.getCriteria_description());
            pre.setDouble(4, crit.getEvaluation_weight());
            pre.setBoolean(5, crit.isTeam_evaluation());
            pre.setInt(6, crit.getCriteria_order());
            pre.setInt(7, crit.getMax_loc());
            pre.setBoolean(8, crit.isStatus());
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
            if (result != -1) {
                check = true;
            }
        } catch (SQLException e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateCriteria(Criteria crit) {

        //criteria_id,criteria_iterationid, crit_title, crit_description,crit_weight, crit_order, crit_loc , status
        String sql = "CALL `updateCriteria`(?, ? ,? , ?, ? ,? ,?, ?, ?)";
        boolean check = false;
        double result = 0;
        try {

            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);

            pre.setInt(1, crit.getCriteria_id());
            pre.setString(2, crit.getCriteria_title());
            pre.setString(3, crit.getCriteria_description());
            pre.setDouble(4, crit.getEvaluation_weight());
            pre.setBoolean(5, crit.isTeam_evaluation());
            pre.setInt(6, crit.getCriteria_order());
            pre.setInt(7, crit.getMax_loc());
            pre.setBoolean(8, crit.isStatus());
            pre.setInt(9, crit.getIteration_id());
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
            if (result != -1) {
                check = true;
            }

        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;

    }

    public double getCriteriaTotalWeight(int id) {
        String sql = "SELECT sum(evaluation_weight) FROM evaluation_criteria where iteration_id = " + id + " and status = 1";
        double total = 0;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {

                total = rs.getDouble(1);

            }
            rs.close();
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return total;

    }
}
