<%-- 
    Document   : settingList
    Created on : May 14, 2022, 3:47:40 PM
    Author     : nashd
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title class="text-capitalize">Iteration List  ${SETTING_TYPE_CHOOSE!=null?" · ".concat(sessionScope.LIST_SETTING_TYPE.get(SETTING_TYPE_CHOOSE)):""}</title>
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
                                    <h1 class="mb-0 text-bold text-capitalize">Iteration List</h1>
                                    <div class="small" id="nowTime">
                                    </div>
                                </div>
                                <a  href="iteration?service=add" class="btn btn-primary">
                                    <i class="fa-solid fa-plus"></i>
                                    Create new Iteration
                                </a>
                            </div>
                            <div class="card p-4 mb-4 mt-5 table-wrapper">
                                <div class="card-header d-flex justify-content-between align-items-center bg-white padding-0" style="padding-bottom: 1rem !important">
                                    <div class="d-flex justify-content-sm-start align-items-center">
                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.SUBJECT_CHOOSE!=null}">
                                                        ${requestScope.SUBJECT_CHOOSE.getSubject_code()}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Subject
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="iteration${requestScope.STATUS_CHOOSE!=null?'?status='.concat(requestScope.STATUS_CHOOSE):''}">All</a>
                                                <c:forEach items="${sessionScope.LIST_SUBJECT}" var="subject">
                                                    <a class="dropdown-item text-capitalize" href="iteration?type=${subject.getSubject_id()}${requestScope.STATUS_CHOOSE!=null?'&status='.concat(requestScope.STATUS_CHOOSE):''}">${subject.getSubject_code()}-${subject.getSubject_name()}</a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <!--Status Filter-->
                                        <div class="dropdown">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.STATUS_CHOOSE!=null}">
                                                        ${requestScope.STATUS_CHOOSE==true?"Active":"Inactive"}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Status
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="iteration${requestScope.SUBJECT_CHOOSE!=null?'?type='.concat(requestScope.SUBJECT_CHOOSE.getSubject_id()):''}">All</a>
                                                <a class="dropdown-item text-capitalize" href="iteration?status=true${requestScope.SUBJECT_CHOOSE!=null?'&type='.concat(requestScope.SUBJECT_CHOOSE.getSubject_id()):''}">Active</a>
                                                <a class="dropdown-item text-capitalize" href="iteration?status=false${requestScope.SUBJECT_CHOOSE!=null?'&type='.concat(requestScope.SUBJECT_CHOOSE.getSubject_id()):''}">Inactive</a>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <form action="iteration" id="search" method="POST">
                                            <input type="text" name="search" placeholder="Click enter to search..." value="${search}" class="form-control form-search">

                                        </form> 
                                    </div>
                                </div>
                                <!--                                        table iteration list-->

                                <div class="card-body table-responsive">
                                    <table class="table table-striped table-hover table-bordered padding-0">
                                        <thead class="table-primary text-center">
                                        <form action="iteration" method="POST">
                                            <tr>
                                                <th>
                                                    <input type="text" name="search" value="${search}" hidden="">
                                                    <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                    <input type="text" name="previousSort" value="${requestScope.SORT_ITERATION}" hidden="">
                                                    <input type="text" name="type" value="${requestScope.SUBJECT_CHOOSE.getSubject_code()}" hidden="">
                                                    <button class="bg-transparent border-0" type="submit" name="sort" value="iteration_id"><b>ID</b><i class="fa-solid fa-sort"></i></button>
                                                </th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="iteration_name"><b>Name</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th>Subject</th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="duration"><b>Duration</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="status"><b>Status</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th colspan="2">Actions</th>
                                            </tr>
                                        </form>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${requestScope.LIST_ITERATION==null||requestScope.LIST_ITERATION.size()==0}">
                                                    <tr><td class="dataTables-empty" colspan="7">No results match your search query</td></tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="iter" items="${requestScope.LIST_ITERATION}">
                                                        <tr>
                                                            <td>${iter.iteration_id}</td>
                                                            <td>${iter.iteration_name}</td>
                                                            <td >${iter.getSubject().getSubject_code()}_${iter.getSubject().getSubject_name()}</td>
                                                            <td>${iter.duration}</td>
                                                            <td class="text-center form-switch">
                                                                <a data-bs-toggle="modal" href="#updateStatus${iter.iteration_id}">
                                                                    <input ${loginUser.getRole_id()<3?"":"disabled=''"} class="form-check-input" type="checkbox" ${iter.isStatus()?"checked":""}>
                                                                </a>
                                                            </td>
                                                            <td class="text-center">
                                                                <a href="iteration?id=${iter.iteration_id}&service=detail">
                                                                    <i data-feather="edit"></i>
                                                                </a>
                                                            </td>

                                                        </tr>


                                                    <div class="modal fade" id="updateStatus${iter.iteration_id}" tabindex="-1" aria-labelledby="deleteSetting${iter.iteration_id}" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="exampleModalLabel">${iter.isStatus()?"Deactivate":"Activate"} Iteration?</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    Are you sure to ${iter.isStatus()?"deactivate":"activate"} <span class="text-capitalize">${iter.iteration_name} from ${iter.getSubject().getSubject_code()}?</span>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                                                                    <a href="iteration?id=${iter.iteration_id}&status=${iter.isStatus()}&service=changeStatus" class="btn btn-primary">Change</a>
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
                                        <form action="iteration" method="GET">
                                            <input type="text"  hidden="" name="search" value="${search}">
                                            <input type="text" name="sort" value="${requestScope.SORT_ITERATION}" hidden="">
                                            <c:set var="thisPage" value="${requestScope.THIS_PAGE}"></c:set>
                                            <c:set var="size" value="${requestScope.ITERATION_SIZE}"></c:set>
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