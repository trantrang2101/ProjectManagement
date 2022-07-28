<%-- 
    Document   : teamList
    Created on : Jun 8, 2022, 10:47:08 PM
    Author     : Admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title class="text-capitalize">Team List  ${SETTING_TYPE_CHOOSE!=null?" · ".concat(sessionScope.LIST_SETTING_TYPE.get(SETTING_TYPE_CHOOSE)):""}</title>
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
                        <div class="container-xl px-4 mt-5">
                            <div class="d-flex justify-content-between align-items-sm-center flex-column flex-sm-row mb-4">
                                <div class="me-4 mb-3 mb-sm-0">
                                    <h1 class="mb-0 text-bold text-capitalize">Team List  ${SETTING_TYPE_CHOOSE!=null?" · ".concat(sessionScope.LIST_SETTING_TYPE.get(SETTING_TYPE_CHOOSE)):""}</h1>
                                    <div class="small" id="nowTime">
                                    </div>
                                </div>
                                <a href="team?service=add" class="btn btn-primary">
                                    <i class="fa-solid fa-plus"></i>
                                    Create new Team
                                </a>
                            </div>
                            <div class="card p-4 mb-4 mt-5 table-wrapper">
                                <div class="card-header d-flex justify-content-between align-items-center bg-white padding-0" style="padding-bottom: 1rem !important">
                                    <div class="d-flex justify-content-sm-start align-items-center">
                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.CLASS_CHOOSE!=null}">
                                                        ${requestScope.CLASS_CHOOSE.getSubject().getSubject_code()}_${requestScope.CLASS_CHOOSE.class_code}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Classes
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="team">All</a>
                                                <c:forEach items="${sessionScope.LIST_CLASS}" var="classroom">
                                                    <a class="dropdown-item text-capitalize" href="team?classroom=${classroom.class_id}">${classroom.getSubject().getSubject_code()}_${classroom.class_code}</a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="dropdown">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.SORT_FILTER!=null}">
                                                        ${requestScope.SORT_FILTER==1?"Activate":"Deactivate"}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Status
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="nav-link" href="team?${requestScope.CLASS_CHOOSE==null?"":"&classroom=".concat(requestScope.CLASS_CHOOSE.getClass_id())}">All</a>
                                                <a class="nav-link text-capitalize" href="team?statusFilter=1${requestScope.CLASS_CHOOSE==null?"":"&classroom=".concat(requestScope.CLASS_CHOOSE.getClass_id())}">Activate</a>
                                                <a class="nav-link text-capitalize" href="team?statusFilter=0${requestScope.CLASS_CHOOSE==null?"":"&classroom=".concat(requestScope.CLASS_CHOOSE.getClass_id())}">Deactivate</a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ms-auto">
                                        <form action="team" id="search" method="POST">
                                            <input type="text" name="search" placeholder="Click enter to search..." value="${search}" class="form-control form-search">
                                            <input type="submit"  hidden="" name="type" value="${requestScope.SETTING_TYPE_CHOOSE}">
                                        </form> 
                                    </div>
                                </div>
                                <div class="card-body table-responsive">
                                    <table class="table table-striped table-hover table-bordered padding-0">
                                        <thead class="table-primary text-center">
                                        <form action="team" method="POST">
                                            <tr>
                                                <th>
                                                    <input type="text" name="search" value="${search}" hidden="">
                                                    <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                    <input type="text" name="previousSort" value="${requestScope.SORT_TEAM}" hidden="">
                                                    <input type="text" name="classroom" value="${requestScope.CLASS_CHOOSE.getClass_code()}" hidden="">
                                                    <input type="text" name="classroom" value="${requestScope.CLASS_CHOOSE}" hidden="">
                                                    <button class="bg-transparent border-0" type="submit" name="sort" value="team_id"><b>ID</b><i class="fa-solid fa-sort"></i></button>
                                                </th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="class_id"><b>Class</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="team_name"><b>Name</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="topic_code"><b>Topic Code</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="topic_name"><b>Topic Name</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="status"><b>Status</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th>Actions</th>
                                            </tr>
                                        </form>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${requestScope.LIST_TEAM.size()==0}">
                                                    <tr><td class="dataTables-empty" colspan="8">No results match your search query</td></tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="team" items="${requestScope.LIST_TEAM}">
                                                        <tr>
                                                            <td>${team.getTeam_id()}</td>
                                                            <td class="text-center">${team.getClassroom().getSubject().getSubject_code()}_${team.getClassroom().getClass_code()}</td>
                                                            <td>${team.getTeam_name()}</td>
                                                            <td>${team.getTopic_code()}</td>
                                                            <td>${team.getTopic_name()}</td>
                                                            <td class="text-center form-switch">
                                                                <a data-bs-toggle="modal" href="#updateStatus${team.getTeam_id()}">
                                                                    <input class="form-check-input" type="checkbox" ${team.isStatus()?"checked":""}>
                                                                </a>
                                                            </td>
                                                            <td class="text-center">
                                                                <a href="team?id=${team.getTeam_id()}&service=detail">
                                                                    <i data-feather="edit"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    <div class="modal fade" id="updateStatus${team.getTeam_id()}" tabindex="-1" aria-labelledby="deleteTeam${team.getTeam_id()}" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="exampleModalLabel">${team.isStatus()?"Deactivate":"Activate"} Team</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    Are you sure to ${team.isStatus()?"deactivate":"activate"} team <span class="text-capitalize">${team.getTeam_id()}?</span>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">No</button>
                                                                    <a href="team?id=${team.getTeam_id()}&status=${team.isStatus()}&service=changeStatus" class="btn btn-primary">Yes</a>
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
                                        <form action="team" method="GET">
                                            <input type="text" hidden="" name="classroom" value="${requestScope.CLASS_CHOOSE}">
                                            <input type="text" hidden="" name="search" value="${search}">
                                            <input type="text" hidden="" name="sort" value="${requestScope.SORT_TEAM}">
                                            <c:set var="thisPage" value="${requestScope.THIS_PAGE}"></c:set>
                                            <c:set var="size" value="${requestScope.TEAM_SIZE}"></c:set>
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
            $("#myModal2").on('show.bs.modal', function (e) {
                $("#myModal1").modal("show");
            });
            const weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
            document.querySelector('#nowTime').innerHTML = "<span class='fw-500 text-primary'>" + weekday[moment().weekday()] + "</span> &middot; " + moment().format('MMMM DD,YYYY · h:mm A');
        </script>
        <script src="js/scripts.js"></script>
    </body>
</html>