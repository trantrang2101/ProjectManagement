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
        <title class="text-capitalize">Milestone List</title>
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
                                    <h1 class="mb-0 text-bold text-capitalize"> Milestone List</h1>
                                    <div class="small" id="nowTime">
                                    </div>
                                </div>
                                <c:if test="${loginUser.getRole_id()<4}">
                                    <div>
                                        <a  href="milestone?service=add" class="btn btn-primary">
                                            <i class="fa-solid fa-plus"></i>
                                            Create new Milestone
                                        </a>
                                        <a  href="milestone?service=sync" class="btn btn-primary">
                                            <i class="fa-solid fa-arrows-rotate"></i>
                                            Sync Milestones
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                            <div class="card p-4 mb-4 mt-5 table-wrapper">
                                <div class="card-header d-flex justify-content-between align-items-center bg-white padding-0" style="padding-bottom: 1rem !important">
                                    <div class="d-flex justify-content-sm-start align-items-center">
                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.CLASS_CHOOSE!=null}">
                                                        ${requestScope.CLASS_CHOOSE.getSubject().getSubject_code()}_${requestScope.CLASS_CHOOSE.getClass_code()}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        ${sessionScope.LIST_CLASS.get(0).getClass_code()}
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <c:forEach items="${sessionScope.LIST_CLASS}" var="class">
                                                    <a class="dropdown-item text-capitalize" href="milestone?class=${class.getClass_id()}${requestScope.STATUS_CHOOSE!=null?"&status=".concat(requestScope.STATUS_CHOOSE):""}">${class.getSubject().getSubject_code()}_${class.class_code}</a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <!--Status Filter-->
                                        <div class="dropdown">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.STATUS_CHOOSE!=null}">
                                                        ${sessionScope.LIST_STATUS[requestScope.STATUS_CHOOSE]}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Status
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="milestone${requestScope.SUBJECT_CHOOSE==null?'':'?type='.concat(requestScope.SUBJECT_CHOOSE.getSubject_id())}">All</a>
                                                <c:forEach begin="0" end="${fn:length(sessionScope.LIST_STATUS)-1}" var="i">
                                                    <a class="dropdown-item text-capitalize" href="milestone?status=${i}${requestScope.CLASS_CHOOSE==null?'':'&class='.concat(requestScope.CLASS_CHOOSE.getClass_id())}">${sessionScope.LIST_STATUS[i]}</a>
                                                </c:forEach>        
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <form action="milestone" id="search" method="POST">
                                            <input type="text" name="search" placeholder="Click enter to search..." value="${search}" class="form-control form-search">
                                            <input type="submit" hidden="" name="type" value="">
                                        </form> 
                                    </div>
                                </div>
                                <div class="card-body table-responsive">
                                    <table class="table table-striped table-hover table-bordered padding-0">
                                        <thead class="table-primary text-center">
                                        <form action="milestone" method="POST">
                                            <tr>
                                                <th>
                                                    <input type="text" name="search" value="${search}" hidden="">
                                                    <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                    <input type="text" name="previousSort" value="${requestScope.SORT_MILESTONE}" hidden="">
                                                    <button class="bg-transparent border-0" type="submit" name="sort" value="milestone_id"><b>ID</b><i class="fa-solid fa-sort"></i></button>
                                                </th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="milestone_name"><b>Name</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="iteration_id"><b>Iteration</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="class_id"><b>Class</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="from_date"><b>From</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="to_date"><b>To</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="status"><b>Status</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th colspan="2">Actions</th>
                                            </tr>
                                        </form>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${requestScope.LIST_MILESTONE==null||requestScope.LIST_MILESTONE.size()==0}">
                                                    <tr><td class="dataTables-empty" colspan="9">No results match your search query</td></tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="mile" items="${requestScope.LIST_MILESTONE}">
                                                        <tr>
                                                            <td>${mile.milestone_id}</td>
                                                            <td>${mile.getMilestone_name()}</td>
                                                            <td>${mile.getIteration().getSubject().getSubject_code()}_${mile.getIteration().getIteration_name()}</td>
                                                            <td>${mile.getClassroom().class_code} (${mile.getClassroom().getSetting().getSetting_title()}-${mile.getClassroom().class_year})</td>
                                                            <td>${mile.getFrom_format()}</td>
                                                            <td>${mile.getTo_format()}</td>
                                                            <td>${mile.getStatusValue()}</td>
                                                            <td class="text-center">
                                                                <a href="milestone?id=${mile.milestone_id}">
                                                                    <i data-feather="edit"></i>
                                                                </a>
                                                            </td>
                                                            <c:if test="${loginUser.getRole_id()<4}">
                                                                <td class="text-center">
                                                                    <a data-bs-toggle="modal" href="#cancel${mile.getMilestone_id()}">
                                                                        <i class="fa-solid fa-ban"></i>
                                                                    </a>
                                                                </td>
                                                            </c:if>
                                                        </tr>
                                                    <div class="modal fade" id="cancel${mile.getMilestone_id()}" tabindex="-1" aria-labelledby="cancel${mile.getMilestone_id()}" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="exampleModalLabel">${mmile.getStatus()!=0?"Deactivate":"Activate"} Milestone</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    Are you sure to ${mile.getStatus()!=0?"deactivate":"activate"} Milestone <span>${mile.getMilestone_name()} from ${mile.getClassroom().class_code} (${mile.getClassroom().getSetting().getSetting_title()}-${mile.getClassroom().class_year})?</span>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Close"></input>
                                                                    <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset"></input>
                                                                    <a href="milestone?id=${mile.getMilestone_id()}&status=${mile.getStatus()}&service=changeStatus" class="btn btn-primary">Change</a>
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
                                            <input type="text" name="sort" value="${requestScope.SORT_MILESTONE}" hidden="">
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