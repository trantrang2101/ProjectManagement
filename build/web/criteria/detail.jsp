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
    <c:set var="criteriaChoose" value="${requestScope.CRITERIA_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title class="">Criteria · ${criteriaChoose != null ? criteriaChoose.getIteration().getSubject().getSubject_code()  : "Add Criteria" } </title>
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
                                                <c:when test="${criteriaChoose != null}" >
                                                    <h1 class="mb-0 text-bold">Criteria Detail · ${criteriaChoose.getIteration().getSubject().getSubject_code()} - ${criteriaChoose.getIteration().getIteration_name()} (${criteriaChoose.getCriteria_title()})</h1>
                                                </c:when>
                                                <c:otherwise>
                                                    <h1 class="mb-0 text-bold">Create new Criteria</h1>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="small" id="nowTime">
                                            </div>
                                        </div>
                                    </div>
                                    <nav class="mt-4 rounded bg-light" aria-label="breadcrumb">
                                        <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                            <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="criteria"> Criteria List</a></li>
                                                <c:if test="${criteriaChoose!=null}">
                                                <li class="breadcrumb-item text-capitalize"><a href="criteria?type=${criteriaChoose.getIteration().getSubject().getSubject_id()}">${criteriaChoose.getIteration().getSubject().getSubject_code()} - ${criteriaChoose.getIteration().getIteration_name()}</a></li>
                                                <li class="breadcrumb-item active">${criteriaChoose.getCriteria_title()}</li>
                                                </c:if>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <div class="card card-waves p-4 mb-4 mt-5">
                                <div class="row align-items-end">
                                    <c:if test="${criteriaChoose!=null}">
                                        <div class="mb-3 col-xl-6 col-md-3">
                                            <label for="id" class="form-label">Criteria ID</label>
                                            <input type="text" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${criteriaChoose.criteria_id}" disabled="">
                                        </div>
                                    </c:if>
                                    <div class="mb-3 col">
                                        <c:choose>
                                            <c:when test="${criteriaChoose != null}" >
                                                <label for="subject_id" class="form-label">Subject ID</label>  
                                                <input id="subject_id" name="subject_id" name type="text" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${criteriaChoose.getIteration().getSubject().getSubject_code()} - ${criteriaChoose.getIteration().getSubject().getSubject_name()}" disabled="">
                                                <input type="text" name="id" class="form-control" value="${criteriaChoose.criteria_id}" hidden="">
                                            </c:when>
                                            <c:otherwise>
                                                <form action="criteria" id="subjectChangeForm" method="POST">
                                                    <label for="subject_id" class="form-label">Subject ID</label>
                                                    <select id="subject_id" onchange="this.form.submit();" name="subject_id" class="form-control col border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" >
                                                        <option value="1" selected="" disabled="">--Choose a subject--</option>
                                                        <c:forEach items="${sessionScope.LIST_SUBJECT}" var="subject">
                                                            <c:choose>
                                                                <c:when test="${subjectChoose!=null&&subjectChoose.getSubject_id()==subject.getSubject_id()}">
                                                                    <option class="text-capitalize" selected="" value="${subject.getSubject_id()}">${subject.getSubject_code()} - ${subject.getSubject_name()} </option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option class="text-capitalize" value="${subject.getSubject_id()}">${subject.getSubject_code()} - ${subject.getSubject_name()} </option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                    <input type="text" hidden="" name="service" value="add">
                                                    <input type="text" hidden="" name="submitChange" value="changeSubject">
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <c:choose>
                                    <c:when test="${(!requestScope.LIST_ITERATION.isEmpty() || criteriaChoose != null) && (requestScope.SUBJECT_CHOOSE !=null || criteriaChoose != null)}">
                                        <form action="criteria" method="POST">
                                            <div class="row">
                                                <c:choose>
                                                    <c:when test="${criteriaChoose != null}" >
                                                        <div class="mb-3 col-xl-6 col-md-12">
                                                            <label ${loginUser.getRole_id()>2?'disabled=""':''} class="form-label" for="iteration_id">Iteration Name</label>
                                                            <input type="text" required=""  class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${criteriaChoose.getIteration().getIteration_name()}" disabled="">
                                                            <input type="text" class="form-control" value="${criteriaChoose.getIteration().getIteration_id()}" hidden="">
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="mb-3 col-xl-6 col-md-12">
                                                            <label  class="form-label" for="iteration_id">Iteration Name</label>
                                                            <input type="hidden" name="submit" value="changeIteration">
                                                            <select ${loginUser.getRole_id()>2?'disabled=""':''} id="iteration_id"  name="iteration_id" onchange="document.getElementById('iterationChoose').value = this.value; changeMaxValue(this.options[this.selectedIndex].getAttribute('maxweight'));" class="form-control col border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" >
                                                                <option class="text-capitalize"  value="" selected="" disabled="">---Choose criteria---</option>
                                                                <c:forEach items="${requestScope.LIST_ITERATION}" var="iteration">
                                                                    <c:choose>
                                                                        <c:when test="${iteration.getIterationTotalWeight() == 100}">
                                                                            <option class="text-capitalize" maxweight="${iteration.getIterationTotalWeight()}" disabled="" value="${iteration.getIteration_id()}">${iteration.getIteration_name()} - Total Weight ${iteration.getIterationTotalWeight()}% </option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option class="text-capitalize" maxweight="${iteration.getIterationTotalWeight()}" value="${iteration.getIteration_id()}">${iteration.getIteration_name()} - Total Weight ${iteration.getIterationTotalWeight()}% </option>
                                                                        </c:otherwise>

                                                                    </c:choose>

                                                                </c:forEach>          
                                                            </select>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                
             
                                                
                                                <div class="mb-3 col-xl-3 col-md-6 d-flex flex-column justify-content-between">
                                                    <label class="form-check-label" for="team_evalCriteria">Team Evaluation</label>
                                                    <div id="team_evalCriteria">
                                                        <input ${loginUser.getRole_id()<2?"":"disabled=''"} onchange="changeStatus('team_eval', 'Team', 'Member')" type="checkbox" class="btn-check" id="team_eval" name="team_eval" autocomplete="off"  ${criteriaChoose!=null&&criteriaChoose.isTeam_evaluation()?"checked":""}>
                                                        <label class="btn btn-outline-primary" for="team_eval"> ${criteriaChoose!=null&&criteriaChoose.isTeam_evaluation()?"Team":"Member"} </label>
                                                    </div>
                                                </div>
                                                <div class="mb-3 col-xl-3 col-md-6 d-flex flex-column justify-content-between">
                                                    <label class="form-check-label" for="statusCriteria">Status</label>
                                                    <div id="statusCriteria">
                                                       
                                                         <a data-bs-toggle="modal" href="#updateStatus${criteriaChoose.criteria_id}">
                                                        <input ${loginUser.getRole_id()<2?"":"disabled=''"} onchange="changeStatus('status', 'Activate', 'Deactivate')" type="checkbox" class="btn-check" id="status" name="status" autocomplete="off" ${criteriaChoose!=null&&criteriaChoose.isStatus()?"checked":""}>
                                                        <label class="btn btn-outline-primary" for="status">${criteriaChoose!=null&&criteriaChoose.isStatus()?"Activate":"Deactivate"}</label>
                                                         </a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal fade" id="updateStatus${criteriaChoose.criteria_id}" tabindex="-1" aria-labelledby="deleteSetting${criteriaChoose.criteria_id}" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="exampleModalLabel">${criteriaChoose.isStatus()?"Deactivate":"Activate"} Criteria?</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            Are you sure to ${criteriaChoose.isStatus()?"deactivate":"activate"} criteria <span class="">${criteriaChoose.getCriteria_title()} from ${criteriaChoose.getIteration().getIteration_name()} of subject ${criteriaChoose.getIteration().getSubject().getSubject_code()}?</span>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                                                            <a href="criteria?id=${criteriaChoose.criteria_id}&status=${criteriaChoose.isStatus()}&service=changeStatus&inDetail=1" class="btn btn-primary">Change</a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">   
                                                <div class="mb-3 col-xl-6 col-md-12 order-0">
                                                    <label for="title" class="form-label">Criteria Title</label>
                                                    <input type="submit" hidden="" name="submitChange" value="change">
                                                    <input type="text" name="id" class="form-control" value="${criteriaChoose.criteria_id}" hidden="">
                                                    <input type="text" hidden="" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${criteriaChoose!=null ? criteriaChoose.getIteration().getSubject().getSubject_id() : (subjectChoose!=null?subjectChoose.getSubject_id():'')}" name="subject_id">
                                                    <input type="text" hidden="" id="iterationChoose" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${criteriaChoose!=null ? criteriaChoose.getIteration().getIteration_id() : ''}" name="iteration_id">
                                                    <input type="text" ${loginUser.getRole_id()>2?'disabled=""':''} id="title" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${criteriaChoose!=null ? criteriaChoose.getCriteria_title() : ""}" name="title">
                                                </div>
                                                <div class="mb-3 col-xl-6 col-md-4 order-xl-0 order-sm-1">
                                                    <label for="order" class="form-label">Criteria Order</label>
                                                    <input type="number" ${loginUser.getRole_id()>2?'disabled=""':''} required="" name="order" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${criteriaChoose!=null ? criteriaChoose.getCriteria_order() : "1"}" min="1" max="10">
                                                </div>
                                                <div class="mb-3 col-xl-6 col-md-4">
                                                    <label for="weight" class="form-label">Evaluation Weight(%) </label>
                                                    <input ${loginUser.getRole_id()>2?'disabled=""':''} type="number" id="weight" required="" name="weight" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${criteriaChoose!=null ? criteriaChoose.getEvaluation_weight() : "1"}" min="1"  max="${!criteriaChoose.isStatus()?"100":100 - criteriaChoose.getIteration().getIterationTotalWeight() + criteriaChoose.getEvaluation_weight()}"  >
                                                    <c:if test="${criteriaChoose != null}">
                                                        <p id="weightNoti" style="font-size: medium; color: red">Total weight of this iteration is ${criteriaChoose.getIteration().getIterationTotalWeight()}% </p>
                                                        <p id="weightNoti" style="font-size: medium; color: red">(Max weight update range is 1 to ${!criteriaChoose.isStatus()?"100":100-criteriaChoose.getIteration().getIterationTotalWeight()+criteriaChoose.getEvaluation_weight()}%)</p>
                                                    </c:if>
                                                    <p id="weightNoti" style="font-size: medium;color: red "></p>
                                                </div>                       
                                                <div class="mb-3 col-xl-6 col-md-4">
                                                    <label for="loc" class="form-label">Max Loc</label>
                                                    <input ${loginUser.getRole_id()>2?'disabled=""':''} type="number"  required="" name="loc" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}" value="${criteriaChoose!=null ? criteriaChoose.getMax_loc() : "10"}" min="10" max="1000">
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class=" col-lg-12">
                                                    <label for="description" class="form-label">Criteria Description</label>
                                                    <textarea ${loginUser.getRole_id()>2?'disabled=""':''} type="text" pattern="\d" required="" name="description" class="form-control border-0 border-bottom ${loginUser.getRole_id()>2?'bg-primary-soft':'bg-transparent'}"> ${criteriaChoose!=null ? criteriaChoose.getCriteria_description() : ""}</textarea>
                                                </div>
                                            </div>
                                            <c:if test="${loginUser.getRole_id()<3}">
                                                <div class="ms-auto">
                                                    <input type="reset" class="btn btn-light" data-bs-dismiss="modal" value="Reset"></input>
                                                    <input type="text" hidden="" name="submitChange" value="addCriteria">
                                                    <button type="submit" name="service" value="${criteriaChoose!=null ?'update':'add'}" class="btn btn-primary">Save changes</button>
                                                </div>
                                            </c:if>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <h5>There is no Iterations in this subject!</h5>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </main>
                    <jsp:include page="../included/footer.jsp"/>
                </div>
            </div>
        </div>
        <script type="text/javascript">

            function changeMaxValue(maxvalue)
            {
                var input = document.getElementById('weight');
                input.setAttribute('max', 100 - maxvalue);
                input = document.getElementById('weight');
                var noti = document.getElementById('weightNoti');

                var max = 100 - maxvalue;
                noti.innerHTML = "Total weight of this iteration is  " + maxvalue + "% (Max weight can input is " + max + "%)";

            }

        </script>
        <script src="js/scripts.js"></script>
    </body>
</html>
