/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.Entity.*;
import Utils.AppUtils;
import java.io.*;
import java.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

/**
 *
 * @author win
 */
public class TrackingServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(TrackingServlet.class);

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User login = (User) AppUtils.getLoginedUser(session);
        List<String> error = new ArrayList<>();
        List<Classroom> listClass = (List<Classroom>) session.getAttribute("LIST_CLASS");
        Classroom classroom = (Classroom) session.getAttribute("CLASS_CHOOSE");
        String classID = request.getParameter("class");
        if (classID == null) {
            if (classroom == null) {
                classroom = listClass.get(0);
            }
            classID = String.valueOf(classroom.getClass_id());
        } else {
            classroom = DAO.ClassDAO.getInstance().getClass(login, Integer.parseInt(classID));
            if (classroom == null) {
                classroom = listClass.get(0);
                classID = String.valueOf(classroom.getClass_id());
            }
        }
        String url = "";
        String success = "";
        Integer team = request.getParameter("team") == null || request.getParameter("team").isEmpty() ? null : Integer.parseInt(request.getParameter("team"));
        if (team == null) {
            team = classroom.getListTeam(login).get(0).getTeam_id();
        } else {
            classroom = DAO.TeamDAO.getInstance().getTeam(team).getClassroom();
            classID = String.valueOf(classroom.getClass_id());
        }
        session.setAttribute("CLASS_CHOOSE", classroom);
        if (!DAO.ClassUserDAO.getInstance().checkAllow(team, login)) {
            error.add("You are not allow to be here");
            team = listClass.get(0).getListTeam(login).get(0).getTeam_id();
        }
        List<ClassUser> listUser = DAO.ClassUserDAO.getInstance().getList(team, 1, "", 0, Integer.MAX_VALUE, login, classroom.getClass_id(), "user_id", true);
        request.setAttribute("LIST_USER", listUser);
        if (team != null) {
            request.setAttribute("TEAM_CHOOSE", DAO.TeamDAO.getInstance().getTeam(team));
        }
        Integer id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? null : Integer.parseInt(request.getParameter("id"));
        try (PrintWriter out = response.getWriter()) {
            String service = request.getParameter("service");
            if (service == null) {
                service = (id != null ? "update" : "list");
            }
            Integer feature = request.getParameter("type") == null || request.getParameter("type").isEmpty() ? null : Integer.parseInt(request.getParameter("type"));
            List<Team> listTeam = DAO.TeamDAO.getInstance().getList(Integer.parseInt(classID), login, "", 0, Integer.MAX_VALUE, "team_name", true, 1);
            request.setAttribute("LIST_TEAM", listTeam);
            Integer assignee = request.getParameter("assignee") == null || request.getParameter("assignee").isEmpty() ? null : Integer.parseInt(request.getParameter("assignee"));
            Integer statusChoose = request.getParameter("statusFilter") == null || request.getParameter("statusFilter").isEmpty() ? null : Integer.parseInt(request.getParameter("statusFilter"));
            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            switch (service) {
                case "list":
                    List<Feature> listFeature = DAO.FeatureDAO.getInstance().getList(team, login, "", 0, Integer.MAX_VALUE, "feature_id", true, true);
                    request.setAttribute("LIST_FEATURE", listFeature);
                    if (feature != null) {
                        request.setAttribute("FEATURE_CHOOSE", DAO.FeatureDAO.getInstance().getFeature(feature));
                    }
                    if (statusChoose != null) {
                        request.setAttribute("SORT_FILTER", DAO.ClassSettingDAO.getInstance().getClassSetting(statusChoose));
                    }
                    if (assignee != null) {
                        request.setAttribute("ASSIGNEE_CHOOSE", DAO.ClassUserDAO.getInstance().getClassUser(classroom.getClass_id(), assignee));
                    }
                    String sort = request.getParameter("sort");
                    boolean statusSort = request.getParameter("sortStatus") == null ? false : Boolean.parseBoolean(request.getParameter("sortStatus"));
                    if (sort == null) {
                        sort = request.getParameter("previousSort") == null ? "tracking_id" : (String) request.getParameter("previousSort");
                        statusSort = true;
                    } else {
                        if (sort.equals((String) request.getParameter("previousSort"))) {
                            statusSort = !statusSort;
                        }
                    }
                    request.setAttribute("THIS_PAGE", thisPage);
                    request.setAttribute("SORT_TRACKING", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("TRACKING_SIZE", (int) Math.ceil(DAO.ClassDAO.getInstance().countRows("tracking", "", (assignee != null ? " and assignee_id=" + assignee : "")
                            + (team != null ? " and function_id in (select function_id from studentmanagement.function where team_id=" + team + ")" : "") + (statusChoose != null ? " and status = " + statusChoose : "")
                            + (login.getRole_id() == 1 ? "" : login.getRole_id() == 2 ? " and milestone_id in (select milestone_id from `studentmanagement`.`milestone`,`studentmanagement`.`class` where milestone.class_id = class.class_id and trainer_id=" + login.getUser_id() + ")" : (login.getRole_id() == 4 ? " and function_id in (select function_id from `studentmanagement`.`function`,`studentmanagement`.`class_user` where class_user.team_id=function.team_id and user_id=" + login.getUser_id() + ")" : " and milestone_id in (select milestone_id from `studentmanagement`.`milestone`,`studentmanagement`.`class`,`studentmanagement`.`subject` where class.class_id=milestone.class_id and class.subject_id=subject.subject_id and author_id=" + login.getUser_id() + ")"))
                            + (feature != null ? " and function_id in (select function_id from `studentmanagement`.`function` where feature_id=" + feature + ")" : "")) * 1.0 / 10));
                    request.setAttribute("LIST_TRACKING", DAO.TrackingDAO.getInstance().getList(team, statusChoose, assignee, null, feature, (thisPage - 1) * 10, 10, login, sort, statusSort, null));
                    dispathForward(request, response, "tracking/list.jsp");
                    break;
                case "changeStatus":
                    try {
                        int statusChange = Integer.parseInt(request.getParameter("status"));
                        String submit = request.getParameter("submit");
                        if (submit == null) {
                            session.setAttribute("TRACKING_CHANGE_STATUS", DAO.TrackingDAO.getInstance().getTracking(id));
                            session.setAttribute("STATUS_CHANGE", DAO.ClassSettingDAO.getInstance().getClassSetting(statusChange));
                        } else {
                            session.removeAttribute("TRACKING_CHANGE_STATUS");
                            session.removeAttribute("STATUS_CHANGE");
                            if (DAO.TrackingDAO.getInstance().updateChangeStatus(id, statusChange)) {
                                success = "Tracking Status change successfully!";
                            } else {
                                error.add("Tracking status change failed!");
                            }
                        }
                    } catch (Exception e) {
                        session.removeAttribute("TRACKING_CHANGE_STATUS");
                        session.removeAttribute("STATUS_CHANGE");
                    }
                    url=("tracking?service=list&team=" + team);
                    break;
                case "update":
                    if (request.getParameter("submitForm") == null) {
                        request.setAttribute("TRACKING_CHOOSE", DAO.TrackingDAO.getInstance().getTracking(id));
                        dispathForward(request, response, "tracking/detail.jsp");
                    } else {
                        int function = Integer.parseInt(request.getParameter("function"));
                        int milestone = Integer.parseInt(request.getParameter("milestone"));
                        int status = Integer.parseInt(request.getParameter("status"));
                        String note = request.getParameter("note");
                        if (DAO.TrackingDAO.getInstance().updateTracking(new Tracking(id, milestone, function, login.getUser_id(), assignee, note, status))) {
                            success = "Update tracking successfully";
                        } else {
                            error.add("Update tracking failed!");
                        }
                        url=("tracking?service=list&class=" + classID);
                    }
                    break;
                case "add":
                    listFeature = DAO.FeatureDAO.getInstance().getList(team);
                    request.setAttribute("LIST_FEATURE", listFeature);
                    String submit = request.getParameter("submitForm");
                    List<Milestone> listMilestone = DAO.MilestoneDAO.getInstance().getList(classroom.getClass_id(), null, 1, login, "", 0, Integer.MAX_VALUE, "milestone_id", true);
                    if (listFeature != null&& !listFeature.isEmpty()) {
                        feature = request.getParameter("feature") == null || request.getParameter("feature").isEmpty() ? listFeature.get(0).getFeature_id() : Integer.parseInt(request.getParameter("feature"));
                        List<Function> listFunction = DAO.FunctionDAO.getInstance().getList(feature);
                        request.setAttribute("FEATURE_CHOOSE", DAO.FeatureDAO.getInstance().getFeature(feature));
                        request.setAttribute("LIST_MILESTONE", listMilestone);
                        request.setAttribute("LIST_FUNCTION", listFunction);
                    }
                    if (submit == null) {
                        dispathForward(request, response, "tracking/detail.jsp");
                    } else {
                        int function = Integer.parseInt(request.getParameter("function"));
                        int milestone = Integer.parseInt(request.getParameter("milestone"));
                        int status = Integer.parseInt(request.getParameter("status"));
                        String note = request.getParameter("note");
                        if (DAO.TrackingDAO.getInstance().checkTracking(milestone, function) != null) {
                            error.add("This tracking has existed");
                        } else {
                            if (DAO.TrackingDAO.getInstance().addTracking(new Tracking(0, milestone, function, login.getUser_id(), assignee, note, status))) {
                                success = "Add tracking successfully!";
                            } else {
                                error.add("Add tracking failed!");
                            }
                        }
                        url=("tracking?service=list&class=" + classID);
                    }
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

}
