/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import DAO.SubjectDAO;
import Model.Entity.Subject;
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
 * @author ADMIN
 */
public class SubjectServlet extends HttpServlet {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(SubjectServlet.class);

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
            /* TODO output your page here. You may use following sample code. */
            String service = request.getParameter("service");
            HttpSession session = request.getSession();
            User login = (User) AppUtils.getLoginedUser(session);
            List<String> error = new ArrayList<>();
            int authorFilter = request.getParameter("authorFilter") != null && !request.getParameter("authorFilter").isEmpty() ? Integer.parseInt(request.getParameter("authorFilter")) : -1;

            Integer statusFilter = request.getParameter("statusFilter") != null && !request.getParameter("statusFilter").isEmpty() ? Integer.parseInt(request.getParameter("statusFilter")) : null;
            int id = request.getParameter("id") != null ? Integer.parseInt(request.getParameter("id")) : -1;
            if (service == null) {
                service = id > 0 ? "detail" : "list";
            }
            String url = "";
            String success = "";
            

            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
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
                        sort = request.getParameter("previousSort") == null ? "subject_id" : (String) request.getParameter("previousSort");
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
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("SORT_SUBJECT", sort);
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("THIS_PAGE", thisPage);
                    request.setAttribute("SUBJECT_SIZE", (int) Math.ceil(DAO.SubjectDAO.getInstance().countRows("subject", search, (statusFilter == null ? "" : " and status= " + statusFilter) + (authorFilter > 0 ? " and author_id=" + authorFilter : "") + " and author_id in (select user_id from user where `email` like \\'%" + search + "%\\' or `full_name` like \\'%" + search + "%\\' or `mobile` like \\'%" + search + "%\\' or `roll_number` like \\'%" + search + "%\\')" + (login == null || login.getRole_id() == 1 ? "" : " and status=1 ".concat(login.getRole_id() == 2 ? " and author_id = " + login.getUser_id() : login.getRole_id() == 3 ? " and subject_id in (select distinct subject_id " + "from `class` where trainer_id=" + login.getUser_id() + ")" : " and subject_id in (select distinct subject_id from `class`,`class_user`" + " where class.class_id = class_user.class_id and user_id=" + login.getUser_id() + ")"))) * 1.0 / 10));
                    request.setAttribute("LIST_SUBJECT", DAO.SubjectDAO.getInstance().getList(search, login, (thisPage - 1) * 10, 10, sort, statusSort, statusFilter, authorFilter));
                    if (authorFilter > 0) {
                        request.setAttribute("AUTHOR_CHOOSE", DAO.UserDAO.getInstance().getUser(authorFilter, true));
                    }
                    dispathForward(request, response, "subject/list.jsp");
                    break;
                case "detail":
                    Subject subject = SubjectDAO.getInstance().getSubject(id);
                    if (subject != null) {
                        request.setAttribute("SUBJECT_CHOOSE", subject);
                        dispathForward(request, response, "subject/detail.jsp");
                    } else {
                        error.add("No subject found!");
                        url = "subject";
                    }
                    break;

                case "changeStatus":
                    boolean status = Boolean.parseBoolean(request.getParameter("status"));
                    if (!DAO.SubjectDAO.getInstance().updateStatus(id, !status)) {
                        error.add("Update Status Failed!");
                    } else {
                        success = "Update Successfully!";
                    }
                    url = "subject";
                    break;

                case "add":
                    if (request.getParameter("submit") == null) {
                        dispathForward(request, response, "subject/detail.jsp");
                    } else {
                        String subject_code = request.getParameter("code");
                        String subject_name = request.getParameter("name");
                        int author_id = Integer.parseInt(request.getParameter("author"));
                        String description = request.getParameter("description");
                        status = request.getParameter("status") != null;

                        if (SubjectDAO.getInstance().checkAddSubject(subject_code)) {
                            error.add("This subject has existed!");
                            url = "subject";
                        } else {
                            int addid = SubjectDAO.getInstance().addSubject(new Subject(subject_code, subject_name, author_id, description, status));
                            if (addid < 0) {
                                error.add("Add Setting Fail!");
                                url = "subject";
                            } else {
                                success = "Add successfully!";
                                url = "subject?id=" + addid;
                            }
                        }
                    }
                    break;
                case "update":
                    String subject_code = request.getParameter("code");
                    String subject_name = request.getParameter("name");
                    int author_id = Integer.parseInt(request.getParameter("author"));
                    status = request.getParameter("status") != null;
                    String description = request.getParameter("description");
                    if (!SubjectDAO.getInstance().updateSubject(new Subject(id, subject_code, subject_name, author_id, description, status))) {
                        error.add("Update Subject Fail!");
                        request.setAttribute("ERROR", error);
                    } else {
                        success = "Update success fully!";
                    }
                    url = "subject";
                    break;
                case "delete":
                    if (DAO.SettingDAO.getInstance().getSetting(login.getRole_id()).getSetting_title().equalsIgnoreCase("Admin")) {
                        DAO.SubjectDAO.getInstance().updateStatus(id, false);
                        success = "Delete successfully!";
                    } else {
                        error.add("Only Admin can change status!");
                    }
                    url = "subject";
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
