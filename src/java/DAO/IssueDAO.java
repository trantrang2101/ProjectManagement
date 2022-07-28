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

/**
 *
 * @author Admin
 */
public class IssueDAO extends Utils.ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(IssueDAO.class);

    private static IssueDAO instance;

    public static IssueDAO getInstance() {
        if (IssueDAO.instance == null) {
            IssueDAO.instance = new IssueDAO();
        }
        return IssueDAO.instance;
    }

    public Issue getIssue(int id) {
        Issue Issue = null;
        String sql = "select * from `issue` where issue_id=" + id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int assignee_id = rs.getInt(2);
                String issue_title = rs.getString(3);
                String description = rs.getString(4);
                String gitlab_id = rs.getString(5);
                String gitlab_url = rs.getString(6);
                String created_at = rs.getString(7);
                String due_date = rs.getString(8);
                int team_id = rs.getInt(9);
                int milestone_id = rs.getInt(10);
                int function_id = rs.getInt(11);
                int status = rs.getInt(12);
                int label = rs.getInt(13);
                Issue = new Issue(id, assignee_id, issue_title, description, gitlab_id, gitlab_url, created_at, due_date, team_id, milestone_id, function_id, status, label);
            }
        } catch (Exception e) {
        }
        return Issue;
    }

    public List<Issue> getList(User user, String search, int start, int limit, String sort, boolean statusSort, Integer statusFilter) {
        List<Issue> list = new ArrayList<>();
        String sql = "CALL search('\\'%" + search + "%\\'','issue','"
                + (statusFilter == null ? "" : " and status = " + statusFilter)
                + (user == null || user.getRole_id() == 1 ? "" : (user.getRole_id() == 4 ? " and team_id in (select team_id from `class_user` where user_id = " + user.getUser_id() + ")"
                : (user.getRole_id() == 3 ? " and team_id in (select team_id from `class_user`,`class` where class_user.class_id=class.class_id and trainer_id=" + user.getUser_id() + ")" : " and team_id in (select team_id from `class_user`,`class`,`subject` where subject.subject_id=class.subject_id and class_user.class_id=class.class_id and author_id=" + user.getUser_id() + ")")))
                + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                String sql1 = rs.getString(1);
                ResultSet rs1 = getData(sql1);
                while (rs1.next()) {
                    try {
                        int issue_id = rs1.getInt(1);
                        int assignee_id = rs1.getInt(2);
                        String issue_title = rs1.getString(3);
                        String description = rs1.getString(4);
                        String gitlab_id = rs1.getString(5);
                        String gitlab_url = rs1.getString(6);
                        String created_at = rs1.getString(7);
                        String due_date = rs1.getString(8);
                        int team_id = rs1.getInt(9);
                        int milestone_id = rs1.getInt(10);
                        int function_id = rs1.getInt(11);
                        int status = rs1.getInt(12);
                        Integer label = rs1.getInt(13);
                        list.add(new Issue(issue_id, assignee_id, issue_title, description, gitlab_id, gitlab_url, created_at, due_date, team_id, milestone_id, function_id, status, label));
                    } catch (Exception e) {
                        e.printStackTrace(new PrintWriter(errors));
                        logger.error(errors.toString());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public boolean updateIssue(Issue issue) {
        boolean check = false;
        String sql = "UPDATE `issue` SET `assignee_id` = ?, `issue_title` = ?, `description` = ?, "
                + "`gitlab_id` = ?, `gitlab_url` = ?, `created_at` = ?, `due_date` = ?, "
                + "`team_id` = ?, `milestone_id` = ?, `function_id` = ?, `status` = ? , `label` = ? WHERE `issue_id` = ?;";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, issue.getAssignee_id());
            pre.setString(2, issue.getIssue_title());
            pre.setString(3, issue.getDescription());
            pre.setString(4, issue.getGitlab_id());
            pre.setString(5, issue.getGitlab_url());
            pre.setString(6, issue.getCreated_at());
            pre.setString(7, issue.getDue_date());
            pre.setInt(8, issue.getTeam_id());
            pre.setInt(9, issue.getMilestone_id());
            pre.setInt(10, issue.getFunction_id());
            pre.setInt(11, issue.getStatus());
            pre.setInt(12, issue.getLabel());
            pre.setInt(13, issue.getIssue_id());

            check = pre.executeUpdate() > 0;

        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateStatus(int id, int status) {
        boolean check = false;
        String sql = "UPDATE `issue` SET `status` = ? WHERE `issue_id` = ?;";
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

    public int addIssue(Issue issue) {
        int check = -1;
        String sql = "INSERT INTO `issue` (`assignee_id`,`issue_title`,`description`,`gitlab_id`,`gitlab_url`,`due_date`,`team_id`,`milestone_id`,`function_id`,`status`,`label`)"
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?);";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, issue.getAssignee_id());
            pre.setString(2, issue.getIssue_title());
            pre.setString(3, issue.getDescription());
            pre.setString(4, issue.getGitlab_id());
            pre.setString(5, issue.getGitlab_url());
            pre.setString(6, issue.getDue_date());
            pre.setInt(7, issue.getTeam_id());
            pre.setInt(8, issue.getMilestone_id());
            pre.setInt(9, issue.getFunction_id());
            pre.setInt(10, issue.getStatus());
            pre.setInt(11, issue.getLabel());

            if (pre.executeUpdate() > 0) {
                ResultSet rs = getData("SELECT issue_id from `issue` order by issue_id desc limit 1");
                if (rs.next()) {
                    check = rs.getInt(1);
                }
            }

        } catch (SQLException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public int checkAddIssue(String issue_title, Integer team_id, Integer milestone_id) {
        int check = -1;
        String sql = "SELECT team_id from `issue` where issue_title = '" + issue_title + "' and team_id = " + team_id + " and milestone_id = " + milestone_id;
        ResultSet rs = getData(sql);
        try {
            if (rs.next()) {
                check = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

}
