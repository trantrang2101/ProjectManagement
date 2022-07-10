/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.Entity;

/**
 *
 * @author ADMIN
 */
public class Criteria {
    private int criteria_id;
    private  int iteration_id;
     private String criteria_title;
     private String criteria_description;
    private double evaluation_weight;
     private boolean team_evaluation;
    private  int criteria_order;
    private int max_loc;
    private boolean status;

    public Criteria() {
    }


    public Criteria(int iteration_id, String criteria_title, String criteria_description, double evaluation_weight,boolean team_evaluation, int criteria_order, int max_loc, boolean status) {
        this.iteration_id = iteration_id;
        this.criteria_title = criteria_title;
        this.criteria_description = criteria_description;
        this.evaluation_weight = evaluation_weight;
        this.team_evaluation = team_evaluation;
        this.criteria_order = criteria_order;
        this.max_loc = max_loc;
        this.status = status;
    }

    public Criteria(int criteria_id, int iteration_id, String criteria_title, String criteria_description, double evaluation_weight, boolean team_evaluation, int criteria_order, int max_loc, boolean status) {
        this.criteria_id = criteria_id;
        this.iteration_id = iteration_id;
        this.criteria_title = criteria_title;
        this.criteria_description = criteria_description;
        this.evaluation_weight = evaluation_weight;
         this.team_evaluation = team_evaluation;
        this.criteria_order = criteria_order;
        this.max_loc = max_loc;
        this.status = status;
    }

    public boolean isTeam_evaluation() {
        return team_evaluation;
    }

    public void setTeam_evaluation(boolean team_evaluation) {
        this.team_evaluation = team_evaluation;
    }

    public Iteration getIteration(){
        return DAO.IterationDAO.getInstance().getIteration(iteration_id);
    }

    
    public String getCriteria_title() {
        return criteria_title;
    }

    public void setCriteria_title(String criteria_title) {
        this.criteria_title = criteria_title;
    }

    public String getCriteria_description() {
        return criteria_description;
    }

    public void setCriteria_description(String criteria_description) {
        this.criteria_description = criteria_description;
    }

    public int getCriteria_id() {
        return criteria_id;
    }

    public void setCriteria_id(int criteria_id) {
        this.criteria_id = criteria_id;
    }

    public int getIteration_id() {
        return iteration_id;
    }

    public void setIteration_id(int iteration_id) {
        this.iteration_id = iteration_id;
    }

    public double getEvaluation_weight() {
        return evaluation_weight;
    }

    public void setEvaluation_weight(double evaluation_weight) {
        this.evaluation_weight = evaluation_weight;
    }

    public int getCriteria_order() {
        return criteria_order;
    }

    public void setCriteria_order(int criteria_order) {
        this.criteria_order = criteria_order;
    }

    public int getMax_loc() {
        return max_loc;
    }

    public void setMax_loc(int max_loc) {
        this.max_loc = max_loc;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
    
}
