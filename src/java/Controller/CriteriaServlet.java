/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import DAO.CriteriaDAO;
import Model.Entity.*;
import Model.Entity.User;
import Utils.AppUtils;
import java.io.IOException;
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
 * @author ADMIN
 */
public class CriteriaServlet extends HttpServlet {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(CriteriaServlet.class);

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
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            User login = (User) AppUtils.getLoginedUser(session);
            List<String> error = new ArrayList<>();
            String service = request.getParameter("service");
            Integer statusFilter = request.getParameter("statusFilter") != null && !request.getParameter("statusFilter").isEmpty() ? Integer.parseInt(request.getParameter("statusFilter")) : null;
            String id = request.getParameter("id");
            String url = "";
            if (service == null) {
                service = id != null ? "detail" : "list";
            }
            String success = "";

            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            int type = request.getParameter("type") == null || request.getParameter("type").isEmpty() ? ((List<Subject>) session.getAttribute("LIST_SUBJECT")).get(0).getSubject_id() : Integer.parseInt(request.getParameter("type"));
            List<Iteration> list = DAO.IterationDAO.getInstance().getList(type, login, "", 0, Integer.MAX_VALUE, "iteration_id", true, true);
            Integer iteration = request.getParameter("iteration") != null && !request.getParameter("iteration").isEmpty() ? Integer.parseInt(request.getParameter("iteration")) : null;
            request.setAttribute("LIST_ITERATION", list);
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
                        sort = request.getParameter("previousSort") == null ? "iteration_id" : (String) request.getParameter("previousSort");
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
                    if (type > 0) {
                        request.setAttribute("SUBJECT_CHOOSE", DAO.SubjectDAO.getInstance().getSubject(type));
                    }
                    if (iteration != null) {
                        request.setAttribute("SORT_ITERATION", DAO.IterationDAO.getInstance().getIteration(iteration));
                    }

                    request.setAttribute("SORT_CRITERIA", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("LIST_CRITERIA", DAO.CriteriaDAO.getInstance().getList(type, search, login, (thisPage - 1) * 10, 10, sort, statusSort, statusFilter, iteration));
                    request.setAttribute("CRITERIA_SIZE", (int) Math.ceil(DAO.CriteriaDAO.getInstance().countRows("evaluation_criteria", search, (iteration == null ? "" : " and iteration_id= " + iteration)
                            + (statusFilter == null ? "" : " and status= " + statusFilter) + (login.getRole_id() == 2 ? (type == 0 ? " and iteration_id in (select iteration_id from iteration join subject on subject.subject_id = iteration.subject_id"
                            + " where subject.author_id = " + login.getUser_id() + ")"
                            : " and iteration_id in (select iteration_id from iteration join subject on subject.subject_id = iteration.subject_id"
                            + " where iteration.subject_id = " + type + " and subject.author_id = " + login.getUser_id() + ")") : (type == 0 ? ""
                            : " and iteration_id in (select iteration_id from iteration join subject on subject.subject_id = iteration.subject_id where iteration.subject_id =  " + type + ")"))) * 1.0 / 10));
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("THIS_PAGE", thisPage);
                    dispathForward(request, response, "criteria/list.jsp");
                    break;
                case "changeStatus":

                    int criteriaID = Integer.parseInt(request.getParameter("id"));
                    boolean status = Boolean.parseBoolean(request.getParameter("status"));
                    if (!DAO.CriteriaDAO.getInstance().updateStatus(criteriaID, !status)) {
                        error.add("Update Status Failed because the current criteria weight is over 100% when active, please deactive unused criteria!");
                    } else {
                        success = "Update Successfully!";
                    }
                    String inDetail = request.getParameter("inDetail");
                    if (inDetail != null) {
                        url = "criteria?id=" + criteriaID + "&service=detail";
                    } else {
                        url = "criteria";
                    }

                    break;
                case "changeTeamEval":
                    criteriaID = Integer.parseInt(request.getParameter("id"));
                    boolean team_eval = Boolean.parseBoolean(request.getParameter("team_eval"));
                    if (!DAO.CriteriaDAO.getInstance().updateTeamEval(criteriaID, !team_eval)) {
                        error.add("Update Team Evaluation Failed!");
                    } else {
                        success = "Update Team Evaluation Successfully!";
                    }
                    url = "criteria";
                    break;
                case "detail":
                    criteriaID = Integer.parseInt(request.getParameter("id"));
                    Criteria crit = CriteriaDAO.getInstance().getCriteria(criteriaID);
                    if (crit != null) {
                        request.setAttribute("CRITERIA_CHOOSE", crit);

                    }
                    dispathForward(request, response, "criteria/detail.jsp");
                    break;
                case "update":

                    status = request.getParameter("status") != null;

                    int criteria_id = Integer.parseInt(id);
                    String title = request.getParameter("title");
                    String description = request.getParameter("description");
                    double weight = Double.parseDouble(request.getParameter("weight"));
                    team_eval = request.getParameter("team_eval") != null;
                    int iteration_id = Integer.parseInt(request.getParameter("iteration_id"));
                    int order = Integer.parseInt(request.getParameter("order"));
                    int loc = Integer.parseInt(request.getParameter("loc"));

                    if (!DAO.CriteriaDAO.getInstance().updateCriteria(new Criteria(criteria_id, iteration_id, title, description, weight, team_eval, order, loc, status))) {
                        error.add("Update Criteria Fail!");
                        request.setAttribute("ERROR", error);
                    } else {
                        success = "Update Successfully!";
                    }
                    url = "criteria?service=list";
                    break;
                case "add":
                    String submit = request.getParameter("submitChange");
                    if (submit == null) {
                        dispathForward(request, response, "criteria/detail.jsp");
                    } else {
                        Integer subject_id = request.getParameter("subject_id") != null ? Integer.parseInt(request.getParameter("subject_id")) : null;
                        iteration = request.getParameter("iteration_id") != null ? Integer.parseInt(request.getParameter("iteration_id")) : null;
                        if (subject_id != null && submit.equals("changeSubject")) {
                            request.setAttribute("SUBJECT_CHOOSE", DAO.SubjectDAO.getInstance().getSubject(subject_id));
                            dispathForward(request, response, "criteria/detail.jsp");
                        } else {
                            status = request.getParameter("status") != null;
                            title = request.getParameter("title");
                            team_eval = request.getParameter("team_eval") != null;
                            description = request.getParameter("description");
                            weight = Double.parseDouble(request.getParameter("weight"));
                            order = Integer.parseInt(request.getParameter("order"));
                            loc = Integer.parseInt(request.getParameter("loc"));
                            if (DAO.CriteriaDAO.getInstance().addCriteria(new Criteria(iteration, title, description, weight, team_eval, order, loc, status))) {
                                success = "Add criteria successfully";
                            } else {
                                error.add("Add criteria failed!");
                            }
                            url = "criteria?service=list";
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
        } catch (ServletException | IOException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
    }

    public void dispathForward(HttpServletRequest request, HttpServletResponse response, String page) {
        RequestDispatcher dispath = request.getRequestDispatcher(page);
        try {
            dispath.forward(request, response);
        } catch (ServletException | IOException ex) {
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
