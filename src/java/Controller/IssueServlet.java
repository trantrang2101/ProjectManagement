/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import static Controller.FunctionServlet.writeExcel;
import DAO.*;
import Model.Entity.*;
import Utils.AppUtils;
import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import javax.swing.JFileChooser;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.ResultSet;
import java.util.stream.Collectors;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.BuiltinFormats;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author Admin
 */
@MultipartConfig
public class IssueServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final StringWriter errors = new StringWriter();
    private static final Logger logger = Logger.getLogger(IssueServlet.class);
    private static final int columnTitle = 0;
    private static final int columnDescription = 1;
    private static final int columnAssignee = 2;
    private static final int columnDueDate = 3;
    private static final int columnMilestone = 4;
    private static final int columnType = 5;
    private static final int columnFunction = 6;
    private static CellStyle cellStyleFormatNumber = null;
//<th>Title</th><th>Description</th><th>Assignee</th><th>Milestone</th><th>Type</th><th>Function</th>

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        List<String> error = new ArrayList<>();
        try (PrintWriter out = response.getWriter()) {
            String service = request.getParameter("service");
            Integer id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? null : Integer.parseInt(request.getParameter("id"));
            Classroom classroom = (Classroom) session.getAttribute("CLASS_CHOOSE");
            Integer classFilter = request.getParameter("class") == null || request.getParameter("class").isEmpty() ? null : Integer.parseInt(request.getParameter("class"));
            List<Classroom> listClass = (List<Classroom>) session.getAttribute("LIST_CLASS");
            String url = "";
            if (service == null) {
                service = id != null ? "detail" : "list";
            }
            User login = (User) AppUtils.getLoginedUser(session);
            Integer status = request.getParameter("status") == null || request.getParameter("status").isEmpty() ? null : Integer.parseInt(request.getParameter("status"));
            Integer statusFilter = request.getParameter("statusFilter") != null && !request.getParameter("statusFilter").isEmpty() ? Integer.parseInt(request.getParameter("statusFilter")) : null;
            Integer milestoneFilter = request.getParameter("milestone") == null || request.getParameter("milestone").isEmpty() ? null : Integer.parseInt(request.getParameter("milestone"));
            Integer functionFilter = request.getParameter("function") == null || request.getParameter("function").isEmpty() ? null : Integer.parseInt(request.getParameter("function"));
            String success = "";
            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            if (classFilter == null) {
                if (classroom == null) {
                    classroom = listClass.get(0);
                }
                classFilter = classroom.getClass_id();
            } else {
                classroom = DAO.ClassDAO.getInstance().getClass(login, classFilter);
                if (classroom == null) {
                    classroom = listClass.get(0);
                    classFilter = classroom.getClass_id();
                }
            }
            int team = request.getParameter("team") == null || request.getParameter("team").isEmpty() ? DAO.ClassDAO.getInstance().getClass(login, classFilter).getListTeam(login).get(0).getTeam_id() : Integer.parseInt(request.getParameter("team"));
            if (functionFilter != null) {
                Function function_choose = FunctionDAO.getInstance().getFunction(functionFilter);
                classroom = function_choose.getTeam().getClassroom();
                classFilter = classroom.getClass_id();
                team = function_choose.getTeam_id();
                request.setAttribute("FUNCTION_CHOOSE", function_choose);
            }
            if (!DAO.ClassUserDAO.getInstance().checkAllow(team, login)) {
                error.add("You are not allow to be here");
                team = DAO.ClassDAO.getInstance().getClass(login, classFilter).getListTeam(login).get(0).getTeam_id();
            }
            if (team > 0) {
                Team team_choose = DAO.TeamDAO.getInstance().getTeam(team);
                classFilter = team_choose.getClass_id();
                request.setAttribute("TEAM_CHOOSE", team_choose);
            }
            if (milestoneFilter != null) {
                Milestone milestone_choose = MilestoneDAO.getInstance().getMilestone(milestoneFilter);
                request.setAttribute("MILESTONE_CHOOSE", milestone_choose);
            }
            if (id != null) {
                User assignee = IssueDAO.getInstance().getIssue(id).getUser();
                request.setAttribute("USER_CHOOSE", assignee);
            }
            session.setAttribute("CLASS_CHOOSE", classroom);
            request.setAttribute("LIST_USER", UserDAO.getInstance().getList(4, "", "user_id", true, 0, Integer.MAX_VALUE, null));
            request.setAttribute("LIST_TEAM", TeamDAO.getInstance().getList(classFilter, login, "", 0, Integer.MAX_VALUE, "team_id", true, null));
            request.setAttribute("LIST_MILESTONE", MilestoneDAO.getInstance().getList(classFilter, null, null, login, "", 0, Integer.MAX_VALUE, "milestone_id", true));
            request.setAttribute("LIST_FUNCTION", FunctionDAO.getInstance().getList(team, null, login, "", 0, Integer.MAX_VALUE, "function_id", true, null, null, null, null));
            List<ClassSetting> listStatus = ClassSettingDAO.getInstance().getListStatus(classFilter, DAO.SettingDAO.getInstance().getSetting("Issue Status").getSetting_id());
            request.setAttribute("LIST_STATUS", listStatus);
            List<ClassSetting> listLabel = ClassSettingDAO.getInstance().getListStatus(classFilter, DAO.SettingDAO.getInstance().getSetting("Issue Type").getSetting_id());
            request.setAttribute("LIST_LABEL", listLabel);
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
                        sort = request.getParameter("previousSort") == null ? "issue_id" : (String) request.getParameter("previousSort");
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
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("THIS_PAGE", thisPage);
                    request.setAttribute("SORT_ISSUE", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("ISSUE_SIZE", (int) Math.ceil(IssueDAO.getInstance().countRows("issue", search, (statusFilter == null ? "" : " and status = " + statusFilter) + (classFilter == null ? "" : " and team_id in (select team_id from team where class_id=" + classFilter + ")")) * 1.0 / 10));
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("STATUS_CHOOSE", status == null ? null : DAO.ClassSettingDAO.getInstance().getClassSetting(status));
                    request.setAttribute("STATUS_VALUE", status);
                    request.setAttribute("LIST_ISSUE", IssueDAO.getInstance().getList(login, search, (thisPage - 1) * 10, 10, sort, statusSort, statusFilter));
                    dispathForward(request, response, "issue/list.jsp");
                    break;
                case "detail":
                    Issue issue = IssueDAO.getInstance().getIssue(Integer.parseInt(request.getParameter("id")));
                    if (issue != null) {
                        request.setAttribute("ISSUE_CHOOSE", issue);
                    }
                    dispathForward(request, response, "issue/detail.jsp");
                    break;
                case "update":
                    String assignee_id = request.getParameter("assignee_id");
                    String issue_title = request.getParameter("issue_title");
                    String description = request.getParameter("description");
                    String gitlab_id = request.getParameter("gitlab_id").isEmpty()? null : request.getParameter("gitlab_id");
                    String gitlab_url = request.getParameter("gitlab_url");
                    String created_at = request.getParameter("created_at");
                    String due_date = request.getParameter("due_date");
                    String team_id = request.getParameter("team_id");
                    String milestone_id = request.getParameter("milestone_id");
                    String function_id = request.getParameter("function_id");
                    status = Integer.parseInt(request.getParameter("status"));
                    int label = Integer.parseInt(request.getParameter("label"));
//                    status = listStatus.get(Integer.parseInt(request.getParameter("status"))).getSetting_id();
//                    int label = listLabel.get(Integer.parseInt(request.getParameter("label"))).getSetting_id();

                    if (!DAO.IssueDAO.getInstance().updateIssue(
                            new Issue(id, Integer.parseInt(assignee_id), issue_title, description,
                                    gitlab_id, gitlab_url, created_at, due_date,
                                    Integer.parseInt(team_id),
                                    Integer.parseInt(milestone_id),
                                    Integer.parseInt(function_id), status, label))) {
                        error.add("Update Issue Fail!");
                        request.setAttribute("ERROR", error);
                    } else {
                        success = "Update Successfully!";
                    }
                    url = "issue?service=list";
                    break;
                case "add":
                    String submit = request.getParameter("submit");
                    if (submit == null) {
                        dispathForward(request, response, "issue/detail.jsp");
                    } else {
                        if (submit.equals("class")) {
                            dispathForward(request, response, "issue/detail.jsp");
                        } else if (submit.equals("team")) {
                            dispathForward(request, response, "issue/detail.jsp");
                        } else {
                            assignee_id = request.getParameter("assignee_id");
                            issue_title = request.getParameter("issue_title");
                            description = request.getParameter("description");
                            gitlab_id = request.getParameter("gitlab_id").isEmpty()? null : request.getParameter("gitlab_id");
                            gitlab_url = request.getParameter("gitlab_url");
                            created_at = request.getParameter("created_at");
                            due_date = request.getParameter("due_date");
                            team_id = request.getParameter("team_id");
                            milestone_id = request.getParameter("milestone_id");
                            function_id = request.getParameter("function_id");
                            status = Integer.parseInt(request.getParameter("status"));
                            label = Integer.parseInt(request.getParameter("label"));
                            Issue i1 = new Issue(
                                    0, Integer.parseInt(assignee_id), issue_title, description,
                                    gitlab_id, gitlab_url, created_at, due_date,
                                    Integer.parseInt(team_id),
                                    Integer.parseInt(milestone_id),
                                    Integer.parseInt(function_id), status, label);
                            if (IssueDAO.getInstance().checkAddIssue(issue_title, Integer.parseInt(assignee_id), status) > 0) {
                                error.add("This issue has existed!");
                            } else {
                                int addid = IssueDAO.getInstance().addIssue(i1);
                                if (addid < 0) {
                                    error.add("Add Issue Fail!");
                                } else {
                                    success = "Add successfully!";
                                }
                            }
                            url = "issue";
                        }
                    }
                    break;
                case "exportExcel":
                    Team team_choose = DAO.TeamDAO.getInstance().getTeam(team);
                    List<Issue> issues = IssueDAO.getInstance().getList(login, "", 0, Integer.MAX_VALUE, "issue_id", true, null);
                    if (issues.size() > 0) {
                        File desktop = new File(System.getProperty("user.home"), "/Desktop");
                        String path = desktop.getAbsolutePath() + File.separator + classroom.getClass_code() + "_Group" + team_choose.getTeam_name() + "_IssueList" + ".xlsx";

                        File newFile = new File(path);
                        if (newFile.exists()) {
                            newFile.delete();
                        }
                        newFile.createNewFile();
                        Workbook workbook = writeExcel(issues, path, classroom.getClass_code() + "_Group" + team_choose.getTeam_name() + "_IssueList");
                        try (OutputStream os = new FileOutputStream(path)) {
                            workbook.write(os);
                        }
                        response.reset();
                        response.setHeader("Content-Disposition", "attachment;filename=" + classroom.getClass_code() + "_Group" + team_choose.getTeam_name() + "_IssueList" + ".xlsx");
                        response.setHeader("charset", "iso-8859-1");
                        response.setContentType("application/vnd.ms-excel");
                        response.setStatus(HttpServletResponse.SC_OK);
                        ServletOutputStream outFile = response.getOutputStream();
                        FileInputStream in = new FileInputStream(newFile);
                        byte[] outputByte = new byte[4096];
                        while (in.read(outputByte, 0, 4096) != -1) {
                            outFile.write(outputByte, 0, 4096);
                        }
                        in.close();
                        out.flush();
                        out.close();
                        newFile.delete();
                        success = "Export successfully";
                    } else {
                        error.add("Team's Issue is empty! Cannot export");
                    }
                    url = ("issue?service=list&team=" + team);
                    break;
                case "importExcel":
                    Part filePart = request.getPart("excel");
                    String fileName = filePart.getSubmittedFileName();
                    for (Part part : request.getParts()) {
                        if (part.getContentType() != null) {
                            File desktop = new File(System.getProperty("user.home"), "/Desktop");
                            String path = desktop.getAbsolutePath() + File.separator + getFileName(part);
                            File file = cloneFile(request, part, path); // creating a new file instance
                            FileInputStream fis = new FileInputStream(file); // obtaining bytes from the file
                            int rowNo = -1;
                            Workbook workbook = null;
                            Sheet sheet = null;
                            if (fileName.endsWith(".xlsx")) {
                                workbook = new XSSFWorkbook(fis);
                                sheet = workbook.getSheetAt(0);
                                rowNo = sheet.getPhysicalNumberOfRows();
                            } else if (fileName.endsWith(".xls")) {
                                workbook = new HSSFWorkbook(fis);
                                sheet = workbook.getSheetAt(0);
                                rowNo = sheet.getPhysicalNumberOfRows();
                            }
                            for (int i = 1; i < rowNo; i++) {
                                try {
                                    Row row = sheet.getRow(i); // returns the logical row
                                    if (isRowEmpty(row)) {
                                        break;
                                    }
//                                int id = Integer.parseInt(row.getCell(1).getStringCellValue());
                                    row.getCell(columnTitle).setCellType(Cell.CELL_TYPE_STRING);
                                    String title = row.getCell(columnTitle).getStringCellValue();
                                    description = row.getCell(columnDescription).getStringCellValue();
                                    String assignee = row.getCell(columnAssignee).getStringCellValue();
                                    String milestone = row.getCell(columnMilestone).getStringCellValue();
                                    String date = row.getCell(columnDueDate).getStringCellValue();
                                    String function = row.getCell(columnFunction).getStringCellValue();
                                    String type = row.getCell(columnType).getStringCellValue();
                                    int milestoneId = DAO.MilestoneDAO.getInstance().checkTitle(milestone);
                                    if (milestoneId < 0) {
                                        error.add("This milestone " + milestone + " is not existed!");
                                        continue;
                                    }
                                    if (date != null && !date.isEmpty()) {
                                        Milestone mile = DAO.MilestoneDAO.getInstance().getMilestone(milestoneId);
                                        Date dueDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH).parse(date);
                                        if (dueDate.after(mile.getDate(mile.getTo_date()))) {
                                            error.add("This due date is after milestone's to date!");
                                            continue;
                                        }
                                    } else {
                                        date = null;
                                    }
                                    ClassUser cu = DAO.ClassUserDAO.getInstance().checkClassUser(classroom.getClass_code(), assignee);
                                    if (cu == null) {
                                        error.add("This assignee has email" + assignee + " not existed in this class!");
                                        continue;
                                    }
                                    int functionId = DAO.FunctionDAO.getInstance().checkAddFunction(String.valueOf(team), null, function);
                                    if (functionId < 0) {
                                        error.add("This function " + function + " not existed in this team! Please add before import issue!");
                                        continue;
                                    }
                                    if (IssueDAO.getInstance().checkAddIssue(title, team, milestoneId) > 0) {
                                        error.add("This issue " + title + " has existed!");
                                        continue;
                                    }
                                    List<String> labels = listLabel.stream().map(ClassSetting::getSetting_title).collect(Collectors.toList());
                                    int index = -1;
                                    for (int j = 0; j < labels.size(); j++) {
                                        if (labels.get(j).equalsIgnoreCase(type)) {
                                            index = j;
                                            break;
                                        }
                                    }
                                    if (index < 0) {
                                        error.add("This label " + type + " not existed in this class!");
                                        continue;
                                    }
                                    issue = new Issue(cu.getUser_id(), title, description, null, "", date, team, milestoneId, functionId, listStatus.get(0).getSetting_id(), listLabel.get(index).getSetting_id());
                                    if (DAO.IssueDAO.getInstance().addIssue(issue) > 0) {
                                        success = "Add issue successfully!";
                                    } else {
                                        error.add("Add issue " + title + " failed!");
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace(new PrintWriter(errors));
                                    logger.error(errors.toString());
                                }
                            }
                            file.delete();
                        }
                    }
                    url = ("issue?service=list&team=" + team);
                    break;
            }
            if (!error.isEmpty()) {
                logger.warn(error);
                session.setAttribute("ERROR", error);
            }
            if (!success.isEmpty()) {
                logger.info(success);
                session.setAttribute("SUCCESS", success);
            }
            if (!url.isEmpty()) {
                response.sendRedirect(url);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
            response.sendRedirect("issue?service=list");
        }
    }

    public static Workbook writeExcel(List<Issue> list, String excelFilePath, String fileName) throws IOException {
        // Create Workbook
        Workbook workbook = getWorkbook(excelFilePath);

        // Create sheet
        Sheet sheet = workbook.createSheet(fileName); // Create sheet with sheet name

        int rowIndex = 0;

        // Write header
        writeHeader(sheet, rowIndex);

        // Write data
        rowIndex++;
        for (Issue book : list) {
            // Create row
            Row row = sheet.createRow(rowIndex);
            // Write data on row
            writeBook(book, row);
            rowIndex++;
        }

        // Write footer
        // Auto resize column witdth
        int numberOfColumn = sheet.getRow(0).getPhysicalNumberOfCells();
        autosizeColumn(sheet, numberOfColumn);
        return workbook;
    }

    // Create workbook
    private static Workbook getWorkbook(String excelFilePath) throws IOException {
        Workbook workbook = null;
        if (excelFilePath.endsWith("xlsx")) {
            workbook = new XSSFWorkbook();
        } else if (excelFilePath.endsWith("xls")) {
            workbook = new HSSFWorkbook();
        } else {
            throw new IllegalArgumentException("The specified file is not Excel file");
        }

        return workbook;
    }

    // Write header with format
    private static void writeHeader(Sheet sheet, int rowIndex) {
        // create CellStyle
        CellStyle cellStyle = createStyleForHeader(sheet);

        // Create row
        Row row = sheet.createRow(rowIndex);

        // Create cells
        Cell cell = row.createCell(0);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Title");

        cell = row.createCell(1);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Description");

        cell = row.createCell(2);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Assignee(mail)");

        cell = row.createCell(3);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Due Date");

        cell = row.createCell(4);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Milestone");

        cell = row.createCell(5);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Type");

        cell = row.createCell(6);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Function");

    }

    // Write data
    private static void writeBook(Issue issue, Row row) {
        if (cellStyleFormatNumber == null) {
            // Format number
            short format = (short) BuiltinFormats.getBuiltinFormat("#,##0");
            // DataFormat df = workbook.createDataFormat();
            // short format = df.getFormat("#,##0");

            //Create CellStyle
            Workbook workbook = row.getSheet().getWorkbook();
            cellStyleFormatNumber = workbook.createCellStyle();
            cellStyleFormatNumber.setDataFormat(format);
        }
        Cell cell = row.createCell(0);

        CellStyle cellStyle = cell.getSheet().getWorkbook().createCellStyle();
        cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        cellStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());

        cell.setCellStyle(cellStyle);

        cell.setCellType(Cell.CELL_TYPE_STRING);
        cell.setCellValue(issue.getIssue_title());

        cell = row.createCell(1);

        cell.setCellStyle(cellStyle);

        cell.setCellValue(issue.getDescription());

        cell = row.createCell(2);

        cell.setCellStyle(cellStyle);

        cell.setCellValue(issue.getUser().getEmail());

        cell = row.createCell(3);

        cell.setCellStyle(cellStyle);

        cell.setCellValue(issue.getDue_date());

        cell = row.createCell(4);

        cell.setCellStyle(cellStyle);

        cell.setCellValue(issue.getMilestone().getMilestone_name());

        // Create cell formula
        // totalMoney = price * quantity
