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
public class ClassSettingDAO extends ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(ClassSettingDAO.class);

    private static ClassSettingDAO instance;

    public static ClassSettingDAO getInstance() {
        if (ClassSettingDAO.instance == null) {
            ClassSettingDAO.instance = new ClassSettingDAO();
        }
        return ClassSettingDAO.instance;
    }

    public ClassSetting getClassSetting(int id) {
        ClassSetting set = null;
        String sql = "SELECT * from `class_setting` where setting_id=" + id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int setting_id = rs.getInt(1);
                int class_id = rs.getInt(2);
                int type_id = rs.getInt(3);
                String setting_title = rs.getString(4);
                int setting_value = rs.getInt(5);
                int display_order = rs.getInt(6);
                String description = rs.getString(7);
                boolean status = rs.getBoolean(8);
                set = new ClassSetting(setting_id, class_id, type_id, setting_title, setting_value, display_order, description, status);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return set;
    }

    public List<ClassSetting> getListStatus(int classId, int typeId) {
        List<ClassSetting> list = new ArrayList<>();
        String sql = "SELECT * from `class_setting` where class_id=" + classId + " and type_id=" + typeId;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int setting_id = rs.getInt(1);
                int class_id = rs.getInt(2);
                int type_id = rs.getInt(3);
                String setting_title = rs.getString(4);
                int setting_value = rs.getInt(5);
                int display_order = rs.getInt(6);
                String description = rs.getString(7);
                boolean status = rs.getBoolean(8);
                list.add(new ClassSetting(setting_id, class_id, type_id, setting_title, setting_value, display_order, description, status));
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public ClassSetting getClassSetting(int classId, int typeId, Integer settingValue) {
        ClassSetting set = null;
        String sql = "SELECT * from `class_setting` where class_id=" + classId + " and type_id=" + typeId + (settingValue == null ? "" : " and setting_value=" + settingValue);
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int setting_id = rs.getInt(1);
                int class_id = rs.getInt(2);
                int type_id = rs.getInt(3);
                String setting_title = rs.getString(4);
                int setting_value = rs.getInt(5);
                int display_order = rs.getInt(6);
                String description = rs.getString(7);
                boolean status = rs.getBoolean(8);
                set = new ClassSetting(setting_id, class_id, type_id, setting_title, setting_value, display_order, description, status);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return set;
    }

    public List<ClassSetting> getList(Integer type, Integer classId, String search, User login, int start, int limit, String sort, boolean statusSort, Integer statusFilter) {
        List<ClassSetting> list = new ArrayList<>();
        String sql = "CALL search('\\'%" + search + "%\\'','class_setting','"
                + "" + (statusFilter == null ? "" : " and status= " + statusFilter)
                + (type == null || type == 0 ? "" : " and type_id=" + type)
                + (classId == 0 ? "" : " and class_id = " + classId) + (login.getRole_id() == 2 ? " and class_id in (select class_id from class where author_id=" + login.getUser_id() + ")" : "") + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
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
                    list.add(new ClassSetting(setting_id, sub, set, setting_title, setting_value, display_order, description, status));
                }
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public int checkAddClassSetting(int type_id, int class_id, int value, boolean status) {
        int check = -1;
        String sql = "SELECT * from `class_setting` where class_id=" + class_id + " type_id =" + type_id + " and setting_value =" + value + " and status=" + status;
        ResultSet rs = getData(sql);
        try {
            if (rs.next()) {
                check = rs.getInt(3);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public int addClassSetting(ClassSetting s) {
        int check = -1;
        String sql = "INSERT INTO `class_setting` (`class_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) VALUES (?, ?, ?, ?, ?, ?, ?);";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, s.getClass_id());
            pre.setInt(2, s.getType().getSetting_id());
            pre.setString(3, s.getSetting_title());
            pre.setInt(4, s.getSetting_value());
            pre.setInt(5, s.getDisplay_order());
            pre.setString(6, s.getDescription());
            pre.setBoolean(7, s.isStatus());
            if (pre.executeUpdate() > 0) {
                ResultSet rs = getData("SELECT setting_id from `class_setting` order by setting_id desc limit 1");
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
        String sql = "UPDATE `class_setting` \n"
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

    public boolean updateClassSetting(ClassSetting s) {
        boolean check = false;
        String sql = "UPDATE `class_setting` \n"
                + "SET type_id=?, setting_title=?,setting_value=?, display_order=?, description=?, status=?,class_id=?\n"
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
            pre.setInt(7, s.getClass_id());
            pre.setInt(8, s.getSetting_id());
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

}
