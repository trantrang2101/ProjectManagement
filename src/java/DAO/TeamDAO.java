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
public class TeamDAO extends ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(TeamDAO.class);

    private static TeamDAO instance;

    public static TeamDAO getInstance() {
        if (TeamDAO.instance == null) {
            TeamDAO.instance = new TeamDAO();
        }
        return TeamDAO.instance;
    }

    public int getTeam(int class_id, int user_id) {
        int team = -1;
        String sql = "SELECT * from `studentmanagement`.`team`,`studentmanagement`.`class_user` where class_user.team_id=team.team_id and user_id=" + user_id + " and team.class_id=" + class_id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                team = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return team;
    }

    public Team getTeam(int id) {
        Team team = null;
        String sql = "SELECT * from `studentmanagement`.`team` where team_id=" + id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int classroom = rs.getInt(2);
                String team_name = rs.getString(3);
                String topic_code = rs.getString(4);
                String topic_name = rs.getString(5);
                String gitlab_url = rs.getString(6);
                boolean status = rs.getBoolean(7);
                String token = rs.getString(8);
                team = new Team(id, classroom, team_name, topic_code, topic_name, gitlab_url, status, token);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return team;
    }

    public List<Team> getList(Integer class_id, User login, String search, int start, int limit, String sort, boolean statusSort, Integer statusFilter) {
        List<Team> list = new ArrayList<>();
        String sql = "CALL `studentmanagement`.search('\\'%" + search + "%\\'','studentmanagement','team','" 
                + (login.getRole_id() == 1 ? "" : (login.getRole_id() == 2 ? " and class_id in (select class_id from `studentmanagement`.`class`,`studentmanagement`.`subject` where subject.subject_id=class.subject_id and author_id=" + login.getUser_id() + ")" : (login.getRole_id() == 3 ? " and class_id in (select class_id from `studentmanagement`.`class` where trainer_id=" + login.getUser_id() + ")" : " and status=1".concat(" and team_id in (select team_id from `studentmanagement`.`class_user` where user_id=" + login.getUser_id() + ")"))))
                + (statusFilter == null ? "" : " and status= " + statusFilter)
                + (class_id == null ? "" : " and class_id = " + class_id)
                + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                String sql1 = rs.getString(1);
                ResultSet rs1 = getData(sql1);
                while (rs1.next()) {
                    int team_id = rs1.getInt(1);
                    int classroom = rs1.getInt(2);
                    String team_name = rs1.getString(3);
                    String topic_code = rs1.getString(4);
                    String topic_name = rs1.getString(5);
                    String gitlab_url = rs1.getString(6);
                    boolean status = rs1.getBoolean(7);
                    String token = rs1.getString(8);
                    list.add(new Team(team_id, classroom, team_name, topic_code, topic_name, gitlab_url, status, token));
                }
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public int checkAddTeam(String team_name, int class_id, boolean status) {
        int check = -1;
        String sql = "SELECT team_id from `studentmanagement`.`team` where team_name = '" + team_name + "' and class_id = " + class_id + " and status = " + status;
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

    public int addTeam(Team t) {
        int check = -1;
        String sql = "INSERT INTO `studentmanagement`.`team` (`class_id`, `team_name`, `topic_code`, `topic_name`, `gitlab_url`, `apiToken`, `status`) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, t.getClassroom().getClass_id());
            pre.setString(2, t.getTeam_name());
            pre.setString(3, t.getTopic_code());
            pre.setString(4, t.getTopic_name());
            pre.setString(5, t.getGitlab_url());
            pre.setString(6, t.getApiToken());
            pre.setBoolean(7, t.isStatus());
            if (pre.executeUpdate() > 0) {
                ResultSet rs = getData("SELECT team_id from `studentmanagement`.`team` order by team_id desc limit 1");
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

    public boolean updateStatus(int teamId, boolean status) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`team` \n"
                + "SET status=?\n"
                + "where team_id=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setBoolean(1, status);
            pre.setInt(2, teamId);
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateTeam(Team t) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`team` \n"
                + "SET class_id=?, team_name=?, topic_code=?, topic_name=?, gitlab_url=?, apiToken=?, status=?\n"
                + "where team_id=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, t.getClassroom().getClass_id());
            pre.setString(2, t.getTeam_name());
            pre.setString(3, t.getTopic_code());
            pre.setString(4, t.getTopic_name());
            pre.setString(5, t.getGitlab_url());
            pre.setString(6, t.getApiToken());
            pre.setBoolean(7, t.isStatus());
            pre.setInt(8, t.getTeam_id());
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

}
