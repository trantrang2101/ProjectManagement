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
    <c:set var="setting" value="${requestScope.SUBJECT_SETTING_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title class="">Subject Setting Detail · ${setting==null?'Add':setting.type.setting_title.concat(" · ").concat(setting.getSubject().getSubject_code())}</title>
    </head>
    <body>
        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
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
                                            <h1 class="mb-0 text-bold">Subject Setting Detail · ${setting==null?'Add':setting.type.setting_title.concat(" · ").concat(setting.getSubject().getSubject_code())}</h1>
                                            <div class="small" id="nowTime">
                                            </div>
                                        </div>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="subjectSetting"> Subject Setting List</a></li>
                                            <li class="breadcrumb-item text-capitalize"><a href="subjectSetting?type=${setting.getSubject().getSubject_id()}">${setting.getSubject().getSubject_code()}</a></li>
                                            <li class="breadcrumb-item active">${setting.setting_title}</li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <form action="subjectSetting" method="POST">
                                <div class="card card-waves p-4 mb-4 mt-5">
                                    <div class="row align-items-end">
                                        <input type="text" name="id" class="form-control" value="${setting.setting_id}" hidden="">
                                        <div class="mb-3 col">
                                            <label for="subject_id" class="form-label border-0 border-bottom">Subject ID</label>
                                            <select ${loginUser.getRole_id()<3?"":"disabled=''"} name="subjectId" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" id="subjectId">
                                                <c:forEach items="${sessionScope.LIST_SUBJECT}" var="subject">
                                                    <c:choose>
                                                        <c:when test="${subject.getSubject_id()==setting.getSubject().getSubject_id()}">
                                                            <option selected="" value="${subject.getSubject_id()}">${subject.getSubject_code()}</option>
                                                        </c:when>                                
                                                        <c:otherwise>
                                                            <option value="${subject.getSubject_id()}">${subject.getSubject_code()}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="mb-3 col">
                                            <label for="typeID" class="form-label">Type</label>
                                            <select id="typeID" ${loginUser.getRole_id()<3?"":"disabled=''"} class="form-control col border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" name="typeID">
                                                <c:forEach items="${sessionScope.SETTING_LIST_SUBJECT}" var="type">
                                                    <c:choose>
                                                        <c:when test="${setting.getType().getSetting_id()==type.getSetting_id()}">
                                                            <option class="text-capitalize" selected="" value="${type.getSetting_id()}">${type.getSetting_title()}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option class="text-capitalize" value="${type.getSetting_id()}">${type.getSetting_title()}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="mb-3 col-xl-9 col-md-6">
                                            <label for="title" class="form-label">Subject Setting Title<span style="color: red">*</span></label>
                                            <input type="text" ${loginUser.getRole_id()<3?"":"disabled=''"} required="" name="title" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${setting.setting_title}">
                                        </div>
                                        <div class="mb-3 col-xl-3 col-md-6 d-flex flex-column justify-content-between">
                                            <label for="statusClassUser">Status</label>
                                            <div id="statusClassUser">
                                                <input ${loginUser.getRole_id()<3?"":"disabled=''"} onchange="changeStatus('status', 'Activate', 'Deactivate')" type="checkbox" class="btn-check" id="status" name="status" autocomplete="off" ${setting!=null&&setting.isStatus()?"checked":""}>
                                                <label class="btn btn-outline-primary" for="status">Active</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="mb-3 col">
                                            <label for="value" class="form-label">Setting Value<span style="color: red">*</span></label>
                                            <input type="text" ${loginUser.getRole_id()<3?"":"disabled=''"} pattern="\d*" required="" name="value" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${setting.setting_value}">
                                        </div>
                                        <div class="mb-3 col">
                                            <label for="display" class="form-label">Display Order<span style="color: red">*</span></label>
                                            <input type="text" ${loginUser.getRole_id()<3?"":"disabled=''"} pattern="\d*" required="" name="display" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${setting.display_order}">
                                        </div>
                                        <div class="mb-3 form-floating">
                                            <textarea class="form-control ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" ${loginUser.getRole_id()<3?"":"disabled=''"} placeholder="Subject Setting description" id="subjectSettingDescription" name="description">${setting!=null?setting.getDescription():''}</textarea>
                                            <label for="subjectSettingDescription">Subject Setting description</label>
                                        </div>
                                    </div>
                                </div>
                                <c:if test="${loginUser.getRole_id()<3}">
                                    <div class="ms-auto">
                                        <input type="text" name="submit" class="form-control" value="add" hidden="">
                                        <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset"></input>
                                        <button type="submit" name="service" value="${setting!=null?'update':'add'}" class="btn btn-primary">Save changes</button>
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