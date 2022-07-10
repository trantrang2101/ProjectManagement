<%-- 
   Document   : slider
   Created on : 10-05-2022, 16:43:09
   Author     : hanhu
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*;"%>
<div id="layoutSidenav_nav">
    <nav class="sidenav shadow-right sidenav-light">
        <div class="sidenav-menu">
            <div class="nav accordion" id="accordionSidenav">
                <div class="sidenav-menu-heading d-sm-none">Account</div>
                <a class="nav-link d-sm-none" href="#!">
                    <div class="nav-link-icon"><i data-feather="bell"></i></div>
                    Alerts
                    <span class="badge bg-warning-soft text-warning ms-auto">4 New!</span>
                </a>
                <a class="nav-link d-sm-none" href="#!">
                    <div class="nav-link-icon"><i data-feather="mail"></i></div>
                    Messages
                    <span class="badge bg-success-soft text-success ms-auto">2 New!</span>
                </a>
                <c:if test="${sessionScope.LOGIN_USER.getRole_id()<3}">
                    <div class="sidenav-menu-heading">Admin</div>
                    <a class="nav-link" href="setting">
                        <div class="nav-link-icon"><i data-feather="settings"></i></div>
                        Setting
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                    <a class="nav-link" href="user">
                        <div class="nav-link-icon"><i data-feather="globe"></i></div>
                        User
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                    <a class="nav-link" href="subject">
                        <div class="nav-link-icon"><i class="fa-solid fa-id-card"></i></div>
                        Subject
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                </c:if>
                <c:if test="${sessionScope.LOGIN_USER.getRole_id()<4}">
                    <div class="sidenav-menu-heading">Author</div>
                    <a class="nav-link" href="subjectSetting">
                        <div class="nav-link-icon"><i data-feather="sliders"></i></div>
                        Subject Setting
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                    <a class="nav-link" href="iteration">
                        <div class="nav-link-icon"><i data-feather="tool"></i></div>
                        Iteration
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                    <a class="nav-link" href="criteria">
                        <div class="nav-link-icon"><i data-feather="codesandbox"></i></div>
                        Criteria
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                </c:if>
                <div class="sidenav-menu-heading">TEACHER</div>
                <a class="nav-link" href="class">
                    <div class="nav-link-icon"><i class="fa-solid fa-chalkboard-user"></i></div>
                    Classroom
                    <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                </a>
                <c:if test="${sessionScope.LIST_CLASS.size()!=0}">
                    <a class="nav-link" href="classUser?class=${sessionScope.LIST_CLASS.get(0).class_id}">
                        <div class="nav-link-icon"><i data-feather="users"></i></div>
                        Classroom Students
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                    <a class="nav-link" href="classSetting">
                        <div class="nav-link-icon"><i class="fa-solid fa-hammer"></i></div>
                        Classroom Setting
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                    <a class="nav-link" href="milestone?class=${sessionScope.LIST_CLASS.get(0).class_id}">
                        <div class="nav-link-icon"><i data-feather="repeat"></i></div>
                        Milestone
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                    <a class="nav-link" href="team">
                        <div class="nav-link-icon"><i data-feather="command"></i></div>
                        Team
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                </c:if>
                <div class="sidenav-menu-heading">STUDENT</div>
                <c:if test="${sessionScope.LIST_CLASS.size()!=0}">
                    <a class="nav-link" href="feature?class=${sessionScope.LIST_CLASS.get(0).class_id}">
                        <div class="nav-link-icon"><i class="fa-solid fa-network-wired"></i></div>
                        Feature
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                    <a class="nav-link" href="function">
                        <div class="nav-link-icon"><i class="fa-solid fa-code-fork"></i></div>
                        Function
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                    <a class="nav-link" href="issue">
                        <div class="nav-link-icon"><i data-feather="tool"></i></div>
                        Issue
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                    <a class="nav-link" href="tracking?class=${sessionScope.LIST_CLASS.get(0).class_id}">
                        <div class="nav-link-icon"><i class="fa-brands fa-stack-overflow"></i></div>
                        Tracking
                        <div class="sidenav-collapse-arrow"><i class="fas fa-angle-right"></i></div>
                    </a>
                </c:if>
            </div>
        </div>
        <!-- Sidenav Footer-->
        <div class="sidenav-footer">
            <div class="sidenav-footer-content">
                <div class="sidenav-footer-subtitle">Logged in as:</div>
                <div class="sidenav-footer-title">${sessionScope.LOGIN_USER.getFull_name()}</div>
            </div>
        </div>
    </nav>
</div>
