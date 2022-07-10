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
        <title class="text-capitalize">Criteria List  ${SETTING_TYPE_CHOOSE!=null?" · ".concat(sessionScope.LIST_SETTING_TYPE.get(SETTING_TYPE_CHOOSE)):""}</title>
    </head>
    <body>
        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
        <c:set var="search" value="${requestScope.SEARCH_WORD}"></c:set>
        <c:if test="${loginUser == null}">
            <c:redirect url="home.jsp"></c:redirect>
        </c:if>
        <div class="nav-fixed">
            <jsp:include page="../included/header.jsp"/>
            <div id="layoutSidenav">
                <jsp:include page="../included/slider.jsp"/>
                <div id="layoutSidenav_content">
                    <main>
                        <div class="container-xl px-4 mt-5">
                            <div class="d-flex justify-content-between align-items-sm-center flex-column flex-sm-row mb-4">
                                <div class="me-4 mb-3 mb-sm-0">
                                    <h1 class="mb-0 text-bold text-capitalize"> Criteria List</h1>
                                    <div class="small" id="nowTime">
                                    </div>
                                </div>
                                <a  href="criteria?service=add" class="btn btn-primary">
                                    <i class="fa-solid fa-plus"></i>
                                    Create new Criteria
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
                                                <a class="nav-link" href="criteria?${requestScope.SORT_FILTER==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)}${requestScope.SORT_TEAMEVAL==null?"":"&teamEvalFilter=".concat(requestScope.SORT_TEAMEVAL)}">All</a>
                                                <c:forEach items="${sessionScope.LIST_SUBJECT}" var="subject">
                                                    <a class="dropdown-item text-capitalize" href="criteria?type=${subject.getSubject_id()}${requestScope.SORT_FILTER==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)} ${requestScope.SORT_TEAMEVAL==null?"":"&teamEvalFilter=".concat(requestScope.SORT_TEAMEVAL)}">${subject.getSubject_code()}-${subject.getSubject_name()}</a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="dropdown " style="margin-right: 10px;" >
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
                                                <a class="nav-link" href="criteria?${requestScope.SORT_TEAMEVAL==null?"":"&teamEvalFilter=".concat(requestScope.SORT_TEAMEVAL)}${requestScope.SUBJECT_CHOOSE==null?"":"&type=".concat(requestScope.SUBJECT_CHOOSE.getSubject_id())}">All</a>
                                                <a class="nav-link text-capitalize" href="criteria?statusFilter=1${requestScope.SUBJECT_CHOOSE==null?"":"&type=".concat(requestScope.SUBJECT_CHOOSE.getSubject_id())}${requestScope.SORT_TEAMEVAL==null?"":"&teamEvalFilter=".concat(requestScope.SORT_TEAMEVAL)}">Activate</a>
                                                <a class="nav-link text-capitalize" href="criteria?statusFilter=0${requestScope.SUBJECT_CHOOSE==null?"":"&type=".concat(requestScope.SUBJECT_CHOOSE.getSubject_id())}${requestScope.SORT_TEAMEVAL==null?"":"&teamEvalFilter=".concat(requestScope.SORT_TEAMEVAL)}">Deactivate</a>
                                            </div>
                                        </div>
                                        <div class="dropdown">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.SORT_TEAMEVAL!=null}">
                                                        ${requestScope.SORT_TEAMEVAL==1?"Activate":"Deactivate"}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        Team Evaluation
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="nav-link" href="criteria?${requestScope.SUBJECT_CHOOSE==null?"":"&type=".concat(requestScope.SUBJECT_CHOOSE.getSubject_id())}${requestScope.SORT_FILTER==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)}">All</a>
                                                <a class="nav-link text-capitalize" href="criteria?teamEvalFilter=1${requestScope.SORT_FILTER==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)}${requestScope.SUBJECT_CHOOSE==null?"":"&type=".concat(requestScope.SUBJECT_CHOOSE.getSubject_id())}">Activate</a>
                                                <a class="nav-link text-capitalize" href="criteria?teamEvalFilter=0${requestScope.SORT_FILTER==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)}${requestScope.SUBJECT_CHOOSE==null?"":"&type=".concat(requestScope.SUBJECT_CHOOSE.getSubject_id())}">Deactivate</a>
                                            </div>
                                        </div>
                                    </div>
                                    <div>      
                                        <form action="criteria" id="search" method="POST">
                                            <input type="text" name="search" placeholder="Click enter to search..." value="${search}" class="form-control form-search">
                                        </form> 
                                    </div>
                                </div>


                                <!--  table criteria list-->

                                <div class="card-body table-responsive">
                                    <table class="table table-striped table-hover table-bordered padding-0">
                                        <thead class="table-primary text-center">
                                        <form action="criteria" method="POST">
                                            <tr>
                                                <th>
                                                    <input type="text" name="search" value="${search}" hidden="">
                                                    <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                    <input type="text" name="previousSort" value="${requestScope.SORT_CRITERIA}" hidden="">
                                                    <input type="text" name="type" value="${requestScope.SUBJECT_CHOOSE.getSubject_code()}" hidden="">
                                                    <button class="bg-transparent border-0" type="submit" name="sort" value="criteria_id"><b>ID</b><i class="fa-solid fa-sort"></i></button>
                                                </th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="iteration_id"><b>Iteration_Subject</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="criteria_title"><b>Title</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="evaluation_weight"><b>Weight</b><i class="fa-solid fa-sort"></i></button></th>
                                                 <th><button class="bg-transparent border-0" type="submit" name="sort" value="evaluation_weight"><b>Team</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="criteria_order"><b>Order</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="max_loc"><b >Max Loc</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="status"><b>Status</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th colspan="2">Actions</th>
                                            </tr>
                                        </form>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${requestScope.LIST_CRITERIA==null||requestScope.LIST_CRITERIA.size()==0}">
                                                    <tr><td class="dataTables-empty" colspan="10">No results match your search query</td></tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="crit" items="${requestScope.LIST_CRITERIA}">
                                                        <tr>
                                                            <td>${crit.criteria_id}</td>
                                                            <td>${crit.getIteration().getIteration_name()}_${crit.getIteration().getSubject().getSubject_code()}</td>
                                                            <td>${crit.getCriteria_title()}</td>
                                                            <td>${crit.getEvaluation_weight()}%</td>
                                                            <td class="text-center form-switch">
                                                                <a data-bs-toggle="modal" href="#updateTeamEval${crit.criteria_id}">
                                                                    <input class="form-check-input" ${loginUser.getRole_id()<3?"":"disabled=''"} type="checkbox" ${crit.isTeam_evaluation()?"checked":""}>
                                                                </a>
                                                            </td>
                                                            <td>${crit.getCriteria_order()}</td>
                                                            <td>${crit.getMax_loc()}</td>
                                                            <td class="text-center form-switch">
                                                                <a data-bs-toggle="modal" href="#updateStatus${crit.criteria_id}">
                                                                    <input class="form-check-input" ${loginUser.getRole_id()<3?"":"disabled=''"} type="checkbox" ${crit.isStatus()?"checked":""}>
                                                                </a>
                                                            </td>
                                                            <td class="text-center">
                                                                <a href="criteria?id=${crit.criteria_id}&service=detail">
                                                                    <i data-feather="edit"></i>
                                                                </a>
                                                            </td>

                                                        </tr>
                                                    <div class="modal fade" id="updateTeamEval${crit.criteria_id}" tabindex="-1" aria-labelledby="deleteSetting${crit.criteria_id}" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="exampleModalLabel">${crit.isTeam_evaluation()?"Deactivate":"Activate"} Team Evaluation of Criteria?</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    Are you sure to ${crit.isTeam_evaluation()?"deactivate":"activate"} team evaluation <span class="">${crit.getCriteria_title()} from ${crit.getIteration().getIteration_name()} of subject ${crit.getIteration().getSubject().getSubject_code()}?</span>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                                                                    <a href="criteria?id=${crit.criteria_id}&team_eval=${crit.isTeam_evaluation()}&service=changeTeamEval" class="btn btn-primary">Change</a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="modal fade" id="updateStatus${crit.criteria_id}" tabindex="-1" aria-labelledby="deleteSetting${crit.criteria_id}" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="exampleModalLabel">${crit.isStatus()?"Deactivate":"Activate"} Criteria?</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    Are you sure to ${crit.isStatus()?"deactivate":"activate"} criteria <span class="">${crit.getCriteria_title()} from ${crit.getIteration().getIteration_name()} of subject ${crit.getIteration().getSubject().getSubject_code()}?</span>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                                                                    <a href="criteria?id=${crit.criteria_id}&status=${crit.isStatus()}&service=changeStatus" class="btn btn-primary">Change</a>
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
                                            <input type="text" name="sort" value="${requestScope.SORT_CRITERIA}" hidden="">
                                            <c:set var="thisPage" value="${requestScope.THIS_PAGE}"></c:set>
                                            <c:set var="size" value="${requestScope.CRITERIA_SIZE}"></c:set>
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