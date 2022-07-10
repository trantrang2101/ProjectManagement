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
public class TrackingUpdateServlet extends HttpServlet {

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
    private static final Logger logger = Logger.getLogger(TrackingUpdateServlet.class);
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User login = (User) AppUtils.getLoginedUser(session);
        List<String> error = new ArrayList<>();
        List<Classroom> listClass = (List<Classroom>) session.getAttribute("LIST_CLASS");
        Integer tracking = request.getParameter("tracking") == null || request.getParameter("tracking").isEmpty() ? null : Integer.parseInt(request.getParameter("tracking"));
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
        Integer feature = request.getParameter("feature") == null || request.getParameter("feature").isEmpty() ? null : Integer.parseInt(request.getParameter("feature"));
        Integer milestone = request.getParameter("milestone") == null || request.getParameter("milestone").isEmpty() ? null : Integer.parseInt(request.getParameter("milestone"));
        Integer assignee = request.getParameter("assignee") == null || request.getParameter("assignee").isEmpty() ? null : Integer.parseInt(request.getParameter("assignee"));
        if (team == null) {
            team = classroom.getListTeam(login).get(0).getTeam_id();
        } else {
            classroom = DAO.TeamDAO.getInstance().getTeam(team).getClassroom();
            classID = String.valueOf(classroom.getClass_id());
        }
        Tracking track = null;
        if (tracking != null) {
            track = DAO.TrackingDAO.getInstance().getTracking(tracking);
            classroom = track.getClassroom();
            classID = String.valueOf(classroom.getClass_id());
            team = track.getTeam().getTeam_id();
            feature = track.getFeature().getFeature_id();
            assignee = track.getAssignee_id();
            request.setAttribute("TRACKING_CHOOSE", track);
        }
        session.setAttribute("CLASS_CHOOSE", classroom);
        if (!DAO.ClassUserDAO.getInstance().checkAllow(team, login)) {
            error.add("You are not allow to be here");
            team = listClass.get(0).getListTeam(login).get(0).getTeam_id();
            classroom = listClass.get(0);
            if (track != null && track.getTeam().getTeam_id() != team) {
                request.removeAttribute("TRACKING_CHOOSE");
            }
        }
        List<Team> listTeam = DAO.TeamDAO.getInstance().getList(Integer.parseInt(classID), login, "", 0, Integer.MAX_VALUE, "team_name", true, 1);
        if (team != null) {
            request.setAttribute("TEAM_CHOOSE", DAO.TeamDAO.getInstance().getTeam(team));
        }
        List<ClassUser> listUser = DAO.ClassUserDAO.getInstance().getList(team, 1, "", 0, Integer.MAX_VALUE, login, classroom.getClass_id(), "user_id", true);
        request.setAttribute("LIST_USER", listUser);
        Integer id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? null : Integer.parseInt(request.getParameter("id"));
        try (PrintWriter out = response.getWriter()) {
            String service = request.getParameter("service");
            if (service == null) {
                service = (id != null ? "update" : "list");
            }
            if (feature != null) {
                request.setAttribute("FEATURE_CHOOSE", DAO.FeatureDAO.getInstance().getFeature(feature));
            }
            if (milestone != null) {
                request.setAttribute("MILESTONE_CHOOSE", DAO.MilestoneDAO.getInstance().getMilestone(milestone));
            }
            if (assignee != null) {
                request.setAttribute("ASSIGNEE_CHOOSE", DAO.ClassUserDAO.getInstance().getClassUser(classroom.getClass_id(), assignee));
            }
            request.setAttribute("LIST_TEAM", listTeam);
            request.setAttribute("LIST_MILESTONE", DAO.MilestoneDAO.getInstance().getList(classroom.getClass_id(), null, null, login, "", 0, Integer.MAX_VALUE, "milestone_id", true));
            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            switch (service) {
                case "list":
                    List<Feature> listFeature = DAO.FeatureDAO.getInstance().getList(team, login, "", 0, Integer.MAX_VALUE, "feature_id", true, true);
                    request.setAttribute("LIST_FEATURE", listFeature);
                    List<Tracking> listTracking = DAO.TrackingDAO.getInstance().getList(team, null, assignee, null, feature, 0, Integer.MAX_VALUE, login, "tracking_id", true, null);
                    request.setAttribute("LIST_TRACKING", listTracking);
                    String sort = request.getParameter("sort");
                    boolean statusSort = request.getParameter("sortStatus") == null ? false : Boolean.parseBoolean(request.getParameter("sortStatus"));
                    if (sort == null) {
                        sort = request.getParameter("previousSort") == null ? "update_id" : (String) request.getParameter("previousSort");
                        statusSort = true;
                    } else {
                        if (sort.equals((String) request.getParameter("previousSort"))) {
                            statusSort = !statusSort;
                        }
                    }
                    request.setAttribute("THIS_PAGE", thisPage);
                    request.setAttribute("SORT_TRACKING", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("TRACKING_UPDATE_SIZE", (int) Math.ceil(DAO.ClassDAO.getInstance().countRows("update_tracking", "", (milestone != null ? " and milestone_id=" + milestone : "") + (tracking != null ? " and tracking_id=" + tracking : "")
                            + (team != null ? " and tracking_id in (select tracking_id from studentmanagement.function, studentmanagement.tracking where function.function_id=tracking.function_id and team_id=" + team + ")" : "") + (feature != null ? " and tracking_id in (select tracking_id from `studentmanagement`.`tracking`,`studentmanagement`.`function` where function.function_id=tracking.function_id and feature_id=" + feature + ")" : "")
                            + (login.getRole_id() == 1 ? "" : login.getRole_id() == 2 ? " and milestone_id in (select milestone_id from `studentmanagement`.`milestone`,`studentmanagement`.`class` where milestone.class_id = class.class_id and trainer_id=" + login.getUser_id() + ")" : (login.getRole_id() == 4 ? " and milestone_id in (select milestone_id from `studentmanagement`.`milestone`,`studentmanagement`.`class_user` where class_user.class_id=milestone.class_id and user_id=" + login.getUser_id() + ")" : " and milestone_id in (select milestone_id from `studentmanagement`.`milestone`,`studentmanagement`.`class`,`studentmanagement`.`subject` where class.class_id=milestone.class_id and class.subject_id=subject.subject_id and author_id=" + login.getUser_id() + ")"))) * 1.0 / 10));
                    request.setAttribute("LIST_TRACKING_UPDATE", DAO.UpdateTrackingDAO.getInstance().getList(team, milestone, tracking, feature, (thisPage - 1) * 10, 10, login, sort, statusSort));
                    dispathForward(request, response, "tracking/updateList.jsp");
                    break;
                case "update":
                    if (request.getParameter("submitForm") == null) {
                        UpdateTracking update = DAO.UpdateTrackingDAO.getInstance().getUpdateTracking(id);
                        request.setAttribute("TRACKING_CHOOSE", update.getTracking());
                        request.setAttribute("TRACKING_UPDATE_CHOOSE", update);
                        dispathForward(request, response, "tracking/updateDetail.jsp");
                    } else {
                        String note = request.getParameter("note");
                        if (track.getAssignee_id() == login.getUser_id()) {
                            if (DAO.UpdateTrackingDAO.getInstance().updateTracking(new UpdateTracking(id, tracking, "", milestone, note))) {
                                success = "Update update tracking successfully!";
                            } else {
                                error.add("Failed to update update tracking!");
                            }
                            url = ("updateTracking?tracking=" + tracking);
                        } else {
                            error.add("Only assignee of this tracking - " + track.getAssignee().getFull_name() + " - can add and edit!");
                            url = ("updateTracking");
                        }
                    }
                    break;
                case "add":
                    listFeature = DAO.FeatureDAO.getInstance().getListNot(team);
                    request.setAttribute("LIST_FEATURE", listFeature);
                    listTracking = DAO.TrackingDAO.getInstance().getList(team, null,  login.getUser_id(),null, feature, 0, Integer.MAX_VALUE, login, "tracking_id", true, true);
                    request.setAttribute("LIST_TRACKING", listTracking);
                    String submit = request.getParameter("submitForm");
                    if (submit == null) {
                        dispathForward(request, response, "tracking/updateDetail.jsp");
                    } else {
                        String note = request.getParameter("note");
                        if (track.getAssignee_id() == login.getUser_id()) {
                            UpdateTracking update = DAO.UpdateTrackingDAO.getInstance().checkTracking(milestone, tracking);
                            if (update != null) {
                                error.add("This update tracking has existed!");
                                url = ("updateTracking?id=" + update.getUpdate_id());
                            } else {
                                update = new UpdateTracking(0, tracking, "", milestone, note);
                                if (DAO.UpdateTrackingDAO.getInstance().addTracking(update)) {
                                    success = "Add new update tracking successfully!";
                                } else {
                                    error.add("Failed to add new update tracking!");
                                }
                                url = ("updateTracking?tracking=" + tracking);
                            }
                        } else {
                            error.add("Only assignee of this tracking - " + track.getAssignee().getFull_name() + " can add and edit!");
                            url = ("updateTracking");
                        }
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
