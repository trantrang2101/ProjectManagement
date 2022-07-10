/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.Entity;

import java.util.List;

/**
 *
 * @author win
 */
public class Classroom {

    private int class_id;
    private String class_code;
    private int trainer_id;
    private int subject_id;
    private int class_year, class_term;
    private boolean block5_class, status;
    private String description,gitlab_url,apiToken;
    public Classroom() {
    }

    public Classroom(int class_id, String class_code, int trainer_id, int subject_id, int class_year, int class_term, boolean block5_class, boolean status, String description, String gitlab_url, String apiToken) {
        this.class_id = class_id;
        this.class_code = class_code;
        this.trainer_id = trainer_id;
        this.subject_id = subject_id;
        this.class_year = class_year;
        this.class_term = class_term;
        this.block5_class = block5_class;
        this.status = status;
        this.description = description;
        this.gitlab_url = gitlab_url;
        this.apiToken = apiToken;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Milestone> getMilestones(int iteration, User user) {
        return DAO.MilestoneDAO.getInstance().getList(class_id, iteration, null, user, "", 0, Integer.MAX_VALUE, "from_date", true);
    }

    public int getTrainer_id() {
        return trainer_id;
    }

    public void setTrainer_id(int trainer_id) {
        this.trainer_id = trainer_id;
    }

    public int getSubject_id() {
        return subject_id;
    }

    public Setting getSetting() {
        return DAO.SettingDAO.getInstance().getSetting(class_term);
    }

    public void setSubject_id(int subject_id) {
        this.subject_id = subject_id;
    }

    public int getClass_id() {
        return class_id;
    }

    public void setClass_id(int class_id) {
        this.class_id = class_id;
    }

    public String getClass_code() {
        return class_code;
    }

    public void setClass_code(String class_code) {
        this.class_code = class_code;
    }

    public User getTrainer() {
        return DAO.UserDAO.getInstance().getUser(trainer_id, false);
    }

    public Subject getSubject() {
        return DAO.SubjectDAO.getInstance().getSubject(subject_id);
    }

    public int getClass_year() {
        return class_year;
    }

    public void setClass_year(int class_year) {
        this.class_year = class_year;
    }

    public int getClass_term() {
        return class_term;
    }

    public void setClass_term(int class_term) {
        this.class_term = class_term;
    }

    public boolean isBlock5_class() {
        return block5_class;
    }

    public void setBlock5_class(boolean block5_class) {
        this.block5_class = block5_class;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getClass_user() {
        return DAO.ClassUserDAO.getInstance().getClassNumber(class_id);
    }

    public List<Team> getListTeam(User login) {
        return DAO.TeamDAO.getInstance().getList(class_id, login, "", 0, Integer.MAX_VALUE, "team_id", true, 1);
    }
}
