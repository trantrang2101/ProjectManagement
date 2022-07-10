<%-- 
    Document   : teamDetail
    Created on : Jun 8, 2022, 11:05:08 PM
    Author     : Admin
--%>
<%@page import="Model.Entity.Team"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
    <c:set var="team" value="${requestScope.TEAM_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title class="">Team Detail · ${team==null?'Add':String.valueOf(team.classroom.class_id).concat(" · ").concat(team.getClassroom().getClass_code())}</title>
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
                        <div class="container-xl px-4 mt-5">
                            <div class="container-xl px-4">
                                <div class="page-header-content pt-4">
                                    <div class="d-flex justify-content-between align-items-sm-center flex-column flex-sm-row mb-4">
                                        <div class="me-4 mb-3 mb-sm-0">
                                            <h1 class="mb-0 text-bold">Team Detail · ${team==null?'Add':String.valueOf(team.classroom.class_id).concat(" · ").concat(team.getClassroom().getClass_code())}</h1>
                                            <div class="small" id="nowTime">
                                            </div>
                                        </div>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="team"> Team List</a></li>
                                            <li class="breadcrumb-item text-capitalize"><a href="team?classroom=${team.getClassroom().getClass_id()}">${team.getClassroom().getClass_code()}</a></li>
                                            <li class="breadcrumb-item active">${team.team_name}</li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <form action="team" method="POST">
                                <div class="card card-waves p-4 mb-4 mt-5">
                                    <div class="row align-items-end">
                                        <div class="mb-3 col-xl-4 col-md-6">
                                            <label for="id" class="form-label">Team ID</label>
                                            <input type="text" class="form-control border-0 border-bottom bg-transparent" value="${team.team_id}" disabled="">
                                            <input type="text" name="id" class="form-control" value="${team.team_id}" hidden="">
                                        </div>
                                        <div class="mb-3 col-xl-4 col-md-6">
                                            <label for="classId" class="form-label border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}">Class</label>
                                            <%
                                                Team t = (Team) request.getAttribute("TEAM_CHOOSE");
                                                if (t != null) {
                                            %>
                                            <input type="text" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${team.getClassroom().getClass_code()}" disabled="">
                                            <input type="text" name="classId" class="form-control" value="${team.getClass_id()}" hidden="">
                                            <%
                                            } else {
                                            %>
                                            <select ${loginUser.getRole_id()<3?"":"disabled=''"} name="classId" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" id="classId">
                                                <c:forEach items="${sessionScope.LIST_CLASS}" var="classroom">
                                                    <c:choose>
                                                        <c:when test="${classroom.getClass_id()==team.getClassroom().getClass_id()}">
                                                            <option selected="" value="${classroom.getClass_id()}">${classroom.getClass_code()}</option>
                                                        </c:when>                                
                                                        <c:otherwise>
                                                            <option value="${classroom.getClass_id()}">${classroom.getClass_code()}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                            <%
                                                }
                                            %>
                                        </div>
                                        <div class="mb-3 col-xl-4 col-md-6">
                                            <label for="teamName" class="form-label">Team Name</label>
                                            <input ${loginUser.getRole_id()<3?"":"disabled=''"} type="text" required="" name="teamName" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${team.team_name}" maxlength="50">
                                        </div>
                                        <div class="mb-3 col-xl-4 col-md-6">
                                            <label for="topicCode" class="form-label">Topic Code</label>
                                            <input ${loginUser.getRole_id()<3?"":"disabled=''"} type="text" required="" name="topicCode" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${team.topic_code}" maxlength="10">
                                        </div>
                                        <div class="mb-3 col-xl-8 col-md-6">
                                            <label for="topicName" class="form-label">Topic Name</label>
                                            <input ${loginUser.getRole_id()<3?"":"disabled=''"} type="text" required="" name="topicName" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${team.topic_name}" maxlength="50">
                                        </div>
                                    </div>
                                    <div class="row row-md-reverse">
                                        <div class="mb-3 col-xl-4 col-md-12 ms-auto">
                                            <label for="gitlabUrl" class="form-label">GitLab URL</label>
                                            <input ${loginUser.getRole_id()<3?"":"disabled=''"} type="text" id="gitlabUrl" name="gitlabUrl" pattern="^(http(s):\/\/)?gitlab\.com[\w\-\._~:\/?#[\]@!\$&'\(\)\*\+,;=.]+$" title="Input must be GitLab URL" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${team.gitlab_url}" maxlength="255">
                                        </div>
                                        <div class="mb-3 col-xl-4 col-md-6">
                                            <label for="accessToken" class="form-label">Access Token</label>
                                            <input ${loginUser.getRole_id()<3?"":"disabled=''"} id="accessToken" ${team.gitlab_url!=null&&team.gitlab_url!=""?"":"disabled=''"}  type="text" required="" id="accessToken" name="accessToken" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3||team.gitlab_url==null||team.gitlab_url==""?'bg-primary-soft':'bg-transparent'}" value="${team.apiToken}" maxlength="50">
                                        </div>
                                        <div class="mb-3 col-xl-4 col-md-6 d-flex flex-column justify-content-between h-100">
                                            <label for="statusClassUser">Status</label>
                                            <div id="statusClassUser">
                                                <input ${loginUser.getRole_id()<3?"":"disabled=''"} onchange="changeStatus('status', 'Activate', 'Deactivate')" type="checkbox" class="btn-check" id="status" name="status" autocomplete="off" ${team!=null&&team.isStatus()?"checked":""}>
                                                <label class="btn btn-outline-primary" for="status">Active</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="ms-auto">
                                    <input type="text" hidden="" name="submit" value="add">
                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                                    <button type="submit" name="service" value="${team==null?'add':'update'}" class="btn btn-primary">Save changes</button>
                                </div>
                            </form>
                        </div>
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