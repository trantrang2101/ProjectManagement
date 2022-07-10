/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import DAO.FunctionDAO;
import Model.Entity.*;
import Utils.AppUtils;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
public class DashBoardServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private String url = "";

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(DashBoardServlet.class);

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        List<String> error = new ArrayList<>();
        try (PrintWriter out = response.getWriter()) {
            User login = (User) AppUtils.getLoginedUser(session);
            session.setAttribute("LOGIN_ROLE", DAO.SettingDAO.getInstance().getSetting(login.getRole_id()));
            HashMap<Integer, String> type = new HashMap<Integer, String>();
            List<Setting> type_id = DAO.SettingDAO.getInstance().getList(null, true, "", 0, 10000000, "setting_id", true);
            for (Setting x : type_id) {
                String value = getServletContext().getInitParameter(String.valueOf(x.getType_id()));
                type.put(x.getType_id(), value);
            }
            String[] listStatus = {"Cancelled", "Opened", "Closed"};
            session.setAttribute("LIST_STATUS", listStatus);
            session.setAttribute("LIST_SUBJECT", DAO.SubjectDAO.getInstance().getList("", login, 0, Integer.MAX_VALUE, "subject_id", true, null, -1));
            session.setAttribute("LIST_SETTING_TYPE", type);
            session.setAttribute("LIST_SETTINGS", DAO.SettingDAO.getInstance().getSettings(1));
            session.setAttribute("LIST_TEACHER", DAO.UserDAO.getInstance().getList(3, "", null, false, 0, Integer.MAX_VALUE, 1));
            session.setAttribute("LIST_AUTHOR", DAO.UserDAO.getInstance().getList(2, "", null, false, 0, Integer.MAX_VALUE, 1));
            List<Classroom> listclass = DAO.ClassDAO.getInstance().getList("", 0, Integer.MAX_VALUE, login, null, null, 1, "class_year", true);
            session.setAttribute("LIST_CLASS", listclass);
            session.setAttribute("LIST_ROLES_SETTING", DAO.SettingDAO.getInstance().getList(findKey(type, "role"), true, "", 0, 10000000, "setting_id", true));
            List<Setting> list = DAO.SettingDAO.getInstance().getList(DashBoardServlet.findKey(type, "class setting"), true, "", 0, Integer.MAX_VALUE, "setting_id", true);
            int function_status = 0;
            for (Setting setting : list) {
                if (setting.getSetting_title().equalsIgnoreCase("function status")) {
                    function_status = setting.getSetting_id();
                    break;
                }
            }
            session.setAttribute("SETTING_LIST_CLASS", list);
            session.setAttribute("SETTING_LIST_SUBJECT", DAO.SettingDAO.getInstance().getList(DashBoardServlet.findKey(type, "subject setting"), true, "", 0, Integer.MAX_VALUE, "setting_id", true));
            session.setAttribute("LIST_FUNCTION_STATUS", DAO.ClassSettingDAO.getInstance().getList(function_status, listclass.get(0).getClass_id(), "", login, 0, Integer.MAX_VALUE, "setting_id", true, 1));
            if (login.getRole_id() < 4) {
                dispathForward(request, response, "/index.jsp");
            } else {
                url = ("class");
            }
            if (!url.isEmpty()) {
                response.sendRedirect(url);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        } finally {
            logger.warn(error);
            session.setAttribute("ERROR", error);
        }
    }

    public static Integer findKey(HashMap<Integer, String> map, String value) {
        for (Map.Entry<Integer, String> entry : map.entrySet()) {
            if (entry.getValue().equalsIgnoreCase(value)) {
                return entry.getKey();
            }
        }
        return null;
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
