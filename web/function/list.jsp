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
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.5/xlsx.min.js"></script>
        <title class="text-capitalize">Function List</title>
    </head>
    <body  ${sessionScope.FUNCTION_CHANGE_STATUS!=null&&sessionScope.STATUS_CHANGE!=null?' class="modal-open" style="overflow: hidden; padding-right: 8px;"':''}>
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
                                    <h1 class="mb-0 text-bold text-capitalize">Function List</h1>
                                    <div class="small" id="nowTime">
                                    </div>
                                </div>

                                <c:choose>
                                    <c:when test="${loginUser.getRole_id()>3}">
                                        <c:if test="${loginUser.getRole_id()>3}">
                                            <div class="col-12 col-xl-auto mb-3 d-flex justify-content-between">
                                             
                                                <a href="function?service=add&type=${requestScope.TYPE_CHOOSE.team_id}" class="btn btn-primary " style="margin-right: 1rem;">
                                                    <i class="fa-solid fa-plus"></i>
                                                    Add New Function
                                                </a>
                                                <a data-bs-toggle="modal" href="#addFunction" class="btn btn-primary" style="margin-right: 1rem;">
                                                    <i class="fa-solid fa-plus"></i>
                                                    Import Function
                                                </a>
                                                <c:if test="${requestScope.LIST_FUNCTION.size()>0}">
                                                    <a href="function?service=exportExcel&type=${TYPE_CHOOSE.team_id}" class="btn btn-primary">
                                                        <i data-feather="external-link"></i>
                                                        Export Function
                                                    </a>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${requestScope.LIST_FUNCTION.size()>0}">
                                            <a href="function?service=exportExcel&type=${TYPE_CHOOSE.team_id}" class="btn btn-primary">
                                                <i data-feather="external-link"></i>
                                                Export Function
                                            </a>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>

                                <div class="modal fade" id="addFunction" tabindex="-1" role="dialog" aria-labelledby="addPerson" aria-hidden="true" style="">
                                    <div class="modal-dialog modal-xl" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="exampleModalLabel">Add Function</h5>
                                                <button type="button" class="btn-close" onclick="refreshTable()" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <form action="function" method="POST" enctype="multipart/form-data">
                                                <div class="modal-body">
                                                    <div class="d-flex flex-column justify-content-around">
                                                        <input type="file" onchange="upload()" name="excel" hidden accept=".csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" id="inputExcel" />
                                                        <input type="hidden" name="type" value="${requestScope.TYPE_CHOOSE.team_id}">
                                                        <div class="w-100 d-flex justify-content-around">
                                                            <label for="inputExcel" class="btn padding-0 icon rounded-circle bg-primary">
                                                                <i class="text-white fa-solid fa-file-excel center"></i>
                                                            </label>

                                                        </div>
                                                        <div>
                                                            <h2>Guide insert Excel</h2>
                                                            <i class="text-muted">If you do not follow this guide you cannot insert <strong>Function</strong> into data</i>
                                                            <a href="assets/demo/demoFunction.xlsx" download="">Click here to download template!</a>
                                                            <div class="table-responsive">
                                                                <table class="table table-striped table-hover table-bordered padding-0" id="display_excel_data"></table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="modal-footer" id="importFooter" style="display: none;">
                                                    <button type="submit" class="btn btn-primary" onclick="document.querySelector('#preloader').style.display = 'block';" name="service" value="importExcel">Import</button>
                                                    <button type="reset" class="btn btn-light" onclick="refreshTable()" data-bs-dismiss="modal" aria-label="Close">Cancel</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <div class="card p-4 mb-4 mt-5 table-wrapper">
                                <div class="card-header d-flex justify-content-between align-items-center bg-white padding-0" style="padding-bottom: 1rem !important">
                                    <!--Filter-->
                                    <div class="d-flex justify-content-sm-start align-items-center">
                                        <!--                                    Class filter-->
                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.CLASS_CHOOSE!=null}">
                                                        ${requestScope.CLASS_CHOOSE.getSubject().getSubject_code()}_ ${requestScope.CLASS_CHOOSE.getClass_code()}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        ${sessionScope.LIST_CLASS.get(0).getSubject().getSubject_code()}_ ${sessionScope.LIST_CLASS.get(0).getClass_code()}
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <c:forEach items="${sessionScope.LIST_CLASS}" var="class">
                                                    <a class="dropdown-item text-capitalize" href="function?class=${class.getClass_id()}${requestScope.STATUS_VALUE!=null?"&status=".concat(requestScope.STATUS_VALUE):""}">${class.getSubject().getSubject_code()}_ ${class.getClass_code()}</a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <!--                                    Team Filter-->
                                        <c:if test="${requestScope.LIST_TEAM!=null}">
                                            <div class="dropdown" style="margin-right: 10px;">
                                                <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    GR ${requestScope.TYPE_CHOOSE.getTeam_name()}
                                                </button>
                                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                    <c:forEach items="${requestScope.LIST_TEAM}" var="team">
                                                        <a class="dropdown-item text-capitalize" href="function?type=${team.getTeam_id()}${class.getClass_id()}${requestScope.STATUS_VALUE!=null?"&status=".concat(requestScope.STATUS_VALUE):""}${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}">
                                                            GR ${team.getTeam_name()}
                                                        </a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:if>
                                        <!--                                    Feature filter-->
                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.FEATURE_CHOOSE!=null}">
                                                        ${requestScope.FEATURE_CHOOSE.getFeature_name()}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Feature 
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="function?${requestScope.STATUS_CHOOSE!=null?"&status=".concat(requestScope.STATUS_VALUE):""}${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}${requestScope.TYPE_CHOOSE!=null?"&type=".concat(requestScope.TYPE_CHOOSE.getTeam_id()):""}${requestScope.PRIORITY_CHOOSE!=null?"&priority=".concat(requestScope.PRIORITY_CHOOSE):""}${requestScope.COMPLEXITY_CHOOSE!=null?"&complexity=".concat(requestScope.COMPLEXITY_CHOOSE.getSetting_id()):""}">All</a>
                                                <c:forEach items="${requestScope.LIST_FEATURE}" var="feature">
                                                    <a class="dropdown-item text-capitalize" href="function?feature=${feature.getFeature_id()}${requestScope.STATUS_CHOOSE!=null?"&status=".concat(requestScope.STATUS_VALUE):""}${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}${requestScope.TYPE_CHOOSE!=null?"&type=".concat(requestScope.TYPE_CHOOSE.getTeam_id()):""}${requestScope.COMPLEXITY_CHOOSE!=null?"&complexity=".concat(requestScope.COMPLEXITY_CHOOSE.getSetting_id()):""}${requestScope.PRIORITY_CHOOSE!=null?"&priority=".concat(requestScope.PRIORITY_CHOOSE):""}">${feature.getFeature_name()}</a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <!--Status Filter-->
                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.STATUS_CHOOSE!=null}">
                                                        ${requestScope.STATUS_CHOOSE.setting_title}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Status
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="function?${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}${requestScope.TYPE_CHOOSE!=null?"&type=".concat(requestScope.TYPE_CHOOSE.getTeam_id()):""}${requestScope.FEATURE_CHOOSE!=null?"&feature=".concat(requestScope.FEATURE_CHOOSE.getFeature_id()):""}${requestScope.PRIORITY_CHOOSE!=null?"&priority=".concat(requestScope.PRIORITY_CHOOSE):""}${requestScope.COMPLEXITY_CHOOSE!=null?"&complexity=".concat(requestScope.COMPLEXITY_CHOOSE.getSetting_id()):""}${requestScope.OWNER_CHOOSE!=null?"&owner_id=".concat(requestScope.OWNER_CHOOSE.getUser_id()):""}">All</a>
                                                <c:forEach items="${sessionScope.LIST_FUNCTION_STATUS}" var="status">
                                                    <a class="dropdown-item text-capitalize" href="function?status=${status.setting_value}${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}${requestScope.TYPE_CHOOSE!=null?"&type=".concat(requestScope.TYPE_CHOOSE.getTeam_id()):""}${requestScope.FEATURE_CHOOSE!=null?"&feature=".concat(requestScope.FEATURE_CHOOSE.getFeature_id()):""}${requestScope.PRIORITY_CHOOSE!=null?"&priority=".concat(requestScope.PRIORITY_CHOOSE):""}${requestScope.COMPLEXITY_CHOOSE!=null?"&complexity=".concat(requestScope.COMPLEXITY_CHOOSE.getSetting_id()):""}${requestScope.OWNER_CHOOSE!=null?"&owner_id=".concat(requestScope.OWNER_CHOOSE.getUser_id()):""}">${status.setting_title}</a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <!--Complexity Filter-->
