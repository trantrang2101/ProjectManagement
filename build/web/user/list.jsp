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
        <link href="css/styles.css" rel="stylesheet" />
        <title class="text-capitalize">User List  ${requestScope.ROLE_CHOOSE != null?" · ".concat(requestScope.ROLE_CHOOSE.getSetting_title()):""}</title>
    </head>
    <body>
        <c:set var="userChoose" value="${sessionScope.CHOOSE_USER}"></c:set>
        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
        <c:set value="${requestScope.SEARCH_WORD}" var="search"></c:set>
            <div class="nav-fixed">
            <jsp:include page="../included/header.jsp"/>
            <div id="layoutSidenav">
                <jsp:include page="../included/slider.jsp"/>
                <div id="layoutSidenav_content">
                    <main>
                        <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                            <div class="container-fluid px-4">
                                <div class="page-header-content">
                                    <div class="row align-items-center justify-content-between pt-3">
                                        <div class="col-auto mb-3">
                                            <h1 class="page-header-title">
                                                <div class="page-header-icon"><i data-feather="user"></i></div>
                                                Users List
                                            </h1>
                                        </div>
                                        <div class="col-12 col-xl-auto mb-3">
                                            <a class="btn btn-sm btn-light text-primary" href="setting?type=1">
                                                <i class="me-1" data-feather="users"></i>
                                                Manage Groups
                                            </a>
                                            <a class="btn btn-sm btn-light text-primary" href="user?service=add">
                                                <i class="me-1" data-feather="user-plus"></i>
                                                Add New User
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </header>
                        <div class="container-fluid px-4">
                            <div class="card p-4 mb-4 mt-5">
                                <div class="card-header d-flex justify-content-between align-items-center bg-white padding-0" style="padding-bottom: 1rem !important">
                                    <div class="d-flex justify-content-sm-start align-items-center">
                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.ROLE_CHOOSE!=null}">
                                                        ${requestScope.ROLE_CHOOSE.getSetting_title()}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Roles
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="user${requestScope.SORT_FILTER==null?"":"?statusFilter=".concat(requestScope.SORT_FILTER)}">All</a>
                                                <c:forEach items="${sessionScope.LIST_ROLES_SETTING}" var="type">
                                                    <a class="dropdown-item text-capitalize" href="user?type=${type.getSetting_id()}${requestScope.ROLE_CHOOSE==null?"":"&statusFilter=".concat(requestScope.SORT_FILTER)}">${type.getSetting_title()}</a>
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
                                                <a class="nav-link" href="user"${requestScope.ROLE_CHOOSE==null?"":"?type=".concat(requestScope.ROLE_CHOOSE.getSetting_id())}>All</a>
                                                <a class="nav-link text-capitalize" href="user?statusFilter=1${requestScope.ROLE_CHOOSE==null?"":"&type=".concat(requestScope.ROLE_CHOOSE.getSetting_id())}">Activate</a>
                                                <a class="nav-link text-capitalize" href="user?statusFilter=0${requestScope.ROLE_CHOOSE==null?"":"&type=".concat(requestScope.ROLE_CHOOSE.getSetting_id())}">Deactivate</a>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <form action="user" id="search" method="POST">
                                            <input type="text" name="search" placeholder="Click enter to search..." value="${search}" class="form-control form-search">
                                            <input type="submit"  hidden="" name="type" value="${requestScope.ROLE_CHOOSE.getSetting_id()}">
                                        </form> 
                                    </div>
                                </div>
                                <div class="card-body table-responsive">
                                    <table class="table table-striped table-hover table-bordered padding-0">
                                        <thead class="table-primary">
                                        <form action="user" method="POST">
                                            <tr>
                                                <th>
                                                    <input type="text" name="search" value="${search}" hidden="">
                                                    <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                    <input type="text" name="previousSort" value="${requestScope.SORT_USER}" hidden="">
                                                    <input type="text" name="type" value="${requestScope.ROLE_CHOOSE.getSetting_id()}" hidden="">
                                                    <button class="bg-transparent border-0" type="submit" name="sort" value="full_name"><b>User</b><i class="fa-solid fa-sort"></i></button>
                                                </th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="email"><b>Email</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="role_id"><b>Role</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="gender"><b>Gender</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="status"><b>Status</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th colspan="2">Actions</th>
                                            </tr>
                                        </form>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${requestScope.LIST_USER.size()==0}">
                                                    <tr><td class="dataTables-empty" colspan="7">No results match your search query</td></tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach items="${requestScope.LIST_USER}" var="userChoose">
                                                        <tr>
                                                            <td>
                                                                <div class="d-flex align-items-center">
                                                                    <div class="avatar me-2"><img class="avatar-img img-fluid" src="${userChoose.getAvatar_link()!=null?userChoose.getAvatar_link():!userChoose.isGender()?"assets/img/illustrations/profiles/profile-1.png":"assets/img/illustrations/profiles/profile-2.png"}" /></div>
                                                                        ${userChoose.getFull_name()}
                                                                </div>
                                                            </td>
                                                            <td>${userChoose.getEmail()}</td>
                                                            <td class="text-capitalize">
                                                                <c:forEach items="${sessionScope.LIST_ROLES_SETTING}" var="role">
                                                                    <c:if test="${role.getSetting_value()==userChoose.getRole_id()}">
                                                                        ${role.getSetting_title()}
                                                                    </c:if>
                                                                </c:forEach>
                                                            </td>
                                                            <td>
                                                                ${userChoose.isGender()?"<span class='badge bg-blue-soft text-blue'>Male</span>":"<span class='badge bg-purple-soft text-purple'>Female</span>"}
                                                                <!--                                                        <span class="badge bg-green-soft text-green">Sales</span>
                                                                                                                        <span class="badge bg-blue-soft text-blue">Developers</span>
                                                                                                                        <span class="badge bg-red-soft text-red">Marketing</span>
                                                                                                                        <span class="badge bg-purple-soft text-purple">Managers</span>
                                                                                                                        <span class="badge bg-yellow-soft text-yellow">Customer</span>-->
                                                            </td>
                                                            <td class="text-center form-switch">
                                                                <a data-bs-toggle="modal" href="#updateStatus${userChoose.getUser_id()}">
                                                                    <input class="form-check-input" ${loginUser.getRole_id()<2?"":"disabled=''"} name="status" type="checkbox" ${userChoose.isStatus()?"checked":""}>
                                                                </a>
                                                            </td>
                                                            <td class="text-center">
                                                                <a class="btn btn-datatable btn-icon btn-transparent-dark me-2" href="user?id=${userChoose.getUser_id()}"><i data-feather="edit"></i></a>
                                                            </td>
                                                        </tr>
                                                    <div class="modal fade" id="updateStatus${userChoose.getUser_id()}" tabindex="-1" aria-labelledby="updateStatus${userChoose.getUser_id()}" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="exampleModalLabel">${userChoose.isStatus()?"Deactive":"Active"} user ${userChoose.getFull_name()}</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    Select "Change" below if you are ready to ${userChoose.isStatus()?"deactive":"active"} this user ${userChoose.getFull_name()}.
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                                                                    <a href="user?service=changeStatus&id=${userChoose.getUser_id()}&status=${userChoose.isStatus()}" class="btn btn-primary">Change</a>
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
                                        <form action="user "method="GET">
                                            <input type="text"  hidden="" name="type" value="${requestScope.ROLE_CHOOSE.getSetting_id()}">
                                            <input type="text"  hidden="" name="statusFilter" value="${requestScope.SORT_FILTER}">
                                            <input type="text"  hidden="" name="search" value="${search}">
                                            <input type="text"  hidden="" name="sort" value="${requestScope.SORT_USER}">
                                            <c:set var="thisPage" value="${requestScope.THIS_PAGE}"></c:set>
                                            <c:set var="size" value="${requestScope.USER_SIZE}"></c:set>
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
            window.addEventListener('DOMContentLoaded', event => {
                var bir = document.querySelector('#birthday');
                var day = bir.value.split(' ')[0].split('-');
                var time = bir.value.split(' ')[1].split(':');
                document.querySelector('#inputBirthday').value = moment(new Date(day[0], day[1] - 1, day[2], time[0], time[1])).format('YYYY-MM-DD');
            });
            function avataImage(item, id) {
                var ava = document.querySelector('#' + id);
                while (ava.firstChild) {
                    ava.removeChild(ava.firstChild);
                }
                var image = document.createElement('img');
                image.classList.add('img-account-profile', 'rounded-circle', 'mb-2');
                image.alt = 'Avatar image';
                image.src = item !== "" ? item.value : "${userChoose.getAvatar_link()!=null?userChoose.getAvatar_link():!userChoose.isGender()?"assets/img/illustrations/profiles/profile-1.png":"assets/img/illustrations/profiles/profile-2.png"}";
                ava.appendChild(image);
            }
            const weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
            document.querySelector('#nowTime').innerHTML = "<span class='fw-500 text-primary'>" + weekday[moment().weekday()] + "</span> &middot; " + moment().format('MMMM DD,YYYY · h:mm A');
        </script>
        <script src="js/scripts.js"></script>
    </body>
</html>
