/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import DAO.SubjectSettingDAO;
import Model.Entity.Setting;
import Model.Entity.SubjectSetting;
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
import java.util.HashMap;
import org.apache.log4j.Logger;

/**
 *
 * @author Admin
 */
public class SubjectSettingServlet extends HttpServlet {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(SubjectSettingServlet.class);

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

        try (PrintWriter out = response.getWriter()) {
            String service = request.getParameter("service");
            String url = "";
//            String id = request.getParameter("id");
            Integer id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? null : Integer.parseInt(request.getParameter("id"));
            if (service == null) {
                service = id != null ? "detail" : "list";
            }
            User login = AppUtils.getLoginedUser(session);
            Integer statusFilter = request.getParameter("statusFilter") != null && !request.getParameter("statusFilter").isEmpty() ? Integer.parseInt(request.getParameter("statusFilter")) : null;
            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            int type = (request.getParameter("type") == null || request.getParameter("type").isEmpty()) ? 0 : Integer.parseInt(request.getParameter("type"));
            switch (service) {
                case "list":
                    if (type > 0) {
                        request.setAttribute("SUBJECT_CHOOSE", DAO.SubjectDAO.getInstance().getSubject(type));
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
                        sort = request.getParameter("previousSort") == null ? "setting_id" : (String) request.getParameter("previousSort");
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
                    request.setAttribute("SORT_SETTING", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("THIS_PAGE", thisPage);
                    request.setAttribute("SUBJECT_SETTING_SIZE", (int) Math.ceil(DAO.SubjectSettingDAO.getInstance().countRows("subject_setting", search, (type == 0 ? "" : " and subject_id = " + type) + (login.getRole_id() == 2 ? " and subject_id in (select subject_id from subject where author_id=" + login.getUser_id() + ")" : "")) * 1.0 / 10));
                    request.setAttribute("LIST_SUBJECT_SETTING", DAO.SubjectSettingDAO.getInstance().getList(type, search, login, (thisPage - 1) * 10, 10, sort, statusSort, statusFilter));
                    dispathForward(request, response, "subjectSetting/list.jsp");
                    break;
                case "detail":
//                    SubjectSetting set = SubjectSettingDAO.getInstance().getSubjectSetting(Integer.parseInt(id));
//                    if (set != null) {
//                        request.setAttribute("SETTING_CHOOSE", set);
//                    }
//                    request.setAttribute("SETTING_LIST_SUBJECT", DAO.SettingDAO.getInstance().getList(5, "", 0, Integer.MAX_VALUE, "setting_id", true));
//                    dispathForward(request, response, "subjectSetting/detail.jsp");
//                    break;

                    SubjectSetting set = SubjectSettingDAO.getInstance().getSubjectSetting(id);
                    if (set != null) {
                        request.setAttribute("SUBJECT_SETTING_CHOOSE", set);
                        dispathForward(request, response, "subjectSetting/detail.jsp");
                    } else {
                        error.add("No subject found!");
                        url = "subjectSetting";
                    }
                    break;
                case "changeStatus":
                    boolean status = Boolean.parseBoolean(request.getParameter("status"));
                    if (!DAO.SubjectSettingDAO.getInstance().updateStatus(id, !status)) {
                        error.add("Update Status Failed!");
                    } else {
                        session.setAttribute("SUCCESS", "Update Successfully!");
                    }
                    url = "subjectSetting";
                    break;
                case "update":
                    int subject = Integer.parseInt(request.getParameter("subjectId"));
                    int typeID = Integer.parseInt(request.getParameter("typeID"));
                    String title = request.getParameter("title");
                    String description = request.getParameter("description");
                    status = request.getParameter("status") != null;
                    int value = Integer.parseInt(request.getParameter("value"));
                    int display = Integer.parseInt(request.getParameter("display"));
                    if (!DAO.SubjectSettingDAO.getInstance().updateSubjectSetting(new SubjectSetting(id, subject, typeID, title, value, display, description, status))) {
                        error.add("Update Setting Fail!");
                        request.setAttribute("ERROR", error);
                    } else {
                        success = "Update successfully!";
                    }
                    url = "subjectSetting";
                    break;
                case "add":
                    if (request.getParameter("submit") == null) {
                        dispathForward(request, response, "subjectSetting/detail.jsp");
                    } else {
                        typeID = Integer.parseInt(request.getParameter("typeID"));
                        subject = Integer.parseInt(request.getParameter("subjectId"));
                        title = request.getParameter("title");
                        description = request.getParameter("description");
                        status = request.getParameter("status") != null;
                        value = Integer.parseInt(request.getParameter("value"));
                        display = Integer.parseInt(request.getParameter("display"));
                        if (DAO.SubjectSettingDAO.getInstance().checkAddSubjectSetting(typeID, subject, value, status)) {
                            error.add("This subjectSetting has existed!");
                        } else {
                            int addid = DAO.SubjectSettingDAO.getInstance().addSubjectSetting(new SubjectSetting(0, subject, typeID, title, value, display, description, status));
                            if (addid < 0) {
                                error.add("Add Setting Fail!");
                            } else {
                                success = "Add successfully!";
                            }
                        }
                        url = "subjectSetting";
                    }
                    break;
            }
            if (!success.isEmpty()) {
                logger.info(success);
                session.setAttribute("SUCCESS", success);
            }
            if (!error.isEmpty()) {
                logger.warn(error);
                session.setAttribute("ERROR", error);
            }
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
