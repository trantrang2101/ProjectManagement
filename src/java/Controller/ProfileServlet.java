/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.Entity.User;
import Utils.AppUtils;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import java.io.PrintWriter;
import java.io.StringWriter;
import org.apache.log4j.Logger;

/**
 *
 * @author win
 */
public class ProfileServlet extends HttpServlet {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(ProfileServlet.class);

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
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            List<String> error = new ArrayList<>();
            String url = "";
            String success = "";
            
            User login = (User) AppUtils.getLoginedUser(session);
            String service = request.getParameter("service");
            if (service == null) {
                service = "uploadImage";
            }
            switch (service) {
                case "profile":
                    session.setAttribute("CHOOSE_USER", login);
                    dispathForward(request, response, "user/profile.jsp");
                    break;
                case "changePW": {
                    String email = request.getParameter("email");
                    String currentPW = request.getParameter("passwordCurrent");
                    String newPW = request.getParameter("password");
                    String passwordCf = request.getParameter("passwordCf");
                    if (BCrypt.checkpw(currentPW, login.getPassword())) {
                        if (newPW.equals(passwordCf)) {
                            if (DAO.UserDAO.getInstance().changePW(email, newPW)) {
                                success = "Change password succesfully!";
                            } else {
                                error.add("Change password failed!");
                            }
                        } else {
                            error.add("Confirm password is not match with new Password!");
                        }
                    } else {
                        error.add("Current Password is wrong!");
                    }
                    url = "profile?service=profile";
                    break;
                }
                case "uploadImage":
                    String name = "";
                    String uploadPath = "";
                    String applicationPath = getServletContext().getRealPath("");
                    String build = "";
                    uploadPath = applicationPath.replace("build\\", "");
                    build = applicationPath;
                    name = "assets\\img\\user" + File.separator + login.getUser_id() + ".png";
                    File fileUploadDirectory = new File(uploadPath);
                    if (!fileUploadDirectory.exists()) {
                        fileUploadDirectory.mkdirs();
                    }
                    File fileBuildUploadDirectory = new File(build);
                    if (!fileBuildUploadDirectory.exists()) {
                        fileBuildUploadDirectory.mkdirs();
                    }
                    try {
                        ServletFileUpload sf = new ServletFileUpload(new DiskFileItemFactory());
                        List<FileItem> multifiles = sf.parseRequest(request);
                        for (FileItem item : multifiles) {
                            if (item.getContentType() != null) {
                                item.write(new File(uploadPath + File.separator + name));
                                item.write(new File(build + File.separator + name));
                            }
                        }
                        boolean check = DAO.UserDAO.getInstance().updateImage(login.getUser_id(), name);
                        if (check) {
                            login.setAvatar_link(name);
                            success = "Update image successfully!";
                            AppUtils.storeLoginedUser(session, login);
                        }
                    } catch (Exception e) {
                        e.printStackTrace(new PrintWriter(errors));
                        logger.error(errors.toString());
                        error.add("Update image failed!");
                    }
                    url = "profile?service=profile";
                    break;

                case "update": {
                    boolean check = true;
                    String email = request.getParameter("email");
                    String roll_number = request.getParameter("rollNumber");
                    String full_name = request.getParameter("fullname");
                    boolean gender = Integer.parseInt(request.getParameter("gender")) > 0;
                    String facebook_link = request.getParameter("facebook_link");
                    String date_of_birth = request.getParameter("date_of_birth");
                    String mobile = request.getParameter("mobile");
                    int role_id = Integer.parseInt(request.getParameter("role_id"));
                    if (role_id == 4 && roll_number != null) {
                        roll_number = roll_number.toUpperCase();
                    } else {
                        roll_number = "";
                    }
                    User update = new User(login.getUser_id(), roll_number, full_name, gender, date_of_birth, email, login.getRoll_number(), mobile, login.getAvatar_link(), facebook_link, role_id, true);
                    if (check && DAO.UserDAO.getInstance().updateUser(update)) {
                        AppUtils.storeLoginedUser(request.getSession(), DAO.UserDAO.getInstance().getUser(email));
                        success = "Update successfully!";
                        AppUtils.storeLoginedUser(session, update);
                    } else {
                        error.add("Update Fail");
                    }

                    url = "profile?service=profile";
                    break;
                }
                default:
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

    public void dispathForward(HttpServletRequest request, HttpServletResponse response, String page) {
        RequestDispatcher dispath = request.getRequestDispatcher(page);
        try {
            dispath.forward(request, response);
        } catch (Exception ex) {
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

}
