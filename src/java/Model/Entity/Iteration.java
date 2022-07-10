
package Model.Entity;

import java.util.List;

/**
 *
 * @author Admin
 */
public class Iteration {
    private int iteration_id, subject_id;
    private String iteration_name;
    private int duration;
    private boolean status;
    private String description;



    public Iteration() {
    }
    

    public Iteration(int iteration_id, int subject_id, String iteration_name, int duration, String description, boolean status) {
        this.iteration_id = iteration_id;
        this.subject_id = subject_id;
        this.iteration_name = iteration_name;
        this.duration = duration;
        this.status = status;
        this.description=description;
    }

    public int getIteration_id() {
        return iteration_id;
    }

    public void setIteration_id(int iteration_id) {
        this.iteration_id = iteration_id;
    }
    
    public List<Criteria> getCriteria(User login){
        return DAO.CriteriaDAO.getInstance().getList(subject_id, "", login, 0, Integer.MAX_VALUE, "criteria_id", true, 1,1);
    }
    
    public Subject getSubject() {
        return DAO.SubjectDAO.getInstance().getSubject(subject_id);
    }

    public int getSubject_id() {
        return getSubject().getSubject_id();
    }
    
    public String getIteration_name() {
        return iteration_name;
    }

    public void setIteration_name(String iteration_name) {
        this.iteration_name = iteration_name;
    }
        public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
    public double getIterationTotalWeight(){
        return DAO.CriteriaDAO.getInstance().getCriteriaTotalWeight(iteration_id);
    }
}
