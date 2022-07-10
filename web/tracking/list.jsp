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
        <c:set var="class" value="${sessionScope.CLASS_CHOOSE}"></c:set>
            <link href="css/styles.css" rel="stylesheet" />
            <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.5/xlsx.min.js"></script>
            <title class="text-capitalize">Tracking List </title>
        </head>
        <body ${sessionScope.TRACKING_CHANGE_STATUS!=null&&sessionScope.STATUS_CHANGE!=null?' class="modal-open" style="overflow: hidden; padding-right: 8px;"':''}>
        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
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
                                                Tracking List
                                            </h1>
                                        </div>
                                        <c:if test="${loginUser.getRole_id()==4&&requestScope.TEAM_CHOOSE.getLeader().getUser_id()==loginUser.getUser_id()}">
                                            <div class="col-12 col-xl-auto mb-3 d-flex justify-content-between ms-auto">
                                                <a href="tracking?team=${requestScope.TEAM_CHOOSE.getTeam_id()}&service=add" class="btn btn-primary" style="margin-right: 1rem;">
                                                    <i class="fa-solid fa-plus"></i>
                                                    Add New Tracking
                                                </a>
                                            </div>
                                        </c:if>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="tracking${class!=null?'?class='.concat(class.getClass_id()):''}">Tracking</a></li>
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
                                            <div class="dropdown mb-3 col-xl-3 col-lg-6">
                                                <label for="class" class="form-label">Class</label>
                                                <button class="form-select text-capitalize border-0 border-bottom bg-transparent d-flex align-items-start" id="class" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    ${class.getSubject().getSubject_code()}_${class.class_code}
                                                </button>
                                                <div class="dropdown-menu w-100" aria-labelledby="class">
                                                    <c:forEach items="${sessionScope.LIST_CLASS}" var="classroom">
                                                        <a class="dropdown-item text-capitalize w-100" href="tracking?class=${classroom.class_id}">${classroom.getSubject().getSubject_code()}_${classroom.class_code}</a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="dropdown mb-3 col-xl-2 col-lg-6">
                                                <label for="team" class="form-label">Team</label>
                                                <button class="form-select text-capitalize border-0 border-bottom bg-transparent d-flex align-items-start" id="team" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    ${requestScope.TEAM_CHOOSE.getTeam_name()}
                                                </button>
                                                <div class="dropdown-menu" aria-labelledby="team">
                                                    <c:forEach items="${requestScope.LIST_TEAM}" var="team">
                                                        <a class="dropdown-item text-capitalize" href="tracking?team=${team.getTeam_id()}${requestScope.SORT_FILTER==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)}">${team.getTeam_name()}</a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="dropdown mb-3 col-xl-3 col-lg-6">
                                                <label for="class" class="form-label">Feature</label>
                                                <button class="form-select text-capitalize border-0 border-bottom bg-transparent d-flex align-items-start" id="class" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    <c:choose>
                                                        <c:when test="${requestScope.FEATURE_CHOOSE!=null}">
                                                            ${requestScope.FEATURE_CHOOSE.getFeature_name()}
                                                        </c:when>                                
                                                        <c:otherwise>
                                                            All Features
                                                        </c:otherwise>
                                                    </c:choose>
                                                </button>
                                                <div class="dropdown-menu w-100" aria-labelledby="class">
                                                    <a class="dropdown-item text-capitalize w-100" href="tracking?team=${requestScope.TEAM_CHOOSE.team_id}${requestScope.SORT_FILTER==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)}${requestScope.ASSIGNEE_CHOOSE==null?"":"&assignee=".concat(requestScope.ASSIGNEE_CHOOSE.getUser_id())}">All</a>
                                                    <c:forEach items="${requestScope.LIST_FEATURE}" var="feature">
                                                        <a class="dropdown-item text-capitalize w-100" href="tracking?team=${requestScope.TEAM_CHOOSE.team_id}&type=${feature.getFeature_id()}${requestScope.SORT_FILTER==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)}${requestScope.ASSIGNEE_CHOOSE==null?"":"&assignee=".concat(requestScope.ASSIGNEE_CHOOSE.getUser_id())}">${feature.getFeature_name()}</a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="mb-3 col-xl-2 col-lg-12">
                                                <label for="status" class="form-label">Assignee</label>
                                                <button class="form-select text-capitalize border-0 border-bottom d-flex align-items-start" id="status" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    <c:choose>
                                                        <c:when test="${requestScope.ASSIGNEE_CHOOSE!=null}">
                                                            ${requestScope.ASSIGNEE_CHOOSE.getUser().getFull_name()}
                                                        </c:when>                                
                                                        <c:otherwise>
                                                            All Assignee
                                                        </c:otherwise>
                                                    </c:choose>
                                                </button>
                                                <div class="dropdown-menu " aria-labelledby="status">
                                                    <a class="nav-link text-dark text-normal" href="tracking?team=${requestScope.TEAM_CHOOSE.team_id}${requestScope.SORT_FILTER==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER.getSetting_id())}">All</a>
                                                    <c:forEach items="${requestScope.LIST_USER}" var="user">
                                                        <a class="nav-link text-capitalize text-dark text-normal" href="tracking?team=${requestScope.TEAM_CHOOSE.team_id}&assignee=${user.getUser_id()}${requestScope.SORT_FILTER==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER.getSetting_id())}">${user.getUser().getFull_name()}</a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="dropdown mb-3 col-xl-2 col-lg-6">
                                                <label for="status" class="form-label">Status</label>
                                                <button class="form-select text-capitalize border-0 border-bottom d-flex align-items-start" id="status" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    <c:choose>
                                                        <c:when test="${requestScope.SORT_FILTER!=null}">
                                                            ${requestScope.SORT_FILTER.getSetting_title()}
                                                        </c:when>                                
                                                        <c:otherwise>
                                                            All Status
                                                        </c:otherwise>
                                                    </c:choose>
                                                </button>
                                                <div class="dropdown-menu " aria-labelledby="status">
                                                    <a class="nav-link text-dark text-normal" href="tracking?team=${requestScope.TEAM_CHOOSE.team_id}">All</a>
                                                    <c:forEach items="${sessionScope.LIST_FUNCTION_STATUS}" var="status">
                                                        <a class="nav-link text-capitalize text-dark text-normal" href="tracking?team=${requestScope.TEAM_CHOOSE.team_id}&statusFilter=${status.getSetting_id()}${requestScope.ASSIGNEE_CHOOSE==null?"":"&assignee=".concat(requestScope.ASSIGNEE_CHOOSE.getUser_id())}">${status.getSetting_title()}</a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body table-responsive">
                                    <table class="table table-striped table-hover table-bordered padding-0">
                                        <thead class="table-primary">
                                        <form action="tracking" method="POST">
                                            <tr>
                                                <th>
                                                    <input type="text" name="Team" value="${requestScope.TEAM_CHOOSE.getTeam_name()}" hidden="">
                                                    <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                    <input type="text" name="previousSort" value="${requestScope.SORT_TRACKING}" hidden="">
                                                    <button class="bg-transparent border-0" type="submit" name="sort" value="tracking_id"><b>ID</b><i class="fa-solid fa-sort"></i></button>
                                                </th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="milestone_id"><b>Milestone</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="function_id"><b>Function</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="assigner_id"><b>Assigner</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="assignee_id"><b>Assignee</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="status"><b>Status</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th colspan="2">Actions</th>
                                            </tr>
                                        </form>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${requestScope.LIST_TRACKING.size()==0}">
                                                    <tr><td class="dataTables-empty" colspan="10">No results match your search query</td></tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach items="${requestScope.LIST_TRACKING}" varStatus="count" var="tracking">
                                                        <tr>
                                                            <td> ${tracking.getTracking_id()}</td>
                                                            <td><a href="milestone?id=${tracking.getMilestone_id()}">${tracking.getMilestone().getMilestone_name()}</a></td>
                                                            <td><a href="function?id=${tracking.getFunction_id()}">${tracking.getFunction().getFunction_name()}</a></td>                
                                                            <td>${tracking.getAsssigner().getFull_name()}</td>
                                                            <td>${tracking.getAssignee().getFull_name()}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${loginUser.getRole_id()!=4||tracking.getAssignee_id()!=loginUser.getUser_id()||tracking.getStatusSetting().getSetting_title().toLowerCase()=='closed'}">
                                                                        ${tracking.getStatusSetting().getSetting_title()}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button class="form-select bg-transparent text-capitalize border-0 border-bottom d-flex align-items-start" id="status" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                            ${tracking.getStatusSetting().getSetting_title()}
                                                                        </button>
                                                                        <div class="dropdown-menu " aria-labelledby="status">
                                                                            <c:forEach items="${sessionScope.LIST_FUNCTION_STATUS}" var="status">
                                                                                <c:if test="${status.getSetting_id()>tracking.getStatus()}">
                                                                                    <a class="nav-link text-capitalize text-dark" href="tracking?status=${status.getSetting_id()}&id=${tracking.getTracking_id()}&service=changeStatus">${status.getSetting_title()}</a>
                                                                                </c:if>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <a href="tracking?id=${tracking.getTracking_id()}">
                                                                    <i data-feather="edit"></i>
                                                                </a>
                                                            </td>
                                                            <td>
                                                                <a href="updateTracking?tracking=${tracking.getTracking_id()}">
                                                                    <i data-feather="refresh-cw"></i>
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
                                        <form action="tracking "method="POST">
                                            <input type="text" name="team" value="${requestScope.TEAM_CHOOSE.getTeam_id()}" hidden="">
                                            <input type="text" name="sort" value="${requestScope.SORT_TRACKING}" hidden="">
                                            <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                            <input type="text" name="type" value="${requestScope.FEATURE_CHOOSE.getFeature_id()}" hidden="">
                                            <input type="text" name="assignee" value="${requestScope.ASSIGNEE_CHOOSE.getUser_id()}" hidden="">
                                            <input type="text" name="statusFilter" value="${requestScope.SORT_FILTER.getSetting_id()}" hidden="">
                                            <c:set var="thisPage" value="${requestScope.THIS_PAGE}"></c:set>
                                            <c:set var="size" value="${requestScope.TRACKING_SIZE}"></c:set>
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
                    <jsp:include page="../included/footer.jsp"/>
                </div>
            </div>
        </div>
        <c:if test="${sessionScope.TRACKING_CHANGE_STATUS!=null&&sessionScope.STATUS_CHANGE!=null}">
            <div class="modal fade show" tabindex="-1" aria-modal="true" role="dialog" style="display: block;">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Change Status Tracking</h5>
                            <a href="tracking?submit=false&service=changeStatus" class="btn-close" aria-label="Close"></a>
                        </div>
                        <div class="modal-body">
                            Are you sure to change status tracking ${sessionScope.TRACKING_CHANGE_STATUS.getFunction().getFunction_name()} assigned by yourself from ${sessionScope.TRACKING_CHANGE_STATUS.getStatusSetting().getSetting_title()} to ${sessionScope.STATUS_CHANGE.getSetting_title()}
                        </div>
                        <div class="modal-footer">
                            <a href="tracking?submit=false&service=changeStatus" class="btn btn-light">Close</a>
                            <a href="tracking?id=${sessionScope.TRACKING_CHANGE_STATUS.getTracking_id()}&status=${sessionScope.STATUS_CHANGE.getSetting_id()}&submit=true&service=changeStatus" class="btn btn-primary">Change</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-backdrop fade show"></div>
        </c:if>
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