//        cell = row.createCell(COLUMN_INDEX_TOTAL, CellType.FORMULA);
//        cell.setCellStyle(cellStyleFormatNumber);
//        int currentRow = row.getRowNum() + 1;
//        String columnPrice = CellReference.convertNumToColString(COLUMN_INDEX_PRICE);
//        String columnQuantity = CellReference.convertNumToColString(COLUMN_INDEX_QUANTITY);
//        cell.setCellFormula(columnPrice + currentRow + "*" + columnQuantity + currentRow);
        cell = row.createCell(5);
        cell.setCellValue(issue.getIssueLabel().getSetting_title());

        cell = row.createCell(6);
        cell.setCellValue(issue.getFunction().getFunction_name());

    }

    // Create CellStyle for header
    private static CellStyle createStyleForHeader(Sheet sheet) {
        Font font = sheet.getWorkbook().createFont();
        font.setFontName("Times New Roman");
        font.setBold(true);
        font.setFontHeightInPoints((short) 14); // font size
        font.setColor(IndexedColors.WHITE.getIndex()); // text color

        CellStyle cellStyle = sheet.getWorkbook().createCellStyle();
        cellStyle.setFont(font);
        cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        cellStyle.setFillForegroundColor(IndexedColors.AQUA.getIndex());
        cellStyle.setBorderBottom(BorderStyle.THIN);
        return cellStyle;
    }

    private static void autosizeColumn(Sheet sheet, int lastColumn) {
        for (int columnIndex = 0; columnIndex < lastColumn; columnIndex++) {
            sheet.autoSizeColumn(columnIndex);
        }
    }

    public static boolean isRowEmpty(Row row) {
        for (int c = row.getFirstCellNum(); c < row.getLastCellNum(); c++) {
            Cell cell = row.getCell(c);
            if (cell != null && cell.getCellType() != Cell.CELL_TYPE_BLANK)
                return false;
        }
        return true;
    }
    
    private static File cloneFile(HttpServletRequest httpServletRequest, Part part, String output) throws IOException, ServletException {
        InputStream inputStream;
        FileOutputStream fileOutputStream;
        inputStream = httpServletRequest.getPart(part.getName()).getInputStream();
        int i = inputStream.available();
        byte[] b = new byte[i];
        inputStream.read(b);
        fileOutputStream = new FileOutputStream(output);
        fileOutputStream.write(b);
        inputStream.close();
        fileOutputStream.close();
        File f = new File(output);
        return f;
    }

    private static String getFileName(final Part part) {
        final String partHeader = part.getHeader("content-disposition");
        logger.info("Part Header = {" + partHeader + "}");
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(
                        content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
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
