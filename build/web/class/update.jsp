<%-- 
    Document   : classList
    Created on : May 14, 2022, 3:47:40 PM
    Author     : nashd
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
    <c:set var="class" value="${requestScope.CLASS_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title class="">Class <c:if test="${class!=null}">(${class.getSubject().getSubject_code()}) ${class.class_code} (${class.getSetting().getSetting_title()}-${class.class_year})</c:if></title>
        </head>
        <body>
        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
        <c:if test="${loginUser == null}">
            <c:redirect url="home.jsp"></c:redirect>
        </c:if>
        <div class="nav-fixed">
            <jsp:include page="../included/header.jsp"/>
            <div id="layoutSidenav">
                <jsp:include page="../included/slider.jsp"/>
                <div id="layoutSidenav_content">
                    <main>
                        <form action="class" method="POST">
                            <div class="container-xl px-4 mt-5">
                                <div class="container-xl px-4">
                                    <div class="page-header-content pt-4">
                                        <div class="d-flex justify-content-between align-items-sm-center flex-column flex-sm-row mb-4">
                                            <div class="me-4 mb-3 mb-sm-0">
                                                <h1 class="mb-0 text-bold">Class <c:if test="${class!=null}">(${class.getSubject().getSubject_code()}) ${class.class_code} (${class.getSetting().getSetting_title()}-${class.class_year})</c:if></h1>
                                                    <div class="small" id="nowTime">
                                                    </div>
                                                </div>
                                            </div>
                                            <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                                <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                                    <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                                    <li class="breadcrumb-item"><a href="class"> Class List</a></li>
                                                    <c:if test="${class!=null}">
                                                    <li class="breadcrumb-item text-capitalize"><a href="class?type=${class.getSubject().getSubject_id()}">${class.getSubject().getSubject_code()}</a></li>
                                                    <li class="breadcrumb-item active"> (${class.getSubject().getSubject_code()}) ${class.class_code} (${class.getSetting().getSetting_title()}-${class.class_year})</li>
                                                    </c:if>
                                            </ol>
                                        </nav>
                                        <c:if test="${class!=null}">
                                            <div class="d-flex justify-content-between align-items-center mg-t-20">
                                                <a href="iteration?type=${class.getSubject().getSubject_id()}" class="btn btn-primary">View Iterations</a>
                                                <a href="milestone?class=${class.getClass_id()}" class="btn btn-primary">View Milestones</a>
                                                <a href="classUser?class=${class.getClass_id()}" class="btn btn-primary">View Class Users</a>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="card card-waves p-4 mb-4 mt-5">
                                    <div class="row">
                                        <div class="mb-3 col-xl-3 col-md-6">
                                            <label for="title" class="form-label">Class Code<span style="color: red">*</span></label>
                                            <input type="text" ${loginUser.getRole_id()<3?"required=''":"disabled=''"} name="classCode" class="form-control border-0 border-bottom bg-transparent" value="${class!=null?class.getClass_code():''}">
                                            <input type="text" hidden="" name="id" class="form-control" value="${class!=null?class.getClass_id():''}">
                                        </div>
                                        <div class="mb-3 col-lg-9 col-sm-6">
                                            <label for="teacher" class="form-label">Teacher<span style="color: red">*</span></label>
                                            <select id="teacher" ${loginUser.getRole_id()<3?"required=''":"disabled=''"} class="form-control  border-0 border-bottom bg-transparent" name="teacher">
                                                <c:forEach items="${sessionScope.LIST_TEACHER}" var="teacher">
                                                    <c:choose>
                                                        <c:when test="${class!=null&&teacher.getUser_id()==class.getTrainer().getUser_id()}">
                                                            <option class="text-capitalize" value="${teacher.getUser_id()}" selected="">${teacher.getFull_name()}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option class="text-capitalize" value="${teacher.getUser_id()}">${teacher.getFull_name()}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="subject" class="form-label">Subject<span style="color: red">*</span></label>
                                        <select id="subject" ${loginUser.getRole_id()<3?"required=''":"disabled=''"} class="form-control  border-0 border-bottom bg-transparent" name="subject">
                                            <c:forEach items="${sessionScope.LIST_SUBJECT}" var="subject">
                                                <c:choose>
                                                    <c:when test="${class!=null&&subject.getSubject_id()==class.getSubject().getSubject_id()}">
                                                        <option class="" selected="" value="${subject.getSubject_id()}">(${subject.getSubject_code()}) ${subject.getSubject_name()}</option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option class="" value="${subject.getSubject_id()}">(${subject.getSubject_code()}) ${subject.getSubject_name()}</option>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="row">
                                        <div class="mb-3 col-xl-4 col-md-6">
                                            <label for="year" class="form-label">Class Year<span style="color: red">*</span></label>
                                            <input type="text" pattern="\d*" ${loginUser.getRole_id()<3?"required=''":"disabled=''"} value="${class!=null?class.getClass_year():''}" name="year" id="year" class="form-control border-0 border-bottom bg-transparent">
                                        </div>
                                        <div class="mb-3 col-xl-8 col-md-12 ms-auto">
                                            <label for="gitlabUrl" class="form-label">GitLab URL</label>
                                            <input ${loginUser.getRole_id()<3?"":"disabled=''"} type="text" id="gitlabUrl" name="gitlabUrl" pattern="^(http(s):\/\/)?gitlab\.com[\w\-\._~:\/?#[\]@!\$&'\(\)\*\+,;=.]+$" title="Input must be GitLab URL" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${class.gitlab_url}" maxlength="255">
                                        </div>
                                        <div class="mb-3 col-xl-4 col-md-6">
                                            <label for="accessToken" class="form-label">Access Token<span style="color: red">*</span></label>
                                            <input ${loginUser.getRole_id()<3?"":"disabled=''"} id="accessToken" ${class.gitlab_url!=null&&class.gitlab_url!=""?"":"disabled=''"}  type="text" required="" id="accessToken" name="accessToken" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3||class.gitlab_url==null||class.gitlab_url==""?'bg-primary-soft':'bg-transparent'}" value="${class.apiToken}" maxlength="50">
                                        </div>
                                        <div class="mb-3 col-xl-4 col-md-12">
                                            <label for="sem" class="form-label">Semester<span style="color: red">*</span></label>
                                            <select id="sem" ${loginUser.getRole_id()<3?"required=''":"disabled=''"} class="form-control col border-0 border-bottom bg-transparent" name="sem">
                                                <c:forEach items="${requestScope.LIST_TERM}" var="sem">
                                                    <c:choose>
                                                        <c:when test="${class!=null&&class.getClass_term()==sem.getSetting_id()}">
                                                            <option class="" selected="" value="${sem.getSetting_id()}">${sem.getSetting_title()}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option class="" value="${sem.getSetting_id()}">${sem.getSetting_title()}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="mb-3 col-xl-2 col-md-6 d-flex flex-column justify-content-between">
                                            <label for="block5Changes">Block 5</label>
                                            <div id="block5Changes">
                                                <input onchange="changeStatus('block5', 'Block 5', 'Block 10')"${loginUser.getRole_id()<3?"":"disabled=''"} type="checkbox" class="btn-check" id="block5" name="block5" autocomplete="off" ${class!=null&&class.isBlock5_class()?"checked=''":""}>
                                                <label class="btn btn-outline-primary" for="block5">Block 5</label>
                                            </div>
                                        </div>
                                        <div class="mb-3 col-xl-2 col-md-6 d-flex flex-column justify-content-between">
                                            <label for="statusClassUser">Status</label>
                                            <div id="statusClassUser">
                                                <input ${loginUser.getRole_id()<3?"":"disabled=''"} onchange="changeStatus('status', 'Activate', 'Deactivate')" type="checkbox" class="btn-check" id="status" name="status" autocomplete="off" ${class!=null&&class.isStatus()?"checked":""}>
                                                <label class="btn btn-outline-primary" for="status">Active</label>
                                            </div>
                                        </div> 
                                    </div>
                                    <div class="form-floating">
                                        <textarea class="form-control bg-transparent" ${loginUser.getRole_id()<3?"":"disabled=''"} placeholder="Class description" id="classDescription" name="description">${class!=null?class.getDescription():''}</textarea>
                                        <label for="classDescription">Class description</label>
                                    </div>
                                </div>
                                <c:if test="${loginUser.getRole_id()<3}">
                                    <div class="ms-auto container-xl">
                                        <input type="hidden" name="submit" value="class">
                                        <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset"></input>
                                        <button type="submit" name="service" value="${class!=null?'update':'add'}" class="btn btn-primary">Save changes</button>
                                    </div>
                                </c:if>
                        </form>
                    </main>
                    <jsp:include page="../included/footer.jsp"/>
                </div>
            </div>
        </div>
        <script>
            $("#gitlabUrl").on("change", function () {
                if (this.value) {
                    document.getElementById("accessToken").disabled = false;
                    document.getElementById("accessToken").classList.remove('bg-primary-soft');
                } else {
                    document.getElementById("accessToken").disabled = true;
                    document.getElementById("accessToken").classList.add('bg-primary-soft');
                }
            });
            const weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
            document.querySelector('#nowTime').innerHTML = "<span class='fw-500 text-primary'>" + weekday[moment().weekday()] + "</span> &middot; " + moment().format('MMMM DD,YYYY · h:mm A');
        </script>
        <script src="js/scripts.js"></script>
    </body>
</html>