<!--                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.COMPLEXITY_CHOOSE!=null}">
                                                        ${requestScope.COMPLEXITY_CHOOSE.setting_title}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Complexity
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="function?${requestScope.STATUS_CHOOSE!=null?"?status=".concat(requestScope.STATUS_VALUE):""}${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}${requestScope.TYPE_CHOOSE!=null?"&type=".concat(requestScope.TYPE_CHOOSE.getTeam_id()):""}${requestScope.FEATURE_CHOOSE!=null?"&feature=".concat(requestScope.FEATURE_CHOOSE.getFeature_id()):""}${requestScope.PRIORITY_CHOOSE!=null?"&priority=".concat(requestScope.PRIORITY_CHOOSE):""}${requestScope.OWNER_CHOOSE!=null?"&owner_id=".concat(requestScope.OWNER_CHOOSE.getUser_id()):""}">All</a>
                                                <c:forEach items="${requestScope.COMPLEXITY_LIST}" var="complexity">
                                                    <a class="dropdown-item text-capitalize" href="function?complexity=${complexity.setting_id}${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}${requestScope.TYPE_CHOOSE!=null?"&type=".concat(requestScope.TYPE_CHOOSE.getTeam_id()):""}${requestScope.FEATURE_CHOOSE!=null?"&feature=".concat(requestScope.FEATURE_CHOOSE.getFeature_id()):""}${requestScope.STATUS_CHOOSE!=null?"&status=".concat(requestScope.STATUS_VALUE):""}${requestScope.PRIORITY_CHOOSE!=null?"&priority=".concat(requestScope.PRIORITY_CHOOSE):""}${requestScope.OWNER_CHOOSE!=null?"&owner_id=".concat(requestScope.OWNER_CHOOSE.getUser_id()):""}">${complexity.setting_title}</a>
                                                </c:forEach>
                                            </div>
                                        </div>-->
                                        <!--Priority Filter-->
