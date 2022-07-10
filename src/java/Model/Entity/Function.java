package Model.Entity;

import java.util.ArrayList;
import java.util.List;

public class Function {

    private int function_id, team_id, feature_id, complexity_id, owner_id, priority, status;
    private String function_name, description, access_roles;

    public Function() {
    }

//    public List<Integer> getAccess_roles() {
//        List<Integer> roles = new ArrayList<>();
//        String[] r = access_roles.replaceAll("\\s", "").split(",");
//        for (String string : r) {
//            roles.add(Integer.parseInt(string));
//        }
//        return roles;
//    }

//    public void setAccess_roles(List<Integer> access_roles) {
//        StringBuilder s = null;
//        for (int i = 0; i < access_roles.size(); i++) {
//            if (i == access_roles.size() - 1) {
//                s.append(access_roles.get(i));
//            } else {
//                s.append(access_roles.get(i) + ", ");
//            }
//
//        }
//        this.access_roles=s.toString();
//    }

    public String getAccess_roles() {
        return access_roles;
    }

    public void setAccess_roles(String access_roles) {
        this.access_roles = access_roles;
    }

    
    public Function(int function_id, int team_id, int feature_id, int complexity_id, int owner_id, int priority, String function_name, String description, String access_roles, int status) {
        this.function_id = function_id;
        this.team_id = team_id;
        this.feature_id = feature_id;
        this.complexity_id = complexity_id;
        this.owner_id = owner_id;
        this.priority = priority;
        this.function_name = function_name;
        this.description = description;
        this.access_roles = access_roles;
        this.status = status;
    }

    public int isStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public SubjectSetting getComplexity(){
        return DAO.SubjectSettingDAO.getInstance().getSubjectSetting(complexity_id);
    }

    public User getOwner(){
        return DAO.UserDAO.getInstance().getUser(owner_id, true);
    }

    public Team getTeam() {
        return DAO.TeamDAO.getInstance().getTeam(team_id);
    }

     public ClassSetting getFunctionStatus() {
        return DAO.ClassSettingDAO.getInstance().getClassSetting(getTeam().getClass_id(), 10, status);
    }

    public Feature getFeature() {
        return DAO.FeatureDAO.getInstance().getFeature(feature_id);
    }

    public int getFunction_id() {
        return function_id;
    }

    public void setFunction_id(int function_id) {
        this.function_id = function_id;
    }

    public int getTeam_id() {
        return team_id;
    }

    public void setTeam_id(int team_id) {
        this.team_id = team_id;
    }

    public int getFeature_id() {
        return feature_id;
    }

    public void setFeature_id(int feature_id) {
        this.feature_id = feature_id;
    }

    public int getComplexity_id() {
        return complexity_id;
    }

    public void setComplexity_id(int complexity_id) {
        this.complexity_id = complexity_id;
    }

    public int getOwner_id() {
        return owner_id;
    }

    public void setOwner_id(int owner_id) {
        this.owner_id = owner_id;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public String getFunction_name() {
        return function_name;
    }

    public void setFunction_name(String function_name) {
        this.function_name = function_name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
