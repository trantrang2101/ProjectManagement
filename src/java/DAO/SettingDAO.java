/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import Utils.ConnectJDBC;
import Model.Entity.*;
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
public class SettingDAO extends ConnectJDBC {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(SettingDAO.class);

    private static SettingDAO instance;

    public static SettingDAO getInstance() {
        if (SettingDAO.instance == null) {
            SettingDAO.instance = new SettingDAO();
        }
        return SettingDAO.instance;
    }

    public Setting getSetting(String title) {
        Setting set = null;
        String sql = "SELECT * from `studentmanagement`.`setting` where setting_title like '%" + title + "%'";
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int setting_id = rs.getInt(1);
                int type_id = rs.getInt(2);
                String setting_title = rs.getString(3);
                int setting_value = rs.getInt(4);
                int display_order = rs.getInt(5);
                String description = rs.getString(6);
                boolean status = rs.getBoolean(7);
                set = new Setting(setting_id, type_id, setting_title, setting_value, display_order, description, status);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return set;
    }

    public Setting getSetting(int id) {
        Setting set = null;
        String sql = "SELECT * from `studentmanagement`.`setting` where setting_id=" + id;
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int setting_id = rs.getInt(1);
                int type_id = rs.getInt(2);
                String setting_title = rs.getString(3);
                int setting_value = rs.getInt(4);
                int display_order = rs.getInt(5);
                String description = rs.getString(6);
                boolean status = rs.getBoolean(7);
                set = new Setting(setting_id, type_id, setting_title, setting_value, display_order, description, status);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return set;
    }

    public List<Setting> getList(Integer type, Boolean statusFilter, String search, int start, int limit, String sort, boolean statusSort) {
        List<Setting> list = new ArrayList<>();
        String sql = "CALL `studentmanagement`.search('\\'%" + search + "%\\'','studentmanagement','setting','" + (type == null ? "" : " and type_id = " + type) + (statusFilter != null ? " and status=" + statusFilter : "")
                + "'," + start + "," + limit + ",'" + sort + "'," + statusSort + ")";
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                String sql1 = rs.getString(1);
                ResultSet rs1 = getData(sql1);
                while (rs1.next()) {
                    int setting_id = rs1.getInt(1);
                    int type_id = rs1.getInt(2);
                    String setting_title = rs1.getString(3);
                    int setting_value = rs1.getInt(4);
                    int display_order = rs1.getInt(5);
                    String description = rs1.getString(6);
                    boolean status = rs1.getBoolean(7);
                    list.add(new Setting(setting_id, type_id, setting_title, setting_value, display_order, description, status));
                }
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return list;
    }

    public boolean checkAddSetting(int type_id, int value, boolean status) {
        boolean check = false;
        String sql = "SELECT * from `studentmanagement`.`setting` where type_id =" + type_id + " and setting_value =" + value + " and status=" + status;
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

    public int addSetting(Setting s) {
        int check = -1;
        String sql = "INSERT INTO `studentmanagement`.`setting` (`type_id`, `setting_title`, `setting_value`, `display_order`, `status`,`description`) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, s.getType_id());
            pre.setString(2, s.getSetting_title());
            pre.setInt(3, s.getSetting_value());
            pre.setInt(4, s.getDisplay_order());
            pre.setBoolean(5, s.isStatus());
            pre.setString(6, s.getDescription());
            if (pre.executeUpdate() > 0) {
                ResultSet rs = getData("SELECT setting_id from `studentmanagement`.`setting` order by setting_id desc limit 1");
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
        String sql = "UPDATE `studentmanagement`.`setting` \n"
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

    public boolean updateSetting(Setting s) {
        boolean check = false;
        String sql = "UPDATE `studentmanagement`.`setting` \n"
                + "SET type_id=?, setting_title=?,setting_value=?, display_order=?, status=?, `description`=?\n"
                + "where setting_id=?";
        try {
            Connection conn = getConnection();
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, s.getType_id());
            pre.setString(2, s.getSetting_title());
            pre.setInt(3, s.getSetting_value());
            pre.setInt(4, s.getDisplay_order());
            pre.setBoolean(5, s.isStatus());
            pre.setString(6, s.getDescription());
            pre.setInt(7, s.getSetting_id());
            check = pre.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return check;
    }

    public List<Setting> getSettings(int typeId) {
        List<Setting> set = new ArrayList<>();
        String sql = "SELECT * from `studentmanagement`.`setting` where type_id=" + typeId + " order by display_order ASC";
        ResultSet rs = getData(sql);
        try {
            while (rs.next()) {
                int setting_id = rs.getInt(1);
                int type_id = rs.getInt(2);
                String setting_title = rs.getString(3);
                int setting_value = rs.getInt(4);
                int display_order = rs.getInt(5);
                String description = rs.getString(6);
                boolean status = rs.getBoolean(7);
                set.add(new Setting(setting_id, type_id, setting_title, setting_value, display_order, description, status));
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        return set;
    }

}
