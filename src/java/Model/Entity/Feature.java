/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.Entity;

/**
 *
 * @author Admin
 */
public class Feature {
    private int feature_id;
    private int team_id;
    private String feature_name, description;
    
    

    public Feature(int feature_id, int team_id, String feature_name, String description, boolean status) {
        this.feature_id = feature_id;
        this.team_id = team_id;
        this.feature_name = feature_name;
        this.description = description;
        this.status = status;
    }
    private boolean status;
    

    public Feature() {
    }

    public String getDescription() {
        return description;
    }
    
    public Team getTeam(){
        return DAO.TeamDAO.getInstance().getTeam(team_id);
    }
    
  

    public void setDescription(String description) {
        this.description = description;
    }

   

    public int getFeature_id() {
        return feature_id;
    }

    public void setFeature_id(int feature_id) {
        this.feature_id = feature_id;
    }

    public int getTeam_id() {
        return team_id;
    }

    public void setTeam_id(int team_id) {
        this.team_id = team_id;
    }

    public String getFeature_name() {
        return feature_name;
    }

    public void setFeature_name(String feature_name) {
        this.feature_name = feature_name;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
    
}
