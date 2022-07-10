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
public class User {

    private int user_id;
    private String roll_number, full_name;
    private boolean gender;
    private String date_of_birth, email, password, mobile, avatar_link, facebook_link;
    private int role_id;
    private boolean status;

    public User(String roll_number, String full_name, String email, String password, int role_id) {
        this.roll_number = roll_number;
        this.full_name = full_name;
        this.gender=true;
        this.status=true;
        this.email = email;
        this.password = password;
        this.role_id = role_id;
    }
    
    public User(String roll_number, String full_name, boolean gender, String date_of_birth, String email, String password, String mobile, String avatar_link, String facebook_link, int role_id, boolean status) {
        this.roll_number = roll_number;
        this.full_name = full_name;
        this.gender = gender;
        this.date_of_birth = date_of_birth;
        this.email = email;
        this.password = password;
        this.mobile = mobile;
        this.avatar_link = avatar_link;
        this.facebook_link = facebook_link;
        this.role_id = role_id;
        this.status = status;
    }

    public User(int user_id, String roll_number, String full_name, boolean gender, String date_of_birth, String email, String password, String mobile, String avatar_link, String facebook_link, int role_id, boolean status) {
        this.user_id = user_id;
        this.roll_number = roll_number;
        this.full_name = full_name;
        this.gender = gender;
        this.date_of_birth = date_of_birth;
        this.email = email;
        this.password = password;
        this.mobile = mobile;
        this.avatar_link = avatar_link;
        this.facebook_link = facebook_link;
        this.role_id = role_id;
        this.status = status;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getRoll_number() {
        return roll_number;
    }

    public void setRoll_number(String roll_number) {
        this.roll_number = roll_number;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public String getDate_of_birth() {
        return date_of_birth;
    }

    public void setDate_of_birth(String date_of_birth) {
        this.date_of_birth = date_of_birth;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getAvatar_link() {
        return avatar_link;
    }

    public void setAvatar_link(String avatar_link) {
        this.avatar_link = avatar_link;
    }

    public String getFacebook_link() {
        return facebook_link;
    }

    public void setFacebook_link(String facebook_link) {
        this.facebook_link = facebook_link;
    }

    public int getRole_id() {
        return role_id;
    }

    public void setRole_id(int role_id) {
        this.role_id = role_id;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
   public User(int user_id, String full_name) {
        this.user_id = user_id;
        this.full_name = full_name;
    }
}
