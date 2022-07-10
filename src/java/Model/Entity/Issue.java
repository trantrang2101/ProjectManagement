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
public class Issue {
    private int issue_id,assignee_id;
    private String issue_title,description,gitlab_id,gitlab_url,created_at,due_date;
    private int team_id,milestone_id,function_id,status,label;

    public Issue() {
    }

    public Issue(int assignee_id, String issue_title, String description, String gitlab_id, String gitlab_url, String due_date, int team_id, int milestone_id, int function_id, int status) {
        this.assignee_id = assignee_id;
        this.issue_title = issue_title;
        this.description = description;
        this.gitlab_id = gitlab_id;
        this.gitlab_url = gitlab_url;
        this.due_date = due_date;
        this.team_id = team_id;
        this.milestone_id = milestone_id;
        this.function_id = function_id;
        this.status = status;
    }
    
    public Issue(int assignee_id, String issue_title, String description, String gitlab_id, String gitlab_url, String due_date, int team_id, int milestone_id, int function_id, int status, int label) {
        this.assignee_id = assignee_id;
        this.issue_title = issue_title;
        this.description = description;
        this.gitlab_id = gitlab_id;
        this.gitlab_url = gitlab_url;
        this.due_date = due_date;
        this.team_id = team_id;
        this.milestone_id = milestone_id;
        this.function_id = function_id;
        this.status = status;
        this.label = label;
    }
    
    public Issue(int issue_id, int assignee_id, String issue_title, String description, String gitlab_id, String gitlab_url, String created_at, String due_date, int team_id, int milestone_id, int function_id, int status) {
        this.issue_id = issue_id;
        this.assignee_id = assignee_id;
        this.issue_title = issue_title;
        this.description = description;
        this.gitlab_id = gitlab_id;
        this.gitlab_url = gitlab_url;
        this.created_at = created_at;
        this.due_date = due_date;
        this.team_id = team_id;
        this.milestone_id = milestone_id;
        this.function_id = function_id;
        this.status = status;
    }
    
    public Issue(int issue_id, int assignee_id, String issue_title, String description, String gitlab_id, String gitlab_url, String created_at, String due_date, int team_id, int milestone_id, int function_id, int status, int label) {
        this.issue_id = issue_id;
        this.assignee_id = assignee_id;
        this.issue_title = issue_title;
        this.description = description;
        this.gitlab_id = gitlab_id;
        this.gitlab_url = gitlab_url;
        this.created_at = created_at;
        this.due_date = due_date;
        this.team_id = team_id;
        this.milestone_id = milestone_id;
        this.function_id = function_id;
        this.status = status;
        this.label = label;
    }

    public int getIssue_id() {
        return issue_id;
    }

    public void setIssue_id(int issue_id) {
        this.issue_id = issue_id;
    }

    public int getAssignee_id() {
        return assignee_id;
    }

    public void setAssignee_id(int assignee_id) {
        this.assignee_id = assignee_id;
    }
    
    public User getUser() {
        return DAO.UserDAO.getInstance().getUser(assignee_id, false);
    }

    public String getIssue_title() {
        return issue_title;
    }

    public void setIssue_title(String issue_title) {
        this.issue_title = issue_title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getGitlab_id() {
        return gitlab_id;
    }

    public void setGitlab_id(String gitlab_id) {
        this.gitlab_id = gitlab_id;
    }

    public String getGitlab_url() {
        return gitlab_url;
    }

    public void setGitlab_url(String gitlab_url) {
        this.gitlab_url = gitlab_url;
    }

    public String getCreated_at() {
        return created_at;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    public String getDue_date() {
        return due_date;
    }

    public void setDue_date(String due_date) {
        this.due_date = due_date;
    }

    public int getTeam_id() {
        return team_id;
    }

    public void setTeam_id(int team_id) {
        this.team_id = team_id;
    }
    
    public Team getTeam() {
        return DAO.TeamDAO.getInstance().getTeam(team_id);
    }

    public int getMilestone_id() {
        return milestone_id;
    }

    public void setMilestone_id(int milestone_id) {
        this.milestone_id = milestone_id;
    }
    
    public Milestone getMilestone() {
        return DAO.MilestoneDAO.getInstance().getMilestone(milestone_id);
    }

    public int getFunction_id() {
        return function_id;
    }

    public void setFunction_id(int function_id) {
        this.function_id = function_id;
    }
    
    public Function getFunction() {
        return DAO.FunctionDAO.getInstance().getFunction(function_id);
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
    
    public ClassSetting getIssueStatus() {
        return DAO.ClassSettingDAO.getInstance().getClassSetting(status);
    }

    public int getLabel() {
        return label;
    }

    public void setLabel(int label) {
        this.label = label;
    }
    
    
}
