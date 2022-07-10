<%-- 
    Document   : index
    Created on : 10-05-2022, 16:44:41
    Author     : hanhu
--%>
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
    <head>
        <jsp:include page="included/head.jsp" />
        <link href="css/styles.css" rel="stylesheet" />
        <title class="text-capitalize">Dashboard</title>
    </head>
    <body>
        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
        <c:set var="search" value="${requestScope.SEARCH_WORD}"></c:set>
            <div class="nav-fixed">
            <jsp:include page="included/header.jsp"/>
            <div id="layoutSidenav">
                <jsp:include page="included/slider.jsp"/>
                <div id="layoutSidenav_content">
                    <main>
                        <div class="container-xl px-4 mt-5">
                            <div class="d-flex justify-content-between align-items-sm-center flex-column flex-sm-row mb-4">
                                <div class="me-4 mb-3 mb-sm-0">
                                    <h1 class="mb-0 text-bold">Dashboard</h1>
                                    <div class="small" id="nowTime">
                                    </div>
                                </div>
                            </div>
                            <div class="card card-waves mb-4 mt-5">
                                <div class="card-body p-5">
                                    <div class="row align-items-center justify-content-between">
                                        <div class="col">
                                            <h2 class="text-primary">Welcome back, your dashboard is ready!</h2>
                                            <p class="text-gray-700">Great job, your affiliate dashboard is ready to go! You can
                                                view sales, generate links, prepare coupons, and download affiliate reports
                                                using this dashboard.</p>
                                            <a class="btn btn-primary p-3" href="#!">
                                                Get Started
                                                <i class="ms-1" data-feather="arrow-right"></i>
                                            </a>
                                        </div>
                                        <div class="col d-none d-lg-block mt-xxl-n4"><img class="img-fluid px-xl-4 mt-xxl-n5" src="assets/img/illustrations/statistics.svg" /></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xl-3 col-md-6 mb-4">
                                    <div class="card border-start-lg border-start-primary h-100">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center">
                                                <div class="flex-grow-1">
                                                    <div class="small fw-bold text-primary mb-1">Earnings (monthly)</div>
                                                    <div class="h5">$4,390</div>
                                                    <div class="text-xs fw-bold text-success d-inline-flex align-items-center">
                                                        <i class="me-1" data-feather="trending-up"></i>
                                                        12%
                                                    </div>
                                                </div>
                                                <div class="ms-2"><i class="fas fa-dollar-sign fa-2x text-gray-200"></i></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-3 col-md-6 mb-4">
                                    <!-- Dashboard info widget 2-->
                                    <div class="card border-start-lg border-start-secondary h-100">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center">
                                                <div class="flex-grow-1">
                                                    <div class="small fw-bold text-secondary mb-1">Average sale price</div>
                                                    <div class="h5">$27.00</div>
                                                    <div class="text-xs fw-bold text-danger d-inline-flex align-items-center">
                                                        <i class="me-1" data-feather="trending-down"></i>
                                                        3%
                                                    </div>
                                                </div>
                                                <div class="ms-2"><i class="fas fa-tag fa-2x text-gray-200"></i></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-3 col-md-6 mb-4">
                                    <!-- Dashboard info widget 3-->
                                    <div class="card border-start-lg border-start-success h-100">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center">
                                                <div class="flex-grow-1">
                                                    <div class="small fw-bold text-success mb-1">Clicks</div>
                                                    <div class="h5">11,291</div>
                                                    <div class="text-xs fw-bold text-success d-inline-flex align-items-center">
                                                        <i class="me-1" data-feather="trending-up"></i>
                                                        12%
                                                    </div>
                                                </div>
                                                <div class="ms-2"><i class="fas fa-mouse-pointer fa-2x text-gray-200"></i></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-3 col-md-6 mb-4">
                                    <!-- Dashboard info widget 4-->
                                    <div class="card border-start-lg border-start-info h-100">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center">
                                                <div class="flex-grow-1">
                                                    <div class="small fw-bold text-info mb-1">Conversion rate</div>
                                                    <div class="h5">1.23%</div>
                                                    <div class="text-xs fw-bold text-danger d-inline-flex align-items-center">
                                                        <i class="me-1" data-feather="trending-down"></i>
                                                        1%
                                                    </div>
                                                </div>
                                                <div class="ms-2"><i class="fas fa-percentage fa-2x text-gray-200"></i></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <jsp:include page="included/footer.jsp"/>
                    </main>
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