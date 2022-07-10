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
        <title class="text-capitalize">Class Setting List  ${requestScope.CLASS_CHOOSE!=null?" · ".concat(requestScope.CLASS_CHOOSE.getClass_code()):""}</title>
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
                                    <h1 class="mb-0 text-bold text-capitalize">Class Setting List  ${requestScope.CLASS_CHOOSE!=null?" · ".concat(requestScope.CLASS_CHOOSE.getClass_code()):""}</h1>
                                    <div class="small" id="nowTime">
                                    </div>
                                </div>
                                <div>
                                    <a href="classSetting?service=add" class="btn btn-primary">
                                        <i class="fa-solid fa-plus"></i>
                                        Create new Class Setting
                                    </a>
                                    <a  href="classSetting?service=sync" class="btn btn-primary">
                                        <i class="fa-solid fa-arrows-rotate"></i>
                                        Sync Label
                                    </a>
                                </div>
                            </div>
                            <div class="card p-4 mb-4 mt-5 table-wrapper">
                                <div class="card-header d-flex justify-content-between align-items-center bg-white padding-0" style="padding-bottom: 1rem !important">
                                    <div class="d-flex justify-content-sm-start align-items-center">
                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.CLASS_CHOOSE!=null}">
                                                        (${requestScope.CLASS_CHOOSE.getSubject().getSubject_code()}) ${requestScope.CLASS_CHOOSE.class_code} (${requestScope.CLASS_CHOOSE.getSetting().getSetting_title()}-${requestScope.CLASS_CHOOSE.class_year})
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Classes
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <c:forEach items="${sessionScope.LIST_CLASS}" var="class">
                                                    <a class="dropdown-item text-capitalize" href="classSetting?class=${class.getClass_id()}${requestScope.TYPE_CHOOSE==null?"":"&type=".concat(requestScope.getSetting_id.getClass_id())}${requestScope.SORT_FILTER!=null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)}">${class.getSubject().getSubject_code()}_${class.class_code}</a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.TYPE_CHOOSE!=null}">
                                                        ${requestScope.TYPE_CHOOSE.getSetting_title()}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Type
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="nav-link" href="classSetting?${requestScope.CLASS_CHOOSE==null?"":"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id())}${requestScope.SORT_FILTER!=null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)}">All</a>
                                                <c:forEach items="${sessionScope.SETTING_LIST_CLASS}" var="type">
                                                    <a class="dropdown-item text-capitalize" href="classSetting?type=${type.getSetting_id()}">${type.getSetting_title()}</a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <!--Status Filter-->
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
                                                <a class="nav-link" href="classSetting?${requestScope.CLASS_CHOOSE==null?"":"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id())}">All</a>
                                                <a class="nav-link text-capitalize" href="classSetting?statusFilter=1${requestScope.CLASS_CHOOSE==null?"":"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id())}${requestScope.TYPE_CHOOSE==null?"":"&type=".concat(requestScope.getSetting_id.getClass_id())}">Activate</a>
                                                <a class="nav-link text-capitalize" href="classSetting?statusFilter=0${requestScope.CLASS_CHOOSE==null?"":"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id())}${requestScope.TYPE_CHOOSE==null?"":"&type=".concat(requestScope.getSetting_id.getClass_id())}">Deactivate</a>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <form action="classSetting" id="search" method="GET">
                                            <input type="text" name="search" placeholder="Click enter to search..." value="${search}" class="form-control form-search">
                                            <input type="submit"  hidden="" name="type" value="${requestScope.CLASS_CHOOSE.getClass_id()}">
                                        </form> 
                                    </div>
                                </div>
                                <div class="card-body table-responsive">
                                    <table class="table table-striped table-hover table-bordered padding-0">
                                        <thead class="table-primary text-center">
                                        <form action="classSetting" method="POST">
                                            <tr>
                                                <th>
                                                    <input type="text" name="search" value="${search}" hidden="">
                                                    <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                    <input type="text" name="previousSort" value="${requestScope.SORT_SETTING}" hidden="">
                                                    <input type="text" name="type" value="${requestScope.CLASS_CHOOSE.getClass_id()}" hidden="">
                                                    <button class="bg-transparent border-0" type="submit" name="sort" value="setting_id"><b>ID</b><i class="fa-solid fa-sort"></i></button>
                                                </th>
                                                <th>Class</th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="type_id"><b>Type</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="setting_title"><b>Title</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="setting_value"><b>Value</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="display_order"><b>Order</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="status"><b>Status</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th colspan="2">Actions</th>
                                            </tr>
                                        </form>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${requestScope.LIST_CLASS_SETTING.size()==0}">
                                                    <tr><td class="dataTables-empty" colspan="8">No results match your search query</td></tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="setting" items="${requestScope.LIST_CLASS_SETTING}">
                                                        <tr>
                                                            <td class="text-center">${setting.getSetting_id()}</td>
                                                            <td class="text-center">${setting.getClass(loginUser).getSubject().getSubject_code()}_${setting.getClass(loginUser).getClass_code()}</td>
                                                            <td class="text-capitalize">${setting.getType().getSetting_title()}</td>
                                                            <td>${setting.getSetting_title()}</td>
                                                            <td  class="text-center">${setting.getSetting_value()}</td>
                                                            <td  class="text-center">${setting.getDisplay_order()}</td>
                                                            <td class="text-center form-switch">
                                                                <a data-bs-toggle="modal" href="#updateStatus${setting.getSetting_id()}">
                                                                    <input class="form-check-input" ${loginUser.getRole_id()<3?"":"disabled=''"} type="checkbox" ${setting.isStatus()?"checked":""}>
                                                                </a>
                                                            </td>
                                                            <td class="text-center">
                                                                <a href="classSetting?id=${setting.setting_id}&service=detail">
                                                                    <i data-feather="edit"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    <div class="modal fade" id="updateStatus${setting.getSetting_id()}" tabindex="-1" aria-labelledby="updateStatus${setting.getSetting_id()}" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="exampleModalLabel">${setting.isStatus()?"Deactivate":"Activate"} Class Setting</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    Are you sure to ${setting.isStatus()?"deactivate":"activate"} <span class="text-capitalize">${setting.type.setting_title} in ${setting.getClass(loginUser).getClass_code()}?</span>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                                                                    <a href="classSetting?id=${setting.setting_id}&service=changeStatus&status=${setting.status}" class="btn btn-primary">Change</a>
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
                                        <form action="classSetting" method="GET">
                                            <input type="text" name="sort" value="${requestScope.SORT_SETTING}" hidden="">
                                            <input type="submit"  hidden="" name="type" value="${requestScope.CLASS_CHOOSE}">
                                            <input type="text"  hidden="" name="search" value="${search}">
                                            <c:set var="thisPage" value="${requestScope.THIS_PAGE}"></c:set>
                                            <c:set var="size" value="${requestScope.CLASS_SETTING_SIZE}"></c:set>
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