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
    <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
    <c:set var="feature" value="${requestScope.FEATURE_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title class="">FEATURE · Feature Detail · ${feature==null?'Add New Feature':feature.feature_name} ${feature==null?'':feature.team_id}</title>
    </head>
    <body>
        <div class="nav-fixed">
            <jsp:include page="../included/header.jsp"/>
            <div id="layoutSidenav">
                <jsp:include page="../included/slider.jsp"/>
                <div id="layoutSidenav_content">
                    <main>
                        <div class="container-xl px-4 mt-5">
                            <div class="container-xl px-4">
                                <div class="page-header-content pt-4">
                                    <div class="d-flex justify-content-between align-items-sm-center flex-column flex-sm-row mb-4">
                                        <div class="me-4 mb-3 mb-sm-0">
                                            <h1 class="mb-0 text-bold">Feature Detail · ${feature==null?'Add New Feature':feature.feature_name} ${feature==null?'':feature.team_id}</h1>
                                            <div class="small" id="nowTime">
                                            </div>
                                        </div>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="feature"> Feature List</a></li>
                                                <c:choose>
                                                    <c:when test="${feature==null}">
                                                    <li class="breadcrumb-item active">Add New Feature</li>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <li class="breadcrumb-item active">${feature.feature_name}</li>
                                                    </c:otherwise>
                                                </c:choose>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <div class="card card-waves p-4 mb-4 mt-5">
                                <div class="row align-items-end">
                                    <div class="mb-3 col-sm-2 col-lg-4">
                                        <label for="id" class="form-label">Feature ID</label>
                                        <input type="text" class="form-control border-0 border-bottom bg-transparent" value="${feature.feature_id}" disabled="">
                                    </div>
                                    <div class="mb-3 col-sm-5 col-lg-4">
                                        <form action="feature" method="POST">
                                            <label for="subject_id" class="form-label">Class ID</label>
                                            <c:choose>
                                                <c:when test="${serve=='update'}">
                                                    <input name="type" type="text" class="form-control border-0 border-bottom bg-transparent" value="${feature.getTeam().team_name} - ${feature.getTeam().getClassroom().getClass_code()}" disabled="">
                                                </c:when>
                                                <c:otherwise>
                                                    <select id="subject_id" name="class" onchange="this.form.submit();" class="form-control col border-0 border-bottom bg-transparent">
                                                        <c:forEach items="${sessionScope.LIST_CLASS}" var="class">
                                                            <c:choose>
                                                                <c:when test="${(feature!=null&&feature.getTeam().class_id==class.class_id)||(requestScope.CLASS_CHOOSE!=null&&requestScope.CLASS_CHOOSE.class_id==class.class_id)}">
                                                                    <option class="text-capitalize" value="${class.class_id}" selected="">${class.getSubject().getSubject_code()}_${class.class_code}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${class.class_id}">${class.getSubject().getSubject_code()}_${class.class_code}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                    <input type="hidden" name="service"value="add">
                                                    <input type="text" name="submitForm" hidden="" value="class">
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
                                    </div>

                                    <div class="mb-3 col-sm-5 col-lg-4">
                                        <form action="feature" method="POST">
                                            <label for="subject_id" class="form-label">Team</label>
                                            <c:choose>
                                                <c:when test="${serve=='update'}">
                                                    <input name="type" type="text" class="form-control border-0 border-bottom bg-transparent" value="${feature.getTeam().team_id}" hidden="">
                                                    <input type="text" class="form-control border-0 border-bottom bg-transparent" value="${feature.getTeam().team_name} - ${feature.getTeam().getClassroom().getClass_code()}" disabled="">
                                                </c:when>
                                                <c:otherwise>
                                                    <select id="subject_id" name="type" class="form-control col border-0 border-bottom bg-transparent">
                                                        <c:forEach items="${requestScope.LIST_TEAM}" var="team">
                                                            <c:choose>
                                                                <c:when test="${feature.team_id==team.team_id||(requestScope.TYPE_CHOOSE!=null && requestScope.TYPE_CHOOSE.team_id==team.team_id)}">
                                                                    <option class="text-capitalize" value="${team.team_id}" selected="">${team.team_name}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${team.team_id}">${team.team_name} - ${team.getClassroom().getClass_code()}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </c:otherwise>
                                            </c:choose>

                                    </div>
                                </div>

                                <div class="row">
                                    <div class="mb-3 col-sm-7 col-lg-8">
                                        <input type="text" name="id" class="form-control" value="${feature.feature_id}" hidden="">
                                        <label for="title" class="form-label">Feature Name</label>
                                        <input type="text" ${loginUser.getRole_id()>3?"required=''":"disabled=''"} name="title" class="form-control border-0 border-bottom bg-transparent" value="${feature.feature_name}">
                                    </div>

                                    <div class="mb-3 col-xl-3 col-md-3 d-flex flex-column justify-content-between">
                                        <label for="statusFeature">Status</label>
                                        <div id="statusFeature">
                                            <input ${loginUser.getRole_id()>3?"":"disabled=''"} onchange="changeStatus('status', 'Activate', 'Deactivate')" type="checkbox" class="btn-check" id="status" name="status" autocomplete="off" ${feature!=null&&feature.isStatus()?"checked":""}>
                                            <label class="btn btn-outline-primary" for="status">Active</label>
                                        </div>
                                    </div>
                                   
                                </div>
                                <div class="mb-3 form-floating">
                                    <textarea class="form-control" placeholder="Feature description" ${loginUser.getRole_id()>3?"":"disabled=''"} id="featureDesctiption" name="description">${feature!=null?feature.getDescription():''}</textarea>
                                    <label for="featureDesctiption">Feature description</label>
                                </div>
                                <div class="ms-auto">
                                    <input type="text" name="submitForm" hidden="" value="detail">
                                    <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset">
                                    <button type="submit" name="service" value="${feature==null?'add':'update'}" class="btn btn-primary">Save changes</button>
                                </div>
                            </div>
                            </form>
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