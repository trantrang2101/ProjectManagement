/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import Model.Entity.*;
import Utils.ConnectJDBC;
import static Utils.ConnectJDBC.getConnection;
import java.sql.Connection;
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
 * @author win
 */
public class MilestoneDAO extends ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(MilestoneDAO.class);

    private static MilestoneDAO instance;

    public static MilestoneDAO getInstance() {
        if (MilestoneDAO.instance == null) {

            MilestoneDAO.instance = new MilestoneDAO();

        }
        return MilestoneDAO.instance;
    }

    private MilestoneDAO() {

    }

    public int addMilestone(Milestone m) {
        int check = -1;
        String sql = "INSERT INTO `milestone` (`milestone_name`, `iteration_id`, `class_id`, `from_date`, `to_date`,`status`) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, m.getMilestone_name());
            if (m.getIteration_id() != null) {
                pre.setInt(2, m.getIteration_id());
            } else {
                pre.setNull(2, java.sql.Types.INTEGER);
            }
            pre.setInt(3, m.getClass_id());
            pre.setString(4, m.getFrom_date());
            pre.setString(5, m.getTo_date());
            pre.setInt(6, m.getStatus());
            if (pre.executeUpdate() > 0) {
                ResultSet rs = getData("SELECT milestone_id from `milestone` order by milestone_id desc limit 1");
                if (rs.next()) {
                    check = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }
    public int checkAddMilestone(int milestone_id, String milestone_name) {
        int check = -1;
        String sql = "SELECT * from `function` where milestone_id = " + milestone_id + " and milestone_name='" + milestone_name + "'";

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

    public int checkTitle(String title) {
        int set = -1;
        String sql = "SELECT milestone_id from `milestone` where milestone_name = '" + title + "'";
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                set = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return set;
    }

    public Milestone getMilestone(int id) {
        Milestone set = null;
        String sql = "SELECT * from `milestone` where milestone_id=" + id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int milestone_id = rs.getInt(1);
                String milestone_name = rs.getString(2);
                int iteration_id = rs.getInt(3);
                int class_id = rs.getInt(4);
                String from_date = rs.getString(5);
                String to_date = rs.getString(6);
                int status = rs.getInt(7);
                set = new Milestone(milestone_id, milestone_name, iteration_id, class_id, from_date, to_date, status);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return set;
    }

    public boolean updateMilestone(int milestone_id, int status) {
        boolean check = false;
        String sql = "UPDATE `milestone` \n"
                + "SET status=?\n"
                + "where milestone_id=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, status);
            pre.setInt(2, milestone_id);
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateMilestone(Milestone m) {
        boolean check = false;
        String sql = "UPDATE `milestone` \n"
                + "SET milestone_name=?, from_date=?, to_date=?, status=?,iteration_id=? "
                + "where milestone_id=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, m.getMilestone_name());
            pre.setString(2, m.getFrom_date());
            pre.setString(3, m.getTo_date());
            pre.setInt(4, m.getStatus());
            if (m.getIteration_id() == null || m.getIteration_id() == 0) {
                pre.setNull(5, java.sql.Types.INTEGER);
            } else {
                pre.setInt(5, m.getIteration_id());
            }
            pre.setInt(6, m.getMilestone_id());
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }
    
    public List<Milestone> getList(Integer classFilter, Integer iterationFilter, Integer statusFilter, User user, String search, int start, int limit, String sort, boolean statusSort) {
        List<Milestone> list = new ArrayList<>();
        String sql = "CALL search('\\'%" + search + "%\\'','milestone','" + (classFilter != null ? " and class_id = " + classFilter : "") + (iterationFilter != null ? " and iteration_id=" + iterationFilter : "")
                + (user.getRole_id() == 1 ? "" : user.getRole_id() == 3 ? " and class_id in (select class_id from `class` where trainer_id=" + user.getUser_id() + ")" : (user.getRole_id() == 4 ? " and class_id in (select class_id from `class_user` where user_id=" + user.getUser_id() + ")" : " and class_id in (select class_id from `class`,`subject` where class.subject_id=subject.subject_id and author_id=" + user.getUser_id() + ")"))
                + (statusFilter != null ? " and status=" + statusFilter : "") + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs1 = getData(sql);
        try {
            while (rs1.next()) {
                String sql1 = rs1.getString(1);
                ResultSet rs = getData(sql1);
                while (rs.next()) {
                    int milestone_id = rs.getInt(1);
                    String milestone_name = rs.getString(2);
                    int iteration_id = rs.getInt(3);
                    int class_id = rs.getInt(4);
                    String from_date = rs.getString(5);
                    String to_date = rs.getString(6);
                    int status = rs.getInt(7);
                    list.add(new Milestone(milestone_id, milestone_name, iteration_id, class_id, from_date, to_date, status));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }
}
