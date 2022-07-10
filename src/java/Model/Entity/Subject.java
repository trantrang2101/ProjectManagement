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
public class Subject {
    private int subject_id;
    private String subject_code;
    private String subject_name;
    private String author;
    private int author_id;
    private String description;
    private boolean status;

    public Subject(int subject_id, String subject_code, String subject_name, String author, int author_id, String description, boolean status) {
        this.subject_id = subject_id;
        this.subject_code = subject_code;
        this.subject_name = subject_name;
        this.author = author;
        this.author_id = author_id;
        this.description = description;
        this.status = status;
    }
    
    

    public Subject(int subject_id, String subject_code, String subject_name, int author_id, boolean status) {
        this.subject_id = subject_id;
        this.subject_code = subject_code;
        this.subject_name = subject_name;
        this.author = DAO.UserDAO.getInstance().getUser(author_id, false).getFull_name();
        this.author_id = author_id;
        this.status = status;
    }

    public Subject(String subject_code, String subject_name, int author_id, String description, boolean status) {
        this.subject_code = subject_code;
        this.subject_name = subject_name;
        this.author_id = author_id;
        this.author = DAO.UserDAO.getInstance().getUser(author_id, false).getFull_name();
         this.description = description;
        this.status = status;
    }


    public Subject() {
    }

    public Subject(int subject_id, String subject_code, String subject_name, int author_id, String description, boolean status) {
        this.subject_id = subject_id;
        this.subject_code = subject_code;
        this.subject_name = subject_name;
        this.author = DAO.UserDAO.getInstance().getUser(author_id, false).getFull_name();
         this.author_id = author_id;
        this.description = description;
        this.status = status;
    }

    


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }



    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public int getSubject_id() {
        return subject_id;
    }

    public void setSubject_id(int subject_id) {
        this.subject_id = subject_id;
    }

    public String getSubject_code() {
        return subject_code;
    }

    public void setSubject_code(String subject_code) {
        this.subject_code = subject_code;
    }

    public String getSubject_name() {
        return subject_name;
    }

    public void setSubject_name(String subject_name) {
        this.subject_name = subject_name;
    }

    public int getAuthor_id() {
        return author_id;
    }

    public void setAuthor_id(int author_id) {
        this.author_id = author_id;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

 
    
    
}
