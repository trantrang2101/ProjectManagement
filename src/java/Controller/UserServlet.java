/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.Entity.Classroom;
import Model.Entity.User;
import Utils.AppUtils;
import java.io.*;
import java.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.PrintWriter;
import java.io.StringWriter;
import org.apache.log4j.Logger;

/**
 *
 * @author ADMIN
 */
public class UserServlet extends HttpServlet {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(UserServlet.class);

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
            int id = request.getParameter("id") != null ? Integer.parseInt(request.getParameter("id")) : -1;
            String service = request.getParameter("service");
            if (service == null) {
                service = id > 0 ? "detail" : "list";
            }
            int type = request.getParameter("type") != null && !request.getParameter("type").isEmpty() ? Integer.parseInt(request.getParameter("type")) : -1;
            Integer statusFilter = request.getParameter("statusFilter") != null && !request.getParameter("statusFilter").isEmpty() ? Integer.parseInt(request.getParameter("statusFilter")) : null;
            List<String> error = new ArrayList<>();
            User login = (User) AppUtils.getLoginedUser(session);
            String url = "";
            User choose = (User) session.getAttribute("CHOOSE_USER");
            String success = "";

            switch (service) {
                case "add":
                    if (request.getParameter("submit") == null) {
                        dispathForward(request, response, "user/profile.jsp");
                    } else {
                        String email = request.getParameter("email");
                        String roll_number = request.getParameter("rollNumber");
                        String full_name = request.getParameter("fullname");
                        boolean gender = Integer.parseInt(request.getParameter("gender")) > 0;
                        String date_of_birth = request.getParameter("date_of_birth");
                        String mobile = request.getParameter("mobile");
                        int role_id = Integer.parseInt(request.getParameter("role_id"));
                        String ava = request.getParameter("avatar_link");
                        if (!email.endsWith("fpt.edu.vn") && !email.endsWith("fu.edu.vn")) {
                            error.add("Not fpt email!");
                        }
                        if (DAO.UserDAO.getInstance().getUser(email) != null) {
                            error.add("This email has been registered!");
                        }
                        if (role_id == 4 && roll_number == null) {
                            error.add("Student need Roll Number!!");
                        } else if (role_id == 4 && roll_number != null) {
                            roll_number = roll_number.toUpperCase();
                        } else {
                            roll_number = "";
                        }
                        String password = SignupServlet.generateRandomPassword(20).trim();
                        int user_id = -1;
                        User u = new User(roll_number, full_name, gender, date_of_birth, email, password, mobile, ava, date_of_birth, role_id, true);
                        if (error.isEmpty()) {
                            if (!DAO.UserDAO.getInstance().addUser(u) || (user_id = DAO.UserDAO.getInstance().getUser(email).getUser_id()) < 0) {
                                error.add("Resiger Fail");
                                url = "signup?service=signup";
                            } else {
                                success = "Add user successfully!";
                                session.setAttribute("LIST_AUTHOR", DAO.UserDAO.getInstance().getList(2, "", null, false, 0, Integer.MAX_VALUE, 1));
                                SignupServlet.sendMail(email, "<h2>JOIN OUR TEAM NOW</h2>"
                                        + "<p>Come join our community as " + DAO.SettingDAO.getInstance().getSetting(role_id).getSetting_title() + " where you can share, learn, and discover amazing resources, connect with peers, ask questions, engage in conversations, share your best and less successful experiences. Exchange methodologies and adapt them to your needs.</p>"
                                        + "<span>If you accept this invatation, we are giving you an password: <h3>" + password + "</h3></span>"
                                        + "<p>I hope you can join our team as fast as possible! Best wishes!</p>",
                                        "EduProject Invited You To Our Team");
                                url = "user?id=" + user_id;
                            }
                        } else {
                            url = "user?service=list";
                        }
                    }
                    break;
                case "detail":
                    session.setAttribute("CHOOSE_USER", DAO.UserDAO.getInstance().getUser(id, true));
                    dispathForward(request, response, "user/profile.jsp");
                    break;
                case "update":
                    String email = request.getParameter("email");
                    String roll_number = request.getParameter("rollNumber");
                    String full_name = request.getParameter("fullname");
                    boolean gender = Integer.parseInt(request.getParameter("gender")) > 0;
                    String facebook_link = request.getParameter("facebook_link");
                    String date_of_birth = request.getParameter("date_of_birth");
                    String mobile = request.getParameter("mobile");
                    int role_id = Integer.parseInt(request.getParameter("role_id"));
                    if (role_id != 4) {
                        roll_number = "";
                    }
                    User update = new User(choose.getUser_id(), roll_number, full_name, gender, date_of_birth, email, "", mobile, choose.getAvatar_link(), facebook_link, role_id, true);
                    if (DAO.UserDAO.getInstance().updateUser(update)) {
                        success = "Update successfully!";
                        session.setAttribute("LIST_AUTHOR", DAO.UserDAO.getInstance().getList(2, "", null, false, 0, Integer.MAX_VALUE, 1));
                        if (id == login.getUser_id()) {
                            AppUtils.storeLoginedUser(session, update);
                        }
                    } else {
                        error.add("Update Fail");
                    }
                    url = "user?id=" + id;
                    break;
                case "list":
                    String search = request.getParameter("search");
                    if (search == null || search.isEmpty()) {
                        search = "";
                    } else {
                        search = search.trim();
                    }
                    String sort = request.getParameter("sort");
                    boolean statusSort = request.getParameter("sortStatus") == null ? true : Boolean.parseBoolean(request.getParameter("sortStatus"));
                    if (sort == null) {
                        sort = request.getParameter("previousSort") == null ? "user_id" : (String) request.getParameter("previousSort");
                        statusSort = true;
                    } else {
                        if (sort.equals((String) request.getParameter("previousSort"))) {
                            statusSort = !statusSort;
                        } else {
                            statusSort = true;
                        }
                    }
                    if (statusFilter != null) {
                        request.setAttribute("SORT_FILTER", statusFilter);
                    }
                    int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("THIS_PAGE", thisPage);
                    request.setAttribute("SORT_USER", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("USER_SIZE", (int) Math.ceil(DAO.UserDAO.getInstance().countRows("user", search, (statusFilter == null ? "" : " and status=" + statusFilter).concat(type > 0 ? " and role_id=" + type : "")) * 1.0 / 10));
                    request.setAttribute("LIST_USER", DAO.UserDAO.getInstance().getList(type, search, sort, statusSort, (thisPage - 1) * 10, 10, statusFilter));
                    if (type > 0) {
                        request.setAttribute("ROLE_CHOOSE", DAO.SettingDAO.getInstance().getSetting(type));
                    }
                    dispathForward(request, response, "user/list.jsp");
                    break;

                case "changeStatus":
                    boolean status = Boolean.parseBoolean(request.getParameter("status"));
                    if (DAO.SettingDAO.getInstance().getSetting(login.getRole_id()).getSetting_title().equalsIgnoreCase("Admin")) {
                        if (login.getUser_id() == id) {
                            error.add("You cannot change your status!!!");
                        } else {
                            if (DAO.UserDAO.getInstance().updateStatus(id, !status)) {
                                if (status) {
                                    List<Classroom> listClass = DAO.ClassDAO.getInstance().getList("", 0, Integer.MAX_VALUE, login, null, null, -1, "class_id", true);
                                    for (Classroom classroom : listClass) {
                                        if (!DAO.ClassUserDAO.getInstance().updateChangeStatus(id, classroom.getClass_id(), false)) {
                                            error.add("Update Fail");
                                            break;
                                        }
                                    }
                                }
                                session.setAttribute("LIST_AUTHOR", DAO.UserDAO.getInstance().getList(2, "", null, false, 0, Integer.MAX_VALUE, 1));
                                success = "Update status successfully!";
                            } else {
                                error.add("Update Fail");
                            }
                        }
                    } else {
                        error.add("Only Admin can change status!");
                    }
                    url = "user?id=" + id;
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
        } catch (Exception ex) {
            ex.printStackTrace(new PrintWriter(errors));
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
