/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import DAO.TeamDAO;
import Model.Entity.Team;
import Model.Entity.User;
import Utils.AppUtils;
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
import java.io.PrintWriter;
import java.io.StringWriter;
import org.apache.log4j.Logger;

/**
 *
 * @author Admin
 */
public class TeamServlet extends HttpServlet {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(TeamServlet.class);

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
        HttpSession session = request.getSession();
        List<String> error = new ArrayList<>();
        try (PrintWriter out = response.getWriter()) {
            String service = request.getParameter("service");
            Integer id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? null : Integer.parseInt(request.getParameter("id"));
            String url = "";
            if (service == null) {
                service = id != null ? "detail" : "list";
            }
            User login = (User) AppUtils.getLoginedUser(session);
            Integer statusFilter = request.getParameter("statusFilter") != null && !request.getParameter("statusFilter").isEmpty() ? Integer.parseInt(request.getParameter("statusFilter")) : null;
            String success = "";
            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            Integer classroom = request.getParameter("classroom") == null || request.getParameter("classroom").isEmpty() ? null : Integer.parseInt(request.getParameter("classroom"));
            switch (service) {
                case "list":
                    if (classroom != null) {
                        request.setAttribute("CLASS_CHOOSE", DAO.ClassDAO.getInstance().getClass(login, classroom));
                    }
                    String search = request.getParameter("search");
                    if (search == null || search.isEmpty()) {
                        search = "";
                    } else {
                        search = search.trim();
                    }
                    String sort = request.getParameter("sort");
                    boolean statusSort = request.getParameter("sortStatus") == null ? true : Boolean.parseBoolean(request.getParameter("sortStatus"));
                    if (sort == null) {
                        sort = request.getParameter("previousSort") == null ? "class_id" : (String) request.getParameter("previousSort");
                    } else {
                        if (sort.equals((String) request.getParameter("previousSort"))) {
                            statusSort = !statusSort;
                        }
                    }
                    if (statusFilter != null) {
                        request.setAttribute("SORT_FILTER", statusFilter);
                    }
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("THIS_PAGE", thisPage);
                    request.setAttribute("SORT_TEAM", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("TEAM_SIZE", (int) Math.ceil(TeamDAO.getInstance().countRows("team", search,
                            (statusFilter == null ? "" : " and status = " + statusFilter).concat(classroom == null ? "" : " and class_id = " + classroom)) * 1.0 / 10));
                    request.setAttribute("LIST_TEAM", TeamDAO.getInstance().getList(classroom, login, search, (thisPage - 1) * 10, 10, sort, statusSort, statusFilter));
                    request.setAttribute("SETTING_SIZE", (int) Math.ceil(TeamDAO.getInstance().countRows("team", search, (classroom == null ? "" : " and class_id = " + classroom)) * 1.0 / 10));
                    dispathForward(request, response, "team/list.jsp");
                    break;
                case "changeStatus":
                    int teamID = Integer.parseInt(request.getParameter("id"));
                    boolean status = Boolean.parseBoolean(request.getParameter("status"));
                    if (!DAO.TeamDAO.getInstance().updateStatus(teamID, !status)) {
                        error.add("Update Status Failed!");
                    } else {
                        success = "Update Successfully!";
                    }
                    url = "team";
                    break;
                case "detail":
                    teamID = Integer.parseInt(request.getParameter("id"));
                    Team t = TeamDAO.getInstance().getTeam(teamID);
                    if (t != null) {
                        request.setAttribute("TEAM_CHOOSE", t);
                    }
                    dispathForward(request, response, "team/detail.jsp");
                    break;
                case "update":
                    int classID = Integer.parseInt(request.getParameter("classId"));
                    String team_name = request.getParameter("teamName");
                    String topic_code = request.getParameter("topicCode");
                    String topic_name = request.getParameter("topicName");
                    status = request.getParameter("status") != null;
                    String gitlab_url = request.getParameter("gitlabUrl");
                    String accessToken = request.getParameter("accessToken");
                    if (gitlab_url == null) {
                        gitlab_url = "";
                    }
                    if (accessToken == null) {
                        accessToken = "";
                    }
                    if (!TeamDAO.getInstance().updateTeam(new Team(id, classID, team_name, topic_code, topic_name, gitlab_url, status, accessToken))) {
                        error.add("Update Team Fail!");
                        request.setAttribute("ERROR", error);
                    } else {
                        request.setAttribute("SUCCESS", "Update successfully!");
                    }
                    url = "team";
                    break;
                case "add":
                    if (request.getParameter("submit") == null) {
                        dispathForward(request, response, "team/detail.jsp");
                    } else {
                        classID = Integer.parseInt(request.getParameter("classId"));
                        team_name = request.getParameter("teamName");
                        topic_code = request.getParameter("topicCode");
                        topic_name = request.getParameter("topicName");
                        status = request.getParameter("status") != null;
                        gitlab_url = request.getParameter("gitlabUrl").replace("https://", "");
                        accessToken = request.getParameter("accessToken");
                        if (gitlab_url == null) {
                            gitlab_url = "";
                        }
                        if (accessToken == null) {
                            accessToken = "";
                        }
                        if (TeamDAO.getInstance().checkAddTeam(team_name, classID, status) > 0) {
                            error.add("This team has existed!");
                        } else {
                            int addid = TeamDAO.getInstance().addTeam(new Team(0, classID, team_name, topic_code, topic_name, gitlab_url, status, accessToken));
                            if (addid < 0) {
                                error.add("Add Team Fail!");
                            } else {
                                request.setAttribute("SUCCESS", "Add successfully!");
                            }
                            url = "team?service=list";
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
