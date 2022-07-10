/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import DAO.SettingDAO;
import Model.Entity.Classroom;
import Model.Entity.User;
import Utils.AppUtils;
import java.io.*;
import java.util.*;
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
 * @author win
 */
public class ClassServlet extends HttpServlet {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(ClassServlet.class);

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
        try (PrintWriter out = response.getWriter()) {
            String url = "";
            String service = request.getParameter("service");
            Integer id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? null : Integer.parseInt(request.getParameter("id"));
            if (service == null) {
                service = id != null ? "detail" : "list";
            }
            String success = "";

            Integer type = request.getParameter("type") == null || request.getParameter("type").isEmpty() ? null : Integer.parseInt(request.getParameter("type"));
            Integer statusFilter = request.getParameter("status") == null || request.getParameter("status").isEmpty() || request.getParameter("status").equals("on") ? null : Integer.parseInt(request.getParameter("status"));
            Integer trainer = request.getParameter("trainer") == null || request.getParameter("trainer").isEmpty() ? null : Integer.parseInt(request.getParameter("trainer"));
            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            User login = (User) AppUtils.getLoginedUser(session);
            switch (service) {
                case "list":
                    String search = request.getParameter("search");
                    if (search == null || search.isEmpty()) {
                        search = "";
                    } else {
                        search = search.trim();
                    }
                    if (type != null) {
                        request.setAttribute("SUBJECT_CHOOSE", DAO.SubjectDAO.getInstance().getSubject(type));
                    }
                    if (trainer != null) {
                        request.setAttribute("TRAINER_CHOOSE", DAO.UserDAO.getInstance().getUser(trainer, false));
                    }
                    if (statusFilter != null) {
                        request.setAttribute("SORT_FILTER", statusFilter);
                    }
                    String sort = request.getParameter("sort");
                    boolean statusSort = request.getParameter("sortStatus") == null ? true : Boolean.parseBoolean(request.getParameter("sortStatus"));
                    if (sort == null) {
                        sort = request.getParameter("previousSort") == null ? "class_code" : (String) request.getParameter("previousSort");
                        statusSort = true;
                    } else {
                        if (sort.equals((String) request.getParameter("previousSort"))) {
                            statusSort = !statusSort;
                        } else {
                            statusSort = true;
                        }
                    }
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("THIS_PAGE", thisPage);
                    request.setAttribute("SORT_CLASS", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("LIST_TERM", DAO.SettingDAO.getInstance().getList(2, true, "", 0, Integer.MAX_VALUE, "setting_id", true));
                    request.setAttribute("CLASS_SIZE", (int) Math.ceil(DAO.ClassDAO.getInstance().countRows("class", search, (trainer != null ? " and trainer_id=" + trainer : "").concat(type != null ? " and subject_id=" + type : "")
                            + (login.getRole_id() == 1 ? "" : " and status=1".concat(login.getRole_id() == 3 ? " and trainer_id=" + login.getUser_id() : login.getRole_id() == 4 ? " and class_id in (select class_id from `studentmanagement`.`class_user` where user_id=" + login.getUser_id() + ")" : " and subject_id in (select subject_id from `studentmanagement`.`subject` where author_id=" + login.getUser_id() + ")"))) * 1.0 / 10));
                    request.setAttribute("LIST_CLASS", DAO.ClassDAO.getInstance().getList(search, (thisPage - 1) * 10, 24, login, type, trainer, statusFilter, sort, statusSort));
                    dispathForward(request, response, "class/list.jsp");
                    break;
                case "changeStatus":
                    boolean statusChange = Boolean.parseBoolean(request.getParameter("status"));
                    if (DAO.ClassDAO.getInstance().updateChangeStatus(id, !statusChange)) {
                        session.setAttribute("LIST_CLASS", DAO.ClassDAO.getInstance().getList("", 0, Integer.MAX_VALUE, login, null, null, 1, "class_year", true));
                        success = "Update Status successfully!";
                    } else {
                        error.add("Update Status failed!");
                    }
                    url = "class";
                    break;
                case "detail":
                    Classroom cm = DAO.ClassDAO.getInstance().getClass(login, id);
                    if (cm != null) {
                        request.setAttribute("CLASS_CHOOSE", cm);
                        request.setAttribute("LIST_ITERATION", DAO.IterationDAO.getInstance().getList(cm.getSubject_id(), login, "", 0, Integer.MAX_VALUE, "iteration_id", true, true));
                        dispathForward(request, response, "student/class.jsp");
                    } else {
                        error.add("You are not allow to go to this class");
                        url = "class?service=list";
                    }
                    break;
                case "delete":
                    if (DAO.ClassDAO.getInstance().updateChangeStatus(id, false)) {
                        success = "Delete successfully!";
                    } else {
                        error.add("Delete failed!");
                    }
                    url = "class";
                    break;
                case "update":
                    if (request.getParameter("submit") == null) {
                        request.setAttribute("LIST_TEACHER", DAO.UserDAO.getInstance().getList(3, "", null, false, 0, Integer.MAX_VALUE, 1));
                        request.setAttribute("LIST_TERM", DAO.SettingDAO.getInstance().getList(2, true, "", 0, Integer.MAX_VALUE, "setting_id", true));
                        request.setAttribute("CLASS_CHOOSE", DAO.ClassDAO.getInstance().getClass(login, id));
                        dispathForward(request, response, "class/update.jsp");
                    } else {
                        String classCode = request.getParameter("classCode");
                        int teacher = Integer.parseInt(request.getParameter("teacher"));
                        int subject = Integer.parseInt(request.getParameter("subject"));
                        int sem = Integer.parseInt(request.getParameter("sem"));
                        int year = Integer.parseInt(request.getParameter("year"));
                        boolean block5 = request.getParameter("block5") != null;
                        boolean status = request.getParameter("status") != null;
                        String description = request.getParameter("description");
                        String gitlab_url = request.getParameter("gitlabUrl").replace("https://", "");
                        String accessToken = request.getParameter("accessToken");
                        if (gitlab_url == null) {
                            gitlab_url = "";
                        }
                        if (accessToken == null) {
                            accessToken = "";
                        }
                        Classroom c = new Classroom(id, classCode, teacher, subject, year, sem, block5, status, description, gitlab_url, accessToken);
                        if (DAO.ClassDAO.getInstance().updateClassroom(c)) {
                            session.setAttribute("LIST_CLASS", DAO.ClassDAO.getInstance().getList("", 0, Integer.MAX_VALUE, login, null, null, 1, "class_year", true));
                            success = "Update successfully!";
                        } else {
                            error.add("Update failed!");
                        }
                        url = "class?service=list";
                    }
                    break;
                case "add":
                    if (request.getParameter("submit") == null) {
                        request.setAttribute("LIST_TERM", DAO.SettingDAO.getInstance().getList(2, true, "", 0, Integer.MAX_VALUE, "setting_id", true));
                        dispathForward(request, response, "class/update.jsp");
                    } else {
                        String classCode = request.getParameter("classCode");
                        int teacher = Integer.parseInt(request.getParameter("teacher"));
                        int subject = Integer.parseInt(request.getParameter("subject"));
                        int sem = Integer.parseInt(request.getParameter("sem"));
                        int year = Integer.parseInt(request.getParameter("year"));
                        boolean block5 = request.getParameter("block5") != null;
                        boolean status = request.getParameter("status") != null;
                        String description = request.getParameter("description");
                        String gitlab_url = request.getParameter("gitlabUrl").replace("https://", "");
                        String accessToken = request.getParameter("accessToken");
                        if (gitlab_url == null) {
                            gitlab_url = "";
                        }
                        if (accessToken == null) {
                            accessToken = "";
                        }
                        if (DAO.ClassDAO.getInstance().checkClass(classCode, subject, year, sem, block5)) {
                            error.add("Class has exited!");
                        } else {
                            Classroom c = new Classroom(-1, classCode, teacher, subject, year, sem, block5, status, description, gitlab_url, accessToken);
                            if (DAO.ClassDAO.getInstance().addClass(c)) {
                                success = "Add successfully!";
                                session.setAttribute("LIST_CLASS", DAO.ClassDAO.getInstance().getList("", 0, Integer.MAX_VALUE, login, null, null, 1, "class_year", true));
                                SignupServlet.sendMail(c.getTrainer().getEmail(), "<h2>JOIN YOUR NEW CLASS NOW</h2>"
                                        + "<p>You are invited to the trainner of class " + c.getClass_code() + " of subject (" + c.getSubject().getSubject_code() + ") " + c.getSubject().getSubject_name() + " managed by subject manager " + c.getSubject().getAuthor() + ".</p>"
                                        + "<span>If you accept this invatation, please login to see your class</span>",
                                        "Invited you to be trainner of class!");
                            } else {
                                error.add("Add failed!");
                            }
                        }
                    }
                    url = "class?service=list";
                    break;

            }
            session.setAttribute("LIST_CLASS", DAO.ClassDAO.getInstance().getList("", 0, Integer.MAX_VALUE, login, null, null, 1, "class_year", true));
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
