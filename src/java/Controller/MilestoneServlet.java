/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.Entity.*;
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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import org.apache.log4j.Logger;
import org.gitlab.api.GitlabAPI;
import org.gitlab.api.http.GitlabHTTPRequestor;
import static org.gitlab.api.http.Method.DELETE;
import static org.gitlab.api.http.Method.PUT;
import org.gitlab.api.http.Query;
import org.gitlab.api.models.GitlabGroup;
import org.gitlab.api.models.GitlabMilestone;
import org.gitlab.api.models.GitlabProject;

/**
 *
 * @author win
 */
public class MilestoneServlet extends HttpServlet {

    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(MilestoneServlet.class);

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
            Integer id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? null : Integer.parseInt(request.getParameter("id"));
            String url = "";
            if (service == null) {
                service = id != null ? "update" : "list";
            }
            String success = "";
            List<Classroom> list = DAO.ClassDAO.getInstance().getList("", 0, Integer.MAX_VALUE, login, null, null, 1, "class_id", true);
            Integer classroom = request.getParameter("class") == null || request.getParameter("class").isEmpty() || "0".equals(request.getParameter("class")) ? null : Integer.parseInt(request.getParameter("class"));
            Classroom c = classroom == null ? list.get(0) : DAO.ClassDAO.getInstance().getClass(login, classroom);
            List<Iteration> listIteration = DAO.IterationDAO.getInstance().getList(c.getSubject_id(), login, "", 0, Integer.MAX_VALUE, "iteration_id", true, true);
            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            switch (service) {
                case "list":
                    if (classroom != null) {
                        request.setAttribute("CLASS_CHOOSE", DAO.ClassDAO.getInstance().getClass(login, classroom));
                    } else {
                        if (!list.isEmpty()) {
                            request.setAttribute("CLASS_CHOOSE", list.get(0));
                        }
                    }
                    String search = request.getParameter("search");
                    if (search == null || search.isEmpty()) {
                        search = "";
                    } else {
                        search = search.trim();
                    }
                    Integer statusFilter = request.getParameter("status") == null ? null : Integer.parseInt(request.getParameter("status"));
                    String sort = request.getParameter("sort");
                    boolean statusSort = request.getParameter("sortStatus") == null ? true : Boolean.parseBoolean(request.getParameter("sortStatus"));
                    if (sort == null) {
                        sort = request.getParameter("previousSort") == null ? "milestone_id" : (String) request.getParameter("previousSort");
                    } else {
                        if (sort.equals((String) request.getParameter("previousSort"))) {
                            statusSort = !statusSort;
                        }
                    }
                    if (statusFilter != null) {
                        request.setAttribute("STATUS_CHOOSE", statusFilter);
                    }
                    request.setAttribute("SORT_MILESTONE", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("MILESTONE_SIZE", (int) Math.ceil(DAO.CriteriaDAO.getInstance().countRows("milestone", search, (classroom != null ? " and class_id = " + classroom : "")
                            + (login.getRole_id() == 1 ? "" : login.getRole_id() == 3 ? " and class_id in (select class_id from `class` where trainer_id=" + login.getUser_id() + ")" : (login.getRole_id() == 4 ? " and class_id in (select class_id from `class_user` where user_id=" + login.getUser_id() + ")" : " and class_id in (select class_id from `class`,`subject` where class.subject_id=subject.subject_id and author_id=" + login.getUser_id() + ")"))
                            + (statusFilter != null ? " and status=" + statusFilter : "")) * 1.0 / 10));
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("THIS_PAGE", thisPage);
                    request.setAttribute("LIST_MILESTONE", DAO.MilestoneDAO.getInstance().getList(classroom, null, statusFilter, login, search, (thisPage - 1) * 10, 10, sort, statusSort));
                    dispathForward(request, response, "milestone/list.jsp");
                    break;
                case "sync":
                    if (list != null && !list.isEmpty()) {
                        for (Classroom cl : list) {
                            List<Milestone> milestones = DAO.MilestoneDAO.getInstance().getList(c.getClass_id(), null, null, login, "", 0, Integer.MAX_VALUE, "class_id", true);
                            if (!milestones.isEmpty()) {
                                if (cl.getApiToken() != null && cl.getGitlab_url() != null && !cl.getApiToken().isEmpty() && !cl.getGitlab_url().isEmpty()) {
                                    String[] splitURL = cl.getGitlab_url().split("/");
                                    String spaceName = "";
                                    for (int i = 1; i < splitURL.length - 1; i++) {
                                        spaceName += splitURL[i] + "/";
                                    }
                                    spaceName += splitURL[splitURL.length - 1];
                                    GitlabAPI api = GitlabAPI.connect("https://gitlab.com/", cl.getApiToken());
                                    try {
                                        List<String> milestoneGit = new ArrayList<>();
                                        GitlabGroup group = api.getGroup(spaceName);
                                        for (Milestone m : milestones) {
                                            try {
                                                GitlabMilestone gitMile = findMilestone(m.getMilestone_name(), api, group);
                                                boolean exists = true;
                                                if (gitMile == null) {
                                                    gitMile = new GitlabMilestone();
                                                    exists = false;
                                                }
                                                gitMile.setTitle(m.getMilestone_name());
                                                gitMile.setStartDate(m.getDate(m.getFrom_date()));
                                                gitMile.setDueDate(m.getDate(m.getTo_date()));
                                                String state = "";
                                                if ("Opened".equals(m.getStatusValue())) {
                                                    state = "activate";
                                                } else {
                                                    state = "close";
                                                }
                                                if (exists) {
                                                    gitMile = updateMilestoneGroup(gitMile, api, group, state);
                                                } else {
                                                    gitMile = createMilestoneGroup(gitMile, api, group);
                                                    gitMile = updateMilestoneGroup(gitMile, api, group, state);
                                                }
                                                milestoneGit.add(m.getMilestone_name());
                                            } catch (IOException | ParseException e) {
                                                e.printStackTrace(new PrintWriter(errors));
                                                logger.error(errors.toString());
                                            }
                                        }
                                        try {
                                            List<GitlabMilestone> listMile = getMilestones(api, group);
                                            for (GitlabMilestone gitlabMilestone : listMile) {
                                                if (!milestoneGit.contains(gitlabMilestone.getTitle())) {
                                                    deleteMilestone(api, group, gitlabMilestone);
                                                }
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace(new PrintWriter(errors));
                                            logger.error(errors.toString());
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
                    url = "milestone";
                    break;
                case "changeStatus":
                    int status = Integer.parseInt(request.getParameter("status"));
                    Milestone milestone = DAO.MilestoneDAO.getInstance().getMilestone(id);
                    if (status == 0) {
                        if (new Date(milestone.getTo_date()).after(new Date())) {
                            status = 1;
                        } else {
                            status = 2;
                        }
                    } else {
                        status = 0;
                    }
                    if (!DAO.MilestoneDAO.getInstance().updateMilestone(id, status)) {
                        error.add("Cancelled Milestone Failed!");
                    } else {
                        success = "Cancelled Milestone Successfully!";
                    }
                    url = "milestone";
                    break;
                case "update":
                    String submit = request.getParameter("submitForm");
                    int iteration_id = request.getParameter("iteration_id") == null || request.getParameter("iteration_id").isEmpty() ? 0 : Integer.parseInt(request.getParameter("iteration_id"));
                    if (listIteration != null && listIteration.size() > 0) {
                        Iteration iter = iteration_id == 0 ? listIteration.get(0) : DAO.IterationDAO.getInstance().getIteration(iteration_id);
                        request.setAttribute("LIST_ITERATION", listIteration);
                        request.setAttribute("ITERATION_CHOOSE", iter);
                        request.setAttribute("CLASS_CHOOSE", c);
                        if (submit == null) {
                            if (id == null) {
                                url = "milestone?service=list";
                            } else {
                                Milestone mile = DAO.MilestoneDAO.getInstance().getMilestone(id);
                                request.setAttribute("MILESTONE_CHOOSE", mile);
                                if (mile.getIteration_id() != 0) {
                                    request.setAttribute("ITERATION_CHOOSE", mile.getIteration());
                                } else {
                                    request.setAttribute("LIST_ITERATION", listIteration);
                                }
                                dispathForward(request, response, "milestone/detail.jsp");
                            }
                        } else {
                            String milestone_name = request.getParameter("name");
                            iteration_id = Integer.parseInt(request.getParameter("iteration"));
                            int class_id = Integer.parseInt(request.getParameter("class"));
                            String from_date = request.getParameter("from");
                            String to_date = request.getParameter("to");
                            status = Integer.parseInt(request.getParameter("status"));
                            if (DAO.MilestoneDAO.getInstance().checkTitle(milestone_name) != id) {
                                error.add("This title has exists!");
                            } else {
                                Milestone mile = new Milestone(id, milestone_name, iteration_id, class_id, from_date, to_date, status);
                                if (!DAO.MilestoneDAO.getInstance().updateMilestone(mile)) {
                                    error.add("Update Milestone Fail!");
                                } else {
                                    success = "Update Successfully!";
                                }
                            }
                            url = "milestone?service=list";
                        }
                    } else {
                        error.add("Data is not enough to update");
                        url = "milestone?service=list";
                    }
                    break;
                case "add":
                    submit = request.getParameter("submitForm");
                    int class_id = request.getParameter("class_id") == null || request.getParameter("class_id").isEmpty() ? 0 : Integer.parseInt(request.getParameter("class_id"));
                    iteration_id = request.getParameter("iteration_id") == null || request.getParameter("iteration_id").isEmpty() ? 0 : Integer.parseInt(request.getParameter("iteration_id"));
                    if (listIteration != null && listIteration.size() > 0) {
                        Iteration iter = iteration_id == 0 ? listIteration.get(0) : DAO.IterationDAO.getInstance().getIteration(iteration_id);
                        request.setAttribute("LIST_ITERATION", listIteration);
                        request.setAttribute("ITERATION_CHOOSE", iter);
                        request.setAttribute("CLASS_CHOOSE", c);
                        if (submit == null) {
                            dispathForward(request, response, "milestone/detail.jsp");
                        } else {
                            String milestone_name = request.getParameter("name");
                            iteration_id = Integer.parseInt(request.getParameter("iteration"));
                            class_id = Integer.parseInt(request.getParameter("class"));
                            String from_date = request.getParameter("from");
                            String to_date = request.getParameter("to");
                            if (to_date == null || to_date.isEmpty()) {
                                to_date = null;
                            }
                            status = Integer.parseInt(request.getParameter("status"));
                            if (DAO.MilestoneDAO.getInstance().checkTitle(milestone_name) > 0) {
                                error.add("This title has exists!");
                            } else {
                                Milestone mile = new Milestone(0, milestone_name, iteration_id, class_id, from_date, to_date, status);
                                id = DAO.MilestoneDAO.getInstance().addMilestone(mile);
                                if (id < 0) {
                                    error.add("Add Milestone Fail!");
                                } else {
                                    mile.setMilestone_id(id);
                                    success = "Add Successfully!";
                                }
                            }
                            url = "milestone?service=list";
                        }
                    } else {
                        error.add("Data is not enough to add");
                        url = "milestone?service=list";
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

    private static GitlabMilestone updateMilestoneGroup(GitlabMilestone milestone, GitlabAPI api, GitlabGroup group, String stateEvent) throws IOException {
        String tailUrl = group.URL + "/" + group.getId() + GitlabMilestone.URL + "/" + milestone.getId();
        GitlabHTTPRequestor requestor = api.retrieve().method(PUT);
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        if (milestone.getTitle() != null) {
            requestor.with("title", milestone.getTitle());
        }
        if (milestone.getDescription() != null) {
            requestor = requestor.with("description", milestone.getDescription());
        }
        if (milestone.getDueDate() != null) {
            requestor = requestor.with("due_date", formatter.format(milestone.getDueDate()));
        }
        if (milestone.getStartDate() != null) {
            requestor = requestor.with("start_date", formatter.format(milestone.getStartDate()));
        }
        if (stateEvent != null) {
            requestor.with("state_event", stateEvent);
        }
        return requestor.to(tailUrl, GitlabMilestone.class);
    }

    private static GitlabMilestone createMilestoneGroup(GitlabMilestone milestone, GitlabAPI api, GitlabGroup group) throws IOException {
        String tailUrl = group.URL + "/" + group.getId() + GitlabMilestone.URL;
        GitlabHTTPRequestor requestor = api.dispatch().with("title", milestone.getTitle());
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        if (milestone.getDescription() != null) {
            requestor = requestor.with("description", milestone.getDescription());
        }
        if (milestone.getDueDate() != null) {
            requestor = requestor.with("due_date", formatter.format(milestone.getDueDate()));
        }
        if (milestone.getStartDate() != null) {
            requestor = requestor.with("start_date", formatter.format(milestone.getStartDate()));
        }
        return requestor.to(tailUrl, GitlabMilestone.class);
    }

    private static List<GitlabMilestone> getMilestones(GitlabAPI api, GitlabGroup group) throws IOException {
        String tailUrl = group.URL + "/" + group.getId() + GitlabMilestone.URL;
        List<GitlabMilestone> list = Arrays.asList(api.retrieve().to(tailUrl, GitlabMilestone[].class));
        return list;
    }

    public void deleteMilestone(GitlabAPI api,GitlabGroup group,GitlabMilestone mile)
            throws IOException {
        String tailUrl = group.URL + "/"+ group.getId()+ mile.URL + "/"+ mile.getId();
        api.retrieve().method(DELETE).to(tailUrl, Void.class);
    }

    private static GitlabMilestone findMilestone(String name, GitlabAPI api, GitlabGroup group) throws IOException {
        String tailUrl = group.URL + "/" + group.getId() + GitlabMilestone.URL + "?title=" + name;
        List<GitlabMilestone> list = Arrays.asList(api.retrieve().to(tailUrl, GitlabMilestone[].class));
        if (list == null || list.isEmpty()) {
            return null;
        } else {
            return list.get(0);
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
