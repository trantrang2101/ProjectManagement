<%-- 
    Document   : settingDetail
    Created on : May 17, 2022, 9:46:33 AM
    Author     : Admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
    <c:set var="setting" value="${requestScope.SETTING_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title>Setting Detail · ${setting.setting_title}</title>
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
                                            <h1 class="mb-0 text-bold text-capitalize">Setting Detail · <c:if test="${setting!=null}">${setting.setting_title} (${sessionScope.LIST_SETTING_TYPE.get(setting.getType_id())})</c:if></h1>
                                                <div class="small" id="nowTime">
                                                </div>
                                            </div>
                                        </div>
                                        <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                            <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                                <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                                <li class="breadcrumb-item"><a href="setting"> Setting List</a></li>
                                                <li class="breadcrumb-item text-capitalize"><a href="setting?type=${setting.getType_id()}"> ${sessionScope.LIST_SETTING_TYPE.get(setting.getType_id())}</a></li>
                                            <li class="breadcrumb-item active">${setting.setting_title}</li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <form action="setting" method="POST">
                                <div class="card card-waves p-4 mb-4 mt-5">
                                    <div class="row align-items-end">
                                        <input type="text" name="id" class="form-control" value="${setting!=null?setting.setting_id:''}" hidden="">
                                        <div class="mb-3 col-6">
                                            <label for="typeIDDetail" class="form-label">Type</label>
                                            <select ${loginUser.getRole_id()<2?"":"disabled=''"} id="typeIDDetail" class="form-control col border-0 border-bottom ${loginUser.getRole_id()>1?'bg-primary-soft':'bg-transparent'}" name="typeID">
                                                <c:forEach items="${sessionScope.LIST_SETTING_TYPE}" var="type">
                                                    <c:choose>
                                                        <c:when test="${setting!=null&&setting.type_id.equals(type.key)}">
                                                            <option class="text-capitalize" value="${type.key}" selected="">${type.value}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option class="text-capitalize" value="${type.key}">${type.value}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="mb-3 col-xl-6 col-md-6">
                                            <label for="title" class="form-label">Setting Title</label>
                                            <input type="text" name="title" ${loginUser.getRole_id()<2?"":"disabled=''"} class="form-control border-0 border-bottom ${loginUser.getRole_id()>1?'bg-primary-soft':'bg-transparent'}" value="${setting!=null?setting.setting_title:''}">
                                        </div>
                                        <div class="mb-3 col-xl-6 col-md-6 d-flex flex-column justify-content-between">
                                            <label for="statusClassUser">Status</label>
                                            <div id="statusClassUser">
                                                <input ${loginUser.getRole_id()<2?"":"disabled=''"} onchange="changeStatus('status', 'Activate', 'Deactivate')" type="checkbox" class="btn-check" id="status" name="status" autocomplete="off" ${setting!=null&&setting.isStatus()?"checked":""}>
                                                <label class="btn btn-outline-primary" for="status">Active</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="mb-3 col">
                                            <label for="value" class="form-label">Setting Value</label>
                                            <input type="text" ${loginUser.getRole_id()<2?"":"disabled=''"} pattern="\d*" name="value" class="form-control border-0 border-bottom ${loginUser.getRole_id()>1?'bg-primary-soft':'bg-transparent'}" value="${setting!=null?setting.setting_value:''}">
                                        </div>
                                        <div class="mb-3 col">
                                            <label for="display" class="form-label">Display Order</label>
                                            <input type="text" ${loginUser.getRole_id()<2?"":"disabled=''"} pattern="\d*" name="display" class="form-control border-0 border-bottom ${loginUser.getRole_id()>1?'bg-primary-soft':'bg-transparent'}" value="${setting!=null?setting.display_order:''}">
                                        </div>
                                    </div>
                                    <div class="mb-3 form-floating">
                                        <textarea class="form-control ${loginUser.getRole_id()>1?'bg-primary-soft':'bg-transparent'}" ${loginUser.getRole_id()<2?"":"disabled=''"} placeholder="Setting description" id="settingDescription" name="description">${setting!=null?setting.getDescription():''}</textarea>
                                        <label for="settingDescription">Setting description</label>
                                    </div>
                                </div>
                                <c:if test="${loginUser.getRole_id()<2}">
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
            const weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
            document.querySelector('#nowTime').innerHTML = "<span class='fw-500 text-primary'>" + weekday[moment().weekday()] + "</span> &middot; " + moment().format('MMMM DD,YYYY · h:mm A');
        </script>
        <script src="js/scripts.js"></script>
    </body>
</html>