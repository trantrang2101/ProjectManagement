<%-- 
    Document   : profile
    Created on : May 18, 2022, 8:55:38 AM
    Author     : win
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="../included/head.jsp" />
        <c:set var="class" value="${requestScope.CLASS_CHOOSE}"></c:set>
            <link href="css/styles.css" rel="stylesheet" />
            <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.5/xlsx.min.js"></script>
            <title class="text-capitalize">Class User List (${class.getSubject().getSubject_code()}) ${class.class_code} (${class.getSetting().getSetting_title()}-${class.class_year})</title>
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
                                                <div class="page-header-icon"><i data-feather="user"></i></div>
                                                Class User List
                                            </h1>
                                        </div>
                                        <c:if test="${loginUser.getRole_id()<4}">
                                            <div class="col-12 col-xl-auto mb-3 d-flex justify-content-between">
                                                <a data-bs-toggle="modal" href="#addClassUser" class="btn btn-primary" style="margin-right: 1rem;">
                                                    <i class="fa-solid fa-plus"></i>
                                                    Add New Class User
                                                </a>
                                                <c:if test="${requestScope.LIST_CLASS_USER.size()>0}">
                                                    <a href="classUser?service=exportExcel&class=${class.getClass_id()}" class="btn btn-primary">
                                                        <i data-feather="external-link"></i>
                                                        Export Class
                                                    </a>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </div>
                                    <div class="modal fade" id="addClassUser" tabindex="-1" role="dialog" aria-labelledby="addPerson" aria-hidden="true" style="">
                                        <div class="modal-dialog modal-xl" role="document">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="exampleModalLabel">Add Student</h5>
                                                    <button type="button" class="btn-close" onclick="refreshTable()" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <form action="classUser" method="POST" enctype="multipart/form-data">
                                                    <div class="modal-body">
                                                        <div class="d-flex flex-column justify-content-around">
                                                            <input type="file" onchange="upload()" name="excel" hidden accept=".csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" id="inputExcel" />
                                                            <input type="hidden" name="class" value="${class.class_id}">
                                                            <div class="w-100 d-flex justify-content-around">
                                                                <label for="inputExcel" class="btn padding-0 icon rounded-circle bg-primary">
                                                                    <i class="text-white fa-solid fa-file-excel center"></i>
                                                                </label>
                                                                <a href="classUser?class=${class.class_id}&service=add" class="btn icon rounded-circle bg-primary padding-0">
                                                                    <i class="fa-solid fa-keyboard text-white center"></i>
                                                                </a>
                                                            </div>
                                                            <div>
                                                                <h2>Guide insert Excel</h2>
                                                                <i class="text-muted">If you do not follow this guide you cannot insert <strong>Student</strong> into data</i>
                                                                <a href="assets/demo/demoClassUser.xlsx" download="">Click here to download template!</a>
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
                                            <li class="breadcrumb-item"><a href="class"> Class List</a></li>
                                            <li class="breadcrumb-item text-capitalize"><a href="class?type=${class.getSubject().getSubject_id()}">${class.getSubject().getSubject_code()}</a></li>
                                            <li class="breadcrumb-item text-capitalize"><a href="class?id=${class.getClass_id()}&service=${loginUser.getRole_id()>3?'detail':'update'}"> (${class.getSubject().getSubject_code()}) ${class.class_code} (${class.getSetting().getSetting_title()}-${class.class_year})</a></li>
                                            <li class="breadcrumb-item active">Class User ${classChoose.isBlock5_class()?"<span class='badge bg-red-soft text-red'>Block 5</span>  -  ":""}</li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                        </header>
                        <div class="container-fluid px-4">
                            <div class="card p-4 mb-4 mt-5">
                                <div class="card-header d-flex flex-column justify-content-between bg-white">
                                    <div class="">
                                        <div class="row" style="padding:  1 rem !important;box-sizing: border-box;">
                                            <div class="dropdown mb-3 col-xl-6 col-lg-12">
                                                <label for="class" class="form-label">Class</label>
                                                <button class="form-select text-capitalize border-0 border-bottom bg-transparent d-flex align-items-start" id="class" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    (${class.getSubject().getSubject_code()}) ${class.class_code} (${class.getSetting().getSetting_title()}-${class.class_year})
                                                </button>
                                                <div class="dropdown-menu w-100" aria-labelledby="class">
                                                    <c:forEach items="${sessionScope.LIST_CLASS}" var="classChoose">
                                                        <a class="dropdown-item text-capitalize w-100" href="classUser?class=${classChoose.class_id}">(${classChoose.getSubject().getSubject_code()}) ${classChoose.class_code} (${classChoose.getSetting().getSetting_title()}-${classChoose.class_year})</a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="dropdown mb-3 col-xl-2 col-lg-4">
                                                <label for="team" class="form-label">Team</label>
                                                <button class="form-select text-capitalize border-0 border-bottom bg-transparent d-flex align-items-start" id="team" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    <c:choose>
                                                        <c:when test="${requestScope.TEAM_CHOOSE!=null}">
                                                            ${requestScope.TEAM_CHOOSE.getTeam_name()}
                                                        </c:when>                                
                                                        <c:otherwise>
                                                            All Teams
                                                        </c:otherwise>
                                                    </c:choose>
                                                </button>
                                                <div class="dropdown-menu" aria-labelledby="team">
                                                    <a class="dropdown-item" href="classUser?class=${class.getClass_id()}${requestScope.SORT_FILTER==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)}">All</a>
                                                    <c:forEach items="${requestScope.LIST_TEAM}" var="team">
                                                        <a class="dropdown-item text-capitalize" href="classUser?class=${class.getClass_id()}&type=${team.getTeam_id()}${requestScope.TEAM_CHOOSE==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)}">${team.getTeam_name()}</a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <c:if test="${loginUser.getRole_id()<4}">
                                                <div class="dropdown mb-3 col-xl-2 col-lg-4">
                                                    <label for="status" class="form-label">Status</label>
                                                    <button class="form-select text-capitalize border-0 border-bottom d-flex align-items-start" id="status" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                        <c:choose>
                                                            <c:when test="${requestScope.SORT_FILTER!=null}">
                                                                ${requestScope.SORT_FILTER==1?"Activate":"Deactivate"}
                                                            </c:when>                                
                                                            <c:otherwise>
                                                                All Status
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </button>
                                                    <div class="dropdown-menu " aria-labelledby="status">
                                                        <a class="nav-link" href="classUser?class=${class.getClass_id()}${requestScope.TEAM_CHOOSE==null?"":"&type=".concat(requestScope.TEAM_CHOOSE.getTeam_id())}">All</a>
                                                        <a class="nav-link text-capitalize" href="classUser?class=${class.getClass_id()}&statusFilter=1${requestScope.TEAM_CHOOSE==null?"":"&type=".concat(requestScope.TEAM_CHOOSE.getTeam_id())}">Activate</a>
                                                        <a class="nav-link text-capitalize" href="classUser?class=${class.getClass_id()}&statusFilter=0${requestScope.TEAM_CHOOSE==null?"":"&type=".concat(requestScope.TEAM_CHOOSE.getTeam_id())}">Deactivate</a>
                                                    </div>
                                                </div>
                                            </c:if>
                                            <div class="mb-3 col-xl-2 col-lg-4 ms-auto">
                                                <label for="search" class="form-label">Search</label>
                                                <form action="classUser" id="search" method="POST">
                                                    <input type="submit" name="class" value="${class.getClass_id()}" hidden="">
                                                    <input type="text" name="search" placeholder="Click enter to search..." value="${search}" class="form-control form-search">
                                                </form> 
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body table-responsive">
                                    <table class="table table-striped table-hover table-bordered padding-0">
                                        <thead class="table-primary">
                                        <form action="classUser" method="POST">
                                            <tr>
                                                <th>No</th>
                                                <th>
                                                    <input type="text" name="class" value="${class.getClass_id()}" hidden="">
                                                    <input type="text" name="search" value="${search}" hidden="">
                                                    <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                    <input type="text" name="previousSort" value="${requestScope.SORT_CLASS_USER}" hidden="">
                                                    <button class="bg-transparent border-0" type="submit" name="sort" value="team_id"><b>Team</b><i class="fa-solid fa-sort"></i></button>
                                                </th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="user_id"><b>Student</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="team_leader"><b>Leader</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="ongoing_eval"><b>Ongoing</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="final_pres_eval"><b>Final Pres</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="final_topic_eval"><b>Final Topic</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="dropout_date"><b>Dropout</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="status"><b>Status</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th>Actions</th>
                                            </tr>
                                        </form>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${requestScope.LIST_CLASS_USER.size()==0}">
                                                    <tr><td class="dataTables-empty" colspan="10">No results match your search query</td></tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach items="${requestScope.LIST_CLASS_USER}" varStatus="count" var="classUser">
                                                        <tr>
                                                            <td>${count.getCount()+(requestScope.THIS_PAGE-1)*10}</td>
                                                            <td> ${classUser.getTeam().getTeam_name()}</td>
                                                            <td>${classUser.getUser().getFull_name()}</td>
                                                            <td>${classUser.isTeam_leader()?"LEADER":""} </td>                
                                                            <td>${classUser.getOngoing_eval()} </td>                
                                                            <td>${classUser.getFinal_pres_eval()} </td>                
                                                            <td>${classUser.getFinal_topic_eval()} </td>                
                                                            <td>${classUser.getDropoutFormat()} </td>                
                                                            <td class="text-center form-switch">
                                                                <a data-bs-toggle="modal" href="#deleteClass${classUser.getClass_id()}User${classUser.getUser_id()}">
                                                                    <input ${loginUser.getRole_id()<4?'':'disabled=""'} class="form-check-input" type="checkbox" ${classUser.isStatus()?"checked":""}>
                                                                </a>
                                                            </td>
                                                            <td>
                                                                <a href="classUser?class=${classUser.getClass_id()}&service=update&user=${classUser.getUser_id()}">
                                                                    <i data-feather="edit"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    <div class="modal fade" id="deleteClass${classUser.getClass_id()}User${classUser.getUser_id()}" tabindex="-1" aria-labelledby="deleteClass${classUser.getClass_id()}User${classUser.getUser_id()}" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="exampleModalLabel">${classUser.isStatus()?"Deactive":"Active"} Class User</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    Are you sure to ${subjectChoose.isStatus()?"deactive":"active"} Student <span class="text-capitalize">${classUser.getUser().getFull_name()}</span> from class ${classUser.getClassroom().getClass_code()} (${classUser.getClassroom().getSubject().getSubject_code()}-${classUser.getClassroom().getSubject().getSubject_name()})?
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset"></input>
                                                                    <a href="classUser?class=${classUser.getClass_id()}&user=${classUser.getUser_id()}&status=${classUser.isStatus()}&service=changeStatus" class="btn btn-primary">Change</a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="card-footer bg-white">
                                    <nav class="d-flex align-items-end justify-content-end" aria-label="">
                                        <form action="classUser "method="POST">
                                            <input type="text" name="class" value="${class.getClass_id()}" hidden="">
                                            <input type="text"  hidden="" name="search" value="${search}">
                                            <input type="text" name="sort" value="${requestScope.SORT_CLASS_USER}" hidden="">
                                            <input type="text" name="type" value="${requestScope.TEAM_CHOOSE.getTeam_id()}" hidden="">
                                            <input type="text" name="statusFilter" value="${requestScope.SORT_FILTER}" hidden="">
                                            <c:set var="thisPage" value="${requestScope.THIS_PAGE}"></c:set>
                                            <c:set var="size" value="${requestScope.CLASS_USER_SIZE}"></c:set>
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
                    </main>
                </div>
            </div>
        </div>
        <jsp:include page="../included/footer.jsp"/>
    </div>
    <script>
        function refreshTable() {
            document.querySelector('#importFooter').style.display = "none";
            document.getElementById('display_excel_data').innerHTML = '';
        }
        function displayJsonToHtmlTable(jsonData) {
            var table = document.getElementById("display_excel_data");
            if (jsonData.length > 0) {
                var htmlData = '<tr class="table-primary"><th>Group_name</th><th>User_name</th><th>Roll_number</th><th>Full_name</th><th>Group_leader</th></tr>';
                for (var i = 0; i < jsonData.length; i++) {
                    var row = jsonData[i];
                    htmlData += '<tr><td>' + row["Group_name"] + '</td><td>' + row["User_name"]
                            + '</td><td>' + row["Roll_number"] + '</td><td>' + row["Full_name"] + '</td><td>' + row["Group_leader"] + '</td></tr>';
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
