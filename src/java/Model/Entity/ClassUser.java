/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.Entity;

import java.text.ParseException;
import java.text.SimpleDateFormat;

/**
 *
 * @author win
 */
public class ClassUser {
    private int class_id,team_id,user_id;
    private boolean team_leader;
    private String dropout_date,user_notes;
    private double ongoing_eval,final_pres_eval,final_topic_eval;
    private boolean status;

    public ClassUser(int class_id, int team_id, int user_id, boolean team_leader, String dropout_date, String user_notes, double ongoing_eval, double final_pres_eval, double final_topic_eval, boolean status) {
        this.class_id = class_id;
        this.team_id = team_id;
        this.user_id = user_id;
        this.team_leader = team_leader;
        this.dropout_date = dropout_date;
        this.user_notes = user_notes;
        this.ongoing_eval = ongoing_eval;
        this.final_pres_eval = final_pres_eval;
        this.final_topic_eval = final_topic_eval;
        this.status = status;
    }

    public ClassUser(int class_id, int team_id, int user_id, boolean team_leader, String dropout_date, String user_notes, boolean status) {
        this.class_id = class_id;
        this.team_id = team_id;
        this.user_id = user_id;
        this.team_leader = team_leader;
        this.dropout_date = dropout_date;
        this.user_notes = user_notes;
        this.status = status;
    }
    public String getDropoutFormat() throws ParseException{
        return dropout_date==null?null:new SimpleDateFormat("MMM dd, yyy").format(new SimpleDateFormat("yyyy-MM-dd").parse(dropout_date.split(" ")[0]));
    }
    public int getClass_id() {
        return class_id;
    }
    
    public Classroom getClassroom(){
        return DAO.ClassDAO.getInstance().getClass(null,class_id);
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
    
    public User getUser(){
        return DAO.UserDAO.getInstance().getUser(user_id, false);
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public boolean isTeam_leader() {
        return team_leader;
    }

    public void setTeam_leader(boolean team_leader) {
        this.team_leader = team_leader;
    }

    public String getDropout_date() {
        return dropout_date;
    }

    public void setDropout_date(String dropout_date) {
        this.dropout_date = dropout_date;
    }

    public String getUser_notes() {
        return user_notes;
    }

    public void setUser_notes(String user_notes) {
        this.user_notes = user_notes;
    }

    public double getOngoing_eval() {
        return ongoing_eval;
    }

    public void setOngoing_eval(double ongoing_eval) {
        this.ongoing_eval = ongoing_eval;
    }
    
    public Team getTeam(){
        return DAO.TeamDAO.getInstance().getTeam(team_id);
    }

    public double getFinal_pres_eval() {
        return final_pres_eval;
    }

    public void setFinal_pres_eval(double final_pres_eval) {
        this.final_pres_eval = final_pres_eval;
    }

    public double getFinal_topic_eval() {
        return final_topic_eval;
    }

    public void setFinal_topic_eval(int final_topic_eval) {
        this.final_topic_eval = final_topic_eval;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
}
