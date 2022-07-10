/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Model.Entity.*;
import Utils.AppUtils;
import java.io.*;
import java.text.ParseException;
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
import java.io.PrintWriter;
import java.io.StringWriter;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author win
 */
@MultipartConfig
public class ClassUserServlet extends HttpServlet {

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
    private static final Logger logger = Logger.getLogger(ClassUserServlet.class);
    private static final int columnGroup = 0;
    private static final int columnEmail = 1;
    private static final int columnRollNumber = 2;
    private static final int columnFullName = 3;
    private static final int columnGroupLeader = 4;
    private static CellStyle cellStyleFormatNumber = null;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User login = (User) AppUtils.getLoginedUser(session);
        List<String> error = new ArrayList<>();
        Classroom classroom = (Classroom) request.getAttribute("CLASS_CHOOSE");
        String classID = request.getParameter("class");
        if (classID != null) {
            classroom = DAO.ClassDAO.getInstance().getClass(login, Integer.parseInt(classID));
        } else {
            classID = String.valueOf(classroom.getClass_id());
        }
        request.setAttribute("CLASS_CHOOSE", classroom);
        try (PrintWriter out = response.getWriter()) {
            String url = "";
            String service = request.getParameter("service");
            Integer id = request.getParameter("user") == null || request.getParameter("user").isEmpty() ? null : Integer.parseInt(request.getParameter("user"));
            if (service == null) {
                service = (id != null ? "update" : "list");
            }
            request.setAttribute("LIST_TEAM", DAO.TeamDAO.getInstance().getList(Integer.parseInt(classID), login, "", 0, Integer.MAX_VALUE, "team_name", true, 1));
            String success = "";
            Integer type = request.getParameter("type") == null || request.getParameter("type").isEmpty() ? null : Integer.parseInt(request.getParameter("type"));
            Integer statusChoose = request.getParameter("statusFilter") == null || request.getParameter("statusFilter").isEmpty() ? null : Integer.parseInt(request.getParameter("statusFilter"));
            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            Setting student = DAO.SettingDAO.getInstance().getList(null, true, "student", 0, 1, "setting_id", true).get(0);
            switch (service) {
                case "list":
                    String search = request.getParameter("search");
                    if (search == null || search.isEmpty()) {
                        search = "";
                    } else {
                        search = search.trim();
                    }
                    if ((type == null && login.getRole_id() == 4) || type != null) {
                        type = type == null ? DAO.TeamDAO.getInstance().getTeam(Integer.parseInt(classID), login.getUser_id()) : type;
                        request.setAttribute("TEAM_CHOOSE", DAO.TeamDAO.getInstance().getTeam(type));
                    }
                    if (statusChoose != null) {
                        request.setAttribute("SORT_FILTER", statusChoose);
                    }
                    String sort = request.getParameter("sort");
                    boolean statusSort = request.getParameter("sortStatus") == null ? false : Boolean.parseBoolean(request.getParameter("sortStatus"));
                    if (sort == null) {
                        sort = request.getParameter("previousSort") == null ? "team_id" : (String) request.getParameter("previousSort");
                        statusSort = true;
                    } else {
                        if (sort.equals((String) request.getParameter("previousSort"))) {
                            statusSort = !statusSort;
                        }
                    }
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("THIS_PAGE", thisPage);
                    request.setAttribute("SORT_CLASS_USER", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    request.setAttribute("CLASS_USER_SIZE", (int) Math.ceil(DAO.ClassDAO.getInstance().countRows("class_user", search, (search.isEmpty() ? "" : " or user_id in (select user_id from `studentmanagement`.`user` where (`email` like \"%" + search + "%\" or `full_name` like \"%" + search + "%\" or `roll_number` like \"%" + search + "%\"))") + " and class_id=" + classID + (type != null ? " and team_id=" + type : "") + (statusChoose != null ? " and status = " + statusChoose : "")
                            + (login.getRole_id() == 1 ? "" : login.getRole_id() == 3 ? " and class_id in (select class_id from `studentmanagement`.`class` where trainer_id=" + login.getUser_id() + ")" : " and status=1".concat(login.getRole_id() == 4 ? "" : " and class_id in (select class_id from `studentmanagement`.`class`,`studentmanagement`.`subject` where class.subject_id=subject.subject_id and author_id=" + login.getUser_id() + ")"))) * 1.0 / 10));
                    request.setAttribute("LIST_CLASS_USER", DAO.ClassUserDAO.getInstance().getList(type, statusChoose, search, (thisPage - 1) * 10, 10, login, Integer.parseInt(classID), sort, statusSort));
                    dispathForward(request, response, "classUser/list.jsp");
                    break;
                case "changeStatus":
                    boolean statusChange = Boolean.parseBoolean(request.getParameter("status"));
                    ClassUser getUser = DAO.ClassUserDAO.getInstance().getClassUser(Integer.parseInt(classID), id);
                    ClassUser leaderTeam = DAO.ClassUserDAO.getInstance().getLeader(getUser.getTeam_id());
                    if ((getUser.isTeam_leader() && leaderTeam != null && leaderTeam.getUser_id() != id && !statusChange && leaderTeam.isStatus())) {
                        error.add("This team already have leader!");
                    } else {
                        if (getUser.getUser() == null) {
                            error.add("This user has been deactived!");
                        } else {
                            if (DAO.ClassUserDAO.getInstance().updateChangeStatus(id, Integer.parseInt(classID), !statusChange)) {
                                success = "Update Status successfully!";
                            } else {
                                error.add("Update Status failed!");
                            }
                        }
                    }
                    url = "classUser?service=list&class=" + classID;
                    break;
                case "delete":
                    if (DAO.ClassDAO.getInstance().updateChangeStatus(id, false)) {
                        success = "Delete successfully!";
                    } else {
                        error.add("Delete failed!");
                    }
                     url = "classUser";
                    break;
                case "update":
                    if (request.getParameter("submit") == null) {
                        request.setAttribute("CLASS_USER_CHOOSE", DAO.ClassUserDAO.getInstance().getClassUser(Integer.parseInt(classID), id));
                        dispathForward(request, response, "classUser/detail.jsp");
                    } else {
                        int team = Integer.parseInt(request.getParameter("team"));
                        String date = request.getParameter("dropoutDate");
                        boolean leader = request.getParameter("leader") != null;
                        boolean status = request.getParameter("status") != null;
                        String note = request.getParameter("note");
                        leaderTeam = DAO.ClassUserDAO.getInstance().getLeader(team);
                        if ((leader && leaderTeam != null && leaderTeam.getUser_id() != id && status && leaderTeam.isStatus())) {
                            error.add("This team already have leader!");
                        } else {
                            ClassUser classU = new ClassUser(Integer.parseInt(classID), team, id, leader, date, note, status);
                            if (DAO.UserDAO.getInstance().getUser(id, false) == null) {
                                error.add("This user has been deactived!");
                            } else {
                                if (DAO.ClassUserDAO.getInstance().updateClassUser(classU)) {
                                    success = "Update successfully!";
                                } else {
                                    error.add("Update failed!");
                                }
                            }
                        }
                       url ="classUser?service=list&class=" + classID;
                    }
                    break;
                case "add":
                    String submit = request.getParameter("submitForm");
                    if (submit == null) {
                        request.setAttribute("LIST_CLASS", DAO.ClassDAO.getInstance().getList("", 0, Integer.MAX_VALUE, login, null, classroom.getTrainer_id(), 1, "class_id", true));
                        dispathForward(request, response, "classUser/detail.jsp");
                    } else {
                        String email = request.getParameter("email");
                        if (DAO.ClassUserDAO.getInstance().checkClassUser(classroom.getClass_code(), email) != null) {
                            error.add("User has existed in this class");
                        } else {
                            User userGet = DAO.UserDAO.getInstance().getUser(email);
                            if (userGet == null) {
                                String rollNum = request.getParameter("rollNum").toUpperCase();
                                String fullName = request.getParameter("fullName");
                                String password = SignupServlet.generateRandomPassword(20).trim();
                                userGet = new User(rollNum, fullName, email, password, student.getSetting_id());
                                if (DAO.UserDAO.getInstance().checkRollNumber(rollNum) == null) {
                                    if (DAO.UserDAO.getInstance().addUser(userGet)) {
                                        SignupServlet.sendMail(email, "<h2>JOIN OUR TEAM NOW</h2>"
                                                + "<p>Come join our community as Student where you can share, learn, and discover amazing resources, connect with peers, ask questions, engage in conversations, share your best and less successful experiences. Exchange methodologies and adapt them to your needs.</p>"
                                                + "<span>If you accept this invatation, we are giving you an password: <h3>" + password + "</h3></span>"
                                                + "<p>I hope you can join our team as fast as possible! Best wishes!</p>",
                                                "EduProject Invited You To Our Team");
                                    }
                                } else {
                                    error.add("This roll number has been exists!");
                                }
                            }
                            userGet = DAO.UserDAO.getInstance().getUser(email);
                            id = userGet.getUser_id();
                            int team = Integer.parseInt(request.getParameter("team"));
                            String date = request.getParameter("dropoutDate");
                            boolean leader = request.getParameter("leader") != null;
                            boolean status = request.getParameter("status") != null;
                            String note = request.getParameter("note");
                            if (date == null && !status) {
                                date = new Date().toString();
                            }
                            leaderTeam = DAO.ClassUserDAO.getInstance().getLeader(team);
                            if ((leader && leaderTeam != null && leaderTeam.getUser_id() != id && status && leaderTeam.isStatus())) {
                                error.add("This team already have leader!");
                            } else {
                                ClassUser classU = new ClassUser(Integer.parseInt(classID), team, id, leader, date, note, status);
                                if (DAO.UserDAO.getInstance().getUser(id, false) == null) {
                                    error.add("This user has been deactived!");
                                } else {
                                    if (DAO.ClassUserDAO.getInstance().addClassUser(classU)) {
                                        success = "Add successfully!";
                                    } else {
                                        error.add("Add failed!");
                                    }
                                }
                            }
                        }
                         url ="classUser?service=list&class=" + classID;
                    }
                    break;
                case "exportExcel":
                    List<ClassUser> classUsers = DAO.ClassUserDAO.getInstance().getList(null, null, "", 0, Integer.MAX_VALUE, login, Integer.parseInt(classID), "team_id", true);
                    if (classUsers.size() > 0) {
                        File desktop = new File(System.getProperty("user.home"), "/Desktop");
                        String path = desktop.getAbsolutePath() + File.separator + classroom.getClass_code() + "_" + classroom.getSubject().getSubject_code() + ".xlsx";
                        File newFile = new File(path);
                        if (newFile.exists()) {
                            newFile.delete();
                        }
                        newFile.createNewFile();
                        Workbook workbook = writeExcel(classUsers, path, classroom.getClass_code() + "_" + classroom.getSubject().getSubject_code());
                        try (OutputStream os = new FileOutputStream(path)) {
                            workbook.write(os);
                        }
                        response.reset();
                        response.setHeader("Content-Disposition", "attachment;filename=" + classroom.getClass_code() + "_" + classroom.getSubject().getSubject_code() + ".xlsx");
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
                        error.add("Class is empty! Cannot export");
                    }
                    url ="classUser?class=" + classID;
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
//                                int id = Integer.parseInt(row.getCell(1).getStringCellValue());
                                    row.getCell(columnGroup).setCellType(Cell.CELL_TYPE_STRING);
                                    String GroupName = row.getCell(columnGroup).getStringCellValue();
//                                boolean gender = row.getCell(3).getStringCellValue().equals("1");
//                                String classUserid = row.getCell(4).getStringCellValue();
//                                String password = row.getCell(6).getStringCellValue();
                                    String email = row.getCell(columnEmail).getStringCellValue();
                                    String rollNumber = row.getCell(columnRollNumber).getStringCellValue();
                                    String fullName = row.getCell(columnFullName).getStringCellValue();
                                    row.getCell(columnGroupLeader).setCellType(CellType.STRING);
                                    boolean leader = Boolean.parseBoolean(row.getCell(columnGroupLeader).getStringCellValue());
                                    if (DAO.ClassUserDAO.getInstance().checkClassUser(classroom.getClass_code(), email) != null) {
                                        error.add("This User has existed in this class!");
                                    } else {
                                        String password = SignupServlet.generateRandomPassword(20).trim();
                                        if (!email.endsWith("@fpt.edu.vn")) {
                                            continue;
                                        }
                                        if (DAO.UserDAO.getInstance().getUser(email) == null && DAO.UserDAO.getInstance().checkRollNumber(rollNumber) == null) {
                                            if (DAO.UserDAO.getInstance().addUser(new User(rollNumber, fullName, email, password, student.getSetting_id()))) {
                                                SignupServlet.sendMail(email, "<h2>JOIN OUR TEAM NOW</h2>"
                                                        + "<p>Come join our community as Student where you can share, learn, and discover amazing resources, connect with peers, ask questions, engage in conversations, share your best and less successful experiences. Exchange methodologies and adapt them to your needs.</p>"
                                                        + "<span>If you accept this invatation, we are giving you an password: <h3>" + password + "</h3></span>"
                                                        + "<p>I hope you can join our team as fast as possible! Best wishes!</p>",
                                                        "EduProject Invited You To Our Team");
                                            }
                                        }
                                        User user = DAO.UserDAO.getInstance().getUser(email);
                                        if (user == null || !user.isStatus()) {
                                            continue;
                                        }
                                        int teamID = DAO.TeamDAO.getInstance().checkAddTeam(GroupName, Integer.parseInt(classID), true);
                                        if (teamID < 0 && (teamID = DAO.TeamDAO.getInstance().addTeam(new Team(Integer.parseInt(classID), GroupName, "", "", "", true, ""))) < 0) {
                                            continue;
                                        }
                                        if (DAO.ClassUserDAO.getInstance().getLeader(teamID) != null && leader) {
                                            continue;
                                        }
                                        if (DAO.ClassUserDAO.getInstance().addClassUser(new ClassUser(Integer.parseInt(classID), teamID, user.getUser_id(), leader, null, null, true))) {
                                            success = "Add user into class successfully!";
                                        } else {
                                            success = "";
                                            error.add("Add user into class failed!");
                                        }
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace(new PrintWriter(errors));
                                    logger.error(errors.toString());
                                }
                            }
                            file.delete();
                        }
                    }
                    url ="classUser?service=list&class=" + classID;
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
               dispathForward(request, response,"classUser?service=list&class=" + classID);
        }
    }

    public static Workbook writeExcel(List<ClassUser> list, String excelFilePath, String fileName) throws IOException {
        // Create Workbook
        Workbook workbook = getWorkbook(excelFilePath);

        // Create sheet
        Sheet sheet = workbook.createSheet(fileName); // Create sheet with sheet name

        int rowIndex = 0;

        // Write header
        writeHeader(sheet, rowIndex);

        // Write data
        rowIndex++;
        for (ClassUser book : list) {
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
        cell.setCellValue("Team");

        cell = row.createCell(1);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Email");

        cell = row.createCell(2);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Roll number");

        cell = row.createCell(3);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Full name");

        cell = row.createCell(4);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("LEADER");

        cell = row.createCell(5);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Dropout Date");

        cell = row.createCell(6);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("On going");

        cell = row.createCell(7);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Final Pres");

        cell = row.createCell(8);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Final Topic");

        cell = row.createCell(9);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Note");

    }

    // Write data
    private static void writeBook(ClassUser classUser, Row row) {
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

        if (!classUser.isStatus()) {
            cell.setCellStyle(cellStyle);
        }
        cell.setCellType(Cell.CELL_TYPE_STRING);
        cell.setCellValue(classUser.getTeam().getTeam_name());

        cell = row.createCell(1);
        if (!classUser.isStatus()) {
            cell.setCellStyle(cellStyle);
        }
        cell.setCellValue(classUser.getUser().getEmail());

        cell = row.createCell(2);
        if (!classUser.isStatus()) {
            cell.setCellStyle(cellStyle);
        }
        cell.setCellValue(classUser.getUser().getRoll_number());

        cell = row.createCell(3);
        if (!classUser.isStatus()) {
            cell.setCellStyle(cellStyle);
        }
        cell.setCellValue(classUser.getUser().getFull_name());

        cell = row.createCell(4);
        if (!classUser.isStatus()) {
            cell.setCellStyle(cellStyle);
        }
        cell.setCellValue(classUser.isTeam_leader() ? "TRUE" : "");

        // Create cell formula
        // totalMoney = price * quantity
//        cell = row.createCell(COLUMN_INDEX_TOTAL, CellType.FORMULA);
//        cell.setCellStyle(cellStyleFormatNumber);
//        int currentRow = row.getRowNum() + 1;
//        String columnPrice = CellReference.convertNumToColString(COLUMN_INDEX_PRICE);
//        String columnQuantity = CellReference.convertNumToColString(COLUMN_INDEX_QUANTITY);
//        cell.setCellFormula(columnPrice + currentRow + "*" + columnQuantity + currentRow);
        cell = row.createCell(5);
        if (!classUser.isStatus()) {
            cell.setCellStyle(cellStyle);
        }
        try {
            cell.setCellValue(classUser.getDropoutFormat());
        } catch (ParseException ex) {
            ex.printStackTrace(new PrintWriter(errors));
            logger.error(errors.toString());
        }

        cell = row.createCell(6);
        if (!classUser.isStatus()) {
            cell.setCellStyle(cellStyle);
        }
        cell.setCellType(Cell.CELL_TYPE_NUMERIC);
        cell.setCellValue(classUser.getOngoing_eval());

        cell = row.createCell(7);
        if (!classUser.isStatus()) {
            cell.setCellStyle(cellStyle);
        }
        cell.setCellValue(classUser.getFinal_pres_eval());

        cell = row.createCell(8);
        if (!classUser.isStatus()) {
            cell.setCellStyle(cellStyle);
        }
        cell.setCellValue(classUser.getFinal_topic_eval());

        cell = row.createCell(9);
        if (!classUser.isStatus()) {
            cell.setCellStyle(cellStyle);
        }
        cell.setCellType(Cell.CELL_TYPE_STRING);
        cell.setCellValue(classUser.getUser_notes());
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
