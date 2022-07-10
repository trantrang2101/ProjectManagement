<%-- 
    Document   : issueList
    Created on : Jun 22, 2022, 7:09:41 PM
    Author     : Admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="../included/head.jsp" />
        <c:set var="user" value="${requestScope.USER_CHOOSE}"></c:set>
            <link href="css/styles.css" rel="stylesheet" />
            <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.5/xlsx.min.js"></script>
            <title class="text-capitalize">Issue List (${user.full_name}) ${user.email} </title>
    </head>
    <body>
        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
        <c:set var="search" value="${requestScope.SEARCH_WORD}"></c:set>
            <div class="nav-fixed">
            <jsp:include page="../included/header.jsp"/>
            <div id="layoutSidenav">
                <jsp:include page="../included/slider.jsp"/>
                <div id="layoutSidenav_content">
                    <main>
                        <header class="page-header page-header-compact page-header-light bg-white mb-4">
                            <div class="container-fluid px-4">
                                <div class="page-header-content">
                                    <div class="row align-items-center justify-content-between pt-3">
                                        <div class="col-auto mb-3">
                                            <h1 class="page-header-title">
                                                <div class="page-header-icon"><i data-feather="issue"></i></div>
                                                Issue List
                                            </h1>
                                        </div>
                                        <div class="col-12 col-xl-auto mb-3 d-flex justify-content-between">
                                            <a data-bs-toggle="modal" href="#addIssue" class="btn btn-primary" style="margin-right: 1rem;">
                                                <i class="fa-solid fa-plus"></i>
                                                Add New Issue
                                            </a>
                                            <c:if test="${requestScope.LIST_ISSUE.size()>0}">
                                                <a href="issue?service=exportExcel&user=${user.getUser_id()}" class="btn btn-primary">
                                                    <i data-feather="external-link"></i>
                                                    Export Issue
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="modal fade" id="addIssue" tabindex="-1" role="dialog" aria-labelledby="addPerson" aria-hidden="true" style="">
                                        <div class="modal-dialog modal-xl" role="document">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="exampleModalLabel">Add Issue</h5>
                                                    <button type="button" class="btn-close" onclick="refreshTable()" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <form action="issue" method="POST" enctype="multipart/form-data">
                                                    <div class="modal-body">
                                                        <div class="d-flex flex-column justify-content-around">
                                                            <input type="file" onchange="upload()" name="excel" hidden accept=".csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" id="inputExcel" />
                                                            <input type="hidden" name="user" value="${user.user_id}">
                                                            <div class="w-100 d-flex justify-content-around">
                                                                <label for="inputExcel" class="btn padding-0 icon rounded-circle bg-primary">
                                                                    <i class="text-white fa-solid fa-file-excel center"></i>
                                                                </label>
                                                                <a href="issue?user=${user.user_id}&service=add" class="btn icon rounded-circle bg-primary padding-0">
                                                                    <i class="fa-solid fa-keyboard text-white center"></i>
                                                                </a>
                                                            </div>
                                                            <div>
                                                                <h2>Guide insert Excel</h2>
                                                                <i class="text-muted">If you do not follow this guide you cannot insert <strong>Issue</strong> into data</i>
                                                                <a href="assets/demo/demoIssue.xlsx" download="">Click here to download template!</a>
                                                                <div class="table-responsive">
                                                                    <table class="table table-striped table-hover table-bordered padding-0" id="display_excel_data"></table>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer" id="importFooter" style="display: none;">
                                                        <button type="submit" class="btn btn-primary" onclick="document.querySelector('#preloader').style.display = 'block';" name="service" value="importExcel">Import</button>
                                                        <button type="reset" class="btn btn-light" onclick="refreshTable()" data-bs-dismiss="modal" aria-label="Close">Cancel</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="user"> User List</a></li>
                                            <li class="breadcrumb-item text-capitalize"><a href="user?id=${user.getUser_id()}">${user.getFull_name()}</a></li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                        </header>
                        <div class="container-fluid px-4">
                            <div class="card p-4 mb-4 mt-5">
                                <div class="card-header d-flex flex-column justify-content-between bg-white">
                                    <div class="card-header d-flex justify-content-between align-items-center bg-white padding-0" style="padding-bottom: 1rem !important">
                                        <!--Filter-->
                                        <div class="d-flex justify-content-sm-start align-items-center">
                                            <!--                                    Class filter-->
                                            <div class="dropdown" style="margin-right: 10px;">
                                                <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    <c:choose>
                                                        <c:when test="${requestScope.CLASS_CHOOSE!=null}">
                                                            ${requestScope.CLASS_CHOOSE.getSubject().getSubject_code()}_ ${requestScope.CLASS_CHOOSE.getClass_code()}
                                                        </c:when>                                
                                                        <c:otherwise>
                                                            ${sessionScope.LIST_CLASS.get(0).getSubject().getSubject_code()}_ ${sessionScope.LIST_CLASS.get(0).getClass_code()}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </button>
                                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                    <c:forEach items="${sessionScope.LIST_CLASS}" var="class">
                                                        <a class="dropdown-item text-capitalize" href="issue?class=${class.getClass_id()}${requestScope.STATUS_VALUE!=null?"&status=".concat(requestScope.STATUS_VALUE):""}">${class.getSubject().getSubject_code()}_ ${class.getClass_code()}</a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <!--                                    Team Filter-->
                                            <c:if test="${requestScope.LIST_TEAM!=null}">
                                                <div class="dropdown" style="margin-right: 10px;">
                                                    <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                        ${requestScope.TEAM_CHOOSE.getTeam_name()}
                                                    </button>
                                                    <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                        <c:forEach items="${requestScope.LIST_TEAM}" var="team">
                                                            <a class="dropdown-item text-capitalize" href="issue?team=${team.getTeam_id()}${class.getClass_id()}${requestScope.STATUS_VALUE!=null?"&status=".concat(requestScope.STATUS_CHOOSE):""}">${team.getTeam_name()}</a>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </c:if>
                                            <!--Status Filter-->
                                            <div class="dropdown" style="margin-right: 10px;">
                                                <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    <c:choose>
                                                        <c:when test="${requestScope.STATUS_CHOOSE!=null}">
                                                            ${requestScope.STATUS_CHOOSE.setting_title}
                                                        </c:when>                                
                                                        <c:otherwise>
                                                            All Status
                                                        </c:otherwise>
                                                    </c:choose>
                                                </button>
                                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                    <a class="dropdown-item" href="issue?${requestScope.STATUS_CHOOSE!=null?"?status=".concat(requestScope.STATUS_CHOOSE.setting_id):"?status="}${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}">All</a>
                                                    <c:forEach items="${requestScope.LIST_STATUS}" var="status">
                                                        <a class="dropdown-item text-capitalize" href="issue?status=${status.setting_value}${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}${requestScope.TEAM_CHOOSE!=null?"&team=".concat(requestScope.TEAM_CHOOSE.getTeam_id()):""}">${status.setting_title}</a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                        <div>
                                            <form action="issue" id="search" method="POST">
                                                <input type="text" name="search" placeholder="Click enter to search..." value="${search}" class="form-control form-search">
                                            </form> 
                                        </div>
                                    </div>
                                    <div class="card-body table-responsive">
                                        <table class="table table-striped table-hover table-bordered padding-0">
                                            <thead class="table-primary">
                                            <form action="issue" method="POST">
                                                <tr>
                                                    <th>
                                                        <input type="text" name="search" value="${search}" hidden="">
                                                        <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                        <input type="text" name="previousSort" value="${requestScope.SORT_TEAM}" hidden="">
                                                        <input type="text" name="user" value="${requestScope.USER_CHOOSE.getFull_name()}" hidden="">
                                                        <button class="bg-transparent border-0" type="submit" name="sort" value="issue_id"><b>ID</b><i class="fa-solid fa-sort"></i></button>
                                                    </th>
                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="assignee_id"><b>Assignee</b><i class="fa-solid fa-sort"></i></button></th>
                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="issue_title"><b>Title</b><i class="fa-solid fa-sort"></i></button></th>
                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="gitlab_id"><b>GitLab ID</b><i class="fa-solid fa-sort"></i></button></th>
                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="gitlab_url"><b>GitLab URL</b><i class="fa-solid fa-sort"></i></button></th>
                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="created_at"><b>Created At</b><i class="fa-solid fa-sort"></i></button></th>
                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="due_date"><b>Due Date</b><i class="fa-solid fa-sort"></i></button></th>
                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="team_id"><b>Team</b><i class="fa-solid fa-sort"></i></button></th>
                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="milestone_id"><b>Milestone</b><i class="fa-solid fa-sort"></i></button></th>
                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="function_id"><b>Function</b><i class="fa-solid fa-sort"></i></button></th>
                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="status"><b>Status</b><i class="fa-solid fa-sort"></i></button></th>
                                                    <th>Actions</th>
                                                </tr>
                                            </form>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${requestScope.LIST_ISSUE.size()==0}">
                                                        <tr><td class="dataTables-empty" colspan="8">No results match your search query</td></tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="issue" items="${requestScope.LIST_ISSUE}">
                                                            <tr>
                                                                <td>${issue.getIssue_id()}</td>
                                                                <td class="text-center">${issue.getUser().getFull_name()}</td>
                                                                <td>${issue.getIssue_title()}</td>
                                                                <td>${issue.getGitlab_id()}</td>
                                                                <td>${issue.getGitlab_url()}</td>
                                                                <td>${issue.getCreated_at()}</td>
                                                                <td>${issue.getDue_date()}</td>
                                                                <td class="text-center">${issue.getTeam().getTeam_name()}</td>
                                                                <td class="text-center">${issue.getMilestone().getMilestone_name()}</td>
                                                                <td class="text-center">${issue.getFunction().getFunction_name()}</td>
                                                                <td >${issue.getIssueStatus().setting_title}</td>
                                                                <td class="text-center">
                                                                    <a href="issue?id=${issue.getIssue_id()}&service=detail">
                                                                        <i data-feather="edit">Issue ${issue.getIssue_id()}</i>
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="card-footer bg-white">
                                        <nav class="d-flex align-items-end justify-content-end" aria-label="">
                                            <form action="issue" method="GET">
                                                <input type="text" hidden="" name="user" value="${requestScope.USER_CHOOSE}">
                                                <input type="text" hidden="" name="search" value="${search}">
                                                <input type="text" hidden="" name="sort" value="${requestScope.SORT_ISSUE}">
                                                <c:set var="thisPage" value="${requestScope.THIS_PAGE}"></c:set>
                                                <c:set var="size" value="${requestScope.ISSUE_SIZE}"></c:set>
                                                <input type="text" id="thisPage"  hidden="" value="${thisPage!=null?thisPage:1}">
                                                <ul id="pagination" class="pagination">
                                                    <c:if test="${thisPage>1}">
                                                        <li class="page-item page-pagination"><button class="page-link" name="page" value="1" type="submit">First</button></li>
                                                        </c:if>
                                                        <c:if test="${thisPage>3}">
                                                        <li class="page-item page-pagination"><button class="page-link" name="page" value="${thisPage-3}" type="submit">«</button></li>
                                                        </c:if>
                                                        <c:if test="${thisPage>1}">
                                                        <li class="page-item page-pagination"><button class="page-link" name="page" value="${thisPage-1}" type="submit">‹</button></li>
                                                        </c:if>
                                                        <c:forEach var = "i" begin = "1" end = "${size}">
                                                            <c:choose>
                                                                <c:when test="${i==thisPage}">
                                                                <li class="page-item page-pagination page-normal active"><button class="page-link" name="page" value="${i}" type="submit">${i}</button></li>
                                                                </c:when>
                                                                <c:otherwise>
                                                                <li class="page-item page-pagination page-normal"><button class="page-link" name="page" value="${i}" type="submit">${i}</button></li>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                        <c:if test="${thisPage<size}">
                                                        <li class="page-item page-pagination"><button class="page-link" name="page" value="${thisPage+1}" type="submit">›</button></li>
                                                        </c:if>
                                                        <c:if test="${thisPage<size-3}">
                                                        <li class="page-item page-pagination"><button class="page-link" name="page" value="${thisPage+3}" type="submit">»</button></li>
                                                        </c:if>
                                                        <c:if test="${thisPage<size}">
                                                        <li class="page-item page-pagination"><button class="page-link" name="page" value="${size}" type="submit">Last</button></li>
                                                        </c:if>
                                                </ul>
                                            </form>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                    <jsp:include page="../included/footer.jsp"/>
                </div>
            </div>
        </div>
        <script>
            function refreshTable() {
                document.querySelector('#importFooter').style.display = "none";
                document.getElementById('display_excel_data').innerHTML = '';
            }
            function displayJsonToHtmlTable(jsonData) {
                var table = document.getElementById("display_excel_data");
                if (jsonData.length > 0) {
                    var htmlData = '<tr class="table-primary"><th>Title</th><th>Description</th><th>Assignee(mail)</th><th>Milestone</th><th>Type</th><th>Function</th></tr>';
                    for (var i = 0; i < jsonData.length; i++) {
                        var row = jsonData[i];
                        htmlData += '<tr><td>' + row["Title"] + '</td><td>' + row["Description"] + '</td><td>' + row["Assignee(mail)"] + '</td><td>' + row["Milestone"] + '</td><td>' + row["Type"] + '</td><td>' + row["Function"] + '</td></tr>';
                    }
                    table.innerHTML = htmlData;
                    document.querySelector('#importFooter').style.display = "flex";
                } else {
                    table.innerHTML = 'There is no data in Excel';
                }
            }
            function excelFileToJSON(file) {
                try {
                    var reader = new FileReader();
                    reader.readAsBinaryString(file);
                    reader.onload = function (e) {
                        var data = e.target.result;
                        var workbook = XLSX.read(data, {
                            type: 'binary'
                        });
                        var result = {};
                        var firstSheetName = workbook.SheetNames[0];
                        //reading only first sheet data
                        var jsonData = XLSX.utils.sheet_to_json(workbook.Sheets[firstSheetName]);
//                    alert(JSON.stringify(jsonData));
                        //displaying the json result into HTML table
                        displayJsonToHtmlTable(jsonData);
                    }
                } catch (e) {
                    console.error(e);
                }
            }
            function upload() {
                var files = document.getElementById('inputExcel').files;
                if (files.length == 0) {
                    vNotify.error(
                            {text: '${error}', title: 'Please choose any file...'}
                    );
                    return;
                }
                var filename = files[0].name;
                var extension = filename.substring(filename.lastIndexOf(".")).toUpperCase();
                if (extension == '.XLS' || extension == '.XLSX') {
                    //Here calling another method to read excel file into json
                    excelFileToJSON(files[0]);
                } else {
                    vNotify.error(
                            {text: '${error}', title: 'Please select a valid excel file.'}
                    );
                }
            }
        </script>
        <script src="js/scripts.js"></script>
    </body>
</html>
