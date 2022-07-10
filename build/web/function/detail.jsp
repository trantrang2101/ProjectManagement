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
    <c:set var="function" value="${requestScope.FUNCTION_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title class="">FUNCTION · Function Detail · ${function==null?'Add New Function':function.function_name} ${function==null?'':function.team_id}</title>
    </head>
    <body>
        <div class="nav-fixed">
            <jsp:include page="../included/header.jsp"/>
            <div id="layoutSidenav">
                <c:if test="${sessionScope.LOGIN_USER.getRole_id()<=4}">
                    <jsp:include page="../included/slider.jsp"/>
                </c:if>
                <div id="layoutSidenav_content">
                    <main>
                        <div class="container-xl px-4 mt-5">
                            <div class="container-xl px-4">
                                <div class="page-header-content pt-4">
                                    <div class="d-flex justify-content-between align-items-sm-center flex-column flex-sm-row mb-4">
                                        <div class="me-4 mb-3 mb-sm-0">
                                            <h1 class="mb-0 text-bold">Function Detail · ${function==null?'Add New Function':function.function_name} ${function==null?'':'from Group '.concat(function.getTeam().team_name).concat(" - ").concat(function.getTeam().getClassroom().getSubject().getSubject_code()).concat("_").concat(function.getTeam().getClassroom().class_code)}</h1>
                                            <div class="small" id="nowTime">
                                            </div>
                                        </div>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="function"> Function List</a></li>
                                                <c:choose>
                                                    <c:when test="${function==null}">
                                                    <li class="breadcrumb-item active">Add New Function</li>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <li class="breadcrumb-item active">${function.function_name}</li>
                                                    </c:otherwise>
                                                </c:choose>

                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <div class="card card-waves p-4 mb-4 mt-5">

                                <div class="row align-items-end">
                                    <div class="mb-3 col-sm-2 col-lg-4">
                                        <label for="id" class="form-label">Function ID</label>
                                        <input type="text" class="form-control border-0 border-bottom bg-transparent" value="${function.function_id}" disabled="">
                                    </div>
                                    <div class="mb-3 col-sm-5 col-lg-4">
                                        <form action="function" method="POST">
                                            <label for="class_code" class="form-label">Class Code</label>
                                            <c:choose>
                                                <c:when test="${serve=='update'}">
                                                    <input type="text" class="form-control border-0 border-bottom bg-transparent" value="${function.getTeam().getClassroom().getSubject().getSubject_code()}_${function.getTeam().getClassroom().class_code}" disabled="">
                                                </c:when>
                                                <c:otherwise>
                                                    <select id="class_code" name="class" onchange="this.form.submit();" class="form-control col border-0 border-bottom bg-transparent">
                                                        <c:forEach items="${sessionScope.LIST_CLASS}" var="class">
                                                            <c:choose>
                                                                <c:when test="${(function!=null&&function.getTeam().class_id==class.class_id)||(requestScope.CLASS_CHOOSE!=null&&requestScope.CLASS_CHOOSE.class_id==class.class_id)}">
                                                                    <option class="text-capitalize" value="${class.class_id}" selected="">${class.getSubject().getSubject_code()}_${class.class_code}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${class.class_id}">${class.getSubject().getSubject_code()}_${class.class_code}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>

                                                </c:otherwise>
                                            </c:choose>
                                            <input type="hidden" name="service"value="add">
                                            <input type="text" name="submitForm" hidden="" value="class">
                                        </form>
                                    </div>
                                    <div class="mb-3 col-sm-5 col-lg-4">
                                        <form action="function" method="POST">
                                            <label for="subject_id" class="form-label">Team</label>
                                            <c:choose>
                                                <c:when test="${serve=='update'}">
                                                    <input name="type" type="text" class="form-control border-0 border-bottom bg-transparent" value="${function.getTeam().team_name} - ${function.getTeam().getClassroom().getClass_code()}" disabled="">
                                                </c:when>
                                                <c:otherwise>
                                                    <select id="subject_id" name="type"  onchange="this.form.submit();" class="form-control col border-0 border-bottom bg-transparent">
                                                        <c:forEach items="${requestScope.LIST_TEAM}" var="team">
                                                            <c:choose>

                                                                <c:when test="${(function!=null&&function.team_id==team.team_id)||(requestScope.TYPE_CHOOSE!=null&&requestScope.TYPE_CHOOSE.team_id==team.team_id)}">
                                                                    <option class="text-capitalize" value="${team.team_id}" selected="">${team.team_name} - ${team.getClassroom().getClass_code()}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${team.team_id}">${team.team_name} - ${team.getClassroom().getClass_code()}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>

                                                </c:otherwise>
                                            </c:choose>
                                            <input type="hidden" name="service"value="add">
                                            <input type="text" name="submitForm" hidden="" value="type">
                                        </form>
                                    </div>
                                    <form action="function" method="POST">
                                        <div class="row">

                                            <div class="mb-3 col-sm-5 col-lg-4">

                                                <label for="feature_id" class="form-label">Feature</label>

                                                <select ${isDisabled?"disabled=''":""} id="feature_id" name="feature_id" class="form-control col border-0 border-bottom bg-transparent">
                                                    <c:choose>
                                                        <c:when test="${requestScope.LIST_FEATURE==null||requestScope.LIST_FEATURE.size()==0}">
                                                            <option class="text-capitalize" value=null selected="">No Feature Yet</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach items="${requestScope.LIST_FEATURE}" var="feature">

                                                                <c:choose>
                                                                    <c:when test="${function.getFeature().feature_id==feature.feature_id}">
                                                                        <option class="text-capitalize" value="${feature.feature_id}" selected="">${feature.feature_name}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option class="text-capitalize" value="${feature.feature_id}">${feature.feature_name}</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </select>


                                            </div>

                                            <c:choose>
                                                <c:when test="${loginUser.getRole_id()>3}">
                                                    <div class="mb-9 col-sm-7 col-lg-8">
                                                        <a href="feature?service=add&type=${requestScope.TYPE_CHOOSE.team_id}"><button type="button" class="btn btn-primary">Create New Feature</button></a>
                                                    </div> 
                                                </c:when>
                                            </c:choose>

                                        </div>
                                </div>

                                <div class="row">
                                    <div class="mb-3 col-sm-7 col-lg-8">
                                        <input type="text" name="id" class="form-control" value="${function.function_id}" hidden="">
                                        <input type="text" name="type" class="form-control" value="${function!=null?function.team_id:requestScope.TYPE_CHOOSE.team_id}" hidden="">
                                        <label for="title" class="form-label">Function Name</label>
                                        <input type="text" required='' ${isDisabled?"disabled=''":""} name="title" class="form-control border-0 border-bottom bg-transparent" value="${function.function_name}">
                                    </div>
                                    <div class="mb-3 d-flex flex-column justify-content-start align-items-end form-check form-switch  col-sm-5 col-lg-4">
                                        <label class="small mb-1" for="status">Status</label>
                                        <select ${isDisabled?"disabled=''":""} id="status" name="status" class="form-control col border-0 border-bottom bg-transparent">
                                            <c:forEach items="${sessionScope.LIST_FUNCTION_STATUS}" var="status">
                                                <c:choose>
                                                    <c:when test="${(function!=null&&function.isStatus()==status.setting_value)}">

                                                        <option class="text-capitalize" value="${status.setting_value}" selected="">${status.setting_title}</option>

                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:choose>
                                                            <c:when test="${function!=null}">
                                                                <c:if test="${status.getSetting_value()>function.getFunctionStatus().setting_value}">
                                                                    <option class="text-capitalize" value="${status.setting_value}">${status.setting_title}</option>
                                                                </c:if>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option class="text-capitalize" value="${status.setting_value}">${status.setting_title}</option>

                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>





                                <div class="mb-3 d-flex flex-column justify-content-between align-items-start">

                                    <label for="title" class="form-label">Access Roles</label>
                                    <input type="text" ${isDisabled?"disabled=''":""} name="access_roles" class="form-control border-0 border-bottom bg-transparent" value="${function.access_roles}">
                                </div>

                                <div class="row align-items-start">
                                    <div class=" d-flex flex-column justify-content-end form-check form-switch  col-sm-4 col-lg-4">
                                        <label for="complexity_id" class="form-label">Complexity</label>

                                        <select ${isDisabled?"disabled=''":""} id="complexity_id" name="complexity_id" class="form-control col border-0 border-bottom bg-transparent">
                                            <c:forEach items="${requestScope.COMPLEXITY_LIST}" var="complexity">
                                                <c:choose>
                                                    <c:when test="${(function!=null&&function.complexity_id==complexity.setting_value)}">
                                                        <option class="text-capitalize" value="${complexity.setting_value}" selected="">${complexity.setting_title}</option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option class="text-capitalize" value="${complexity.setting_value}">${complexity.setting_title}</option>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </select>

                                    </div>
                                    <div class="d-flex flex-column justify-content-end  form-check form-switch  col-sm-4 col-lg-4">
                                        <label for="owner_id" class="form-label">Owner</label>
                                        <c:choose>
                                            <c:when test="${isLeader}">
                                                <select ${isDisabled?"disabled=''":""} id="owner_id" name="owner_id" class="form-control col border-0 border-bottom bg-transparent">
                                                    <c:forEach items="${requestScope.LIST_CLASS_USER}" var="user">
                                                        <c:choose>
                                                            <c:when test="${(function!=null&&function.owner_id==user.user_id)}">
                                                                <option ${!user.isStatus()?"disabled=''":""} class="text-capitalize" value="${user.user_id}" selected="">${user.getUser().full_name}</option>

                                                            </c:when>
                                                            <c:otherwise>
                                                                <option ${!user.isStatus()?"disabled=''":""} class="text-capitalize" value="${user.user_id}">${user.getUser().full_name}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </select>  
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${serve=='update'}">
                                                        <select ${loginUser.getUser_id()==function.owner_id?"":"disabled=''"} id="owner_id" name="owner_id" class="form-control col border-0 border-bottom bg-transparent">
                                                            <c:forEach items="${requestScope.LIST_CLASS_USER}" var="user">
                                                                <c:choose>
                                                                    <c:when test="${(function!=null&&function.owner_id==user.user_id)}">
                                                                        <option ${!user.isStatus()?"disabled=''":""} class="text-capitalize" value="${user.user_id}" selected="">${user.getUser().full_name}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option ${!user.isStatus()?"disabled=''":""} class="text-capitalize" value="${user.user_id}">${user.getUser().full_name}</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </select>  
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input disabled='' type="text" required='' name="owner_id" class="form-control border-0 border-bottom bg-transparent" value="${loginUser.getFull_name()}">
                                                        <input hidden='' type="text" required='' name="owner_id" class="form-control border-0 border-bottom bg-transparent" value="${loginUser.getUser_id()}">
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>

                                    </div>
                                    <div class=" d-flex flex-column justify-content-end  form-check form-switch  col-sm-4 col-lg-4">
                                        <label class="form-check-label" for="priority">Priority</label>
                                        <input ${isDisabled?"disabled=''":""} type="number" required='' name="priority" class="form-control border-0 border-bottom bg-transparent" value="${function.priority}">
                                    </div>
                                </div>
                                <div class="mb-3 form-floating">
                                    <textarea ${isDisabled?"disabled=''":""}s class="form-control" placeholder="Function description" id="functionDesctiption" name="description">${function!=null?function.getDescription():''}</textarea>
                                    <label for="functionDesctiption">Function description</label>
                                </div>
                                <c:choose>
                                    <c:when test="${loginUser.getRole_id()>3}">
                                        <div class="ms-auto">
                                            <input type="text" name="submitForm" hidden="" value="detail">
                                            <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset"></input>
                                            <button type="submit" name="service" value="${function==null?'add':'update'}" class="btn btn-primary">Save changes</button>
                                        </div>
                                    </c:when>
                                </c:choose>


                                </form>
                            </div>

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