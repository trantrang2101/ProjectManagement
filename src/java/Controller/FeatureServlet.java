/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import DAO.FeatureDAO;
import Model.Entity.Classroom;
import Model.Entity.Feature;
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
public class FeatureServlet extends HttpServlet {

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
    private static final Logger logger = Logger.getLogger(FeatureServlet.class);

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        List<String> error = new ArrayList<>();
        String success = "";

        String url = "";
        try (PrintWriter out = response.getWriter()) {
            Integer id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? null : Integer.parseInt(request.getParameter("id"));
            String service = request.getParameter("service");
            if (service == null) {
                service = id != null ? "detail" : "list";
            }
            User login = (User) AppUtils.getLoginedUser(session);
            Classroom classroom = (Classroom) session.getAttribute("CLASS_CHOOSE");
            Integer classFilter = request.getParameter("class") == null || request.getParameter("class").isEmpty() ? null : Integer.parseInt(request.getParameter("class"));
            List<Classroom> listClass = (List<Classroom>) session.getAttribute("LIST_CLASS");
            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            Boolean status = request.getParameter("status") == null || request.getParameter("status").isEmpty() ? null : Boolean.parseBoolean(request.getParameter("status"));
            if (classFilter == null) {
                if (classroom == null) {
                    classroom = listClass.get(0);
                }
                classFilter=classroom.getClass_id();
            }else{
                classroom=DAO.ClassDAO.getInstance().getClass(login, classFilter);
                if (classroom==null) {
                    classroom=listClass.get(0);
                    classFilter=classroom.getClass_id();
                }
            }
            int type = request.getParameter("type") == null || request.getParameter("type").isEmpty() ? DAO.ClassDAO.getInstance().getClass(login, classFilter).getListTeam(login).get(0).getTeam_id() : Integer.parseInt(request.getParameter("type"));
            if (!DAO.ClassUserDAO.getInstance().checkAllow(type, login)) {
                error.add("You are not allow to be here");
                type = DAO.ClassDAO.getInstance().getClass(login, classFilter).getListTeam(login).get(0).getTeam_id();
            }
            if (type > 0) {
                Team team_choose = DAO.TeamDAO.getInstance().getTeam(type);
                classFilter = team_choose.getClass_id();
                request.setAttribute("TYPE_CHOOSE", team_choose);
            }
            session.setAttribute("CLASS_CHOOSE", classroom);
            request.setAttribute("LIST_TEAM", DAO.TeamDAO.getInstance().getList(classFilter, login, "", 0, Integer.MAX_VALUE, "team_id", true, 1));
            switch (service) {
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
                        sort = request.getParameter("previousSort") == null ? "feature_id" : (String) request.getParameter("previousSort");
                        statusSort = true;
                    } else {
                        if (sort.equals((String) request.getParameter("previousSort"))) {
                            statusSort = !statusSort;
                        }
                    }
                    request.setAttribute("SORT_FEATURE", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("FEATURE_SIZE", (int) Math.ceil(DAO.FeatureDAO.getInstance().countRows("feature", search, (login.getRole_id() == 4 ? "and team_id = (select team_id from class_user where user_id="+login.getUser_id()+" )" :"".concat(login.getRole_id()==2?"and team_id in (select team_id from `studentmanagement`.`team` where class_id in (select class_id from class where subject_id in (select subject_id from subject where author_id="+login.getUser_id()+")))":"").concat(login.getRole_id()==3?"and team_id in (select team_id from `studentmanagement`.`team` where class_id in (select class_id from class where trainer_id in (select trainer_id from class where trainer_id="+login.getUser_id()+")))":"")) 
                + (type == 0 ? "" : " and team_id = " + type) 
                + (status==null ? "" : " and status = " + status)) * 1.0 / 10));
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("STATUS_CHOOSE", status);
                    request.setAttribute("THIS_PAGE", thisPage);
                    request.setAttribute("LIST_FEATURE", DAO.FeatureDAO.getInstance().getList(type, login, search, (thisPage - 1) * 10, 10, sort, statusSort, status));
                    dispathForward(request, response, "feature/list.jsp");
                    break;
                case "changeStatus":
                    status = Boolean.parseBoolean(request.getParameter("status"));
                    if (!DAO.FeatureDAO.getInstance().updateStatus(id, !status)) {
                        error.add("Update Status Failed!");
                    } else {
                        success = "Update Status Successfully!";
                    }
                    url = "feature";
                    break;
                case "update":
                    int team_id = Integer.parseInt(request.getParameter("type"));
                    String feature_name = request.getParameter("title");
                    status = request.getParameter("status") != null;
                    String description = request.getParameter("description");
                    if (!DAO.FeatureDAO.getInstance().updateFeature(new Feature(id, team_id, feature_name, description, status))) {
                        error.add("Update Feature Fail!");
                        request.setAttribute("ERROR", error);
                    } else {
                        success = "Update Successfully!";
                    }
                    url = "feature?service=list";
                    break;
                case "add":
                    String submit = request.getParameter("submitForm");
                    if (submit == null) {
                        dispathForward(request, response, "feature/detail.jsp");
                    } else {
                        if (submit.equals("class")) {
                            dispathForward(request, response, "feature/detail.jsp");
                        } else {
                            team_id = Integer.parseInt(request.getParameter("type"));
                            feature_name = request.getParameter("title");
                            status = request.getParameter("status") != null;
                            description = request.getParameter("description");
                            if (FeatureDAO.getInstance().checkAddFeature(team_id, feature_name)!=-1) {
                                error.add("This feature has existed in this team!");
                            } else {
                                int addid = FeatureDAO.getInstance().addFeature(new Feature(0, team_id, feature_name, description, status));
                                if (addid < 0) {
                                    error.add("Add Feature Fail!");
                                } else {
                                    success = "Add successfully!";
                                }
                            }
                            url = "feature";
                        }
                    }
                    break;

                case "detail":
                    request.setAttribute("serve", "update");
                    request.setAttribute("FEATURE_CHOOSE", DAO.FeatureDAO.getInstance().getFeature(id));
                    dispathForward(request, response, "feature/detail.jsp");
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