<!--                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.PRIORITY_CHOOSE!=null}">
                                                        Priority ${requestScope.PRIORITY_CHOOSE}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Priority
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="function?${requestScope.STATUS_CHOOSE!=null?"?status=".concat(requestScope.STATUS_VALUE):""}${requestScope.COMPLEXITY_CHOOSE!=null?"&complexity=".concat(requestScope.COMPLEXITY_CHOOSE.getSetting_id()):""}${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}${requestScope.TYPE_CHOOSE!=null?"&type=".concat(requestScope.TYPE_CHOOSE.getTeam_id()):""}${requestScope.FEATURE_CHOOSE!=null?"&feature=".concat(requestScope.FEATURE_CHOOSE.getFeature_id()):""}${requestScope.OWNER_CHOOSE!=null?"&owner_id=".concat(requestScope.OWNER_CHOOSE.getUser_id()):""}">All</a>
                                                <c:forEach items="${requestScope.PRIORITY_LIST}" var="priority">
                                                    <a class="dropdown-item text-capitalize" href="function?priority=${priority}${requestScope.COMPLEXITY_CHOOSE!=null?"&complexity=".concat(requestScope.COMPLEXITY_CHOOSE.getSetting_id()):""}${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}${requestScope.TYPE_CHOOSE!=null?"&type=".concat(requestScope.TYPE_CHOOSE.getTeam_id()):""}${requestScope.FEATURE_CHOOSE!=null?"&feature=".concat(requestScope.FEATURE_CHOOSE.getFeature_id()):""}${requestScope.STATUS_CHOOSE!=null?"&status=".concat(requestScope.STATUS_VALUE):""}${requestScope.OWNER_CHOOSE!=null?"&owner_id=".concat(requestScope.OWNER_CHOOSE.getUser_id()):""}">Priority ${priority}</a>
                                                </c:forEach>
                                            </div>
                                        </div>-->
                                        <!--Owner Filter-->
                                        <div class="dropdown" style="margin-right: 10px;">
                                            <button class="form-select text-capitalize" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <c:choose>
                                                    <c:when test="${requestScope.OWNER_CHOOSE!=null}">
                                                        ${OWNER_CHOOSE.getUser().full_name}
                                                    </c:when>                                
                                                    <c:otherwise>
                                                        All Owner
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="function?${requestScope.PRIORITY_CHOOSE!=null?"&priority=".concat(requestScope.PRIORITY_CHOOSE):""}${requestScope.STATUS_CHOOSE!=null?"?status=".concat(requestScope.STATUS_VALUE):"?status="}${requestScope.COMPLEXITY_CHOOSE!=null?"&complexity=".concat(requestScope.COMPLEXITY_CHOOSE.getSetting_id()):""}${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}${requestScope.TYPE_CHOOSE!=null?"&type=".concat(requestScope.TYPE_CHOOSE.getTeam_id()):""}${requestScope.FEATURE_CHOOSE!=null?"&feature=".concat(requestScope.FEATURE_CHOOSE.getFeature_id()):""}">All Owner</a>
                                                <c:forEach items="${requestScope.LIST_CLASS_USER}" var="user">
                                                    <a class="dropdown-item text-capitalize" href="function?owner_id=${user.user_id}${requestScope.PRIORITY_CHOOSE!=null?"&priority=".concat(requestScope.PRIORITY_CHOOSE):""}${requestScope.COMPLEXITY_CHOOSE!=null?"&complexity=".concat(requestScope.COMPLEXITY_CHOOSE.getSetting_id()):""}${requestScope.CLASS_CHOOSE!=null?"&class=".concat(requestScope.CLASS_CHOOSE.getClass_id()):""}${requestScope.TYPE_CHOOSE!=null?"&type=".concat(requestScope.TYPE_CHOOSE.getTeam_id()):""}${requestScope.FEATURE_CHOOSE!=null?"&feature=".concat(requestScope.FEATURE_CHOOSE.getFeature_id()):""}${requestScope.STATUS_CHOOSE!=null?"&status=".concat(requestScope.STATUS_VALUE):""}"> ${user.getUser().full_name}</a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>

                                </div>

                                <div card-header d-flex justify-content-between align-items-center bg-white padding-0 style="margin-right: 10%;">
                                    <form action="function" id="search" method="POST">
                                        <input type="text" name="search" placeholder="Click enter to search..." value="${search}" class="form-control form-search">
                                    </form> 
                                </div>
                                <!--                                        table function list-->

                                <div class="card-body table-responsive">
                                    <table class="table table-striped table-hover table-bordered padding-0">
                                        <thead class="table-primary text-center">
                                        <form action="function" method="POST">
                                            <tr>
                                                <th>
                                                    <input type="text" name="search" value="${search}" hidden="">
                                                    <input type="text" name="sortStatus" value="${requestScope.SORT_STATUS}" hidden="">
                                                    <input type="text" name="previousSort" value="${requestScope.SORT_FEATURE}" hidden="">
                                                    <input type="text" name="type" value="${requestScope.SUBJECT_CHOOSE.getSubject_code()}" hidden="">
                                                    <button class="bg-transparent border-0" type="submit" name="sort" value="feature_id"><b>ID</b><i class="fa-solid fa-sort"></i></button>
                                                </th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="feature_name"><b>Feature</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="function_name"><b>Function</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="access_roles"><b>Access</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="complexiy_id"><b>Complexity</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="owner_id"><b>Owner</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="priority"><b>Priority</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th><button class="bg-transparent border-0" type="submit" name="sort" value="status"><b>Status</b><i class="fa-solid fa-sort"></i></button></th>
                                                <th colspan="2">Actions</th>
                                            </tr>
                                        </form>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${requestScope.LIST_FUNCTION==null||requestScope.LIST_FUNCTION.size()==0}">
                                                    <tr><td class="dataTables-empty" colspan="9">No results match your search query</td></tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="func" items="${requestScope.LIST_FUNCTION}">
                                                        <tr>
                                                            <td>${func.function_id}</td>
                                                            <td >${func.getFeature().getFeature_name()}</td>
                                                            <td >${func.getFunction_name()}</td>
                                                            <td >${func.getAccess_roles().toString().replaceAll("\\[|\\]", "")}</td>
                                                            <td >${func.getComplexity().getSetting_title()}</td>
                                                            <td >${func.getOwner().getFull_name()}</td>
                                                            <td >${func.getPriority()}</td>

                                                            <td>  
                                                                <c:choose>
                                                                    <c:when test="${!isLeader&&(
                                                                                    isDropped||loginUser.getRole_id()!=4||func.owner_id!=loginUser.getUser_id()||func.getFunctionStatus().setting_title.toLowerCase()=='closed')}">
                                                                                ${func.getFunctionStatus().setting_title}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <button class="form-select bg-transparent text-capitalize border-0 border-bottom d-flex align-items-start" id="status" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                                    ${func.getFunctionStatus().setting_title}
                                                                                </button>
                                                                                <div class="dropdown-menu " aria-labelledby="status">
                                                                                    <c:forEach items="${sessionScope.LIST_FUNCTION_STATUS}" var="status">
                                                                                        <c:if test="${status.getSetting_value()>func.getFunctionStatus().setting_value}">
                                                                                            <a class="nav-link text-capitalize text-dark" href="function?status=${status.getSetting_id()}&id=${func.function_id}&service=changeStatus">${status.getSetting_title()}</a>
                                                                                        </c:if>
                                                                                    </c:forEach>
                                                                                </div>
                                                                            </c:otherwise>
                                                                    </c:choose>
                                                                </td>

                                                                <td class="text-center">
                                                                    <a href="function?id=${func.function_id}&service=detail&class=${func.getTeam().getClassroom().class_id}&type=${func.getTeam().getTeam_id()}">
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
                                            <form action="function" method="GET">
                                                <input type="text"  hidden="" name="search" value="${search}">
                                                <input type="text" name="sort" value="${requestScope.SORT_FUNCTION}" hidden="">
                                                <input type="text" name="type" value="${requestScope.TYPE_CHOOSE.getTeam_id()}" hidden="">
                                                <input type="text" name="class" value="${requestScope.CLASS_CHOOSE.getClass_id()}" hidden="">
                                                <input type="text" name="feature" value="${requestScope.FEATURE_CHOOSE.getFeature_id()}" hidden="">
                                                <input type="text" name="complexity" value="${requestScope.COMPLEXITY_CHOOSE.getSetting_id()}" hidden="">
                                                <input type="text" name="priority" value="${requestScope.PRIORITY_CHOOSE}" hidden="">
                                                <input type="text" name="status" value="${requestScope.STATUS_VALUE}" hidden="">
                                                <c:set var="thisPage" value="${requestScope.THIS_PAGE}"></c:set>
                                                <c:set var="size" value="${requestScope.FUNCTION_SIZE}"></c:set>
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

            <c:if test="${sessionScope.FUNCTION_CHANGE_STATUS!=null&&sessionScope.STATUS_CHANGE!=null}">
                <div class="modal fade show" tabindex="-1" aria-modal="true" role="dialog" style="display: block;">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">Change Status Function</h5>
                                <a href="function?submit=false&service=changeStatus" class="btn-close" aria-label="Close"></a>
                            </div>
                            <div class="modal-body">
                                Are you sure to change status function ${sessionScope.FUNCTION_CHANGE_STATUS.getFunction_name()} from ${sessionScope.FUNCTION_CHANGE_STATUS.getFunctionStatus().getSetting_title()} to ${sessionScope.STATUS_CHANGE.getSetting_title()}
                            </div>
                            <div class="modal-footer">
                                <a href="function?submit=false&service=changeStatus" class="btn btn-light">Close</a>
                                <a href="function?id=${sessionScope.FUNCTION_CHANGE_STATUS.getFunction_id()}&status=${sessionScope.STATUS_CHANGE.getSetting_id()}&submit=true&service=changeStatus" class="btn btn-primary">Change</a>
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
                        var htmlData = '<tr class="table-primary"><th>Feature</th><th>Function Name</th><th>Priority</th><th>Access Roles</th><th>Description</th></tr>';
                        for (var i = 0; i < jsonData.length; i++) {
                            var row = jsonData[i];
                            htmlData += '<tr><td>' + row["Feature"] + '</td><td>' + row["Function Name"] + '</td><td>'
                                    + row["Priority"] + '</td><td>' + row["Access Roles"] + '</td><td>' + row["Description"] + '</td>';
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