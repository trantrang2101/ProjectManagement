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
            <title class="text-capitalize">Tracking List</title>
        </head>
        <body>
        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
            <div class="nav-fixed">
            <jsp:include page="../included/header.jsp"/>
            <div id="layoutSidenav">
                <jsp:include page="../included/slider.jsp"/>
                <div id="layoutSidenav_content">
                    <main>
                        <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                            <div class="container-fluid px-4">
                                <div class="page-header-content">
                                    <div class="row mb-4">
                                        <div class="d-flex flex-column align-center justify-content-start col-xl-6 col-md-12 mb-3 mb-9 gap-3">
                                            <h1 class="mb-0 text-bold text-capitalize mb-3">Subject List</h1>
                                            <div class="text-muted d-flex"><h6>Function: </h6><span class="ml-4">${requestScope.TRACKING_CHOOSE.getFunction().getFunction_name()}</span></div>
                                            <div class="text-muted d-flex"><h6>Evaluated in: </h6><span class="ml-4">${requestScope.TRACKING_CHOOSE.getMilestone().getMilestone_name()}</span></div>
                                            <textarea disabled="" class="text-muted">${requestScope.TRACKING_CHOOSE.getTracking_note()}</textarea>
                                        </div>
                                        <div class="col-xl-6 col-md-12 mb-3 mb-9">
                                            <c:if test="${(requestScope.TRACKING_CHOOSE!=null&&requestScope.TRACKING_CHOOSE.getAssignee_id()==loginUser.getUser_id())&&loginUser.getRole_id()==4}">
                                                <form action="updateTracking" method="POST">
                                                    <div class="row">
                                                        <div class="mb-3 col-xl-6 col-md-6">
                                                            <label for="tracking" class="form-label">Function<span style="color: red">*</span></label>
                                                            <input type="hidden" name="class" value="${requestScope.TRACKING_UPDATE_CHOOSE.getTracking().getClassroom().getClass_id()}"/>
                                                            <input type="hidden" name="team" value="${requestScope.TRACKING_UPDATE_CHOOSE.getTracking().getTeam().getTeam_id()}"/>
                                                            <input type="hidden" name="feature" value="${requestScope.TRACKING_UPDATE_CHOOSE.getTracking().getFeature().getFeature_id()}"/>
                                                            <input type="text" name="tracking" id="tracking" class="form-control" value="${requestScope.TRACKING_CHOOSE.getTracking_id()}" hidden="">
                                                            <input type="text" required=""  class="form-control border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" value="${requestScope.TRACKING_CHOOSE.getFunction().getFunction_name()}_${requestScope.TRACKING_CHOOSE.getAssignee().getFull_name()}" disabled="">
                                                            <c:if test="${requestScope.TRACKING_UPDATE_CHOOSE != null}" >
                                                                <input type="hidden" name="id" value="${requestScope.TRACKING_UPDATE_CHOOSE.getUpdate_id()}"/>
                                                            </c:if>
                                                        </div>
                                                        <div class="mb-3 col-xl-6 col-md-6">
                                                            <label for="milestone" class="form-label">Milestone<span style="color: red">*</span></label>
                                                            <c:choose>
                                                                <c:when test="${requestScope.TRACKING_UPDATE_CHOOSE != null}" >
                                                                    <input type="text" required=""  class="form-control border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" value="${requestScope.TRACKING_CHOOSE.getMilestone().getMilestone_name()}" disabled="">
                                                                    <input type="text" name="milestone" id="milestone" class="form-control" value="${requestScope.TRACKING_UPDATE_CHOOSE.getMilestone_id()}" hidden="">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <select ${loginUser.getRole_id()==4?"":"disabled=''"} id="milestone" required="" ${requestScope.LIST_MILESTONE==null?'disabled=""':''} name="milestone" class="form-control col border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" >
                                                                        <c:forEach items="${requestScope.LIST_MILESTONE}" var="milestone">
                                                                            <c:if test="${milestone.after()}">
                                                                                <c:choose>
                                                                                    <c:when test="${(requestScope.MILESTONE_CHOOSE!=null&&requestScope.MILESTONE_CHOOSE.getMilestone_id()==milestone.getMilestone_id())||(requestScope.TRACKING_CHOOSE!=null&&requestScope.TRACKING_CHOOSE.getMilestone_id()==milestone.getMilestone_id())}">
                                                                                        <option class="text-capitalize" value="${milestone.getMilestone_id()}" selected="">${milestone.getMilestone_name()}</option>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <option class="text-capitalize" value="${milestone.getMilestone_id()}">${milestone.getMilestone_name()}</option>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </c:if>
                                                                        </c:forEach>          
                                                                    </select>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                    <div class="mb-3 form-floating">
                                                        <textarea ${loginUser.getRole_id()==4?"":"disabled=''"} class="form-control ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" placeholder="User Note" id="trackingNote" name="note">${requestScope.TRACKING_UPDATE_CHOOSE!=null?requestScope.TRACKING_UPDATE_CHOOSE.getUpdate_note():''}</textarea>
                                                        <label for="trackingNote">Tracking Note</label>
                                                    </div>
                                                    <div class="ms-auto">
                                                        <input type="text" name="submitForm" class="form-control" value="add" hidden="">
                                                        <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset"></input>
                                                        <button type="submit" name="service" value="${trackingChoose!=null?'update':'add'}" class="btn btn-primary">Save changes</button>
                                                    </div>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </header>
                        <div class="container-fluid px-4">
                            <div class="card p-4 mb-4 mt-5">
                                <div class="card-body table-responsive">
                                    <table class="table table-striped table-hover table-bordered padding-0">
                                        <thead class="table-primary">
                                        <form action="updateTracking" method="POST">
                                            <tr>
                                                <th>
                                                    <input type="text" name="Team" value="${requestScope.TEAM_CHOOSE.getTeam_name()}" hidden="">
                                                    <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                    <input type="text" name="previousSort" value="${requestScope.SORT_TRACKING}" hidden="">
                                                    <button class="bg-transparent border-0" type="submit" name="sort" value="tracking_id"><b>ID</b><i class="fa-solid fa-sort"></i></button>
                                                </th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="milestone_id"><b>Tracking</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="function_id"><b>Milestone</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="assigner_id"><b>Update Date</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="assignee_id"><b>Notes</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th>Actions</th>
                                            </tr>
                                        </form>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${requestScope.LIST_TRACKING_UPDATE.size()==0}">
                                                    <tr><td class="dataTables-empty" colspan="10">No results match your search query</td></tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach items="${requestScope.LIST_TRACKING_UPDATE}" varStatus="count" var="tracking">
                                                        <tr>
                                                            <td> ${tracking.getUpdate_id()}</td>
                                                            <td> ${tracking.getTracking().getFunction().getFunction_name()}_${tracking.getTracking().getAssignee().getFull_name()}</td>
                                                            <td>${tracking.getMilestone().getMilestone_name()}</td>                
                                                            <td>${tracking.getDate()}</td>
                                                            <td>${tracking.getUpdate_note()}</td>
                                                            <td>
                                                                <a href="updateTracking?id=${tracking.getUpdate_id()}">
                                                                    <i data-feather="edit"></i>
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
                                            <input type="text" name="milestone" value="${requestScope.MILESTONE_CHOOSE.getMilestone_id()}" hidden="">
                                            <input type="text" name="feature" value="${requestScope.FEATURE_CHOOSE.getFeature_id()}" hidden="">
                                            <input type="text" name="tracking" value="${requestScope.TRACKING_CHOOSE.getTracking_id()}" hidden="">
                                            <c:set var="thisPage" value="${requestScope.THIS_PAGE}"></c:set>
                                            <c:set var="size" value="${requestScope.TRACKING_UPDATE_SIZE}"></c:set>
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
