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
public class Milestone {

    private int milestone_id;
    private String milestone_name;
    private Integer iteration_id;
    private int class_id;
    private String from_date, to_date;
    private int status;

    public Milestone() {
    }

    public Milestone(String milestone_name, int class_id, Date from_date, Date to_date, int status) throws ParseException {
        this.milestone_name = milestone_name;
        this.class_id = class_id;
        this.from_date = new SimpleDateFormat("yyyy-MM-dd").format(from_date);
        this.to_date = new SimpleDateFormat("yyyy-MM-dd").format(to_date);
        this.status = status;
        this.iteration_id = null;
    }

    public Milestone(int milestone_id, String milestone_name, int iteration_id, int class_id, String from_date, String to_date, int status) {
        this.milestone_id = milestone_id;
        this.milestone_name = milestone_name;
        this.iteration_id = iteration_id;
        this.class_id = class_id;
        this.from_date = from_date;
        this.to_date = to_date;
        this.status = status;
    }

    public String getStatusValue() {
        switch (status) {
            case 1:
                return "Opened";
            case 0:
                return "Cancelled";
            default:
                return "Closed";
        }
    }

    public Iteration getIteration() {
        return DAO.IterationDAO.getInstance().getIteration(iteration_id);
    }

    public Classroom getClassroom() {
        return DAO.ClassDAO.getInstance().getClass(null, class_id);
    }

    public int getMilestone_id() {
        return milestone_id;
    }

    public Date getDate(String input) throws ParseException {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH).parse(input);
    }
    
    public boolean after() throws ParseException{
        if (from_date==null) {
            return false;
        }
        if (to_date==null) {
            return true;
        }
        return new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH).parse(to_date).after(new Date());
    }

    public void setMilestone_id(int milestone_id) {
        this.milestone_id = milestone_id;
    }

    public String getMilestone_name() {
        return milestone_name;
    }

    public void setMilestone_name(String milestone_name) {
        this.milestone_name = milestone_name;
    }

    public Integer getIteration_id() {
        return iteration_id;
    }

    public void setIteration_id(int iteration_id) {
        this.iteration_id = iteration_id;
    }

    public int getClass_id() {
        return class_id;
    }

    public void setClass_id(int class_id) {
        this.class_id = class_id;
    }

    public String getFrom_date() {
        return from_date;
    }

    public String getFrom_format() throws ParseException {
        return from_date == null ? null : new SimpleDateFormat("MMM dd, yyy", Locale.ENGLISH).format(new SimpleDateFormat("yyyy-MM-dd").parse(from_date.split(" ")[0]));
    }

    public void setFrom_date(String from_date) {
        this.from_date = from_date;
    }

    public String getTo_format() throws ParseException {
        return to_date == null ? null : new SimpleDateFormat("MMM dd, yyy", Locale.ENGLISH).format(new SimpleDateFormat("yyyy-MM-dd").parse(to_date.split(" ")[0]));
    }

    public String getTo_date() {
        return to_date;
    }

    public void setTo_date(String to_date) {
        this.to_date = to_date;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

}
