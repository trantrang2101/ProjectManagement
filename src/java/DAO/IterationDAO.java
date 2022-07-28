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
public class IterationDAO extends ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(IterationDAO.class);

    private static IterationDAO instance;

    public static IterationDAO getInstance() {
        if (IterationDAO.instance == null) {
            IterationDAO.instance = new IterationDAO();
        }
        return IterationDAO.instance;
    }

    public Iteration getIteration(int id) {
        Iteration iter = null;
        String sql = "SELECT * from `iteration` where iteration_id=" + id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int iteration_id = rs.getInt(1);
                int subject_id = rs.getInt(2);
                String iteration_name = rs.getString(3);
                int duration = rs.getInt(4);
                String description = rs.getString(5);
                boolean status = rs.getBoolean(6);
                iter = new Iteration(iteration_id, subject_id, iteration_name, duration, description, status);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return iter;
    }

    public List<Iteration> getList() {
        List<Iteration> list = new ArrayList<>();
        String sql = "select * from Iteration";
        ResultSet rs1 = getData(sql);
        try {

            while (rs1.next()) {
                try {
                    int iteration_id = rs1.getInt(1);
                    int subject_id1 = rs1.getInt(2);
                    String iteration_name = rs1.getString(3);
                    int duration = rs1.getInt(4);
                    String description = rs1.getString(5);
                    boolean status = rs1.getBoolean(6);
                    Iteration iter = new Iteration(iteration_id, subject_id1, iteration_name, duration, description, status);
                    list.add(iter);
                } catch (Exception e) {
                }
            }

        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public List<Iteration> getList(Integer subject_id, User login, String search, int start, int limit, String sort, boolean statusSort, Boolean statusFilter) {
        List<Iteration> list = new ArrayList<>();
        String sql = "CALL search('\\'%" + search + "%\\'','iteration','"
                + (login == null || login.getRole_id() == 1 ? "" : " and status=1 ".concat(login.getRole_id() == 2 ? " and subject_id in (select subject_id from `subject` where author_id=" + login.getUser_id() + ")" : " and subject_id in (select subject_id from `class` where trainer_id=" + login.getUser_id() + ")"))
                + (subject_id == null || subject_id == 0 ? "" : " and subject_id = " + subject_id)
                + (statusFilter == null ? "" : " and status = " + statusFilter)
                + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                String sql1 = rs.getString(1);
                ResultSet rs1 = getData(sql1);
                while (rs1.next()) {
                    try {
                        int iteration_id = rs1.getInt(1);
                        int subject_id1 = rs1.getInt(2);
                        String iteration_name = rs1.getString(3);
                        int duration = rs1.getInt(4);
                        String description = rs1.getString(5);
                        boolean status = rs1.getBoolean(6);
                        Iteration iter = new Iteration(iteration_id, subject_id1, iteration_name, duration, description, status);
                        list.add(iter);
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

    public int addIteration(Iteration iter) {
        int id = -1;
        String sql = "INSERT INTO `iteration` (`iteration_id`, `subject_id`, `iteration_name`, `duration`,`description`, `status`) VALUES (?, ?, ?, ?,?, ?);";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, iter.getIteration_id());
            pre.setInt(2, iter.getSubject_id());
            pre.setString(3, iter.getIteration_name());
            pre.setInt(4, iter.getDuration());
            pre.setString(5, iter.getDescription());
            pre.setBoolean(6, iter.isStatus());

            if (pre.executeUpdate() > 0) {
                ResultSet rs = getData("SELECT iteration_id from `iteration` order by iteration_id desc limit 1");
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

    public boolean checkAddIter(String subjectID, String iterationName) {
        boolean check = false;
        String sql = "SELECT * FROM iteration where subject_id = '" + subjectID + "'and iteration_name='" + iterationName + "'";

        try {
            ResultSet rs = getData(sql);
            if (rs.next()) {
                check = true;
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateStatus(int iterId, boolean status) {
        boolean check = false;
        String sql = "UPDATE `iteration` \n"
                + "SET status=?\n"
                + "where iteration_id=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setBoolean(1, status);
            pre.setInt(2, iterId);
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateIteration(Iteration s) {
        boolean check = false;
        String sql = "UPDATE `iteration` \n"
                + "            SET `subject_id`=?,`iteration_name`=?, `duration`=?,`description`=?, `status`=?\n"
                + "             where `iteration_id`=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, s.getSubject_id());
            pre.setString(2, s.getIteration_name());
            pre.setInt(3, s.getDuration());
            pre.setString(4, s.getDescription());
            pre.setBoolean(5, s.isStatus());
            pre.setInt(6, s.getIteration_id());
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

}
