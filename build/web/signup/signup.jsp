<%-- 
    Document   : signup
    Created on : May 17, 2022, 7:53:26 AM
    Author     : Admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
        <jsp:include page="../included/head.jsp" />
        <link href="css/site.css" rel="stylesheet" />
    </head>
    <body class="identity-site">
        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
        <c:if test="${loginUser != null}">
            <c:redirect url="dashBoarđ"></c:redirect>
        </c:if>
        <h1 id="site-logo"> 
            <a class="btn return-home-page text-bold padding-0" href="home.jsp" title="EduNext"><img src="assets/img/logo_project.jpg" alt="EduProject"></a>
        </h1>
        <main id="wrap-main-content" style="margin: 0 0 90px;">
            <div class="identity-tabs">
                <a class="btn bg-transparent active">Register</a>
            </div>
            <form class="indentity-form" action="signup" method="post">
                <input hidden="" value="signup" name="service">
                <div class="row">
                    <div class="wrap-form-field col-9">
                        <label for="rollNumber" class="form-label">Roll Number</label>
                        <div class="form-group group-width-icon">
                            <i class="fa-solid fa-user"></i>
                            <input class="form-control"  placeholder="Roll Number" autofocus="" type="text" id="rollNumber" name="rollNumber" maxlength="40">
                        </div>
                    </div>
                    <div class="wrap-form-field col-3">
                        <label class="small mb-1" for="gender">Gender</label>
                        <div id="gender">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" id="male" value="1">
                                <label class="form-check-label" for="male">Male</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" id="female" value="0">
                                <label class="form-check-label" for="female">Female</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="wrap-form-field">
                    <label for="fullname" class="form-label">Full Name<span style="color: red">*</span></label>
                    <div class="form-group group-width-icon">
                        <i class="fa-solid fa-user"></i>
                        <input class="form-control" placeholder="Full name" autofocus="" type="text" data-val="true" data-val-required="Name is required" required="" title="Wrong format" id="fullname" name="fullname" 
                               pattern="^[A-ZÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ][a-zàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]*(?:[ ][A-ZÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ][a-zàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]*)*$" 
                               maxlength="40">
                    </div>
                </div>
                <div class="wrap-form-field">
                    <label for="email" class="form-label">Your email<span style="color: red">*</span></label>
                    <div class="form-group group-width-icon">
                        <i class="fa-solid fa-envelope"></i>
                        <input class="form-control" placeholder="Email" autofocus="" type="email" data-val="true" data-val-required="Email is required" required="" pattern="[a-z0-9._%+-]+@fpt.edu.vn$" id="email" name="email" maxlength="40">
                    </div>
                    <span class="text-danger field-validation-valid" data-valmsg-for="Username" data-valmsg-replace="true"></span>
                </div>
                <div class="row">
                    <div class="wrap-form-field col">
                        <label for="password" class="form-label">Password<span style="color: red">*</span></label>
                        <div class="form-group group-width-icon">
                            <i class="fa-solid fa-lock"></i>
                            <input type="password" id="password" class="form-control" placeholder="Password" autocomplete="off" data-val="true" data-val-required="Password is required" required="" id="password" maxlength="40" name="password">
                            <label for="password" onclick="showPassword(this)">
                                <i class="fa-solid fa-eye eye-icon"></i>
                            </label>
                        </div>
                        <span class="text-danger field-validation-valid" data-valmsg-for="Password" data-valmsg-replace="true"></span>
                    </div>
                    <div class="wrap-form-field col">
                        <label for="passwordCf" class="form-label">Confirm password<span style="color: red">*</span></label>
                        <div class="form-group group-width-icon">
                            <i class="fa-solid fa-lock"></i>
                            <input type="password" id="passwordCf" class="form-control" placeholder="Password" autocomplete="off" data-val="true" data-val-required="Password is required" required="" maxlength="40" name="passwordCf">
                            <label for="passwordCf" onclick="showPassword(this)">
                                <i class="fa-solid fa-eye eye-icon"></i>
                            </label>
                        </div>
                        <span class="text-danger field-validation-valid" data-valmsg-for="Password" data-valmsg-replace="true"></span>
                    </div>
                </div>
                <div class="row">
                    <div class="wrap-form-field col">
                        <label for="mobile" class="form-label">Mobile phone</label>
                        <div class="form-group group-width-icon">
                            <i class="fa-solid fa-mobile-screen-button"></i>
                            <input class="form-control" placeholder="Mobile" pattern="^[0][0-9]{9}$" title="Invalid phone number" autofocus="" type="text" id="mobile" name="mobile" maxlength="10">
                        </div>
                    </div>
                    <div class="wrap-form-field col">
                        <label for="dob" class="form-label">Date of Birth</label>
                        <div class="form-group group-width-icon">
                            <i class="fa-solid fa-cake-candles"></i>
                            <input class="form-control" type="date" id="dob" name="date_of_birth">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="g-recaptcha h-100 col-9 ms-auto" data-sitekey="6LeGd_gfAAAAACOK46jb-mLZYsVm4Io_B4InlvQs" style="margin: 0 0 20px;"></div>
                </div>
                <button class="btn btn-primary edn-btn-login" type="submit" value="Create an account" name="submit">Create an account</button>
                <a class="btn return-home-page text-bold padding-0" href="home.jsp" title="EduNext">Return to home page</a>
                <div>Already have account? <a href="login?service=loginPage" title="Login">Sign in</a></div>
            </form>
        </main>
        <div id="forest-ext-shadow-host"></div>
        <script src="js/scripts.js"></script>
    </body>
    <script src='https://www.google.com/recaptcha/api.js'></script>
    <script>
                                function findLableForControl(el) {
                                    var idVal = el.id;
                                    labels = document.getElementsByTagName('label');
                                    for (var i = 0; i < labels.length; i++) {
                                        if (labels[i].htmlFor === idVal)
                                            return labels[i];
                                    }
                                }
                                var gender = document.querySelector('#btn-check-outlined');
                                var label = findLableForControl(gender);
                                gender.addEventListener('click', function () {
                                    label.innerHTML = gender.checked ? 'Male' : 'Female';
                                    document.getElementById('gender').value = gender.checked ? 1 : 0;
                                });
    </script>
</html>
