/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.Entity;

import java.util.Arrays;
import java.util.List;

/**
 *
 * @author nashd
 */
public class Setting {

    private int setting_id,type_id;
    private String setting_title;
    private int setting_value, display_order;
    private String description;
    private boolean status;

    public Setting() {
    }

    public Setting(int setting_id, int type_id, String setting_title, int setting_value, int display_order, String description, boolean status) {
        this.setting_id = setting_id;
        this.type_id = type_id;
        this.setting_title = setting_title;
        this.setting_value = setting_value;
        this.display_order = display_order;
        this.description = description;
        this.status = status;
    }

    public int getSetting_id() {
        return setting_id;
    }

    public List<String> getAccess(){
        String[] split = description.split(",");
        return Arrays.asList(split);
    }
    
    public void setSetting_id(int setting_id) {
        this.setting_id = setting_id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getType_id() {
        return type_id;
    }

    public void setType_id(int type_id) {
        this.type_id = type_id;
    }

    public String getSetting_title() {
        return setting_title;
    }

    public void setSetting_title(String setting_title) {
        this.setting_title = setting_title;
    }

    public int getSetting_value() {
        return setting_value;
    }

    public void setSetting_value(int setting_value) {
        this.setting_value = setting_value;
    }

    public int getDisplay_order() {
        return display_order;
    }

    public void setDisplay_order(int display_order) {
        this.display_order = display_order;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

}
