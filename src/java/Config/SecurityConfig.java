/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Config;

/**
 *
 * @author ADMIN
 */
import Model.Entity.Setting;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class SecurityConfig {

//    public static final String ROLE_ADMIN = "1";
//    public static final String ROLE_AUTHOR = "2";
//    public static final String ROLE_TEACHER = "3";
//    public static final String ROLE_STUDENT = "4";
    // String: Role
    // List<String>: urlPatterns.
    private static final Map<String, List<String>> mapConfig = new HashMap<String, List<String>>();

    static {
        init();
    }
    
    private static void init() {
        List<Setting> list = DAO.SettingDAO.getInstance().getList(1, true, "", 0, Integer.MAX_VALUE, "setting_id", true);
        for (Setting setting : list) {
            if (setting.getType_id() == 1) {
                   mapConfig.put(String.valueOf(setting.getSetting_value()), setting.getAccess());
            }
         
        }
    }

    public static Set<String> getAllAppRoles() {
        return mapConfig.keySet();
    }
               
    public static List<String> getUrlPatternsForRole(String role) {
        return mapConfig.get(role);
    }

}
