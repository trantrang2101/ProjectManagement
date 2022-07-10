/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import DAO.IterationDAO;
import DAO.SettingDAO;
import Model.Entity.Iteration;
import Model.Entity.Subject;
import Model.Entity.User;
import Utils.AppUtils;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.AbstractList;
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
public class IterationServlet extends HttpServlet {

    
    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(IterationServlet.class);
    
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
        HttpSession session = request.getSession();
        List<String> error = new ArrayList<>();
        String success = "";
            success=success.contains("Login")?"":success;
        String url = "";
        try (PrintWriter out = response.getWriter()) {

            Integer id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? null : Integer.parseInt(request.getParameter("id"));
            String service = request.getParameter("service");
            if (service == null) {
                service = id != null ? "detail" : "list";
            }
            User login = (User) AppUtils.getLoginedUser(session);
            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            int type = request.getParameter("type") == null || request.getParameter("type").isEmpty() ? 0 : Integer.parseInt(request.getParameter("type"));
            Boolean status = request.getParameter("status") == null || request.getParameter("status").isEmpty() ? null : Boolean.parseBoolean(request.getParameter("status"));
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
                    request.setAttribute("SORT_ITERATION", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("STATUS_CHOOSE", status);
                    request.setAttribute("ITERATION_SIZE", (int) Math.ceil(DAO.IterationDAO.getInstance().countRows("iteration", search, (type == 0 ? "" : " and subject_id = " + type)) * 1.0 / 10));
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("THIS_PAGE", thisPage);
                    if (type > 0) {
                        request.setAttribute("SUBJECT_CHOOSE", DAO.SubjectDAO.getInstance().getSubject(type));
                    }
                    request.setAttribute("LIST_ITERATION", DAO.IterationDAO.getInstance().getList(type, login, search, (thisPage - 1) * 10, 10, sort, statusSort, status));
                    dispathForward(request, response,"iteration/list.jsp");
                    break;
                case "changeStatus":
                    int settingID = Integer.parseInt(request.getParameter("id"));
                    status = Boolean.parseBoolean(request.getParameter("status"));
                    if (!DAO.IterationDAO.getInstance().updateStatus(settingID, !status)) {
                        error.add("Update Status Failed!");
                    } else {
                        success = "Update Status Successfully!";
                    }
                    url = "iteration?service=list";
                    break;
                case "update":
                    id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? null : Integer.parseInt(request.getParameter("id"));
                    int subjectID = Integer.parseInt(request.getParameter("subject_id"));
                    String iteration_name = request.getParameter("title");
                    int duration = Integer.parseInt(request.getParameter("duration"));
                    status = request.getParameter("status") != null;
                    String description = request.getParameter("description");
                    if (!DAO.IterationDAO.getInstance().updateIteration(new Iteration(id, subjectID, iteration_name, duration, description, status))) {
                        error.add("Update Iteration Fail!");
                        request.setAttribute("ERROR", error);
                    } else {
                        success = "Update Successfully!";
                    }
                    url = "iteration?service=list";
                    break;
                case "add":
                    if (request.getParameter("submit") == null) {
                        dispathForward(request, response, "iteration/detail.jsp");
                    } else {
                        subjectID = Integer.parseInt(request.getParameter("subject_id"));
                        iteration_name = request.getParameter("title");
                        duration = Integer.parseInt(request.getParameter("duration"));
                        status = request.getParameter("status") != null;
                        description = request.getParameter("description");
                        if (IterationDAO.getInstance().checkAddIter(Integer.toString(subjectID), iteration_name)) {
                            error.add("This iteration has existed in this subject!");
                        } else {
                            int addid = IterationDAO.getInstance().addIteration(new Iteration(0, subjectID, iteration_name, duration, description, status));
                            if (addid < 0) {
                                error.add("Add Iteration Fail!");
                            } else {
                                success = "Add successfully!";
                            }
                        }
                        url = "iteration";
                    }
                    break;

                case "detail":
                    request.setAttribute("ITERATION_CHOOSE", DAO.IterationDAO.getInstance().getIteration(id));
                    dispathForward(request, response, "iteration/detail.jsp");
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
