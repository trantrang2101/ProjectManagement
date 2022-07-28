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
    <body class="bg-primary">
        <div id="layoutAuthentication">
            <div id="layoutAuthentication_content">
                <main>
                    <div class="container-xl px-4">
                        <div class="row justify-content-center">
                            <div class="col-xl-5 col-lg-6 col-md-8 col-sm-11">
                                <div class="card my-5">
                                    <div class="card-body p-5 text-center"><div class="h3 fw-light mb-0">Password Recovery</div></div>
                                    <hr class="my-0" />
                                    <div class="card-body p-5">
                                        <div class="text-center small text-muted mb-4">Enter your email address below and we will send you a link to reset your password.</div>
                                        <form action="signup">
                                            <div class="mb-3">
                                                <label class="text-gray-600 small" for="email">Email address<span style="color: red">*</span></label>
                                                <input class="form-control form-control-solid" placeholder="Email" autofocus="" type="email" value="${requestScope.EMAIL!=null?requestScope.EMAIL:""}" data-val="true" pattern="[a-z0-9._%+-]+@(fpt|fu).edu.vn$" data-val-pattern="You must input fpt education email" data-val-required="Email is required" title="You must input fpt education email" maxlength="40" required="" id="email" name="email">
                                            </div>
                                            <button class="btn btn-primary" name="service" value="forgotPW">Reset Password</button>
                                        </form>
                                    </div>
                                    <hr class="my-0" />
                                    <div class="card-body px-5 py-4">
                                        <div class="small text-center">
                                            New user?
                                            <a href="signup">Create an account!</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="js/scripts.js"></script>
    <script src="js/scripts.js"></script>
</body>
</html>
