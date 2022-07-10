/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.Entity;

/**
 *
 * @author nashd
 */
public class Team {

    private int team_id, class_id;
    private String team_name,topic_code,topic_name,gitlab_url;
    private boolean status;
    private String apiToken;

    public Team() {
    }

    public Team(int class_id, String team_name, String topic_code, String topic_name, String gitlab_url, boolean status, String apiToken) {
        this.class_id = class_id;
        this.team_name = team_name;
        this.topic_code = topic_code;
        this.topic_name = topic_name;
        this.gitlab_url = gitlab_url;
        this.status = status;
        this.apiToken = apiToken;
    }

    public Team(int team_id, int class_id, String team_name, String topic_code, String topic_name, String gitlab_url, boolean status, String apiToken) {
        this.team_id = team_id;
        this.class_id = class_id;
        this.team_name = team_name;
        this.topic_code = topic_code;
        this.topic_name = topic_name;
        this.gitlab_url = gitlab_url;
        this.status = status;
        this.apiToken = apiToken;
    }

    public int getClass_id() {
        return class_id;
    }

    public void setClass_id(int class_id) {
        this.class_id = class_id;
    }
    
    public int getTeam_id() {
        return team_id;
    }

    public void setTeam_id(int team_id) {
        this.team_id = team_id;
    }

    public Classroom getClassroom() {
        return DAO.ClassDAO.getInstance().getClass(null, class_id);
    }

    public String getTeam_name() {
        return team_name;
    }

    public void setTeam_name(String team_name) {
        this.team_name = team_name;
    }

    public String getTopic_code() {
        return topic_code;
    }

    public void setTopic_code(String topic_code) {
        this.topic_code = topic_code;
    }

    public String getTopic_name() {
        return topic_name;
    }

    public void setTopic_name(String topic_name) {
        this.topic_name = topic_name;
    }

    public String getGitlab_url() {
        return gitlab_url;
    }

    public void setGitlab_url(String gitlab_url) {
        this.gitlab_url = gitlab_url;
    }

    public String getApiToken() {
        return apiToken;
    }

    public void setApiToken(String apiToken) {
        this.apiToken = apiToken;
    }
    
    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
    public ClassUser getLeader(){
        return DAO.ClassUserDAO.getInstance().getLeader(team_id);
    }
    
}
