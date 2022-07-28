/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utils;

import Model.Entity.User;

/**
 *
 * @author win
 */
public class Threadable extends Thread{
    public void run(User user){
        Controller.SignupServlet.sendMail(user.getEmail(), "<h2>JOIN OUR TEAM NOW</h2>"
                                                        + "<p>Come join our community as Student where you can share, learn, and discover amazing resources, connect with peers, ask questions, engage in conversations, share your best and less successful experiences. Exchange methodologies and adapt them to your needs.</p>"
                                                        + "<span>If you accept this invatation, we are giving you an password: <h3>" + user.getPassword() + "</h3></span>"
                                                        + "<p>I hope you can join our team as fast as possible! Best wishes!</p>",
                                                        "EduProject Invited You To Our Team");
    }
}
