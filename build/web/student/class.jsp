<%-- 
    Document   : classList
    Created on : May 25, 2022, 10:32:55 AM
    Author     : win
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <c:set var="class" value="${requestScope.CLASS_CHOOSE}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <link href="css/course.css" rel="stylesheet" />
        <title>Class ${class.getClass_code()} - ${class.getSubject().getSubject_code()}</title>
    </head>
    <body>
        <div class="nav-fixed">
            <jsp:include page="../included/header.jsp"/>
            <div id="layoutSidenav">
                <jsp:include page="../included/slider.jsp"/>
                <div id="layoutSidenav_content" style="margin-top: 0;">
                    <main id="site-main" class="site-main">
                        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
                            <div class="course-detail-overlay" style="height: 250px;"></div>
                            <div class="container course-detail-site">
                                <article class="course-detail-content">
                                    <div class="row">
                                        <div class="col-12 col-lg-8">
                                            <h2 class="course-name text-bold fs-34 white-space-pre-wrap text-white text-bold">${class.getSubject().getSubject_name()}</h2>
                                        <p class="course-code-title text-white">Course code: <span class="code">${class.getSubject().getSubject_code()}</span></p>
                                        <nav class="mt-4 w-100 rounded bg-transparent" aria-label="breadcrumb">
                                            <ol class="breadcrumb container px-3 py-2 rounded mb-0">
                                                <c:if test="${loginUser.getRole_id()<3}">
                                                    <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                                    </c:if>
                                                <li class="breadcrumb-item text-capitalize"><a href="class">Class list</a></li>
                                                <li class="breadcrumb-item"><a href="class?type=${class.getSubject().getSubject_id()}">${class.getSubject().getSubject_name()}</a></li>
                                                <li class="breadcrumb-item active"><a href="class?id=${class.getClass_id()}"> ${class.getClass_code()} </a></li>
                                            </ol>
                                        </nav>
                                    </div>
                                </div>
                                <div class="row flex-column-reverse flex-lg-row">
                                    <div class="col-12 col-lg-7 course-detail-content__main">
                                        <div class="wrap-course-detail-content_main">
                                            <div id="live-stream-section" class="view-live-stream">
                                                <div class="wrap-view-live-stream">
                                                </div>
                                            </div>
                                            <div id="course-detail-main-content">
                                                <section id="guide-lines">
                                                    <div id="lessons-content" class="edn-tabs ui-tabs ui-widget ui-widget-content">
                                                        <div id="list-lessons" class="edn-tab-content ui-tabs-panel ui-widget-content" aria-labelledby="list-slots-tab" role="tabpanel" aria-hidden="false">
                                                            <ul class="list-slots none-list mg-0">
                                                                <c:choose>
                                                                    <c:when test="${requestScope.LIST_ITERATION==null||requestScope.LIST_ITERATION.size()==0}">
                                                                        <div class="d-flex flex-column justify-content-center" style="margin-top: 50px;">
                                                                            <img class="img-fluid mb-4" src="assets/img/illustrations/data-report.svg" alt="" style="height: 10rem" />
                                                                            <c:choose>
                                                                                <c:when test="${loginUser.getRole_id()>2}">
                                                                                    <c:choose>
                                                                                        <c:when test="${search!=null}">
                                                                                            <div class="text-center px-0 px-lg-5">
                                                                                                <h5>
                                                                                                    Cannot find any class has word ${search}!
                                                                                                </h5>
                                                                                            </div>
                                                                                        </c:when>
                                                                                        <c:otherwise> 
                                                                                            <div class="text-center px-0 px-lg-5">
                                                                                                <h5>
                                                                                                    You don't have any iteration here!
                                                                                                </h5>
                                                                                            </div>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <div class="text-center px-0 px-lg-5">
                                                                                        <h5>
                                                                                            There are no milestones here! Check again this subject's milestones now!
                                                                                        </h5>
                                                                                        <p class="mb-4">Our generation system is now online. You can start checking again this subject on our system.</p>
                                                                                        <a href="milestone?type=${class.getSubject().getSubject_id()}" class="btn btn-primary">Check subject milestone now</a>
                                                                                    </div>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:forEach var="iteration" items="${requestScope.LIST_ITERATION}">
                                                                            <li class="slot-item">              
                                                                                <div class="slot-item__thumb">                    
                                                                                    <div class="top-head-slot mg-b-12">
                                                                                        <div class="left-top-head-slot">
                                                                                            <i class="las la-angle-down mg-r-5"></i>
                                                                                            <a class="slot-label text-bold text-decoration-none" href="">${iteration.getIteration_name()}</a>
                                                                                            <time class="fs-14"><i class="fa-regular fa-calendar" style="padding: 0 10px;"></i></time>
                                                                                        </div>
                                                                                        <div class="right-top-head-slot">
                                                                                            <a href="" class="text-decoration-none text-lightbold">View detail</a>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="wrap-slot-name">
                                                                                        <h4 class="slot-name text-bold">${iteration.getDescription()}</h4>
                                                                                    </div>      
                                                                                </div>                           
                                                                                <ul class="list-activities none-list" style="display: none;">
                                                                                    <c:set value="${class.getMilestones(iteration.getIteration_id(),loginUser)}" var="listMilestone"></c:set>
                                                                                    <c:choose>
                                                                                        <c:when test="${listMilestone!=null&&listMilestone.size()>0}">
                                                                                            <c:forEach var="milestone" items="${listMilestone}">
                                                                                                <li class="activity-item activity-822928">                      
                                                                                                    <div class="activity-item__icon">                                       
                                                                                                    </div>                      
                                                                                                    <div class="activity-item__sumary">         
                                                                                                        <a class="mg-b-0 text-normal activity-name text-decoration-none d-flex flex-column" href="/en/session/activity?sessionid=98679&amp;activityId=822928" title="${milestone.getMilestone_name()}">
                                                                                                            <div class="d-flex justify-content-between align-items-center">
                                                                                                                <span class="activity-name text-semibold mg-b-10">${milestone.getMilestone_name()}</span>
                                                                                                                <time class="fs-14 text-dark"><i class="fa-regular fa-calendar" style="padding: 0 10px;"></i>${milestone.getFrom_format()} - ${milestone.getTo_format()} (GMT+07)</time>
                                                                                                            </div>
                                                                                                            <span class="activity-state-label fs-12 ended">${milestone.getStatusValue()}</span>
                                                                                                        </a>                           
                                                                                                    </div>                   
                                                                                                </li>
                                                                                            </c:forEach>    
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <div class="text-center px-0 px-lg-5">
                                                                                                <h6>
                                                                                                    You don't have any milestone here!
                                                                                                </h6>
                                                                                            </div>
                                                                                        </c:otherwise>
                                                                                    </c:choose>               
                                                                                </ul>                        
                                                                            </li>
                                                                        </c:forEach>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </section>
                                            </div>
                                        </div>
                                    </div>
                                    <aside id="course-sidebar" class="col-12 col-lg-5 col-xl-5 course-sidebar hide-on-992">
                                        <div class="wrap-course-sidebar course-sidebar-sticky">
                                            <div class="top w-100">
                                                <div class="course-thumb-wrap">
                                                </div>
                                                <div class="course-sumary-desktop pd-15">
                                                    <div class="dropdown mg-b-16 filter-class">
                                                        <label for="class" class="form-label">Class</label>
                                                        <button class="form-select text-capitalize border-0 border-bottom bg-transparent d-flex align-items-start" id="class" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                            ${class.getClass_code()}-${class.getSetting().getSetting_title()}-${class.getClass_year()}
                                                        </button>
                                                        <div class="dropdown-menu" aria-labelledby="class">
                                                            <c:forEach items="${sessionScope.LIST_CLASS}" var="classChoose">
                                                                <a class="dropdown-item text-capitalize" href="class?service=detail&id=${classChoose.class_id}">(${classChoose.getSubject().getSubject_code()}) ${classChoose.class_code} (${classChoose.getSetting().getSetting_title()}-${classChoose.class_year})</a>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                    <div class="course-sumary" style="">
                                                        <ul class="none-list mg-0 mg-t-20 session-member-info fs-14">
                                                            <li class="total-online has-online"><h4 class="fs-24 mg-0 count">2</h4><span>online</span></li>
                                                            <li class="total-member text-center"><a href="classUser?class=${class.getClass_id()}"><h4 class="fs-24 mg-0 count">${class.getClass_user()}</h4><span class="text-dark">students</span></a></li>
                                                        </ul>
                                                    </div>
                                                    <div class="lectures-section mg-t-20">
                                                        <div class="heading-lectures-section mg-b-20"><h4 class="fs-16 mg-0">Lecturer</h4></div>
                                                        <ul class="none-list mg-0">
                                                            <li class="lecture-item mg-b-16">
                                                                <div class="user-acc">
                                                                    <img src="${class.getTrainer().getAvatar_link()!=null?class.getTrainer().getAvatar_link():!class.getTrainer().isGender()?"assets/img/illustrations/profiles/profile-1.png":"assets/img/illustrations/profiles/profile-2.png"}" alt="${class.getTrainer().getEmail().toUpperCase()}" class="user-avatar rounded-circle">
                                                                    <div class="acc-content-right">
                                                                        <div class="wrap-user-name">
                                                                            <span class="user-name text-semibold  fs-14 text-uppercase" title="${class.getTrainer().getEmail().toUpperCase()}">${class.getTrainer().getEmail().toUpperCase()}</span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                    <div class="lectures-section mg-t-20">
                                                        <div class="heading-lectures-section mg-b-20"><h4 class="fs-16 mg-0">Semester - Year</h4></div>
                                                        <ul class="none-list mg-0">
                                                            <li class="lecture-item mg-b-16">
                                                                <div class="user-acc">
                                                                    <div class="acc-content-right">
                                                                        <div class="wrap-user-name">
                                                                            <span class="user-name fs-14">${class.getSetting().getSetting_title()} - ${class.getClass_year()}</span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                    <div class="lectures-section mg-t-20">
                                                        <div class="heading-lectures-section mg-b-20"><h4 class="fs-16 mg-0">Status</h4></div>
                                                        <ul class="none-list mg-0">
                                                            <li class="lecture-item mg-b-16">
                                                                <div class="user-acc">
                                                                    <div class="acc-content-right">
                                                                        <div class="wrap-user-name">
                                                                            <span class="user-name fs-14">${class.isBlock5_class()?"<span class='badge bg-red-soft text-red'>Block 5</span>  -  ":""}${class.isStatus()?"<span class='badge bg-green-soft text-green'>Active</span>":"<span class='badge bg-red-soft text-red'>Inactive</span>"}</span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                                <div class="row mg-t-10 update-button-detail" style="display: none;"></div>
                                                <div class="row mg-t-10 export-class-activity" style="display: block;"></div>
                                            </div>
                                        </div>
                                    </aside>
                                </div>
                            </article>
                        </div>
                        <jsp:include page="../included/footer.jsp"/>
                    </main>
                </div>
            </div>
        </div>
        <script src="js/scripts.js"></script>
        <script>
            $(document).on('click', '.list-slots .slot-item__thumb', function (e) {
                if (!$(e.target).attr('href')) {
                    e.preventDefault();
                    let $this = $(this).closest('.slot-item');
                    if ($this.hasClass('active')) {
                        $this.removeClass('active');
                        $this.find('.list-activities').slideUp(300);
                    } else {
                        $this.addClass('active');
                        $this.find('.list-activities').slideDown(300);
                    }
                    setTimeout(function () {
                        $(".course-sidebar-sticky").trigger("sticky_kit:recalc");
                    }, 350);
                }
            });
            setTimeout(function () {
                let siteMainPaddingTop = parseInt($('.site-main').css('padding-top'));
                let titleHeight = $('.course-name').outerHeight(true);
                let courseCode = $('.course-code-title').outerHeight(true);
                $('.course-detail-overlay').css('height', siteMainPaddingTop + titleHeight + courseCode + 130);
            }, 50);
        </script>
    </body>
</html>
