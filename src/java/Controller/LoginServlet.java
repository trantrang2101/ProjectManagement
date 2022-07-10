/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.Entity.User;
import DAO.*;
import Model.Google.*;
import Utils.AppUtils;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;
import javax.servlet.http.Cookie;
import java.io.PrintWriter;
import java.io.StringWriter;
import org.apache.log4j.Logger;

/**
 *
 * @author ADMIN
 */
public class LoginServlet extends HttpServlet {

    
    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(LoginServlet.class);

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
            HttpSession session = request.getSession();
            String url = "";
            String success = "";
            success=success.contains("Login")?"":success;
            String service = request.getParameter("service");
            if (service == null) {
                service = "loginByGoogle";
            }
            List<String> error = new ArrayList<>();
            switch (service) {
                case "loginPage":
                    url = "loging/login.jsp";
                    break;
                case "login":
                    String RememberMe = request.getParameter("RememberMe");
                    if (RememberMe == null) {
                        eraseCookie(request, response);
                    }
                    String userName = request.getParameter("Username");
                    String password = request.getParameter("Password");
                    User checkUser = DAO.UserDAO.getInstance().login(userName, password);
                    if (checkUser != null) {
                        if (checkUser.isStatus()) {
                            //save session=> index
                            //allow account (fake)
                            AppUtils.storeLoginedUser(session, checkUser);
                            if (RememberMe != null) {
                                //save cookies
                                Cookie cookieUname = new Cookie("cookieUserName", userName);
                                Cookie cookieUpass = new Cookie("cookiePassword", password);
                                Cookie cookRemember = new Cookie("cookieRemember", RememberMe);
                                response.addCookie(cookieUname);
                                response.addCookie(cookieUpass);
                                response.addCookie(cookRemember);
                            }
                            AppUtils.storeLoginedUser(request.getSession(), checkUser);
                            success = "Login successfully!";
                            backToSavedPage(request, response);
                        } else {
                            error.add("You need to verify your account by admin or by your mail!");
                            dispathForward(request, response, "loging/login.jsp");
                        }
                    } else {
                        error.add("Invalid username or password!");
                        dispathForward(request, response, "loging/login.jsp");
                    }
                    break;

                case "logout":
                    session = request.getSession(false);
                    if (request.isRequestedSessionIdValid() && session != null) {
                        session.invalidate();
                        session = request.getSession();
                        success = "Logout successfully";
                    }
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    dispathForward(request, response, "home.jsp");
                    break;

                case "loginByGoogle":
                    String code = request.getParameter("code");
                    if (code == null || code.isEmpty()) {
                        dispathForward(request, response, "loging/login.jsp");
                    } else {
                        try {
                            String accessToken = GoogleUtils.getToken(code);
                            GooglePojo googlePojo = GoogleUtils.getUserInfo(accessToken);
                            request.setAttribute("id", googlePojo.getId());
                            String email = googlePojo.getEmail();
                            User checkGoogleUser = DAO.UserDAO.getInstance().getUser(email);
                            if (checkGoogleUser != null) {
                                if (checkGoogleUser.isStatus()) {
                                    AppUtils.storeLoginedUser(request.getSession(), checkGoogleUser);
                                    success = "Login successfully!";
                                    backToSavedPage(request, response);
                                } else {
                                    error.add("You need to verify your account!");
                                    url = "login?service=loginPage";
                                }
                            } else {
                                error.add("This email has not been register! Please check your mail!");
                                url = "login?service=loginPage";
                            }
                        } catch (Exception e) {
                            error.add(e.toString());
                            url = "login?service=loginPage";
                        }
                    }
                    break;
            }
                logger.warn(error);
                session.setAttribute("ERROR", error);
                logger.info(success);
                session.setAttribute("SUCCESS", success);
            if (!url.isEmpty()) {
                dispathForward(request, response,url);
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

    private void eraseCookie(HttpServletRequest req, HttpServletResponse resp) {
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {

                if (!cookie.getName().equals("JSESSIONID")) {
                    cookie.setValue("");
                    cookie.setMaxAge(0);
                    resp.addCookie(cookie);
                }

            }
        }

    }

    public void backToSavedPage(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int redirectId = -1;
        try {
            redirectId = Integer.parseInt(request.getParameter("redirectId"));
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }
        String requestUri = AppUtils.getRedirectAfterLoginUrl(request.getSession(), redirectId);
        if (requestUri != null) {
            response.sendRedirect(requestUri);
        } else {
            // Mặc định sau khi đăng nhập thành công
            // chuyển hướng về trang /userInfo
            response.sendRedirect(request.getContextPath() + "/dashBoard");
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
