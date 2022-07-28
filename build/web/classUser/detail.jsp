<%-- 
    Document   : settingDetail
    Created on : May 17, 2022, 9:46:33 AM
    Author     : Admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"/>
    <c:set var="classUserChoose" value="${requestScope.CLASS_USER_CHOOSE}"/>
    <c:set var="classChoose" value="${requestScope.CLASS_CHOOSE}"/>
    <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title>Class User Detail · ${classUserChoose==null?'Add':(classChoose.getSubject().getSubject_code().concat(' - ').concat(classChoose.getClass_code()).concat(' - ').concat(classUserChoose.getUser().getFull_name()))}</title>
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
                                            <h1 class="mb-0 text-bold">Class User Detail · ${classUserChoose==null?'Add':(classChoose.getSubject().getSubject_code().concat(' - ').concat(classChoose.getClass_code()).concat(' - ').concat(classUserChoose.getUser().getFull_name()))}</h1>
                                            <div class="small" id="nowTime">
                                            </div>
                                        </div>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="class"> Class List</a></li>
                                            <li class="breadcrumb-item text-capitalize"><a href="class?type=${classChoose.getSubject().getSubject_id()}">${classChoose.getSubject().getSubject_code()}</a></li>
                                            <li class="breadcrumb-item text-capitalize"><a href="class?id=${classChoose.getClass_id()}&service=${loginUser.getRole_id()>3?'detail':'update'}"> (${classChoose.getSubject().getSubject_code()}) ${classChoose.class_code} (${classChoose.getSetting().getSetting_title()}-${classChoose.class_year})</a></li>
                                            <li class="breadcrumb-item text-capitalize"><a href="classUser?class=${classChoose.getClass_id()}"> Class User ${classChoose.isBlock5_class()?"<span class='badge bg-red-soft text-red'>Block 5</span>  -  ":""}</a></li>
                                            <li class="breadcrumb-item active">${classUserChoose.getUser().getFull_name()}</li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <form action="classUser" method="POST">
                                <div class="card card-waves p-4 mb-4 mt-5">
                                    <div class="row align-items-end">
                                        <div class="mb-3 col-xl-6 col-md-9">
                                            <label for="class" class="form-label">Class</label>
                                            <c:choose>
                                                <c:when test="${requestScope.LIST_CLASS!=null}">
                                                    <div class="dropdown w-100">
                                                        <button class="form-select text-capitalize border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'} d-flex align-items-start" id="class" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                            (${classChoose.getSubject().getSubject_code()}) ${classChoose.class_code} (${classChoose.getSetting().getSetting_title()}-${classChoose.class_year})
                                                        </button>
                                                        <div class="dropdown-menu w-100" aria-labelledby="class">
                                                            <c:forEach items="${sessionScope.LIST_CLASS}" var="classChoose">
                                                                <a class="dropdown-item text-capitalize w-100" href="classUser?class=${classChoose.class_id}&service=add">(${classChoose.getSubject().getSubject_code()}) ${classChoose.class_code} (${classChoose.getSetting().getSetting_title()}-${classChoose.class_year})</a>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="text" name="class" disabled="" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${classUserChoose!=null?(classChoose.getSubject().getSubject_code().concat(' - ').concat(classChoose.getClass_code())):''}" id="code" maxlength="10">
                                                    <input type="text" name="class" hidden="" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${classChoose.getClass_id()}" id="code" maxlength="10">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <c:choose>
                                            <c:when test="${requestScope.LIST_TEAM==null}">
                                                <h5>There is no team in this class!</h5>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="mb-3 col-xl-6 col-md-3">
                                                    <label for="team" class="form-label">Team</label>
                                                    <select ${loginUser.getRole_id()<4?"":"disabled=''"} id="team" class="form-select border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" name="team">
                                                        <c:forEach items="${requestScope.LIST_TEAM}" var="team">
                                                            <c:choose>
                                                                <c:when test="${classUserChoose!=null&&classUserChoose.getTeam_id()==team.getTeam_id()}">
                                                                    <option class="text-capitalize" selected="" value="${team.getTeam_id()}">${team.getTeam_name()}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${team.getTeam_id()}">${team.getTeam_name()}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="row align-items-end">
                                                <div class="mb-3 col-xl-12 col-md-12">
                                                    <label for="id" class="form-label">User email<span style="color: red">*</span></label>
                                                    <input type="email" name="email" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" ${classUserChoose!=null?'disabled=""':'data-val="true" pattern="[a-z0-9._%+-]+@(fpt|fu).edu.vn$" data-val-pattern="You must input fpt education email" data-val-required="Email is required" title="You must input fpt education email" maxlength="40"'} value="${classUserChoose.getUser().getEmail()}">
                                                    <input type="text" name="user" class="form-control" value="${classUserChoose!=null?classUserChoose.getUser_id():''}" hidden="">
                                                </div>
                                            </div>
                                            <div class="row align-items-end">
                                                <div class="mb-3 col-xl-6 col-md-3">
                                                    <label for="id" class="form-label">Roll number</label>
                                                    <input type="text" ${loginUser.getRole_id()<4?"":"disabled=''"} name="rollNum" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" ${classUserChoose!=null?'disabled=""':''} value="${classUserChoose.getUser().getRoll_number()}">
                                                </div>
                                                <div class="mb-3 col-xl-6 col-md-6">
                                                    <label for="id" class="form-label">Full name</label>
                                                    <input type="text" ${loginUser.getRole_id()<4?"":"disabled=''"} name="fullName" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" ${classUserChoose!=null?'disabled=""':''} value="${classUserChoose.getUser().getFull_name()}">
                                                </div>
                                                <div class="mb-3 col-xl-6 col-md-3">
                                                    <label class="form-label" for="dropout">Dropout Date</label>
                                                    <input type="date" ${loginUser.getRole_id()<4?"":"disabled=''"} name="dropoutDate" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" id="dropout">
                                                    <input type="text" hidden="" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" id="dropoutDateData" value="${classUserChoose.getDropout_date()}">
                                                </div>
                                                <div class="mb-3 col-xl-3 col-md-3 d-flex flex-column justify-content-between">
                                                    <label for="leaderClassUser">Leader/Member</label>
                                                    <div id="leaderClassUser">
                                                        <input ${loginUser.getRole_id()<4?"":"disabled=''"} onchange="changeStatus('leader', 'Leader', 'Member')" type="checkbox" class="btn-check" id="leader" name="leader" autocomplete="off" ${classUserChoose!=null&&classUserChoose.isTeam_leader()?"checked":""}>
                                                        <label class="btn btn-outline-primary" for="leader">Leader</label>
                                                    </div>
                                                </div>
                                                <div class="mb-3 col-xl-3 col-md-3 d-flex flex-column justify-content-between">
                                                    <label for="statusClassUser">Status</label>
                                                    <div id="statusClassUser">
                                                        <input ${loginUser.getRole_id()<4?"":"disabled=''"} onchange="changeStatus('status', 'Activate', 'Deactivate')" type="checkbox" class="btn-check" id="status" name="status" autocomplete="off" ${classUserChoose!=null&&classUserChoose.isStatus()?"checked":""}>
                                                        <label class="btn btn-outline-primary" for="status">Active</label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="mb-3 form-floating">
                                                <textarea ${loginUser.getRole_id()<4?"":"disabled=''"} class="form-control ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" placeholder="User Note" id="userNote" name="note">${classUserChoose!=null?classUserChoose.getUser_notes():''}</textarea>
                                                <label for="userNote">User Note</label>
                                            </div>
                                            <div ${loginUser.getRole_id()<4?"":"hidden=''"} class="ms-auto">
                                                <input type="text" name="submitForm" class="form-control" value="add" hidden="">
                                                <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset"></input>
                                                <button type="submit" name="service" value="${classUserChoose!=null?'update':'add'}" class="btn btn-primary">Save changes</button>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </form>
                        </div>
                    </main>
                    <jsp:include page="../included/footer.jsp"/>
                </div>
            </div>
        </div>
        <script>
            var bir = document.querySelector('#dropoutDateData');
            if (bir != null && bir.value != '') {
                var day = bir.value.split(' ')[0].split('-');
                var time = bir.value.split(' ')[1].split(':');
                document.querySelector('#dropout').value = moment(new Date(day[0], day[1] - 1, day[2])).format('YYYY-MM-DD');
                document.querySelector('#dropout').max = new Date().toISOString().split("T")[0];
            }
        </script>
        <script src="js/scripts.js"></script>
    </body>
</html>