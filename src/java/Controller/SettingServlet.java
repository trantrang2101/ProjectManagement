/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import DAO.SettingDAO;
import Model.Entity.Setting;
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
 * @author nashd
 */
public class SettingServlet extends HttpServlet {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(SettingServlet.class);

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
            int id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? -1 : Integer.parseInt(request.getParameter("id"));
            String url = "";
            if (service == null) {
                service = id >= 0 ? "detail" : "list";
            }
            String success = "";

            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            Integer type = request.getParameter("type") == null || request.getParameter("type").isEmpty() ? null : Integer.parseInt(request.getParameter("type"));
            switch (service) {
                case "list":
                    request.setAttribute("SETTING_TYPE_CHOOSE", type);
                    String search = request.getParameter("search");
                    if (search == null || search.isEmpty()) {
                        search = "";
                    } else {
                        search = search.trim();
                    }
                    Boolean statusFilter = request.getParameter("status") == null || request.getParameter("status").isEmpty() ? null : Boolean.parseBoolean(request.getParameter("status"));
                    if (statusFilter != null) {
                        request.setAttribute("STATUS_CHOOSE", statusFilter);
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
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("THIS_PAGE", thisPage);
                    request.setAttribute("SORT_SETTING", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("SETTING_SIZE", (int) Math.ceil(SettingDAO.getInstance().countRows("setting", search, (type == null ? "" : " and type_id = " + type) + (statusFilter != null ? " and status=" + statusFilter : "")) * 1.0 / 10));
                    request.setAttribute("LIST_SETTING", SettingDAO.getInstance().getList(type, statusFilter, search, (thisPage - 1) * 10, 10, sort, statusSort));
                    dispathForward(request, response, "setting/list.jsp");
                    break;
                case "changeStatus":
                    int settingID = Integer.parseInt(request.getParameter("id"));
                    boolean status = Boolean.parseBoolean(request.getParameter("status"));
                    if (!DAO.SettingDAO.getInstance().updateStatus(settingID, !status)) {
                        error.add("Update Status Failed!");
                    } else {
                        success = "Update Successfully!";
                    }
                    url = "setting";
                    break;
                case "detail":
                    Setting set = SettingDAO.getInstance().getSetting(id);
                    request.setAttribute("SETTING_CHOOSE", set);
                    dispathForward(request, response, "setting/detail.jsp");
                    break;
                case "update":
                    int typeID = Integer.parseInt(request.getParameter("typeID"));
                    String title = request.getParameter("title");
                    status = request.getParameter("status") != null;
                    int value = Integer.parseInt(request.getParameter("value"));
                    int display = Integer.parseInt(request.getParameter("display"));
                    String description = request.getParameter("description");
                    if (!SettingDAO.getInstance().updateSetting(new Setting(id, typeID, title, value, display, description, status))) {
                        error.add("Update Setting Fail!");
                        request.setAttribute("ERROR", error);
                    } else {
                        request.setAttribute("SUCCESS", "Update success fully!");
                    }
                    url = "setting";
                    break;
                case "add":
                    if (request.getParameter("submit") == null) {
                        url = "setting?service=detail";
                    } else {
                        typeID = Integer.parseInt(request.getParameter("typeID"));
                        title = request.getParameter("title");
                        status = request.getParameter("status") != null;
                        value = Integer.parseInt(request.getParameter("value"));
                        display = Integer.parseInt(request.getParameter("display"));
                        description = request.getParameter("description");
                        if (SettingDAO.getInstance().checkAddSetting(typeID, value, status)) {
                            error.add("This setting has existed!");
                        } else {
                            int addid = SettingDAO.getInstance().addSetting(new Setting(0, typeID, title, value, display, description, status));
                            if (addid < 0) {
                                error.add("Add Setting Fail!");
                            } else {
                                request.setAttribute("SUCCESS", "Add successfully!");
                            }
                        }
                        url = "setting?service=list";
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
