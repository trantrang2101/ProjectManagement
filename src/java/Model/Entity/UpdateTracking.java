/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.Entity;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 *
 * @author win
 */
public class UpdateTracking {

    private int update_id, tracking_id;
    private String update_date;
    private int milestone_id;
    private String update_note;

    public UpdateTracking() {
    }

    public UpdateTracking(int update_id, int tracking_id, String update_date, int milestone_id, String update_note) {
        this.update_id = update_id;
        this.tracking_id = tracking_id;
        this.update_date = update_date;
        this.milestone_id = milestone_id;
        this.update_note = update_note;
    }

    public Tracking getTracking() {
        return DAO.TrackingDAO.getInstance().getTracking(tracking_id);
    }

    public Milestone getMilestone() {
        return DAO.MilestoneDAO.getInstance().getMilestone(milestone_id);
    }

    public int getUpdate_id() {
        return update_id;
    }

    public void setUpdate_id(int update_id) {
        this.update_id = update_id;
    }

    public int getTracking_id() {
        return tracking_id;
    }

    public void setTracking_id(int tracking_id) {
        this.tracking_id = tracking_id;
    }

    public Date getDate() throws ParseException {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH).parse(update_date);
    }

    public String getUpdate_date() {
        return update_date;
    }

    public void setUpdate_date(String update_date) {
        this.update_date = update_date;
    }

    public int getMilestone_id() {
        return milestone_id;
    }

    public void setMilestone_id(int milestone_id) {
        this.milestone_id = milestone_id;
    }

    public String getUpdate_note() {
        return update_note;
    }

    public void setUpdate_note(String update_note) {
        this.update_note = update_note;
    }

}
