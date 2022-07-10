<%-- 
    Document   : login
    Created on : 10-05-2022, 18:16:30
    Author     : hanhu
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login Page</title>
        <jsp:include page="../included/head.jsp" />
        <link href="css/site.css" rel="stylesheet" />
    </head>
    <body class="identity-site">
        <c:if test="${loginUser != null}">
            <c:redirect url="dashBoarđ"></c:redirect>
        </c:if>
        <h1 id="site-logo"> 
            <a class="btn return-home-page text-bold padding-0" href="home.jsp" title="EduNext"><img src="assets/img/logo_project.jpg" alt="EduProject"></a>
        </h1>
        <main id="wrap-main-content">
            <div class="identity-tabs">
                <a class="btn bg-transparent active">Login</a>
            </div>
            <ul class="list-social-login">
                <li class="social-login-item">
                    <a class="btn btn-social-login google-login" href="https://accounts.google.com/o/oauth2/auth?scope=email&redirect_uri=http://localhost:8080/g2/login&response_type=code&client_id=678513387419-k250dkg2v4u23nhv8mq15cselgj5a9b1.apps.googleusercontent.com&approval_prompt=force">
                        <img src="assets/img/logo-gg-new.png" class="" alt="Login with Google account">
                        Sign in with @fpt.edu.vn
                    </a>
                </li>
            </ul>
            <form class="indentity-form" action="login" method="post">
                <input hidden="" value="login" name="service"> 
                <div class="wrap-form-field">
                    <div class="form-group group-width-icon">
                        <i class="fa-solid fa-user"></i>
                        <input class="form-control" placeholder="Email" autofocus="" type="text" data-val="true" data-val-required="Username is required" required="" id="Username" name="Username" maxlength="40" value="${cookie['cookieUserName'].value}" >
                    </div>
                    <span class="text-danger field-validation-valid" data-valmsg-for="Username" data-valmsg-replace="true"></span>
                </div>
                <div class="wrap-form-field">
                    <div class="form-group group-width-icon">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" id="passwordLogin" class="form-control" placeholder="Password" autocomplete="off" data-val="true" data-val-required="Password is required" required="" id="Password" maxlength="40" name="Password" value="${cookie['cookiePassword'].value}">
                        <label for="passwordLogin" onclick="showPassword(this)">
                            <i class="fa-solid fa-eye eye-icon"></i>
                        </label>
                    </div>
                    <span class="text-danger field-validation-valid" data-valmsg-for="Password" data-valmsg-replace="true"></span>
                </div>

                <div class="d-flex justify-content-between align-items-center btn padding-0 bg-transparent">

                    <div class="form-check d-flex align-items-center w-100">
                        <input type="checkbox" class="form-check-input mt-0" style="margin-right: 10px" id="remember" name="RememberMe" ${cookie['cookieRemember'].value != null?"checked":""} value="remember"/>
                        <label class="form-check-label" for="remember">Remember Me</label>
                    </div>
                    <a class="w-100 padding-0 text-end" href="../signup?service=forgotPW" title="Forgot Password">Forgot Your Password</a>
                </div>
                <div class="row">
                    <div class=" col-lg-6"><input type="submit" class="btn btn-primary edn-btn-login " value="Log In"></input></div>
                    <div class=" col-lg-6"><input type="reset" class="btn btn-light edn-btn-re " value="Reset"></input></div>
                </div>

                <a class="btn return-home-page text-bold padding-0" href="../home.jsp" title="EduNext">Return to home page</a>

                <div>Do not have account? <a href="signup" title="Sign up">Sign up</a></div>
            </form>
        </main>
        <div id="forest-ext-shadow-host"></div>
        <script src="js/scripts.js"></script>
    </body>
</html>
