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
        <title class="text-capitalize">Subject List </title>
    </head>
    <body>
        <c:set var="userChoose" value="${sessionScope.CHOOSE_USER}"></c:set>
        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
        <c:set var="search" value="${requestScope.SEARCH_WORD}"></c:set>
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
                                                Subject List
                                            </h1>
                                        </div>
                                        <div class="col-12 col-xl-auto mb-3">
                                            <a href="subject?service=add" class="btn btn-primary">
                                                <i class="fa-solid fa-plus"></i>
                                                Add New Subject
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
                                                    <c:when test="${requestScope.AUTHOR_CHOOSE!=null}">
                                                        ${requestScope.AUTHOR_CHOOSE.getFull_name()}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Authors
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="subject${requestScope.SORT_FILTER==null?'':'?statusFilter='.concat(requestScope.SORT_FILTER)}">All</a>
                                                <c:forEach items="${sessionScope.LIST_AUTHOR}" var="authorChoose">
                                                    <a class="dropdown-item text-capitalize" href="subject?authorFilter=${authorChoose.getUser_id()}${requestScope.SORT_FILTER==null?'':'&statusFilter='.concat(requestScope.SORT_FILTER)}">${authorChoose.getFull_name()}</a>
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
                                                <a class="nav-link" href="subject${requestScope.AUTHOR_CHOOSE==null?'':'?authorFilter='.concat(requestScope.AUTHOR_CHOOSE.getUser_id())}">All</a>
                                                <a class="nav-link text-capitalize" href="subject?statusFilter=1${requestScope.AUTHOR_CHOOSE==null?'':'&authorFilter='.concat(requestScope.AUTHOR_CHOOSE.getUser_id())}">Activate</a>
                                                <a class="nav-link text-capitalize" href="subject?statusFilter=0${requestScope.AUTHOR_CHOOSE==null?'':'&authorFilter='.concat(requestScope.AUTHOR_CHOOSE.getUser_id())}">Deactivate</a>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <form action="subject" id="search" method="POST">
                                            <input type="text" name="search" placeholder="Click enter to search..." value="${search}" class="form-control form-search">
                                        </form> 
                                    </div>
                                </div>
                                <div class="card-body table-responsive">
                                    <table class="table table-striped table-hover table-bordered padding-0">
                                        <thead class="table-primary">
                                        <form action="subject" method="POST">
                                            <tr>
                                                <th>
                                                    <input type="text" name="search" value="${search}" hidden="">
                                                    <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                    <input type="text" name="previousSort" value="${requestScope.SORT_SUBJECT}" hidden="">
                                                    <input type="text" name="type" value="${requestScope.SETTING_TYPE_CHOOSE}" hidden="">
                                                    <button class="bg-transparent border-0" type="submit" name="sort" value="subject_id"><b>Subject ID</b><i class="fa-solid fa-sort"></i></button>
                                                </th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="subject_code"><b>Subject Code</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="subject_name"><b>Subject Name</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="author_id"><b>Author</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="status"><b>Status</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th colspan="3">Actions</th>
                                            </tr>
                                        </form>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${requestScope.LIST_SUBJECT.size()==0}">
                                                    <tr><td class="dataTables-empty" colspan="7">No results match your search query</td></tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach items="${requestScope.LIST_SUBJECT}" var="subjectChoose">
                                                        <tr>
                                                            <td> ${subjectChoose.getSubject_id()}</td>
                                                            <td>${subjectChoose.getSubject_code()}</td>
                                                            <td>${subjectChoose.getSubject_name()} </td>                
                                                            <td> <a  href="user?id=${subjectChoose.author_id}">${subjectChoose.getAuthor()}</a></td>
                                                            <td class="text-center form-switch">
                                                                <a data-bs-toggle="modal" href="#deleteSubject${subjectChoose.getSubject_id()}">
                                                                    <input ${loginUser.getRole_id()<2?"":"disabled=''"} class="form-check-input" type="checkbox" ${subjectChoose.isStatus()?"checked":""}>
                                                                </a>
                                                            </td>
                                                            <td class="text-center">
                                                                <a href="subject?id=${subjectChoose.getSubject_id()}&service=detail"><i data-feather="edit"></i></a>
                                                            </td>

                                                        </tr>
                                                    <div class="modal fade" id="deleteSubject${subjectChoose.getSubject_id()}" tabindex="-1" aria-labelledby="deleteSubject${subjectChoose.getSubject_id()}" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="exampleModalLabel">${subjectChoose.isStatus()?"Deactivate":"Activate"} Subject</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    Are you sure to ${subjectChoose.isStatus()?"deactivate":"activate"} Subject <span class="text-capitalize">${subjectChoose.getSubject_code()}?</span>
                                                                </div>
                                                                <div class="modal-footer">

                                                                   <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Close"></input>
                                                   
                                                                    <a href="subject?id=${subjectChoose.getSubject_id()}&status=${subjectChoose.isStatus()}&service=changeStatus" class="btn btn-primary">Change</a>
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
                                        <form action="subject "method="GET">
                                            <input type="text"  hidden="" name="search" value="${search}">
                                            <input type="text" name="sort" value="${requestScope.SORT_SUBJECT}" hidden="">
                                            <c:set var="thisPage" value="${requestScope.THIS_PAGE}"></c:set>
                                            <c:set var="size" value="${requestScope.SUBJECT_SIZE}"></c:set>
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
        <script src="js/scripts.js"></script>
    </body>
</html>
