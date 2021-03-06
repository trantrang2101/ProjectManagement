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
    <c:set var="issue" value="${requestScope.ISSUE_CHOOSE}"></c:set>
    <c:set var="userChoose" value="${requestScope.USER_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title>Issue Detail · ${issue==null?'Add':(userChoose.getFull_name().concat(' - ').concat(issue.getTeam().getTeam_name()).concat(' - ').concat(issue.getTeam().getClassroom().getClass_code()))}</title>
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
                                            <h1 class="mb-0 text-bold">Issue Detail · ${issue==null?'Add':(userChoose.getFull_name().concat(' - ').concat(issue.getTeam().getTeam_name()).concat(' - ').concat(issue.getTeam().getClassroom().getClass_code()))}</h1>
                                            <div class="small" id="nowTime">
                                            </div>
                                        </div>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="issue"> Issue List</a></li>
                                            <li class="breadcrumb-item text-capitalize"><a href="issue?user=${issue.getTeam_id()}">${issue.getTeam().getTeam_name()}</a></li>
                                            <li class="breadcrumb-item active">${issue.issue_title}</li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <form action="issue" method="POST">
                                <div class="card card-waves p-4 mb-4 mt-5">
                                    <div class="row align-items-end">
                                        <div class="mb-3 col-xl-4 col-md-6">
                                            <label for="id" class="form-label">Issue ID</label>
                                            <input type="text" class="form-control border-0 border-bottom bg-transparent" value="${issue.issue_id}" disabled="">
                                            <input type="text" name="id" class="form-control" value="${issue.issue_id}" hidden="">
                                        </div>
                                        <div class="mb-3 col">
                                            <label for="assignee_id" class="form-label border-0 border-bottom">Assignee</label>
                                            <select ${loginUser.getRole_id()<4?"":"disabled=''"} id="assignee_id" name="assignee_id" class="form-control col border-0 border-bottom bg-transparent">
                                                <c:forEach items="${requestScope.LIST_USER}" var="user">
                                                    <c:choose>
                                                        <c:when test="${(issue!=null&&issue.getUser().getUser_id()==user.getUser_id())}">
                                                            <option class="text-capitalize" value="${user.user_id}" selected="">${user.full_name}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option class="text-capitalize" value="${user.user_id}">${user.full_name}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="mb-3 col-xl-4 col-md-6">
                                            <label for="issue_title" class="form-label">Issue Title</label>
                                            <input type="text" required="" name="issue_title" class="form-control border-0 border-bottom bg-transparent" value="${issue.issue_title}" maxlength="50">
                                        </div>
                                    </div>
                                    <div class="row align-items-end">
                                        <c:choose>
                                            <c:when test="${requestScope.LIST_TEAM==null}">
                                                <h5>There is no team in this class!</h5>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="mb-3 col">
                                                    <label for="team_id" class="form-label">Team</label>
                                                    <select ${loginUser.getRole_id()<4?"":"disabled=''"} id="team_id" class="form-select border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" name="team_id">
                                                        <c:forEach items="${requestScope.LIST_TEAM}" var="team">
                                                            <c:choose>
                                                                <c:when test="${issue!=null&&issue.getTeam_id()==team.getTeam_id()}">
                                                                    <option class="text-capitalize" selected="" value="${team.getTeam_id()}">${team.getTeam_name()}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${team.getTeam_id()}">${team.getTeam_name()}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>   
                                        <c:choose>
                                            <c:when test="${requestScope.LIST_MILESTONE==null}">
                                                <h5>There is no milestone!</h5>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="mb-3 col">
                                                    <label for="milestone_id" class="form-label">Milestone</label>
                                                    <select ${loginUser.getRole_id()<4?"":"disabled=''"} id="milestone_id" class="form-select border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" name="milestone_id">
                                                        <c:forEach items="${requestScope.LIST_MILESTONE}" var="milestone">
                                                            <c:choose>
                                                                <c:when test="${issue!=null&&issue.getMilestone_id()==milestone.getMilestone_id()}">
                                                                    <option class="text-capitalize" selected="" value="${milestone.getMilestone_id()}">${milestone.getMilestone_name()}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${milestone.getMilestone_id()}">${milestone.getMilestone_name()}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:choose>
                                            <c:when test="${requestScope.LIST_FUNCTION==null}">
                                                <h5>There is no function!</h5>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="mb-3 col">
                                                    <label for="function_id" class="form-label">Function</label>
                                                    <select ${loginUser.getRole_id()<4?"":"disabled=''"} id="function_id" class="form-select border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" name="function_id">
                                                        <c:forEach items="${requestScope.LIST_FUNCTION}" var="function">
                                                            <c:choose>
                                                                <c:when test="${issue!=null&&issue.getFunction_id()==function.getFunction_id()}">
                                                                    <option class="text-capitalize" selected="" value="${function.getFunction_id()}">${function.getFunction_name()}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${function.getFunction_id()}">${function.getFunction_name()}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                            </div>
                                            <div class="row align-items-end">
                                                <div class="mb-3 col-xl-6 col-md-3">
                                                    <form action="issue" method="POST">
                                                        <label for="class_code" class="form-label">Class Code</label>
                                                        <c:choose>
                                                            <c:when test="${serve=='update'}">
                                                                <input type="text" class="form-control border-0 border-bottom bg-transparent" value="${issue.getTeam().getClassroom().getSubject().getSubject_code()}_${issue.getTeam().getClassroom().class_code}" disabled="">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <select id="class_code" name="class" onchange="this.form.submit();" class="form-control col border-0 border-bottom bg-transparent">
                                                                    <c:forEach items="${sessionScope.LIST_CLASS}" var="class">
                                                                        <c:choose>
                                                                            <c:when test="${(issue!=null&&issue.getTeam().class_id==class.class_id)||(requestScope.CLASS_CHOOSE!=null&&requestScope.CLASS_CHOOSE.class_id==class.class_id)}">
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
                                                <div class="mb-3 col-xl-6 col-md-9">
                                                    <label class="form-label" for="status">Status</label>
                                                    <select ${loginUser.getRole_id()<4?"":"disabled=''"} id="status" name="status" class="form-control col border-0 border-bottom bg-transparent">
                                                        <c:forEach items="${requestScope.LIST_STATUS}" var="status">
                                                            <c:choose>
                                                                <c:when test="${(issue!=null&&issue.getStatus()==status.setting_value)}">
                                                                    <option class="text-capitalize" value="${status.setting_value}" selected="">${status.setting_title}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${status.setting_value}">${status.setting_title}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="row align-items-end">
                                                <div class="mb-3 col-xl-6 col-md-3">
                                                    <label for="created_at" class="form-label">Created Time</label>
                                                    <input hidden="" type="text" id="created_at" value="${issue.getCreated_at()}">
                                                    <input type="date" name="created_at" id="created_at_data" class="form-control border-0 border-bottom bg-transparent" value="${issue.created_at}">
                                                </div>
                                                <div class="mb-3 col-xl-6 col-md-9">
                                                    <label for="due_date" class="form-label">Due Date</label>
                                                    <input hidden="" type="text" id="update_at" value="${issue.getDue_date()}">
                                                    <input type="date" name="due_date" id="update_at_data" required="" class="form-control border-0 border-bottom bg-transparent" value="${issue.due_date}">
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="mb-3 col">
                                                    <label for="gitlab_id" class="form-label">GitLab ID</label>
                                                    <input type="number" id="gitlab_id" name="gitlab_id" class="form-control border-0 border-bottom bg-transparent" value="${team.gitlab_id}">
                                                </div>
                                                <div class="mb-3 col">
                                                    <label for="gitlab_url" class="form-label">GitLab URL</label>
                                                    <input type="text" id="gitlab_url" name="gitlab_url" class="form-control border-0 border-bottom bg-transparent" pattern="^(http(s):\/\/)?gitlab\.com[\w\-\._~:\/?#[\]@!\$&'\(\)\*\+,;=.]+$" title="Input must be GitLab URL" maxlength="255" value="${team.gitlab_url}">
                                                </div>
                                                <div class="mb-3 form-floating">
                                                    <textarea class="form-control bg-transparent" disabled='' placeholder="Description" id="description" name="description">${issue!=null?issue.getDescription():''}</textarea>
                                                    <label for="description">Description</label>
                                                </div>
                                            </div>
                                            <div ${loginUser.getRole_id()<4?"":"hidden=''"} class="ms-auto">
                                                <input type="text" name="submit" class="form-control" value="add" hidden="">
                                                <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset"></input>
                                                <button type="submit" name="service" value="${issue!=null?'update':'add'}" class="btn btn-primary">Save changes</button>
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
            var bir = document.querySelector('#created_at_data');
            if (bir != null && bir.value != '') {
                var day = bir.value.split(' ')[0].split('-');
                var time = bir.value.split(' ')[1].split(':');
                document.querySelector('#created_at').value = moment(new Date(day[0], day[1] - 1, day[2])).format('YYYY-MM-DD');
                document.querySelector('#created_at').max = new Date().toISOString().split("T")[0];
            }
            bir = document.querySelector('#update_at_data');
            if (bir != null && bir.value != '') {
                var day = bir.value.split(' ')[0].split('-');
                var time = bir.value.split(' ')[1].split(':');
                document.querySelector('#update_at').value = moment(new Date(day[0], day[1] - 1, day[2])).format('YYYY-MM-DD');
                document.querySelector('#update_at').max = new Date().toISOString().split("T")[0];
            }
        </script>
        <script src="js/scripts.js"></script>
    </body>
</html>