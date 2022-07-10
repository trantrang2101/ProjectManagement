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
public class SubjectSettingDAO extends ConnectJDBC {
    
    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(SubjectSettingDAO.class);

    private static SubjectSettingDAO instance;

    public static SubjectSettingDAO getInstance() {
        if (SubjectSettingDAO.instance == null) {
            SubjectSettingDAO.instance = new SubjectSettingDAO();
        }
        return SubjectSettingDAO.instance;
    }

    public SubjectSetting getSubjectSetting(int id) {
        SubjectSetting set = null;
        String sql = "SELECT * from `studentmanagement`.`subject_setting` where setting_id=" + id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int setting_id = rs.getInt(1);
                int subject = rs.getInt(2);
                int type_id = rs.getInt(3);
                String setting_title = rs.getString(4);
                int setting_value = rs.getInt(5);
                int display_order = rs.getInt(6);
                String description = rs.getString(7);
                boolean status = rs.getBoolean(8);
                set = new SubjectSetting(setting_id, subject, type_id, setting_title, setting_value, display_order, description, status);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return set;
    }
    
     public List<SubjectSetting> getSubjectSettingTypeList(int typeID, int subjectID) {
        List<SubjectSetting> list = new ArrayList<>();
       
        String sql = "SELECT * from `studentmanagement`.`subject_setting` where type_id=" + typeID+" and subject_id="+subjectID;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int setting_id = rs.getInt(1);
                int subject = rs.getInt(2);
                int type_id = rs.getInt(3);
                String setting_title = rs.getString(4);
                int setting_value = rs.getInt(5);
                int display_order = rs.getInt(6);
                String description = rs.getString(7);
                boolean status = rs.getBoolean(8);
                list.add(new SubjectSetting(setting_id, subject, type_id, setting_title, setting_value, display_order, description, status));
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public List<SubjectSetting> getList(Integer type, String search, User login, int start, int limit, String sort, boolean statusSort, Integer statusFilter) {
        List<SubjectSetting> list = new ArrayList<>();
        String sql = "CALL `studentmanagement`.search('\\'%" + search + "%\\'','studentmanagement','subject_setting','"
                + "" + (statusFilter == null ? "" : " and status= " + statusFilter)
                + (type == 0 ? "" : " and subject_id = " + type) + (login.getRole_id() == 2 ? " and subject_id in (select subject_id from subject where author_id=" + login.getUser_id() + ")" : "") + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                String sql1 = rs.getString(1);
                ResultSet rs1 = getData(sql1);
                while (rs1.next()) {
                    int setting_id = rs1.getInt(1);
                    int sub = rs1.getInt(2);
                    int set = rs1.getInt(3);
                    String setting_title = rs1.getString(4);
                    int setting_value = rs1.getInt(5);
                    int display_order = rs1.getInt(6);
                    String description = rs1.getString(7);
                    boolean status = rs1.getBoolean(8);
                    list.add(new SubjectSetting(setting_id, sub, set, setting_title, setting_value, display_order, description, status));
                }
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public boolean checkAddSubjectSetting(int type_id, int subject_id, int value, boolean status) {
        boolean check = false;
        String sql = "SELECT * from `studentmanagement`.`subject_setting` where subject_id=" + subject_id + " type_id =" + type_id + " and setting_value =" + value + " and status=" + status;
        ResultSet rs = getData(sql);
        try {
            if (rs.next()) {
                check = true;
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public int addSubjectSetting(SubjectSetting s) {
        int check = -1;
        String sql = "INSERT INTO `studentmanagement`.`subject_setting` (`subject_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) VALUES (?, ?, ?, ?, ?, ?, ?);";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, s.getSubject().getSubject_id());
            pre.setInt(2, s.getType().getSetting_id());
            pre.setString(3, s.getSetting_title());
            pre.setInt(4, s.getSetting_value());
            pre.setInt(5, s.getDisplay_order());
            pre.setString(6, s.getDescription());
            pre.setBoolean(7, s.isStatus());
            if (pre.executeUpdate() > 0) {
                ResultSet rs = getData("SELECT setting_id from `studentmanagement`.`subject_setting` order by setting_id desc limit 1");
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

    public boolean updateStatus(int setId, boolean status) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`subject_setting` \n"
                + "SET status=?\n"
                + "where setting_id=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setBoolean(1, status);
            pre.setInt(2, setId);
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public boolean updateSubjectSetting(SubjectSetting s) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`subject_setting` \n"
                + "SET type_id=?, setting_title=?,setting_value=?, display_order=?, description=?, status=?,subject_id=?\n"
                + "where setting_id=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, s.getType().getSetting_id());
            pre.setString(2, s.getSetting_title());
            pre.setInt(3, s.getSetting_value());
            pre.setInt(4, s.getDisplay_order());
            pre.setString(5, s.getDescription());
            pre.setBoolean(6, s.isStatus());
            pre.setInt(7, s.getSubject().getSubject_id());
            pre.setInt(8, s.getSetting_id());
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

}
