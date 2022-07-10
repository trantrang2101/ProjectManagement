/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import DAO.UserDAO;
import Model.Captcha.VerifyRecaptcha;
import Model.Entity.User;
import Model.uuid.DecodeUUID;
import Model.uuid.codec.StringCodec;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import java.util.UUID;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Date;
import org.apache.log4j.Logger;
import java.util.concurrent.TimeUnit;
import uuid.UuidCreator;

/**
 *
 * @author ADMIN
 */
public class SignupServlet extends HttpServlet {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(SignupServlet.class);

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {

            String service = request.getParameter("service");
            if (service == null) {
                service = "signup";
            }
            HttpSession session = request.getSession();
            String success = "";

            List<String> error = new ArrayList<>();
            String url = "";
            switch (service) {
                case "resetPW":
                    String uuid = request.getParameter("uuid");
                    if (uuid == null || uuid.isEmpty()) {
                        error.add("UUID is empty please check your link again!");
                        dispathForward(request, response, "signup/password.jsp");
                    } else {
                        String email = DAO.UserDAO.getInstance().getEmail(uuid);
                        if (request.getParameter("email") == null) {
                            Date timeUUID = DecodeUUID.getInstantFromUUID(StringCodec.INSTANCE.decode(uuid));
                            Date now = new Date();
                            long diff = now.getTime() - timeUUID.getTime();
                            long minutes = TimeUnit.MILLISECONDS.toMinutes(diff);
                            request.setAttribute("EMAIL", email);
                            if (minutes <= 2) {
                                request.setAttribute("UUID", uuid);
                                dispathForward(request, response, "signup/resetPassword.jsp");
                            } else {
                                error.add("Time out! Please enter your mail again!");
                                dispathForward(request, response, "signup/password.jsp");
                            }
                        } else {
                            String newPW = request.getParameter("password");
                            String passwordCf = request.getParameter("passwordCf");
                            if (newPW.equals(passwordCf)) {
                                if (DAO.UserDAO.getInstance().changePW(email, newPW)) {
                                    success = "Change password succesfully!";
                                    url = "login?service=loginPage";
                                } else {
                                    error.add("Change password failed!");
                                    dispathForward(request, response, "signup/resetPassword.jsp");
                                }
                            } else {
                                error.add("Confirm password is not match with new Password!");
                                dispathForward(request, response, "signup/resetPassword.jsp");
                            }
                        }
                    }
                    break;
                case "forgotPW":
                    String email = request.getParameter("email");
                    if (email != null) {
                        User get = DAO.UserDAO.getInstance().getUser(email);
                        if (get == null) {
                            error.add("This mail is not existed in our system! Please sign up!");
                            url = "signup";
                        } else {
                            if (!get.isStatus()) {
                                error.add("This account is not verified or inactived by admin!");
                                dispathForward(request, response, "signup/password.jsp");
                            } else {
                                uuid = StringCodec.INSTANCE.encode(UuidCreator.getTimeBased());
                                if (DAO.UserDAO.getInstance().setUUID(email, uuid)) {
                                    if (sendMail(email, "<h2>You have forgotten your password</h2>"
                                            + "<h5>You can click this link to reset your password: "
                                            + "<a href='http://localhost:8080/g2/signup?service=resetPW&uuid=" + uuid + "'>Click here!</a></h5>"
                                            + "<span>Notice: This link is avaiable for only 2 minutes!</span>",
                                            "EduProject send request to change password")) {
                                        success = "Please check your email to get your new password!";
                                        url = "login?service=loginPage";
                                    } else {
                                        error.add("Send Mail failed! Please try again!");
                                        dispathForward(request, response, "signup/password.jsp");
                                    }
                                } else {
                                    error.add("Failed to send mail! Please try again!");
                                    dispathForward(request, response, "signup/password.jsp");
                                }
                            }
                        }
                    } else {
                        dispathForward(request, response, "signup/password.jsp");
                    }
                    break;
                case "signup":
                    String submit = request.getParameter("submit");
                    if (submit == null) {
                        dispathForward(request, response, "signup/signup.jsp");
                    } else {
                        email = request.getParameter("email");
                        String roll_number = request.getParameter("rollNumber").toUpperCase();
                        String full_name = request.getParameter("fullname");
                        boolean gender = Integer.parseInt(request.getParameter("gender")) > 0;
                        String date_of_birth = request.getParameter("date_of_birth");
                        String password = request.getParameter("password");
                        String passwordCf = request.getParameter("passwordCf");
                        String mobile = request.getParameter("mobile");
                        boolean verify = VerifyRecaptcha.verify(request.getParameter("g-recaptcha-response"));
                        if (!email.endsWith("fpt.edu.vn") && !email.endsWith("fu.edu.vn")) {
                            error.add("Not FPT email!");
                        }
                        if (UserDAO.getInstance().getUser(email) != null) {
                            error.add("This email has been registered!");
                        }
                        if (!password.equals(passwordCf)) {
                            error.add("Confirm password is not the same!");
                        }
                        if (!verify) {
                            error.add("Verify captcha!");
                        }
                        String verifyCode = StringCodec.INSTANCE.encode(UuidCreator.getTimeBased());
                        User u = new User(roll_number, full_name, gender, date_of_birth, email, password, mobile, null, null, 4, false);
                        if (error.isEmpty()) {
                            if (!UserDAO.getInstance().addUser(u) || !DAO.UserDAO.getInstance().setUUID(email, verifyCode)) {
                                error.add("Resiger Fail");
                                url = "signup?service=signup";
                            } else {
                                if (sendMail(email, "<h2>Please verify your email</h2>"
                                        + "<h3>Amazing deals, updates, interesting news right in your inbox</h3>"
                                        + "<p><a href='http://localhost:8080/g2/signup?service=verifyAccount&uuid=" + verifyCode + "' class='btn btn-primary'>Yes! Subscribe Me</a></p>",
                                        "EduProject Sign Up Confirmation")) {
                                    success = "Register successfully! Please check your mail to verify your account!";
                                    url = "loging/login.jsp";
                                } else {
                                    error.add("Send mail failed! Register again!");
                                    DAO.UserDAO.getInstance().deleteUser(email);
                                    url = "signup?service=signup";
                                }
                            }
                        } else {
                            url = "signup?service=signup";
                        }
                    }
                    break;
                case "verifyAccount":
                    uuid = request.getParameter("uuid");
                    String mail = DAO.UserDAO.getInstance().getEmail(uuid);
                    User verifyMail = DAO.UserDAO.getInstance().getUser(mail);
                    if (verifyMail != null) {
                        if (verifyMail.isStatus()) {
                            error.add("This email has been verify!");
                        } else {
                            DAO.UserDAO.getInstance().updateStatus(verifyMail.getUser_id(), true);
                            success = "Verify successfully!";
                        }
                    } else {
                        error.add("This email has not been register!");
                    }
                    url = "login?service=loginPage";
                    break;
            }
            logger.warn(error);
            session.setAttribute("ERROR", error);
            logger.info(success);
            session.setAttribute("SUCCESS", success);
            if (!url.isEmpty()) {
                response.sendRedirect(url);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
    }

    public void dispathInclude(HttpServletRequest request, HttpServletResponse response, String page) {
        RequestDispatcher dispath = request.getRequestDispatcher(page);
        try {
            dispath.include(request, response);
        } catch (ServletException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        } catch (IOException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
    }

    public void dispathForward(HttpServletRequest request, HttpServletResponse response, String page) {
        RequestDispatcher dispath = request.getRequestDispatcher(page);
        try {
            dispath.forward(request, response);
        } catch (ServletException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        } catch (IOException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    public Integer findKey(HashMap<Integer, String> map, String value) {
        for (Map.Entry<Integer, String> entry : map.entrySet()) {
            if (entry.getValue().equalsIgnoreCase(value)) {
                return entry.getKey();
            }
        }
        return null;
    }

    public static String generateRandomPassword(int len) {
        char[] chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789~`!@#$%^&*()-_=+[{]}\\|;:\'\",<.>/?".toCharArray();
        String output = "";
        Random rand = new Random();
        for (int i = 0; i < len; i++) {
            output += String.valueOf(chars[rand.nextInt(chars.length)]);
        }
        return output;
    }

    public static boolean sendMail(String emailTo, String content, String title) {
        String email = "eduproject.edu.vn@gmail.com";
        String password = "dycifvknavkitnit";
        Properties pro = new Properties();
        pro.put("mail.smtp.host", "smtp.gmail.com");
        pro.put("mail.smtp.port", "587");
        pro.put("mail.smtp.auth", "true");
        pro.put("mail.smtp.starttls.enable", "true"); //TLS
        Session session = Session.getInstance(pro, new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(email, password);
            }
        });
        try {
            MimeMessage mess = new MimeMessage(session);
            mess.setFrom(new InternetAddress(email));
            mess.addRecipient(Message.RecipientType.TO, new InternetAddress(emailTo));
            mess.setSubject(title);
            mess.setContent("<style>"
                    + "        html,"
                    + "body {"
                    + "    margin: 0 auto !important;"
                    + "    padding: 0 !important;"
                    + "    height: 100% !important;"
                    + "    width: 100% !important;"
                    + "    background: #f1f1f1;"
                    + "}"
                    + "* {"
                    + "    -ms-text-size-adjust: 100%;"
                    + "    -webkit-text-size-adjust: 100%;"
                    + "}"
                    + "div[style*='margin: 16px 0'] {"
                    + "    margin: 0 !important;"
                    + "}"
                    + "table,"
                    + "td {"
                    + "    mso-table-lspace: 0pt !important;"
                    + "    mso-table-rspace: 0pt !important;"
                    + "}"
                    + "table {"
                    + "    border-spacing: 0 !important;"
                    + "    border-collapse: collapse !important;"
                    + "    table-layout: fixed !important;"
                    + "    margin: 0 auto !important;"
                    + "}"
                    + "img {"
                    + "    -ms-interpolation-mode:bicubic;"
                    + "}"
                    + "a {"
                    + "    text-decoration: none;"
                    + "}"
                    + ".unstyle-auto-detected-links *,"
                    + ".aBn {"
                    + "    border-bottom: 0 !important;"
                    + "    cursor: default !important;"
                    + "    color: inherit !important;"
                    + "    text-decoration: none !important;"
                    + "    font-size: inherit !important;"
                    + "    font-family: inherit !important;"
                    + "    font-weight: inherit !important;"
                    + "    line-height: inherit !important;"
                    + "}"
                    + ".a6S {"
                    + "    display: none !important;"
                    + "    opacity: 0.01 !important;"
                    + "}"
                    + ".im {"
                    + "    color: inherit !important;"
                    + "}"
                    + "img.g-img + div {"
                    + "    display: none !important;"
                    + "}"
                    + "@media only screen and (min-device-width: 320px) and (max-device-width: 374px) {"
                    + "    u ~ div .email-container {"
                    + "        min-width: 320px !important;"
                    + "    }"
                    + "}"
                    + "@media only screen and (min-device-width: 375px) and (max-device-width: 413px) {"
                    + "    u ~ div .email-container {"
                    + "        min-width: 375px !important;"
                    + "    }"
                    + "}"
                    + "@media only screen and (min-device-width: 414px) {"
                    + "    u ~ div .email-container {"
                    + "        min-width: 414px !important;"
                    + "    }"
                    + "}"
                    + "    </style>"
                    + "    <!-- CSS Reset : END -->"
                    + "    <!-- Progressive Enhancements : BEGIN -->"
                    + "    <style>"
                    + "	    .primary{"
                    + "	background: #0061f2;"
                    + "}"
                    + ".bg_white{"
                    + "	background: #ffffff;"
                    + "}"
                    + ".bg_light{"
                    + "	background: #fafafa;"
                    + "}"
                    + ".bg_black{"
                    + "	background: #000000;"
                    + "}"
                    + ".bg_dark{"
                    + "	background: rgba(0,0,0,.8);"
                    + "}"
                    + ".email-section{"
                    + "	padding:2.5em;"
                    + "}"
                    + ".btn{"
                    + "	padding: 10px 15px;"
                    + "	display: inline-block;"
                    + "}"
                    + ".btn.btn-primary{"
                    + "	border-radius: 5px;"
                    + "	background: #0061f2;"
                    + "	color: #ffffff;"
                    + "}"
                    + ".btn.btn-white{"
                    + "	border-radius: 5px;"
                    + "	background: #ffffff;"
                    + "	color: #000000;"
                    + "}"
                    + ".btn.btn-white-outline{"
                    + "	border-radius: 5px;"
                    + "	background: transparent;"
                    + "	border: 1px solid #fff;"
                    + "	color: #fff;"
                    + "}"
                    + ".btn.btn-black-outline{"
                    + "	border-radius: 0px;"
                    + "	background: transparent;"
                    + "	border: 2px solid #000;"
                    + "	color: #000;"
                    + "	font-weight: 700;"
                    + "}"
                    + "h1,h2,h3,h4,h5,h6{"
                    + "	font-family: 'Lato', sans-serif;"
                    + "	color: #000000;"
                    + "	margin-top: 0;"
                    + "	font-weight: 400;"
                    + "}"
                    + "body{"
                    + "	font-family: 'Lato', sans-serif;"
                    + "	font-weight: 400;"
                    + "	font-size: 15px;"
                    + "	line-height: 1.8;"
                    + "	color: rgba(0,0,0,.4);"
                    + "}"
                    + "a{"
                    + "	color: #0061f2;"
                    + "}"
                    + "table{"
                    + "}"
                    + "/*LOGO*/"
                    + ".logo h1{"
                    + "	margin: 0;"
                    + "}"
                    + ".logo h1 a{"
                    + "	color: #0061f2;"
                    + "	font-size: 24px;"
                    + "	font-weight: 700;"
                    + "	font-family: 'Lato', sans-serif;"
                    + "}"
                    + "/*HERO*/"
                    + ".hero{"
                    + "	position: relative;"
                    + "	z-index: 0;"
                    + "}"
                    + ".hero .text{"
                    + "	color: rgba(0,0,0,.3);"
                    + "}"
                    + ".hero .text h2{"
                    + "	color: #000;"
                    + "	font-size: 40px;"
                    + "	margin-bottom: 0;"
                    + "	font-weight: 400;"
                    + "	line-height: 1.4;"
                    + "}"
                    + ".hero .text h3{"
                    + "	font-size: 24px;"
                    + "	font-weight: 300;"
                    + "}"
                    + ".hero .text h2 span{"
                    + "	font-weight: 600;"
                    + "	color: #0061f2;"
                    + "}"
                    + "/*HEADING SECTION*/"
                    + ".heading-section{"
                    + "}"
                    + ".heading-section h2{"
                    + "	color: #000000;"
                    + "	font-size: 28px;"
                    + "	margin-top: 0;"
                    + "	line-height: 1.4;"
                    + "	font-weight: 400;"
                    + "}"
                    + ".heading-section .subheading{"
                    + "	margin-bottom: 20px !important;"
                    + "	display: inline-block;"
                    + "	font-size: 13px;"
                    + "	text-transform: uppercase;"
                    + "	letter-spacing: 2px;"
                    + "	color: rgba(0,0,0,.4);"
                    + "	position: relative;"
                    + "}"
                    + ".heading-section .subheading::after{"
                    + "	position: absolute;"
                    + "	left: 0;"
                    + "	right: 0;"
                    + "	bottom: -10px;"
                    + "	content: '';"
                    + "	width: 100%;"
                    + "	height: 2px;"
                    + "	background: #0061f2;"
                    + "	margin: 0 auto;"
                    + "}"
                    + ".heading-section-white{"
                    + "	color: rgba(255,255,255,.8);"
                    + "}"
                    + ".heading-section-white h2{"
                    + "	line-height: 1;"
                    + "	padding-bottom: 0;"
                    + "}"
                    + ".heading-section-white h2{"
                    + "	color: #ffffff;"
                    + "}"
                    + ".heading-section-white .subheading{"
                    + "	margin-bottom: 0;"
                    + "	display: inline-block;"
                    + "	font-size: 13px;"
                    + "	text-transform: uppercase;"
                    + "	letter-spacing: 2px;"
                    + "	color: rgba(255,255,255,.4);"
                    + "}"
                    + "ul.social{"
                    + "	padding: 0;"
                    + "}"
                    + "ul.social li{"
                    + "	display: inline-block;"
                    + "	margin-right: 10px;"
                    + "}"
                    + "/*FOOTER*/"
                    + ".footer{"
                    + "	border-top: 1px solid rgba(0,0,0,.05);"
                    + "	color: rgba(0,0,0,.5);"
                    + "}"
                    + ".footer .heading{"
                    + "	color: #000;"
                    + "	font-size: 20px;"
                    + "}"
                    + ".footer ul{"
                    + "	margin: 0;"
                    + "	padding: 0;"
                    + "}"
                    + ".footer ul li{"
                    + "	list-style: none;"
                    + "	margin-bottom: 10px;"
                    + "}"
                    + ".footer ul li a{"
                    + "	color: rgba(0,0,0,1);"
                    + "}"
                    + "@media screen and (max-width: 500px) {"
                    + "}"
                    + "    </style>"
                    + "<div width='100%' style='margin: 0; padding: 0 !important; mso-line-height-rule: exactly; background-color: #f1f1f1;'>"
                    + "	<center style='width: 100%; background-color: #f1f1f1;'>"
                    + "    <div style='display: none; font-size: 1px;max-height: 0px; max-width: 0px; opacity: 0; overflow: hidden; mso-hide: all; font-family: sans-serif;'>"
                    + "      &zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;"
                    + "    </div>"
                    + "    <div style='max-width: 600px; margin: 0 auto;' class='email-container'>"
                    + "    	<!-- BEGIN BODY -->"
                    + "      <table align='center' role='presentation' cellspacing='0' cellpadding='0' border='0' width='100%' style='margin: auto;'>"
                    + "      	<tr>"
                    + "          <td valign='top' class='bg_white' style='padding: 1em 2.5em 0 2.5em;'>"
                    + "          	<table role='presentation' border='0' cellpadding='0' cellspacing='0' width='100%'>"
                    + "          		<tr>"
                    + "          			<td class='logo' style='text-align: center;'>"
                    + "			            <h1><a href='#'>EduProject</a></h1>"
                    + "			          </td>"
                    + "          		</tr>"
                    + "          	</table>"
                    + "          </td>"
                    + "	      </tr><!-- end tr -->"
                    + "	      <tr>"
                    + "          <td valign='middle' class='hero bg_white' style='padding: 3em 0 2em 0;'>"
                    + "            <img src='https://gitlab.com/fu-kiennt-summer22/se1619-net-swp391/g2/-/blob/main/web/assets/img/logo_project.jpg' alt='' style='width: 300px; max-width: 600px; height: auto; margin: auto; display: block;'>"
                    + "          </td>"
                    + "	      </tr><!-- end tr -->"
                    + "				<tr>"
                    + "          <td valign='middle' class='hero bg_white' style='padding: 2em 0 4em 0;'>"
                    + "            <table>"
                    + "            	<tr>"
                    + "            		<td>"
                    + "            			<div class='text' style='padding: 0 2.5em; text-align: center;'>"
                    + content
                    + "            			</div>"
                    + "            		</td>"
                    + "            	</tr>"
                    + "            </table>"
                    + "          </td>"
                    + "	      </tr><!-- end tr -->"
                    + "      <!-- 1 Column Text + Button : END -->"
                    + "      </table>"
                    + "      <table align='center' role='presentation' cellspacing='0' cellpadding='0' border='0' width='100%' style='margin: auto;'>"
                    + "      	<tr>"
                    + "          <td valign='middle' class='bg_light footer email-section'>"
                    + "            <table>"
                    + "            	<tr>"
                    + "                <td valign='top' width='33.333%' style='padding-top: 20px;'>"
                    + "                  <table role='presentation' cellspacing='0' cellpadding='0' border='0' width='100%'>"
                    + "                    <tr>"
                    + "                        <td class='col-12 col-md-4 col-lg-4 introduction footer-column'>"
                    + "                            <img src='https://gitlab.com/fu-kiennt-summer22/se1619-net-swp391/g2/-/blob/main/web/assets/img/logo_project.jpg' class='footer-site-logo' alt='EduProject' lazied=''>"
                    + "                            <p class='slogan mg-b-10'>"
                    + "                                EduProject platform provides learners and instructors with a variety of educational technologies following the social constructive learning."
                    + "                            </p>"
                    + "                            <p class='fs-14 mg-b-0' style='color: red'>*Recommendation: Best use with Chrome browser</p>"
                    + "                        </td>"
                    + "                    </tr>"
                    + "                  </table>"
                    + "                </td>"
                    + "                <td valign='top' width='33.333%' style='padding-top: 20px;'>"
                    + "                  <table role='presentation' cellspacing='0' cellpadding='0' border='0' width='100%'>"
                    + "                    <tr>"
                    + "                      <td style='text-align: left; padding-left: 5px; padding-right: 5px;'>"
                    + "                      	<h3 class='heading'>Contact Info</h3>"
                    + "                      	<ul>"
                    + "					                <li><span class='text'>203 Fake St. Mountain View, San Francisco, California, USA</span></li>"
                    + "					                <li><span class='text'>+2 392 3929 210</span></a></li>"
                    + "					              </ul>"
                    + "                      </td>"
                    + "                    </tr>"
                    + "                  </table>"
                    + "                </td>"
                    + "                <td valign='top' width='33.333%' style='padding-top: 20px;'>"
                    + "                  <table role='presentation' cellspacing='0' cellpadding='0' border='0' width='100%'>"
                    + "                    <tr>"
                    + "                      <td style='text-align: left; padding-left: 10px;'>"
                    + "                      	<h3 class='heading'>Useful Links</h3>"
                    + "                      	<ul>"
                    + "					                <li><a href='#'>Home</a></li>"
                    + "					                <li><a href='#'>About</a></li>"
                    + "					                <li><a href='#'>Services</a></li>"
                    + "					                <li><a href='#'>Work</a></li>"
                    + "					              </ul>"
                    + "                      </td>"
                    + "                    </tr>"
                    + "                  </table>"
                    + "                </td>"
                    + "              </tr>"
                    + "            </table>"
                    + "          </td>"
                    + "        </tr><!-- end: tr -->"
                    + "        <tr>"
                    + "          <td class='bg_light' style='text-align: center;'>"
                    + "          	<p>No longer want to receive these email? You can <a href='#' style='color: rgba(0,0,0,.8);'>Unsubscribe here</a></p>"
                    + "          </td>"
                    + "        </tr>"
                    + "      </table>"
                    + "    </div>"
                    + "  </center>"
                    + "</div>", "text/html");
            Transport.send(mess);
            return true;
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
            return false;
        }
    }

}
