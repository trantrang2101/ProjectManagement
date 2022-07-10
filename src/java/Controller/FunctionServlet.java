/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import static Controller.ClassUserServlet.writeExcel;
import DAO.FunctionDAO;
import Model.Entity.ClassSetting;
import Model.Entity.ClassUser;
import Model.Entity.Classroom;
import Model.Entity.Feature;
import Model.Entity.Function;
import Model.Entity.SubjectSetting;
import Model.Entity.Team;
import Model.Entity.User;
import Utils.AppUtils;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
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
public class FunctionServlet extends HttpServlet {

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
    private static final Logger logger = Logger.getLogger(FunctionServlet.class);
    private static CellStyle cellStyleFormatNumber = null;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        List<String> error = new ArrayList<>();
        String success = "";

        String url = "";
        try (PrintWriter out = response.getWriter()) {
            Integer id = request.getParameter("id") == null || request.getParameter("id").isEmpty() ? null : Integer.parseInt(request.getParameter("id"));
            String service = request.getParameter("service");
            if (service == null) {
                service = id != null ? "detail" : "list";
            }
            User login = (User) AppUtils.getLoginedUser(session);
            Classroom classroom = (Classroom) session.getAttribute("CLASS_CHOOSE");
            Integer classFilter = request.getParameter("class") == null || request.getParameter("class").isEmpty() ? null : Integer.parseInt(request.getParameter("class"));
            List<Classroom> listClass = (List<Classroom>) session.getAttribute("LIST_CLASS");
            int thisPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
            Integer status = request.getParameter("status") == null || request.getParameter("status").isEmpty() ? null : Integer.parseInt(request.getParameter("status"));
            Integer featureFilter = request.getParameter("feature") == null || request.getParameter("feature").isEmpty() ? null : Integer.parseInt(request.getParameter("feature"));
            Integer complexityFilter = request.getParameter("complexity") == null || request.getParameter("complexity").isEmpty() ? null : Integer.parseInt(request.getParameter("complexity"));
           SubjectSetting complexityChoose = complexityFilter == null? null : DAO.SubjectSettingDAO.getInstance().getSubjectSetting(complexityFilter);
            Integer priorityFilter = request.getParameter("priority") == null || request.getParameter("priority").isEmpty() ? null : Integer.parseInt(request.getParameter("priority"));
            Integer ownerFilter = request.getParameter("owner_id") == null || request.getParameter("owner_id").isEmpty() ? null : Integer.parseInt(request.getParameter("owner_id"));
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
            int type = request.getParameter("type") == null || request.getParameter("type").isEmpty() ? DAO.ClassDAO.getInstance().getClass(login, classFilter).getListTeam(login).get(0).getTeam_id() : Integer.parseInt(request.getParameter("type"));
            if (!DAO.ClassUserDAO.getInstance().checkAllow(type, login)) {
                error.add("You are not allow to be here");
                type = DAO.ClassDAO.getInstance().getClass(login, classFilter).getListTeam(login).get(0).getTeam_id();
            }
            if (type > 0) {
                Team team_choose = DAO.TeamDAO.getInstance().getTeam(type);
                classFilter = team_choose.getClass_id();
                request.setAttribute("TYPE_CHOOSE", team_choose);
            }
            if (featureFilter != null) {
                Feature feature_choose = DAO.FeatureDAO.getInstance().getFeature(featureFilter);
                request.setAttribute("FEATURE_CHOOSE", feature_choose);
            }
            session.setAttribute("CLASS_CHOOSE", classroom);
            request.setAttribute("LIST_TEAM", DAO.TeamDAO.getInstance().getList(classFilter, login, "", 0, Integer.MAX_VALUE, "team_id", true, null));
            request.setAttribute("LIST_FEATURE", DAO.FeatureDAO.getInstance().getList(type, login, "", 0, Integer.MAX_VALUE, "feature_id", true, true));
            request.setAttribute("COMPLEXITY_LIST", DAO.SubjectSettingDAO.getInstance().getSubjectSettingTypeList(11, DAO.ClassDAO.getInstance().getClass(login, classFilter).getSubject().getSubject_id()));
            List<ClassUser> listClassUser = DAO.ClassUserDAO.getInstance().getList(type, null, "", (thisPage - 1) * 10, 10, login, classFilter, "user_id", true);
            request.setAttribute("LIST_CLASS_USER", listClassUser);
            boolean isLeader = false;
            boolean isDropped = false;
            ClassUser cu = DAO.ClassUserDAO.getInstance().getClassUser(
                    classroom.getClass_id(),
                    login.getUser_id());
            if (cu != null) {
                isLeader = cu.isTeam_leader();
                isDropped=!cu.isStatus();
            }
            request.setAttribute("isLeader", isLeader);
            request.setAttribute("isDropped", isDropped);
            switch (service) {
                case "list":
                    String search = request.getParameter("search");
                    if (search == null) {
                        search = "";
                    } else {
                        search = search.trim();
                    }
                    String sort = request.getParameter("sort");
                    boolean statusSort = request.getParameter("sortStatus") == null ? true : Boolean.parseBoolean(request.getParameter("sortStatus"));
                    if (sort == null) {
                        sort = request.getParameter("previousSort") == null ? "function_id" : (String) request.getParameter("previousSort");
                        statusSort = true;
                    } else {
                        if (sort.equals((String) request.getParameter("previousSort"))) {
                            statusSort = !statusSort;
                        }
                    }
                    request.setAttribute("SORT_FUNCTION", sort);
                    request.setAttribute("SORT_STATUS", statusSort);
                    
                    request.setAttribute("SEARCH_WORD", search);
                    request.setAttribute("STATUS_CHOOSE", status == null ? null : DAO.ClassSettingDAO.getInstance().getClassSetting(classFilter, 10, status));
                    request.setAttribute("STATUS_VALUE", status);
                    request.setAttribute("COMPLEXITY_CHOOSE", complexityChoose);
                    request.setAttribute("THIS_PAGE", thisPage);
                    List<Function> funcList = DAO.FunctionDAO.getInstance().getList(type, featureFilter, login, search, (thisPage - 1) * 10, 10, "function_id", statusSort, status, 
                            complexityChoose==null?null:complexityChoose.getSetting_value(), 
                            priorityFilter,ownerFilter);
                    request.setAttribute("LIST_FUNCTION", funcList);
                    Set<Integer> priorityList = new HashSet<>();
                    for (Function func : DAO.FunctionDAO.getInstance().getList(type, featureFilter, login, search, 0, Integer.MAX_VALUE, "function_id", statusSort, status, 
                            complexityChoose==null?null:complexityChoose.getSetting_value(), null, ownerFilter)) {
                        priorityList.add(func.getPriority());
                    }
                    request.setAttribute("FUNCTION_SIZE", (int) Math.ceil(DAO.FunctionDAO.getInstance().countRows("function", search, (login.getRole_id() == 4 ? "and team_id = (select team_id from class_user where user_id="+login.getUser_id()+" )" :"".concat(login.getRole_id()==2?"and team_id in (select team_id from `studentmanagement`.`team` where class_id in (select class_id from class where subject_id in (select subject_id from subject where author_id="+login.getUser_id()+")))":"").concat(login.getRole_id()==3?"and team_id in (select team_id from `studentmanagement`.`team` where class_id in (select class_id from class where trainer_id in (select trainer_id from class where trainer_id="+login.getUser_id()+")))":"")) 
                 + (type == 0 ? "" : " and team_id = " + type)
                + (featureFilter == null ? "" : " and feature_id = " + featureFilter)
                + (complexityFilter == null ? "" : " and complexity_id = " + complexityChoose.getSetting_value())
                + (priorityFilter== null ? "" : " and priority = " + priorityFilter)
                + (status == null ? "" : " and status = " + status)) * 1.0 / 10));
                    request.setAttribute("PRIORITY_LIST", priorityList);
                    request.setAttribute("PRIORITY_CHOOSE", priorityFilter);
                     request.setAttribute("OWNER_CHOOSE", ownerFilter==null||classroom==null?null:DAO.ClassUserDAO.getInstance().getClassUser(classroom.getClass_id(), ownerFilter));
                    dispathForward(request, response, "function/list.jsp");
                    break;
                case "changeStatus":
                    try {
                        int statusChange = Integer.parseInt(request.getParameter("status"));
                        ClassSetting cs = DAO.ClassSettingDAO.getInstance().getClassSetting(status);
                        String submit = request.getParameter("submit");
                        if (submit == null) {
                            session.setAttribute("FUNCTION_CHANGE_STATUS", DAO.FunctionDAO.getInstance().getFunction(id));
                            session.setAttribute("STATUS_CHANGE", DAO.ClassSettingDAO.getInstance().getClassSetting(statusChange));
                        } else {
                            session.removeAttribute("FUNCTION_CHANGE_STATUS");
                            session.removeAttribute("STATUS_CHANGE");
                            if (DAO.FunctionDAO.getInstance().updateStatus(id, cs.getSetting_value())) {
                                success = "Function Status change successfully!";
                            } else {
                                error.add("Tracking status change failed!");
                            }
                        }
                    } catch (Exception e) {
                        session.removeAttribute("FUNCTION_CHANGE_STATUS");
                        session.removeAttribute("STATUS_CHANGE");
                    }
                    response.sendRedirect("function?service=list");
                    break;
                case "update":
                    String team_id = request.getParameter("type");
                    String feature_id = request.getParameter("feature_id");
                    String function_name = request.getParameter("title");
                    String complexity_id = request.getParameter("complexity_id");
                    String owner_id = request.getParameter("owner_id");
                    String priority = request.getParameter("priority");
                    String access_role = request.getParameter("access_roles");
                    status = Integer.parseInt(request.getParameter("status"));
                    String description = request.getParameter("description");
                    if (!DAO.FunctionDAO.getInstance().updateFunction(
                            new Function(id,
                                    Integer.parseInt(team_id),
                                    Integer.parseInt(feature_id),
                                    Integer.parseInt(complexity_id),
                                    Integer.parseInt(owner_id),
                                    Integer.parseInt(priority), function_name, description, access_role, status))) {
                        error.add("Update Function Fail!");
                        request.setAttribute("ERROR", error);
                    } else {
                        success = "Update Successfully!";
                    }
                    url = "function?service=list";
                    break;
                case "add":
                    String submit = request.getParameter("submitForm");
                    if (submit == null) {
                        dispathForward(request, response, "function/detail.jsp");
                    } else {
                        if (submit.equals("class")) {
                            dispathForward(request, response, "function/detail.jsp");
                        } else if (submit.equals("type")) {
                            dispathForward(request, response, "function/detail.jsp");
                        } else {
                            team_id = request.getParameter("type");

                            feature_id = request.getParameter("feature_id") == null ? "0" : request.getParameter("feature_id");
                            Feature fe = DAO.FeatureDAO.getInstance().getFeature(Integer.parseInt(feature_id));
                            if (!fe.isStatus()) {
                                error.add("This feature is inactive!");
                            } else {
                                function_name = request.getParameter("title");
                                complexity_id = request.getParameter("complexity_id");
                                owner_id = request.getParameter("owner_id");
                                priority = request.getParameter("priority");
                                String role = request.getParameter("access_roles");
                                status = Integer.parseInt(request.getParameter("status"));
                                description = request.getParameter("description");
                                Function f1 = new Function(
                                        0,
                                        Integer.parseInt(team_id),
                                        Integer.parseInt(feature_id),
                                        Integer.parseInt(complexity_id),
                                        Integer.parseInt(owner_id),
                                        Integer.parseInt(priority), function_name, description, role, status);
                                if (FunctionDAO.getInstance().checkAddFunction(team_id, Integer.parseInt(feature_id), function_name) > 0) {
                                    error.add("This function has existed in this feature!");
                                } else {
                                    int addid = DAO.FunctionDAO.getInstance().addFunction(f1);
                                    if (addid < 0) {
                                        error.add("Add Function Fail!");
                                    } else {
                                        success = "Add successfully!";
                                    }
                                }
                            }

                            url = "function";
                        }
                    }
                    break;
                case "detail":
                    Function function_choose = DAO.FunctionDAO.getInstance().getFunction(id);
                    int statusfc = function_choose.isStatus();

                    List<ClassSetting> statusList = DAO.ClassSettingDAO.getInstance().getList(10, classFilter, "", login, 0, Integer.MAX_VALUE, "setting_id", true, 1);
                    for (int i = 0; i < statusList.size(); i++) {
                        if (statusList.get(i).getSetting_value() == statusfc) {
                            for (int j = 0; j < i; j++) {
                                statusList.remove(0);
                            }
                        }
                    }
                    request.setAttribute("LIST_STATUS", statusList);
                    boolean isDisabled = false;

                    if (cu != null) {
                        isLeader = cu.isTeam_leader();
                        if (!cu.isStatus()) {
                            isDisabled = true;
                        } else {
                            if (function_choose.getFunctionStatus().getSetting_value() == 7) {
                                isDisabled = true;
                            } else {
                                if (!cu.isTeam_leader()) {
                                    if (login.getRole_id() < 4 || login.getUser_id() != function_choose.getOwner_id()) {
                                        isDisabled = true;
                                    }
                                }

                            }
                        }

                    } else {
                        isDisabled = true;
                    }

                    request.setAttribute("isLeader", isLeader);
                    request.setAttribute("serve", "update");
                    request.setAttribute("FUNCTION_CHOOSE", function_choose);
                    request.setAttribute("isDisabled", isDisabled);
                    dispathForward(request, response, "function/detail.jsp");
                    break;
                case "exportExcel":
                    Team team_choose = DAO.TeamDAO.getInstance().getTeam(type);
                    List<Function> functions = DAO.FunctionDAO.getInstance().getList(type, null, login, "", 0, Integer.MAX_VALUE, "function_id", true, null, null, null, null);
                    if (functions.size() > 0) {
                        File desktop = new File(System.getProperty("user.home"), "/Desktop");
                        String path = desktop.getAbsolutePath() + File.separator + classroom.getClass_code() + "_Group" + team_choose.getTeam_name() + "_FunctionList" + ".xlsx";

                        File newFile = new File(path);
                        if (newFile.exists()) {
                            newFile.delete();
                        }
                        newFile.createNewFile();
                        Workbook workbook = writeExcel(functions, path, classroom.getClass_code() + "_Group" + classroom.getSubject().getSubject_code() + "_" + team_choose.getTeam_name() + "_FunctionList");
                        try (OutputStream os = new FileOutputStream(path)) {
                            workbook.write(os);
                        }
                        response.reset();
                        response.setHeader("Content-Disposition", "attachment;filename=" + classroom.getClass_code() + "_Group" + team_choose.getTeam_name() + "_FunctionList" + ".xlsx");
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
                        error.add("Team's Function is empty! Cannot export");
                    }
                    response.sendRedirect("function?service=list&class=" + type);
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
                                    String feature = row.getCell(0).getStringCellValue().trim();
                                    int featureID = DAO.FeatureDAO.getInstance().checkAddFeature(type, feature);
                                    if (featureID == -1) {
                                        featureID = DAO.FeatureDAO.getInstance().addFeature(new Feature(0, type, feature, "", true));
                                    }
                                    Feature ff = DAO.FeatureDAO.getInstance().getFeature(featureID);
                                    if (!ff.isStatus()) {
                                        DAO.FeatureDAO.getInstance().updateStatus(featureID, true);
                                    }
                                    String functionName = row.getCell(1).getStringCellValue();
                                    if (DAO.FunctionDAO.getInstance().checkAddFunction(String.valueOf(type), featureID, functionName) < 0) {
                                        row.getCell(2).setCellType(CellType.STRING);
                                        String Fpriority = row.getCell(2).getStringCellValue();
                                        String access = row.getCell(3).getStringCellValue();
                                        String des = row.getCell(4).getStringCellValue();
                                        Function f1 = new Function(
                                                0,
                                                type,
                                                featureID,
                                                3,
                                                login.getUser_id(),
                                                Integer.parseInt(Fpriority), functionName, des, access, 1);

                                        int addid = DAO.FunctionDAO.getInstance().addFunction(f1);
                                        if (addid < 0) {
                                            error.add("Add Function Fail!");
                                        } else {
                                            success = "Add successfully!";
                                        }
                                    } else {
                                        error.add("Function " + functionName + " existed in this feature!");
                                    }

                                } catch (Exception e) {
                                    e.printStackTrace(new PrintWriter(errors));
                                    logger.error(errors.toString());
                                }
                            }
                            file.delete();
                        }
                    }
                    response.sendRedirect("function?service=list&type=" + type);
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

    public static Workbook writeExcel(List<Function> list, String excelFilePath, String fileName) throws IOException {
        // Create Workbook
        Workbook workbook = getWorkbook(excelFilePath);

        // Create sheet
        Sheet sheet = workbook.createSheet(fileName); // Create sheet with sheet name

        int rowIndex = 0;

        // Write header
        writeHeader(sheet, rowIndex);

        // Write data
        rowIndex++;
        for (Function book : list) {
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
        cell.setCellValue("Feature");

        cell = row.createCell(2);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Function Name");

        cell = row.createCell(3);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Owner");

        cell = row.createCell(4);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Priority");

        cell = row.createCell(5);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Complexity");

        cell = row.createCell(6);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Access Roles");

        cell = row.createCell(7);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Status");
        cell = row.createCell(8);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("Description");

    }

    // Write data
    private static void writeBook(Function function, Row row) {
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

        cell.setCellType(Cell.CELL_TYPE_STRING);
        cell.setCellValue(function.getTeam().getTeam_name());

        cell = row.createCell(1);

        cell.setCellValue(function.getFeature().getFeature_name());

        cell = row.createCell(2);

        cell.setCellValue(function.getFunction_name());

        cell = row.createCell(3);

        cell.setCellValue(function.getOwner().getFull_name());

        cell = row.createCell(4);

        cell.setCellValue(function.getPriority());

        // Create cell formula
        // totalMoney = price * quantity
//        cell = row.createCell(COLUMN_INDEX_TOTAL, CellType.FORMULA);
//        cell.setCellStyle(cellStyleFormatNumber);
//        int currentRow = row.getRowNum() + 1;
//        String columnPrice = CellReference.convertNumToColString(COLUMN_INDEX_PRICE);
//        String columnQuantity = CellReference.convertNumToColString(COLUMN_INDEX_QUANTITY);
//        cell.setCellFormula(columnPrice + currentRow + "*" + columnQuantity + currentRow);
        cell = row.createCell(5);
        cell.setCellValue(function.getComplexity().getSetting_title());

        cell = row.createCell(6);
        cell.setCellValue(function.getAccess_roles());

        cell = row.createCell(7);
        cell.setCellValue(function.getFunctionStatus().getSetting_title());

        cell = row.createCell(8);
        cell.setCellValue(function.getDescription());

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
