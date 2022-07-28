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
    <c:set var="trackingChoose" value="${requestScope.TRACKING_CHOOSE}"></c:set>
    <c:set var="classChoose" value="${sessionScope.CLASS_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title>Tracking Detail · ${trackingChoose!=null?trackingChoose.getFunction().getFunction_name().concat("_").concat(trackingChoose.getAssignee().getFull_name()):"Add"}</title>
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
                                            <h1 class="mb-0 text-bold">Tracking Detail · ${trackingChoose!=null?trackingChoose.getFunction().getFunction_name().concat("_").concat(trackingChoose.getAssignee().getFull_name()):"Add"}</h1>
                                            <div class="small" id="nowTime">
                                            </div>
                                        </div>
                                        <c:if test="${trackingChoose!=null}">
                                            <div class="col-12 col-xl-auto mb-3 d-flex justify-content-between ms-auto">
                                                <a href="updateTracking?tracking=${trackingChoose.getTracking_id()}" class="btn btn-primary" style="margin-right: 1rem;">
                                                    <i class="fa-solid fa-users-viewfinder" style="margin-right: 2px;"></i>
                                                    View Update Tracking
                                                </a>
                                            </div>
                                        </c:if>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item text-capitalize"><a href="tracking?class=${classChoose.getClass_id()}"> Tracking</a></li>
                                            <li class="breadcrumb-item active">${trackingChoose!=null?trackingChoose.getFunction().getFunction_name().concat("_").concat(trackingChoose.getAssignee().getFull_name()):"Add"}</li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <div class="card card-waves p-4 mb-4 mt-5">
                                <div class="row align-items-end">
                                    <div class="mb-3 col-xl-3 col-md-6">
                                        <label for="class" class="form-label">Class<span style="color: red">*</span></label>
                                        <c:choose>
                                            <c:when test="${trackingChoose != null}" >
                                                <input type="text" required=""  class="form-control border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" value="${trackingChoose.getClassroom().getClass_code()}" disabled="">
                                                <input type="text" name="class" id="class" class="form-control" value="${trackingChoose.getClassroom().getClass_id()}" hidden="">
                                            </c:when>
                                            <c:otherwise>
                                                <form action="tracking" method="POST">
                                                    <input type="hidden" name="service" value="add"/>
                                                    <select ${loginUser.getRole_id()==4?"":"disabled=''"} id="class" required="" ${sessionScope.LIST_CLASS==null?'disabled=""':''} name="class" onchange="this.form.submit()" class="form-control col border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" >
                                                        <c:forEach items="${sessionScope.LIST_CLASS}" var="class">
                                                            <c:choose>
                                                                <c:when test="${sessionScope.CLASS_CHOOSE!=null&&sessionScope.CLASS_CHOOSE.getClass_id()==class.getClass_id()}">
                                                                    <option class="text-capitalize" value="${class.getClass_id()}" selected="">${class.getSubject().getSubject_code()}_${class.getClass_code()}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${class.getClass_id()}">${class.getSubject().getSubject_code()}_${class.getClass_code()}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>          
                                                    </select>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="mb-3 col-xl-3 col-md-6">
                                        <label for="team" class="form-label">Team<span style="color: red">*</span></label>
                                        <c:choose>
                                            <c:when test="${trackingChoose != null}" >
                                                <input type="text" required=""  class="form-control border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" value="${trackingChoose.getTeam().getTeam_name()}" disabled="">
                                                <input type="text" name="team" id="team" class="form-control" value="${trackingChoose.getTeam().getTeam_id()}" hidden="">
                                            </c:when>
                                            <c:otherwise>
                                                <form action="tracking" method="POST">
                                                    <input type="hidden" name="service" value="add"/>
                                                    <input type="hidden" name="class" value="${sessionScope.CLASS_CHOOSE!=null?sessionScope.CLASS_CHOOSE.getClass_id():sessionScope.LIST_CLASS.get(0).getClass_id()}"/>
                                                    <select ${loginUser.getRole_id()==4?"":"disabled=''"} id="team" required="" ${requestScope.LIST_TEAM==null?'disabled=""':''} name="class" onchange="this.form.submit()" class="form-control col border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" >
                                                        <c:forEach items="${requestScope.LIST_TEAM}" var="team">
                                                            <c:choose>
                                                                <c:when test="${requestScope.TEAM_CHOOSE!=null&&requestScope.TEAM_CHOOSE.getTeam_id()==team.getTeam_id()}">
                                                                    <option class="text-capitalize" value="${team.getTeam_id()}" selected="">${team.getTeam_name()}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${team.getTeam_id()}">${team.getTeam_name()}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>          
                                                    </select>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="mb-3 col-xl-6 col-md-12">
                                        <label for="feature" class="form-label">Feature<span style="color: red">*</span></label>
                                        <c:choose>
                                            <c:when test="${trackingChoose != null}" >
                                                <input type="text" required=""  class="form-control border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" value="${trackingChoose.getFeature().getFeature_name()}" disabled="">
                                                <input type="text" name="feature" id="feature" class="form-control" value="${trackingChoose.getFeature().getFeature_id()}" hidden="">
                                            </c:when>
                                            <c:otherwise>
                                                <form action="tracking" method="POST">
                                                    <input type="hidden" name="service" value="add"/>
                                                    <input type="hidden" name="class" value="${sessionScope.CLASS_CHOOSE!=null?sessionScope.CLASS_CHOOSE.getClass_id():sessionScope.LIST_CLASS.get(0).getClass_id()}"/>
                                                    <input type="hidden" name="team" value="${requestScope.TEAM_CHOOSE!=null?requestScope.TEAM_CHOOSE.getTeam_id():requestScope.LIST_CLASS.get(0).getTeam_id()}"/>
                                                    <select ${loginUser.getRole_id()==4?"":"disabled=''"} id="feature" required="" ${requestScope.LIST_TEAM==null?'disabled=""':''} name="feature" onchange="this.form.submit()" class="form-control col border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" >
                                                        <c:forEach items="${requestScope.LIST_FEATURE}" var="feature">
                                                            <c:choose>
                                                                <c:when test="${requestScope.FEATURE_CHOOSE!=null&&requestScope.FEATURE_CHOOSE.feature_id==feature.feature_id}">
                                                                    <option class="text-capitalize" value="${feature.feature_id}" selected="">${feature.feature_name}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${feature.feature_id}">${feature.feature_name}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>          
                                                    </select>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <c:if test="${((trackingChoose==null&&requestScope.LIST_FUNCTION.size()>0&&requestScope.LIST_MILESTONE.size()>0)||trackingChoose!=null)}">
                                    <form action="tracking" method="POST">
                                        <div class="row">
                                            <div class="mb-3 col-xl-3 col-md-12">
                                                <label for="function" class="form-label">Function<span style="color: red">*</span></label>
                                                <c:choose>
                                                    <c:when test="${trackingChoose != null}" >
                                                        <input type="hidden" name="class" value="${trackingChoose.getClassroom().getClass_id()}"/>
                                                        <input type="hidden" name="team" value="${trackingChoose.getTeam().getTeam_id()}"/>
                                                        <input type="hidden" name="feature" value="${trackingChoose.getFeature().getFeature_id()}"/>
                                                        <input type="hidden" name="id" value="${trackingChoose.getTracking_id()}"/>
                                                        <input type="text" required=""  class="form-control border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" value="${trackingChoose.getFunction().getFunction_name()}" disabled="">
                                                        <input type="text" name="function" id="function" class="form-control" value="${trackingChoose.getFunction_id()}" hidden="">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="class" value="${sessionScope.CLASS_CHOOSE!=null?sessionScope.CLASS_CHOOSE.getClass_id():sessionScope.LIST_CLASS.get(0).getClass_id()}"/>
                                                        <input type="hidden" name="team" value="${requestScope.TEAM_CHOOSE!=null?requestScope.TEAM_CHOOSE.getTeam_id():requestScope.LIST_CLASS.get(0).getListTeam(loginUser).get(0).getTeam_id()}"/>
                                                        <input type="hidden" name="feature" value="${requestScope.FEATURE_CHOOSE!=null?requestScope.FEATURE_CHOOSE.feature_id:requestScope.LIST_FEATURE.get(0).feature_id}"/>
                                                        <select ${loginUser.getRole_id()==4?"":"disabled=''"} id="function" required="" ${requestScope.LIST_FUNCTION==null?'disabled=""':''} name="function" class="form-control col border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" >
                                                            <c:forEach items="${requestScope.LIST_FUNCTION}" var="function">
                                                                <option class="text-capitalize" value="${function.getFunction_id()}">${function.getFunction_name()}</option>
                                                            </c:forEach>          
                                                        </select>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="mb-3 col-xl-3 col-md-6">
                                                <label for="assignee" class="form-label">Assignee</label>
                                                <c:if test="${trackingChoose!=null&&tracking.getStatusSetting().getSetting_title().toLowerCase()=='to_do'}">
                                                    <input type="hidden" name="assignee" value="${trackingChoose!=null&&tracking.getStatusSetting().getSetting_title().toLowerCase()=='to_do'?"":trackingChoose.getAssignee_id()}"/>
                                                </c:if>
                                                <select ${(trackingChoose!=null&&tracking.getStatusSetting().getSetting_title().toLowerCase()!='to_do')||trackingChoose==null?"":"disabled=''"} ${((trackingChoose!=null&&trackingChoose.getAssignee_id()==loginUser.getUser_id()||requestScope.TEAM_CHOOSE.getLeader().getUser_id()==loginUser.getUser_id())||(trackingChoose==null&&requestScope.TEAM_CHOOSE.getLeader().getUser_id()==loginUser.getUser_id()))?"":"disabled=''"} ${loginUser.getRole_id()==4?"":"disabled=''"} id="assignee" required="" ${requestScope.LIST_USER==null?'disabled=""':''} name="assignee" class="form-control col border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" >
                                                    <c:forEach items="${requestScope.LIST_USER}" var="user">
                                                        <c:choose>
                                                            <c:when test="${trackingChoose!=null&&trackingChoose.getAssignee_id()==user.getUser_id()}">
                                                                <option class="text-capitalize" value="${user.getUser_id()}" selected="">${user.getUser().getFull_name()}</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option class="text-capitalize" value="${user.getUser_id()}">${user.getUser().getFull_name()}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>          
                                                </select>
                                            </div>
                                            <div class="mb-3 col-xl-3 col-md-6">
                                                <label for="milestone" class="form-label">Milestone<span style="color: red">*</span></label>
                                                <c:choose>
                                                    <c:when test="${trackingChoose != null}" >
                                                        <input type="text" required=""  class="form-control border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" value="${trackingChoose.getMilestone().getMilestone_name()}" disabled="">
                                                        <input type="text" name="milestone" id="milestone" class="form-control" value="${trackingChoose.getMilestone_id()}" hidden="">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <select ${loginUser.getRole_id()==4?"":"disabled=''"} id="milestone" required="" ${requestScope.LIST_MILESTONE==null?'disabled=""':''} name="milestone" class="form-control col border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" >
                                                            <c:forEach items="${requestScope.LIST_MILESTONE}" var="milestone">
                                                                <c:choose>
                                                                    <c:when test="${(requestScope.MILESTONE_CHOOSE!=null&&requestScope.MILESTONE_CHOOSE.getMilestone_id()==milestone.getMilestone_id())||(trackingChoose!=null&&trackingChoose.getMilestone_id()==milestone.getMilestone_id())}">
                                                                        <option class="text-capitalize" value="${milestone.getMilestone_id()}" selected="">${milestone.getMilestone_name()}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option class="text-capitalize" value="${milestone.getMilestone_id()}">${milestone.getMilestone_name()}</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>          
                                                        </select>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="mb-3 col-xl-3 col-md-12">
                                                <label for="status" class="form-label">Status</label>
                                                <select ${loginUser.getRole_id()==4?"":"disabled=''"} ${((trackingChoose!=null&&trackingChoose.getAssignee_id()==loginUser.getUser_id()||requestScope.TEAM_CHOOSE.getLeader().getUser_id()==loginUser.getUser_id())||(trackingChoose==null&&requestScope.TEAM_CHOOSE.getLeader().getUser_id()==loginUser.getUser_id()))?"":"disabled=''"} id="status" required="" ${sessionScope.LIST_FUNCTION_STATUS==null?'disabled=""':''} name="status" class="form-control col border-0 border-bottom ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" >
                                                    <c:forEach items="${sessionScope.LIST_FUNCTION_STATUS}" var="status">
                                                        <c:if test="${(trackingChoose!=null&&trackingChoose.getStatus()<=status.getSetting_id())||trackingChoose==null}">
                                                            <c:choose>
                                                                <c:when test="${trackingChoose!=null&&trackingChoose.getStatus()==status.getSetting_id()}">
                                                                    <option class="text-capitalize" value="${status.getSetting_id()}" selected="">${status.getSetting_title()}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${status.getSetting_id()}">${status.getSetting_title()}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:if>
                                                    </c:forEach>          
                                                </select>
                                            </div>
                                        </div>
                                        <div class="mb-3 form-floating">
                                            <textarea ${((trackingChoose!=null&&trackingChoose.getAssignee_id()==loginUser.getUser_id()||requestScope.TEAM_CHOOSE.getLeader().getUser_id()==loginUser.getUser_id())||(trackingChoose==null&&requestScope.TEAM_CHOOSE.getLeader().getUser_id()==loginUser.getUser_id()))?"":"disabled=''"} ${loginUser.getRole_id()==4?"":"disabled=''"} class="form-control ${loginUser.getRole_id()<4?'bg-primary-soft':'bg-transparent'}" placeholder="User Note" id="trackingNote" name="note">${trackingChoose!=null?trackingChoose.getTracking_note():''}</textarea>
                                            <label for="trackingNote">Tracking Note</label>
                                        </div>
                                        <c:if test="${((trackingChoose!=null&&trackingChoose.getAssignee_id()==loginUser.getUser_id()||requestScope.TEAM_CHOOSE.getLeader().getUser_id()==loginUser.getUser_id())||(trackingChoose==null&&requestScope.TEAM_CHOOSE.getLeader().getUser_id()==loginUser.getUser_id()))&&loginUser.getRole_id()==4}">
                                            <div class="ms-auto">
                                                <input type="text" name="submitForm" class="form-control" value="add" hidden="">
                                                <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset">
                                                <button type="submit" name="service" value="${trackingChoose!=null?'update':'add'}" class="btn btn-primary">Save changes</button>
                                            </div>
                                        </c:if>
                                    </form>
                                </c:if>
                            </div>
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