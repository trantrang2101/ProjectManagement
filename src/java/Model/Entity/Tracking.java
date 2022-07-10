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
public class Tracking {

    private int tracking_id, milestone_id, function_id, assigner_id, assignee_id;
    private String tracking_note;
    private int status;

    public Tracking() {
    }

    public Tracking(int tracking_id, int milestone_id, int function_id, int assigner_id, int assignee_id, String tracking_note, int status) {
        this.tracking_id = tracking_id;
        this.milestone_id = milestone_id;
        this.function_id = function_id;
        this.assigner_id = assigner_id;
        this.assignee_id = assignee_id;
        this.tracking_note = tracking_note;
        this.status = status;
    }

    public Milestone getMilestone() {
        return DAO.MilestoneDAO.getInstance().getMilestone(milestone_id);
    }

    public Function getFunction() {
        return DAO.FunctionDAO.getInstance().getFunction(function_id);
    }

    public Setting getSetting() {
        return DAO.SettingDAO.getInstance().getSetting(status);
    }
    
    public List<UpdateTracking> getListUpdate(User user){
        return DAO.UpdateTrackingDAO.getInstance().getList(getTeam().getTeam_id(), null, tracking_id, getFeature().getFeature_id(), 0, Integer.MAX_VALUE, user, "tracking_id", true);
    }

    public ClassSetting getStatusSetting() {
        return DAO.ClassSettingDAO.getInstance().getClassSetting(status);
    }

    public User getAsssigner() {
        return DAO.UserDAO.getInstance().getUser(assigner_id, false);
    }

    public Team getTeam() {
        return getFunction().getTeam();
    }

    public Feature getFeature(){
        return getFunction().getFeature();
    }
    
    public Classroom getClassroom() {
        return getTeam().getClassroom();
    }

    public User getAssignee() {
        return DAO.UserDAO.getInstance().getUser(assignee_id, false);
    }

    public int getTracking_id() {
        return tracking_id;
    }

    public void setTracking_id(int tracking_id) {
        this.tracking_id = tracking_id;
    }

    public int getMilestone_id() {
        return milestone_id;
    }

    public void setMilestone_id(int milestone_id) {
        this.milestone_id = milestone_id;
    }

    public int getFunction_id() {
        return function_id;
    }

    public void setFunction_id(int function_id) {
        this.function_id = function_id;
    }

    public int getAssigner_id() {
        return assigner_id;
    }

    public void setAssigner_id(int assigner_id) {
        this.assigner_id = assigner_id;
    }

    public int getAssignee_id() {
        return assignee_id;
    }

    public void setAssignee_id(int assignee_id) {
        this.assignee_id = assignee_id;
    }

    public String getTracking_note() {
        return tracking_note;
    }

    public void setTracking_note(String tracking_note) {
        this.tracking_note = tracking_note;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

}
