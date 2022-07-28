/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import DAO.ClassSettingDAO;
import Model.Entity.*;
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
import java.util.Arrays;
import java.util.HashMap;
import java.util.Random;
import org.apache.log4j.Logger;
import org.gitlab.api.GitlabAPI;
import org.gitlab.api.http.GitlabHTTPRequestor;
import static org.gitlab.api.http.Method.*;
import org.gitlab.api.http.Query;
import org.gitlab.api.models.*;

/**
 *
 * @author Admin
 */
public class ClassSettingServlet extends HttpServlet {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(ClassSettingServlet.class);

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
        User login = AppUtils.getLoginedUser(session);
        List<Classroom> list = DAO.ClassDAO.getInstance().getList("", 0, Integer.MAX_VALUE, login, null, null, 1, "class_id", true);
        try (PrintWriter out = response.getWriter()) {
            String service = request.getParameter("service");
            String url = "";
            Integer id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? null : Integer.parseInt(request.getParameter("id"));
            if (service == null) {
                service = id != null ? "detail" : "list";
            }
            Integer statusFilter = request.getParameter("statusFilter") != null && !request.getParameter("statusFilter").isEmpty() ? Integer.parseInt(request.getParameter("statusFilter")) : null;
            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            int type = (request.getParameter("type") == null || request.getParameter("type").isEmpty()) ? 0 : Integer.parseInt(request.getParameter("type"));
            int classId = (request.getParameter("class") == null || request.getParameter("class").isEmpty()) ? list.get(0).getClass_id() : Integer.parseInt(request.getParameter("class"));
            switch (service) {
                case "list":
                    if (classId > 0) {
                        request.setAttribute("CLASS_CHOOSE", DAO.ClassDAO.getInstance().getClass(login, classId));
                    }
                    if (type > 0) {
                        request.setAttribute("TYPE_CHOOSE", DAO.SettingDAO.getInstance().getSetting(type));
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
                    request.setAttribute("CLASS_SETTING_SIZE", (int) Math.ceil(DAO.ClassSettingDAO.getInstance().countRows("class_setting", search, (type == 0 ? "" : " and class_id = " + type) + (login.getRole_id() == 2 ? " and class_id in (select class_id from class where author_id=" + login.getUser_id() + ")" : "")) * 1.0 / 10));
                    request.setAttribute("LIST_CLASS_SETTING", DAO.ClassSettingDAO.getInstance().getList(type, classId, search, login, (thisPage - 1) * 10, 10, sort, statusSort, statusFilter));
                    dispathForward(request, response, "classSetting/list.jsp");
                    break;
                case "sync":
                    if (list != null && !list.isEmpty()) {
                        for (Classroom cl : list) {
                            List<ClassSetting> settings = DAO.ClassSettingDAO.getInstance().getList(type, cl.getClass_id(), "", login, 0, Integer.MAX_VALUE, "setting_id", true, 1);
                            if (settings != null && !settings.isEmpty()) {
                                if (cl.getApiToken() != null && !cl.getApiToken().isEmpty() && cl.getGitlab_url() != null && !cl.getGitlab_url().isEmpty()) {
                                    String[] splitURL = cl.getGitlab_url().split("/");
                                    String spaceName = "";
                                    for (int i = 1; i < splitURL.length - 1; i++) {
                                        spaceName += splitURL[i] + "/";
                                    }
                                    spaceName += splitURL[splitURL.length - 1];
                                    GitlabAPI api = GitlabAPI.connect("https://gitlab.com/", cl.getApiToken());
                                    try {
                                        GitlabGroup group = api.getGroup(spaceName);
                                        for (ClassSetting s : settings) {
                                            if (!s.getSetting_title().equalsIgnoreCase("Function Status")) {
                                                try {
                                                    GitlabLabel label = createLabel(api, group, s.getSetting_title());
                                                } catch (Exception e) {
                                                    e.printStackTrace(new PrintWriter(errors));
                                                    logger.error(errors.toString());
                                                }
                                            }
                                        }
                                    } catch (Exception e) {
                                        error.add("Access Token or Gitlab URL wrong!!!!!!");
                                        e.printStackTrace(new PrintWriter(errors));
                                        logger.error(errors.toString());
                                    }
                                }
                            }
                        }
                    }
                    url = "classSetting?service=list";
                    break;
                case "detail":
                    ClassSetting set = ClassSettingDAO.getInstance().getClassSetting(id);
                    if (set != null) {
                        request.setAttribute("CLASS_SETTING_CHOOSE", set);
                        dispathForward(request, response, "classSetting/detail.jsp");
                    } else {
                        error.add("No class found!");
                        url = "classSetting";
                    }
                    break;
                case "changeStatus":
                    boolean status = Boolean.parseBoolean(request.getParameter("status"));
                    if (!DAO.ClassSettingDAO.getInstance().updateStatus(id, !status)) {
                        error.add("Update Status Failed!");
                    } else {
                        session.setAttribute("SUCCESS", "Update Successfully!");
                    }
                    url = "classSetting?service=list&class=" + classId;
                    break;
                case "update":
                    int class_id = Integer.parseInt(request.getParameter("classId"));
                    int typeID = Integer.parseInt(request.getParameter("typeID"));
                    String title = request.getParameter("title");
                    String description = request.getParameter("description");
                    status = request.getParameter("status") != null;
                    int value = Integer.parseInt(request.getParameter("value"));
                    int display = Integer.parseInt(request.getParameter("display"));
                    if (!DAO.ClassSettingDAO.getInstance().updateClassSetting(new ClassSetting(id, class_id, typeID, title, value, display, description, status))) {
                        error.add("Update Setting Fail!");
                        request.setAttribute("ERROR", error);
                    } else {
                        success = "Update successfully!";
                    }
                    url = "classSetting?service=list&class=" + classId;
                    break;
                case "add":
                    if (request.getParameter("submit") == null) {
                        dispathForward(request, response, "classSetting/detail.jsp");
                    } else {
                        typeID = Integer.parseInt(request.getParameter("typeID"));
                        class_id = Integer.parseInt(request.getParameter("classId"));
                        title = request.getParameter("title");
                        description = request.getParameter("description");
                        status = request.getParameter("status") != null;
                        value = Integer.parseInt(request.getParameter("value"));
                        display = Integer.parseInt(request.getParameter("display"));
                        if (DAO.ClassSettingDAO.getInstance().checkAddClassSetting(typeID, class_id, value, status) > 0) {
                            error.add("This classSetting has existed!");
                        } else {
                            int addid = DAO.ClassSettingDAO.getInstance().addClassSetting(new ClassSetting(0, class_id, typeID, title, value, display, description, status));
                            if (addid < 0) {
                                error.add("Add Setting Fail!");
                            } else {
                                success = "Add successfully!";
                            }
                        }
                        url = "classSetting?service=list&class=" + classId;
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
                dispathForward(request, response, url);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
    }

    private static List<GitlabLabel> findLabels(GitlabAPI api, GitlabGroup group) throws IOException {
        String tailUrl = group.URL + "/" + group.getId() + GitlabLabel.URL;
        List<GitlabLabel> list = Arrays.asList(api.retrieve().to(tailUrl, GitlabLabel[].class));
        return list;
    }

    public GitlabLabel updateLabel(GitlabAPI api,
            GitlabGroup group,
            String name, String newName) throws IOException {
        String tailUrl = GitlabGroup.URL + "/" + group.getId() + GitlabLabel.URL;
        GitlabHTTPRequestor requestor = api.retrieve().method(PUT);
        requestor.with("name", name);
        if (newName != null) {
            requestor.with("new_name", newName);
        }
        return requestor.to(tailUrl, GitlabLabel.class);
    }

    public void deleteLabel(
            GitlabAPI api,
            GitlabGroup group,
            String name)
            throws IOException {
        Query query = new Query();
        query.append("name", name);
        String tailUrl = group.URL + "/"
                + group.getId()
                + GitlabLabel.URL
                + query.toString();
        api.retrieve().method(DELETE).to(tailUrl, Void.class);
    }

    private static GitlabLabel createLabel(
            GitlabAPI api,
            GitlabGroup group,
            String name) throws IOException {
        String tailUrl = GitlabGroup.URL + "/" + group.getId() + GitlabLabel.URL;
        return api.dispatch().with("name", name)
                .with("color", randomColor())
                .to(tailUrl, GitlabLabel.class);
    }

    private static String randomColor() {
        Random random = new Random();
        int nextInt = random.nextInt(0xffffff + 1);
        String colorCode = String.format("#%06x", nextInt);
        return colorCode;
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
