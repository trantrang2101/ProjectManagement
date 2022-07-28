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
    <c:set var="milestoneChoose" value="${requestScope.MILESTONE_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title class="">Milestone · ${milestoneChoose != null ? milestoneChoose.getIteration().getSubject().getSubject_code()  : "Add Milestone" } </title>
    </head>  
    <body>
        <c:set var="subjectChoose" value="${requestScope.SUBJECT_CHOOSE}"></c:set>
        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
        <c:set var="search" value="${requestScope.SEARCH_WORD}"></c:set>
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
                                            <c:choose>
                                                <c:when test="${milestoneChoose != null}" >
                                                    <h1 class="mb-0 text-bold">Milestone Detail · ${milestoneChoose.getIteration().getSubject().getSubject_code()} - ${milestoneChoose.getIteration().getIteration_name()}</h1>
                                                </c:when>
                                                <c:otherwise>
                                                    <h1 class="mb-0 text-bold">Create new Milestone</h1>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="small" id="nowTime">
                                            </div>
                                        </div>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="milestone"> Milestone List</a></li>
                                                <c:if test="${milestoneChoose!=null}">
                                                <li class="breadcrumb-item text-capitalize"><a href="milestone?type=${milestoneChoose.getIteration().getSubject().getSubject_id()}">${milestoneChoose.getIteration().getSubject().getSubject_code()} - ${milestoneChoose.getIteration().getIteration_name()}</a></li>
                                                <li class="breadcrumb-item active">${milestoneChoose.getMilestone_name()}</li>
                                                </c:if>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <div class="card card-waves p-4 mb-4 mt-5">
                                <div class="row">
                                    <div class="mb-3 col-12">
                                        <label  class="form-label" for="class_id">Class Code<span style="color: red">*</span></label>
                                        <c:choose>
                                            <c:when test="${milestoneChoose != null}" >
                                                <input type="text" required=""  class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${milestoneChoose.getClassroom().getClass_code()}" disabled="">
                                                <input type="text" name="class" id="class_id" class="form-control" value="${milestoneChoose.getClass_id()}" hidden="">
                                            </c:when>
                                            <c:otherwise>
                                                <form action="milestone" method="POST">
                                                    <input type="hidden" name="service" value="add">
                                                    <select ${loginUser.getRole_id()<4?"":"disabled=''"} id="class_id" required="" ${sessionScope.LIST_CLASS==null?'disabled=""':''} name="class_id" onchange="document.getElementById('classChoose').value = this.value;this.form.submit()" class="form-control col border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" >
                                                        <c:forEach items="${sessionScope.LIST_CLASS}" var="class">
                                                            <c:choose>
                                                                <c:when test="${requestScope.CLASS_CHOOSE!=null&&requestScope.CLASS_CHOOSE.getClass_id()==class.getClass_id()}">
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
                                    <c:if test="${(requestScope.LIST_ITERATION!=null&&requestScope.LIST_ITERATION.size()>0)||milestoneChoose!=null}">
                                        <div class="mb-3 col-12">
                                            <label  class="form-label" for="iteration_id">Iteration Name<span style="color: red">*</span></label>
                                            <c:choose>
                                                <c:when test="${milestoneChoose != null && milestoneChoose.getIteration_id()!=0}" >
                                                    <input type="text" required=""  class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${milestoneChoose.getIteration().getIteration_name()}" disabled="">
                                                    <input type="text" name="iteration" id="iteration_id" class="form-control" value="${milestoneChoose.getIteration().getIteration_id()}" hidden="">
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="milestone">
                                                        <select ${loginUser.getRole_id()<4?"":"disabled=''"} id="iteration_id" ${requestScope.LIST_ITERATION==null?'disabled=""':''} required="" 
                                                                                                             onchange="document.querySelector('#iterationChoose').value = this.value;
                                                                                                                     this.form.submit();
                                                                                                                     console.log(this.value);" name="iteration_id" class="form-control col border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" >
                                                            <c:forEach items="${requestScope.LIST_ITERATION}" var="iteration">
                                                                <c:choose>
                                                                    <c:when test="${requestScope.ITERATION_CHOOSE!=null&&requestScope.ITERATION_CHOOSE.getIteration_id()==iteration.getIteration_id()}">
                                                                        <option class="text-capitalize" selected="" value="${iteration.getIteration_id()}">${iteration.getSubject().getSubject_code()}_${iteration.getIteration_name()}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option class="text-capitalize" value="${iteration.getIteration_id()}">${iteration.getSubject().getSubject_code()}_${iteration.getIteration_name()}</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>          
                                                        </select>
                                                        <input hidden="" name="service" value="${milestoneChoose!=null ?'update':'add'}"/>
                                                        <input hidden="" name="id" value="${milestoneChoose!=null ?milestoneChoose.getMilestone_id():''}"/>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <form class="row" action="milestone" method="POST">      
                                            <div class="mb-3 col-xl-6 col-md-12">
                                                <label for="name" class="form-label">Milestone Name</label>
                                                <input type="text" name="id" class="form-control" value="${milestoneChoose.milestone_id}" hidden="">
                                                <input type="text" hidden="" id="iterationChoose" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${milestoneChoose!=null ? (milestoneChoose.getIteration_id()!=0?milestoneChoose.getIteration_id():(requestScope.ITERATION_CHOOSE!=null?requestScope.ITERATION_CHOOSE.getIteration_id():'')) : requestScope.ITERATION_CHOOSE!=null?requestScope.ITERATION_CHOOSE.getIteration_id():''}" name="iteration">
                                                <input type="text" hidden="" id="classChoose" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${milestoneChoose!=null ? milestoneChoose.getClass_id() : requestScope.CLASS_CHOOSE==null?sessionScope.LIST_CLASS.get(0).getClass_id():requestScope.CLASS_CHOOSE.getClass_id()}" name="class">
                                                <input type="text" ${loginUser.getRole_id()<4?"":"disabled=''"} id="name" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${milestoneChoose!=null ? milestoneChoose.getMilestone_name() : ""}" name="name">
                                            </div>
                                            <div class="mb-3 col-xl-6 col-md-12">
                                                <label class="form-check-label" for="status">Status</label>
                                                <select ${loginUser.getRole_id()<4?"":"disabled=''"} id="status"  name="status" class="form-control col border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" >
                                                    <c:forEach begin="0" end="${fn:length(sessionScope.LIST_STATUS)-1}" var="i">
                                                        <c:choose>
                                                            <c:when test="${milestoneChoose!=null&&milestoneChoose.getStatus()==i}">
                                                                <option class="text-capitalize" selected="" value="${i}">${sessionScope.LIST_STATUS[i]}</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option class="text-capitalize" value="${i}">${sessionScope.LIST_STATUS[i]}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>          
                                                </select>
                                            </div>
                                            <div class="mb-3 col-xl-6 col-md-12">
                                                <label class="form-check-label" for="from">From</label>
                                                <input ${loginUser.getRole_id()<4?"":"disabled=''"} type="date" name="from" id="from" onchange="document.getElementById('fromValue').value = this.value;
                                                        onChangeFromDate()" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}">
                                                <input ${loginUser.getRole_id()<4?"":"disabled=''"} type="text" id="fromValue" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${milestoneChoose!=null?milestoneChoose.getFrom_date():''}" hidden="">
                                            </div>
                                            <div class="mb-3 col-xl-6 col-md-12">
                                                <label class="form-check-label" for="to">To</label>
                                                <input ${loginUser.getRole_id()<4?"":"disabled=''"} type="date" name="to" onchange="onChangeFromDate()" id="to" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}">
                                                <input ${loginUser.getRole_id()<4?"":"disabled=''"} type="text" id="toValue" class="form-control border-0 border-bottom ${loginUser.getRole_id()>3?'bg-primary-soft':'bg-transparent'}" value="${milestoneChoose!=null?milestoneChoose.getTo_date():''}" hidden="">
                                                <input type="text" id="duration" ${loginUser.getRole_id()<4?"":"disabled=''"} value="${requestScope.ITERATION_CHOOSE!=null?requestScope.ITERATION_CHOOSE.getDuration():''}" hidden="">
                                            </div>
                                            <c:if test="${loginUser.getRole_id()<4}">
                                                <div class="ms-auto">
                                                    <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset"></input>
                                                    <input type="text" hidden="" name="submitForm" value="addMilestone">
                                                    <button type="submit" name="service" value="${milestoneChoose!=null ?'update':'add'}" class="btn btn-primary">Save changes</button>
                                                </div>
                                            </c:if>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                            <jsp:include page="../included/footer.jsp"/>
                        </div>
                    </main>
                </div>
            </div>
        </div>
    </div>
    <script>
        var duration = document.querySelector('#duration');
        var toValue = document.querySelector('#toValue');
        var fromValue = document.querySelector('#fromValue');
        var dayFrom, dayTo;
        function onChangeFromDate() {
            if (fromValue != null && fromValue.value != '') {
                dayFrom = fromValue.value.split(' ')[0].split('-');
                var fromDate = new Date(dayFrom[0], dayFrom[1] - 1, dayFrom[2]);
                var date = moment(fromDate).format('YYYY-MM-DD');
                var toDate;
                var dateMomentTo;
                if (toValue != null && toValue.value != '') {
                    dayTo = toValue.value.split(' ')[0].split('-');
                    toDate = new Date(dayTo[0], dayTo[1] - 1, dayTo[2]);
                    document.querySelector('#to').value = moment(toDate).format('YYYY-MM-DD');
                    dateMomentTo = moment(toDate).format('YYYY-MM-DD');
                }
                document.querySelector('#from').value = date;
                var dateFrom = fromDate;
                if (duration != null && duration != '') {
                    document.querySelector('#to').setAttribute("min", date);
                    document.querySelector('#to').setAttribute("max", moment(date, 'YYYY-MM-DD').add(Number(duration.value), 'days').format('YYYY-MM-DD'));
                    dateFrom.setDate(dateFrom.getDate() - Number(duration.value));
                }
                if (fromDate > toDate) {
                    document.querySelector('#to').value = date;
                }
            }
        }
        window.addEventListener('DOMContentLoaded', event => {
            onChangeFromDate();
        });
    </script>
    <script src="js/scripts.js"></script>
</body>
</html>
