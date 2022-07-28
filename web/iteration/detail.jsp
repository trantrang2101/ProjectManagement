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
    <c:set var="iter" value="${requestScope.ITERATION_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title class="">Iteration · ${iter.iteration_name} (${iter.getSubject().getSubject_code()})</title>
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
                            <div class="container-xl px-4">
                                <div class="page-header-content pt-4">
                                    <div class="d-flex justify-content-between align-items-sm-center flex-column flex-sm-row mb-4">
                                        <div class="me-4 mb-3 mb-sm-0">
                                            <h1 class="mb-0 text-bold">Iteration Detail · ${iter.iteration_name} (${iter.getSubject().getSubject_code()})</h1>
                                            <div class="small" id="nowTime">
                                            </div>
                                        </div>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="iteration"> Iteration List</a></li>
                                                <c:choose>
                                                    <c:when test="${iter==null}">
                                                    <li class="breadcrumb-item active">Add New Iteration</li>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <li class="breadcrumb-item text-capitalize"><a href="iteration?type=${iter.subject_id}">${iter.getSubject().getSubject_code()}</a></li>
                                                    <li class="breadcrumb-item active">${iter.iteration_name}</li>
                                                    </c:otherwise>
                                                </c:choose>

                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <form action="iteration" method="POST">
                                <div class="card card-waves p-4 mb-4 mt-5">
                                    <div class="row align-items-end">
                                        <input type="text" name="id" class="form-control" value="${iter.iteration_id}" hidden="">
                                        <div class="mb-3 col-lg-6 col-sm-6">
                                            <label for="subject_id" class="form-label">Subject Code<span style="color: red">*</span></label>
                                            <select id="subject_id" ${loginUser.getRole_id()<3?"required=''":"disabled=''"} name="subject_id" class="form-control col border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}">
                                                <c:forEach items="${sessionScope.LIST_SUBJECT}" var="subject">
                                                    <c:choose>
                                                        <c:when test="${iter.getSubject_id()==subject.getSubject_id()}">
                                                            <option class="text-capitalize" value="${subject.getSubject_id()}" selected="">${subject.getSubject_code()}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option class="text-capitalize" value="${subject.getSubject_id()}">${subject.getSubject_code()}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="mb-3 col-lg-6 col-sm-6">
                                            <label for="title" class="form-label">Iteration Name<span style="color: red">*</span></label>
                                            <input type="text" ${loginUser.getRole_id()<3?"required=''":"disabled=''"} name="title" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${iter.iteration_name}">
                                        </div>
                                        <div class="mb-3 col-xl-4 col-md-3">
                                            <label for="duration" class="form-label">Iteration Duration<span style="color: red">*</span></label>
                                            <input type="text" pattern="\d*" ${loginUser.getRole_id()<3?"required=''":"disabled=''"} name="duration" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${iter.duration}">
                                        </div>
                                        <div class="mb-3 col-xl-2 col-md-3 d-flex flex-column justify-content-between">
                                            <label for="statusClassUser">Status</label>
                                            <div id="statusClassUser">
                                                <input ${loginUser.getRole_id()<3?"":"disabled=''"} onchange="changeStatus('status', 'Activate', 'Deactivate')" type="checkbox" class="btn-check" id="status" name="status" autocomplete="off" ${iter!=null&&iter.isStatus()?"checked":""}>
                                                <label class="btn btn-outline-primary" for="status">Active</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="mb-3 form-floating">
                                            <textarea class="form-control ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" ${loginUser.getRole_id()<3?"":"disabled=''"} placeholder="Iteration description" id="iterationDesctiption" name="description">${iter!=null?iter.getDescription():''}</textarea>
                                            <label for="iterationDesctiption">Iteration description</label>
                                        </div>
                                        <!--                                                                            <div class="mb-3 col">
                                                                                                                        <label for="display" class="form-label">Display Order</label>
                                                                                                                        <input type="text" pattern="\d*" ${loginUser.getRole_id()<3?"required=''":"disabled=''"} name="display" class="form-control" value="${setting.display_order}">
                                                                                                                    </div>-->
                                    </div>
                                    <div class="row">

                                    </div>

                                </div>
                                <c:if test="${loginUser.getRole_id()<3}">
                                    <div class="ms-auto">
                                        <input type="text" name="submit" hidden="" value="detail">
                                        <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset"></input>
                                        <button type="submit" name="service" value="${iter==null?'add':'update'}" class="btn btn-primary">Save changes</button>
                                    </div>
                                </c:if>
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