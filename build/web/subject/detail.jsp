<%-- 
    Document   : subjectChooseDetail
    Created on : May 17, 2022, 9:46:33 AM
    Author     : Admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
    <c:set var="subjectChoose" value="${requestScope.SUBJECT_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title>Subject Detail · ${subjectChoose==null?'Add':subjectChoose.getSubject_code()}</title>
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
                                            <h1 class="mb-0 text-bold">Subject Detail · ${subjectChoose==null?'Add':subjectChoose.getSubject_code()}</h1>
                                            <div class="small" id="nowTime">
                                            </div>
                                        </div>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="subject"> Subject List</a></li>
                                            <li class="breadcrumb-item active">${subjectChoose.getSubject_name()}</li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <form action="subject" method="POST">
                                <div class="card card-waves p-4 mb-4 mt-5">
                                    <div class="row align-items-end">
                                        <c:if test="${subjectChoose!=null}" >
                                            <div class="mb-3 col-xl-6 col-md-3">
                                                <label for="id" class="form-label">Subject ID</label>
                                                <input type="text" class="form-control border-0 border-bottom ${loginUser.getRole_id()>1?'bg-primary-soft':'bg-transparent'}" value="${subjectChoose.getSubject_id()}" disabled="">
                                                <input type="text" name="id" class="form-control" value="${subjectChoose!=null?subjectChoose.getSubject_id():''}" hidden="">
                                            </div>

                                        </c:if>

                                        <div class="mb-3 ${subjectChoose!=null?'col-xl-6 col-md-9':'col'}">
                                            <label for="code" class="form-label">Subject Code</label>
                                            <input type="text" ${loginUser.getRole_id()<2?"":"disabled=''"} name="code" required="" class="form-control border-0 border-bottom ${loginUser.getRole_id()>1?'bg-primary-soft':'bg-transparent'}" value="${subjectChoose!=null?subjectChoose.getSubject_code():''}" id="code" maxlength="10">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="name" class="form-label">Subject Name</label>
                                        <input type="text" required="" ${loginUser.getRole_id()<2?"":"disabled=''"} name="name" value="${subjectChoose!=null?subjectChoose.getSubject_name():''}" class="form-control border-0 border-bottom ${loginUser.getRole_id()>1?'bg-primary-soft':'bg-transparent'}" maxlength="255">
                                    </div>
                                    <div class="row">
                                        <div class="mb-3 col-xl-6 col-md-9">
                                            <label for="author" class="form-label">Author</label>
                                            <select id="author" ${loginUser.getRole_id()<2?"":"disabled=''"} class="form-select border-0 border-bottom ${loginUser.getRole_id()>1?'bg-primary-soft':'bg-transparent'}" name="author">
                                                <c:forEach items="${sessionScope.LIST_AUTHOR}" var="author">
                                                    <c:choose>
                                                        <c:when test="${subjectChoose!=null&&subjectChoose.getAuthor_id()==author.getUser_id()}">
                                                            <option class="text-capitalize" selected="" value="${author.getUser_id()}">${author.getFull_name()}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option class="text-capitalize" value="${author.getUser_id()}">${author.getFull_name()}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="mb-3 col-xl-6 col-md-3 d-flex flex-column justify-content-between">
                                            <label for="statusClassUser">Status</label>
                                            <div id="statusClassUser">
                                                <input ${loginUser.getRole_id()<2?"":"disabled=''"} onchange="changeStatus('status', 'Activate', 'Deactivate')" type="checkbox" class="btn-check" id="status" name="status" autocomplete="off" ${subjectChoose!=null&&subjectChoose.isStatus()?"checked":""}>
                                                <label class="btn btn-outline-primary" for="status">Active</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mb-3 form-floating">
                                        <textarea ${loginUser.getRole_id()<2?"":"disabled=''"} class="form-control ${loginUser.getRole_id()>1?'bg-primary-soft':'bg-transparent'}" placeholder="Subject description" id="subjectDescription" name="description">${subjectChoose!=null?subjectChoose.getDescription():''}</textarea>
                                        <label for="subjectDescription">Subject description</label>
                                    </div>
                                </div>
                                <c:if test="${loginUser.getRole_id()<2}">
                                    <div class="ms-auto">
                                        <input type="text" name="submit" class="form-control" value="add" hidden="">
                                        <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset">
                                        <button type="submit" name="service" value="${subjectChoose!=null?'update':'add'}" class="btn btn-primary">Save changes</button>
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
            const weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
            document.querySelector('#nowTime').innerHTML = "<span class='fw-500 text-primary'>" + weekday[moment().weekday()] + "</span> &middot; " + moment().format('MMMM DD,YYYY · h:mm A');
        </script>
        <script src="js/scripts.js"></script>
    </body>
</html>