<%-- 
    Document   : classList
    Created on : May 25, 2022, 10:32:55 AM
    Author     : win
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <link href="css/course.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/components/prism-core.min.js" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/autoloader/prism-autoloader.min.js" crossorigin="anonymous"></script>
        <title class="text-capitalize">Class List  ${requestScope.SUBJECT_CHOOSE!=null?" · ".concat(requestScope.SUBJECT_CHOOSE.getSubject_code()):""}</title>
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
                            <div class="container-xl px-4 mt-5 d-flex justify-content-between align-items-sm-center flex-column flex-sm-row mb-4">
                                <div class="me-4 mb-3 mb-sm-0">
                                    <h1 class="mb-0 text-bold text-capitalize">Classes List  ${requestScope.SUBJECT_CHOOSE!=null?" · ".concat(requestScope.SUBJECT_CHOOSE.getSubject_code()):""}</h1>
                                    <div class="small" id="nowTime">
                                    </div>
                                </div>
                                <c:if test="${sessionScope.LOGIN_USER.getRole_id()<3}">
                                    <a href="class?service=add" class="btn btn-primary">
                                        <i class="fa-solid fa-plus"></i>
                                        Create new Class
                                    </a>
                                </c:if>
                            </div>
                            <div class="card-header d-flex justify-content-between align-items-center bg-white padding-0 border-0">
                                <div class="d-flex justify-content-sm-start align-items-start">
                                    <div class="dropdown" style="margin-right: 10px;">
                                        <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <c:choose>
                                                <c:when test="${requestScope.SUBJECT_CHOOSE!=null}">
                                                    ${requestScope.SUBJECT_CHOOSE.getSubject_code()} - ${requestScope.SUBJECT_CHOOSE.getSubject_name()}
                                                </c:when>                                
                                                <c:otherwise>
                                                    All Subjects
                                                </c:otherwise>
                                            </c:choose>
                                        </button>
                                        <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                            <a class="dropdown-item" href="class?trainer=${requestScope.TRAINER_CHOOSE==null?'':''.concat(requestScope.TRAINER_CHOOSE.getUser_id())}&status=${requestScope.SORT_FILTER!=null?requestScope.SORT_FILTER:''}">All</a>
                                            <c:forEach items="${sessionScope.LIST_SUBJECT}" var="subject">
                                                <a class="dropdown-item text-capitalize" href="class?type=${subject.subject_id}${requestScope.TRAINER_CHOOSE==null?'':'&trainer='.concat(requestScope.TRAINER_CHOOSE.getUser_id())}${requestScope.SORT_FILTER!=null?'&status='.concat(requestScope.SORT_FILTER):''}">${subject.subject_code} - ${subject.getSubject_name()}</a>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <c:if test="${loginUser.getRole_id()<3}">
                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.TRAINER_CHOOSE!=null}">
                                                        ${requestScope.TRAINER_CHOOSE.getFull_name()}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Teachers
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="class?type=${requestScope.SUBJECT_CHOOSE==null?'':''.concat(requestScope.SUBJECT_CHOOSE.getSubject_id())}&status=${requestScope.SORT_FILTER!=null?requestScope.SORT_FILTER:''}">All</a>
                                                <c:forEach items="${sessionScope.LIST_TEACHER}" var="trainer">
                                                    <a class="dropdown-item text-capitalize" href="class?trainer=${trainer.getUser_id()}${requestScope.SUBJECT_CHOOSE==null?'':'&type='.concat(requestScope.SUBJECT_CHOOSE.getSubject_id())}${requestScope.SORT_FILTER!=null?'&status='.concat(requestScope.SORT_FILTER):''}">${trainer.getFull_name()}</a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>
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
                                            <a class="nav-link" href="class?trainer=${requestScope.TRAINER_CHOOSE==null?'':requestScope.TRAINER_CHOOSE.getUser_id()}&type=${requestScope.SUBJECT_CHOOSE==null?'':requestScope.SUBJECT_CHOOSE.getSubject_id()}">All</a>
                                            <a class="nav-link text-capitalize" href="class?status=1${requestScope.TRAINER_CHOOSE==null?'':'&trainer='.concat(requestScope.TRAINER_CHOOSE.getUser_id())}${requestScope.SUBJECT_CHOOSE==null?'':'&type='.concat(requestScope.SUBJECT_CHOOSE.getSubject_id())}">Activate</a>
                                            <a class="nav-link text-capitalize" href="class?status=0${requestScope.TRAINER_CHOOSE==null?'':'&trainer='.concat(requestScope.TRAINER_CHOOSE.getUser_id())}${requestScope.SUBJECT_CHOOSE==null?'':'&type='.concat(requestScope.SUBJECT_CHOOSE.getSubject_id())}">Deactivate</a>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <form action="class" id="search" method="POST">
                                        <input type="text" name="search" placeholder="Click enter to search..." value="${search}" class="form-control form-search">
                                        <input type="submit"  hidden="" name="type" value="${requestScope.SUBJECT_CHOOSE.getSubject_id()}">
                                    </form> 
                                </div>
                            </div>
                        </div>
                        <div class="p-4 mb-4 mt-5">
                            <div class="container bg-white wrap-list-courses">
                                <c:choose>
                                    <c:when test="${requestScope.LIST_CLASS!=null&&requestScope.LIST_CLASS.size()>0}">  
                                        <ul class="nav nav-tabs" id="navBordersHorizontalTabs" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link ${loginUser.getRole_id()<4?'':'active me-1'}" id="navBordersHorizontalListTab" data-bs-toggle="tab" href="#navBordersHorizontalList" role="tab" aria-controls="navBordersHorizontalList" aria-selected="${loginUser.getRole_id()<4?'true':'false'}">
                                                    <i data-feather="list"></i>
                                                </a>
                                            </li>
                                            <c:if test="${loginUser.getRole_id()<4}">
                                                <li class="nav-item">
                                                    <a class="nav-link ${loginUser.getRole_id()<4?'active me-1':''}" id="navBordersHorizontalTableTab" data-bs-toggle="tab" href="#navBordersHorizontalTable" role="tab" aria-controls="navBordersHorizontalTable" aria-selected="${loginUser.getRole_id()<4?'false':'true'}">
                                                        <i data-feather="table"></i>
                                                    </a>
                                                </li>
                                            </c:if>
                                        </ul>
                                        <!-- Tab panes-->
                                        <div class="tab-content">
                                            <c:if test="${loginUser.getRole_id()<4}">
                                                <div class="tab-pane ${loginUser.getRole_id()<4?'active':''}" id="navBordersHorizontalTable" role="tabpanel" aria-labelledby="navBordersHorizontalTableTab">
                                                    <div class="card-body table-responsive">
                                                        <table class="table table-striped table-hover table-bordered padding-0">
                                                            <thead class="table-primary">
                                                            <form action="class" method="POST">
                                                                <tr>
                                                                    <th>
                                                                        <input type="text" name="search" value="${search}" hidden="">
                                                                        <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                                        <input type="text" name="previousSort" value="${requestScope.SORT_CLASS}" hidden="">
                                                                        <input type="text" name="type" value="${requestScope.SUBJECT_CHOOSE}" hidden="">
                                                                        <button class="bg-transparent border-0" type="submit" name="sort" value="class_code"><b>Class Code</b><i class="fa-solid fa-sort"></i></button>
                                                                    </th>
                                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="subject_id"><b>Subject Code</b><i class="fa-solid fa-sort"></i></button></th>
                                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="trainer_id"><b>Trainer</b><i class="fa-solid fa-sort"></i></button></th>
                                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="class_term"><b>Semester</b><i class="fa-solid fa-sort"></i></button></th>
                                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="class_year"><b>Year</b><i class="fa-solid fa-sort"></i></button></th>
                                                                    <th>Class's Student</th>
                                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="block5_class"><b>Block 5</b><i class="fa-solid fa-sort"></i></button></th>
                                                                    <th><button class="bg-transparent border-0" type="submit" name="sort" value="status"><b>Status</b><i class="fa-solid fa-sort"></i></button></th>
                                                                    <th colspan="3">Actions</th>
                                                                </tr>
                                                            </form>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${requestScope.LIST_CLASS}" var="class">
                                                                    <tr>
                                                                        <td> ${class.getClass_code()}</td>
                                                                        <td><a href="subject?id=${class.getSubject().getSubject_id()}"> ${class.getSubject().getSubject_code()}</a></td>
                                                                        <td>
                                                                            <a href="user?id=${class.trainer.user_id}">${class.trainer.getFull_name()}</a>
                                                                        </td>                
                                                                        <td>${requestScope.LIST_TERM.get(class.class_term-requestScope.LIST_TERM.get(0).getSetting_id()).getSetting_title()}</td>
                                                                        <td>${class.getClass_year()}</td>
                                                                        <td>${class.getClass_user()}</td>
                                                                        <td class="text-center form-switch">
                                                                            <input class="form-check-input" disabled="" type="checkbox" ${class.isBlock5_class()?"checked":""}>
                                                                        </td>
                                                                        <td class="text-center form-switch">
                                                                            <a data-bs-toggle="modal" href="#updateStatus${class.getClass_id()}">
                                                                                <input class="form-check-input" type="checkbox" ${loginUser.getRole_id()>2?"disabled=''":""} ${class.isStatus()?"checked":""}>
                                                                            </a>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <a href="class?id=${class.getClass_id()}&service=update"><i data-feather="edit"></i></a>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <a href="class?id=${class.getClass_id()}"><i data-feather="file"></i></a>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <a href="classUser?class=${class.getClass_id()}"><i data-feather="users"></i></a>
                                                                        </td>
                                                                    </tr>
                                                                <div class="modal fade" id="updateStatus${class.getClass_id()}" tabindex="-1" aria-labelledby="updateStatus${class.getClass_id()}" aria-hidden="true">
                                                                    <div class="modal-dialog">
                                                                        <div class="modal-content">
                                                                            <div class="modal-header">
                                                                                <h5 class="modal-title" id="exampleModalLabel">${subjectChoose.isStatus()?"Deactive":"Active"} Subject</h5>
                                                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                            </div>
                                                                            <div class="modal-body">
                                                                                Are you sure to ${class.isStatus()?"deactive":"active"} Class <span class="text-capitalize">(${class.getSubject().getSubject_code()}) ${class.class_code} (${requestScope.LIST_TERM.get(class.class_term-requestScope.LIST_TERM.get(0).getSetting_id()).getSetting_title()}-${class.class_year})?</span>
                                                                            </div>
                                                                            <div class="modal-footer">
                                                                                <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset"></input>
                                                                                <a href="class?id=${class.getClass_id()}&status=${class.isStatus()}&service=changeStatus" class="btn btn-primary">Change</a>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </c:if>
                                            <div class="tab-pane ${loginUser.getRole_id()<4?'':'active'}" id="navBordersHorizontalList" role="tabpanel" aria-labelledby="navBordersHorizontalListTab">
                                                <div class="edn-tabs ui-tabs ui-widget ui-widget-content">
                                                    <div id="tab-home-page" class="group-head-tab-control hidden">
                                                        <div class="session-group ui-tabs-panel ui-widget-content" id="course-member" role="tabpanel" aria-hidden="false" aria-labelledby="session-group-tab">
                                                            <section class="course-section">
                                                                <div class="wrap-slider-content">
                                                                    <div class="wrap-course-section">
                                                                        <div class="list-course row">
                                                                            <c:forEach items="${requestScope.LIST_CLASS}" var="class">
                                                                                <article class="course-item col-md-4 col-sm-6 col-lg-3 publish">
                                                                                    <div class="wrap-course-item">
                                                                                        <div class="course-infor bg-white">
                                                                                            <div class=" d-flex justify-content-between">
                                                                                                <h3 class="course-title mg-b-15 fs-18">
                                                                                                    <a title="${class.subject.getSubject_name()}" href="class?id=${class.getClass_id()}">
                                                                                                        (${class.subject.getSubject_code()}) ${class.subject.getSubject_name()}
                                                                                                    </a>
                                                                                                </h3>
                                                                                                <c:if test="${sessionScope.LOGIN_USER.getRole_id()<4}">
                                                                                                    <div class="dropdown">
                                                                                                        <a class="bg-transparent" type="button" href="#dropdownMenuButton${class.getClass_id()}"
                                                                                                           data-bs-toggle="dropdown" aria-expanded="false">
                                                                                                            <i class="fa-solid fa-ellipsis-vertical"></i>
                                                                                                        </a>
                                                                                                        <div class="dropdown-menu dropdown-menu-end" id="dropdownMenuButton${class.getClass_id()}" style="z-index: 100000!important;">
                                                                                                            <a href="class?id=${class.getClass_id()}&service=update" class="dropdown-item">
                                                                                                                <div class="dropdown-item-icon">
                                                                                                                    <i data-feather="settings"></i>
                                                                                                                </div>
                                                                                                                Setting
                                                                                                            </a>
                                                                                                            <a data-bs-toggle="modal" href="#deleteClass${class.getClass_id()}" class="dropdown-item">
                                                                                                                <div class="dropdown-item-icon">
                                                                                                                    <i data-feather="trash"></i>
                                                                                                                </div>
                                                                                                                Delete
                                                                                                            </a>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </c:if>
                                                                                            </div>
                                                                                            <table border="0" class="bottom-course-sum text-gray-600 none-list mg-0 fs-14 mg-b-15 padding-0" >
                                                                                                <tr>
                                                                                                    <td><i class="fa-solid fa-circle-user"></i></td>
                                                                                                    <td>
                                                                                                        <span title="${class.getTrainer().getEmail()}">
                                                                                                            ${class.getTrainer().getEmail().toUpperCase()}
                                                                                                        </span>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td><i class="fa-solid fa-people-roof"></i></td>
                                                                                                    <td>
                                                                                                        <span title="${class.getClass_code()}">
                                                                                                            ${class.getClass_code()}
                                                                                                        </span>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td><i class="fa-solid fa-address-card"></i></td>
                                                                                                    <td>
                                                                                                        <span title="Number of students: 0">
                                                                                                            Number of students: ${class.getClass_user()}
                                                                                                        </span>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                            <a class="view-detail text-decoration-none fs-14 mg-b-5" href="class?id=${class.getClass_id()}">
                                                                                                <div class="more"><span>Go to course<ion-icon name="arrow-forward-outline"></ion-icon></span></div>
                                                                                            </a>
                                                                                        </div>
                                                                                    </div>
                                                                                </article>
                                                                                <div class="modal fade" id="deleteClass${class.getClass_id()}" tabindex="-1" aria-labelledby="deleteSetting${setting.getSetting_id()}" aria-hidden="true">
                                                                                    <div class="modal-dialog">
                                                                                        <div class="modal-content">
                                                                                            <div class="modal-header">
                                                                                                <h5 class="modal-title" id="exampleModalLabel">Delete Class</h5>
                                                                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                                            </div>
                                                                                            <div class="modal-body">
                                                                                                Are you sure to delete (${class.getClass_code()}-${class.subject.getSubject_code()}) ${class.subject.getSubject_name()}?
                                                                                            </div>
                                                                                            <div class="modal-footer">
                                                                                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                                                                                                <a href="class?id=${class.getClass_id()}&service=delete" class="btn btn-danger">Delete</a>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </section>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex flex-column justify-content-center" style="margin-top: 50px;">
                                        <img class="img-fluid mb-4" src="assets/img/illustrations/data-report.svg" alt="" style="height: 10rem" />
                                        <c:choose>
                                            <c:when test="${loginUser.getRole_id()==4}">
                                                <c:choose>
                                                    <c:when test="${search!=null}">
                                                        <div class="text-center px-0 px-lg-5">
                                                            <h5>
                                                                Cannot find any class has word ${search}!
                                                            </h5>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise> 
                                                        <div class="text-center px-0 px-lg-5">
                                                            <h5>
                                                                You don't have any class.
                                                            </h5>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${search!=null}">
                                                        <div class="text-center px-0 px-lg-5">
                                                            <h5>
                                                                Cannot find any class has word ${search}!
                                                            </h5>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="text-center px-0 px-lg-5">
                                                            <h5>
                                                                There are no classes here! Generate custom reports now!
                                                            </h5>
                                                            <p class="mb-4">Our new report generation system is now online. You can start creating classroom on our system.</p>
                                                            <a data-bs-toggle="modal" href="#addClass" class="btn btn-primary">Add new class now</a>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-footer border-0 bg-white">
                            <nav class="d-flex align-items-end justify-content-end" aria-label="">
                                <form action="class "method="GET">
                                    <input type="text"  hidden="" name="search" value="${search}">
                                    <input type="text"  hidden="" name="type" value="${requestScope.SUBJECT_CHOOSE.getSubject_id()}">
                                    <input type="text"  hidden="" name="trainer" value="${requestScope.TRAINER_CHOOSE.getUser_id()}">
                                    <c:set var="thisPage" value="${requestScope.THIS_PAGE}"></c:set>
                                    <c:set var="size" value="${requestScope.CLASS_SIZE}"></c:set>
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
                        <jsp:include page="../included/footer.jsp"/>
                    </main>
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