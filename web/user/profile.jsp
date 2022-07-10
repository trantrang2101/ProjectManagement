<%-- 
    Document   : profile
    Created on : May 18, 2022, 8:55:38 AM
    Author     : win
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <c:set var="userChoose" value="${sessionScope.CHOOSE_USER}"></c:set>
        <head>
        <jsp:include page="../included/head.jsp" />
        <link href="css/site.css" rel="stylesheet" />
        <link href="css/styles.css" rel="stylesheet" />
        <title>Account Settings - ${userChoose!=null?userChoose.getFull_name():'Add User'}</title>
    </head>
    <body>
        <c:set var="loginUser" value="${sessionScope.LOGIN_USER}"></c:set>
            <div class="nav-fixed">
            <jsp:include page="../included/header.jsp"/>
            <div id="layoutSidenav">
                <jsp:include page="../included/slider.jsp"/>
                <div id="layoutSidenav_content">
                    <main>
                        <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                            <div class="container-xl px-4">
                                <div class="page-header-content">
                                    <div class="row align-items-center justify-content-between pt-3">
                                        <div class="col-auto mb-3">
                                            <h1 class="page-header-title">
                                                <div class="page-header-icon"><i data-feather="user"></i></div>
                                                Account Settings - Profile
                                            </h1>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </header>
                        <c:if test="${loginUser.getUser_id()!=userChoose.getUser_id()}">
                            <nav class="mt-4 container rounded bg-light" aria-label="breadcrumb">
                                <ol class="breadcrumb px-3 py-2 rounded mb-0">
                                    <li class="breadcrumb-item"><a href="dashBoard">Dashboard</a></li>
                                    <li class="breadcrumb-item"><a href="user"> User List</a></li>
                                        <c:if test="${userChoose!=null}">
                                        <li class="breadcrumb-item text-capitalize"><a href="user?type=${userChoose.role_id}"> ${sessionScope.LIST_ROLES_SETTING.get(userChoose.role_id-1).getSetting_title()} </a></li>
                                        <li class="breadcrumb-item active">${userChoose.getFull_name()}</li>
                                        </c:if>
                                </ol>
                            </nav>
                        </c:if>
                        <div class="container-xl px-4 mt-4">
                            <div class="row">
                                <div class="col-xl-4">
                                    <div class="card mb-4 mb-xl-0" style="margin-bottom: 20px !important;">
                                        <div class="card-header">Profile Picture</div>
                                        <div class="card-body text-center">
                                            <div id="avata_link">
                                                <img class="img-account-profile rounded-circle mb-2" alt="Avatar image"  src="${userChoose!=null&&userChoose.getAvatar_link()!=null?userChoose.getAvatar_link():!userChoose.isGender()?"assets/img/illustrations/profiles/profile-1.png":"assets/img/illustrations/profiles/profile-2.png"}" alt="" />
                                            </div>
                                            <c:if test="${userChoose!=null&&loginUser.getUser_id()==userChoose.getUser_id()}">
                                                <form action="profile" method="POST" enctype='multipart/form-data'>
                                                    <label class="btn btn-outline-primary">
                                                        Upload new photo
                                                        <input type="file" class="account-settings-fileinput" hidden="" onchange="readURL(this)" id="inputImage" multiple="false" name="userImage" accept="image/*">
                                                    </label> &nbsp;
                                                    <button type="submit" class="btn btn-default md-btn-flat">Upload</button>&nbsp;
                                                    <button type="reset" class="btn btn-default md-btn-flat">Reset</button>
                                                    <div class="small mg-t-20 font-italic text-muted mb-4">JPG or PNG no larger than 5 MB</div>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                    <c:if test="${userChoose!=null&&loginUser.getRole_id()==1}">
                                        <div class="card mb-4 mb-xl-0">
                                            <div class="card-header">Account Status: ${userChoose.isStatus()?"<span class='badge bg-green-soft text-green'>Active</span>":"<span class='badge bg-red-soft text-red'>Inactive</span>"}</div>
                                            <div class="card-body">
                                                <a class="btn btn-primary" href="user?service=changeStatus&id=${userChoose.getUser_id()}&status=${userChoose.isStatus()}">Change Status</a>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                                <div class="col-xl-8">
                                    <div class="card mb-4">
                                        <c:choose>
                                            <c:when test="${loginUser.getUser_id()==userChoose.getUser_id()}">
                                                <form action="profile" method="POST">
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="user" method="POST">
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="card-header">Account Details</div>
                                                <div class="card-body">
                                                    <div class="mb-3 row">
                                                        <div class="col-sm-3 col-xl-4">
                                                            <label class="small mb-1" for="inputID">User ID</label>
                                                            <input class="form-control bg-primary-soft" name="id" disabled="" id="inputID" type="email" placeholder="Enter your email address" value="${userChoose!=null?userChoose.getUser_id():0}" />
                                                            <input class="form-control" name="id" hidden="" type="text" placeholder="Enter your email address" value="${userChoose!=null?userChoose.getUser_id():0}" />
                                                        </div>
                                                        <div class="col-sm-9 col-xl-8">
                                                            <label class="small mb-1" for="inputEmailAddress">Email address (*)</label>
                                                            <input class="form-control ${userChoose==null||(userChoose!=null&&loginUser.getRole_id()>1)?'bg-primary-soft':''}" name="email" ${userChoose!=null?"disabled=''":""} onchange="document.getElementById('emailValue').value = this.value;" id="inputEmailAddress" type="email" placeholder="Enter your email address" value="${userChoose!=null?userChoose.getEmail():''}" />
                                                            <input class="form-control" name="email" hidden="" type="email" placeholder="Enter your email address" id="emailValue" value="${userChoose!=null?userChoose.getEmail():''}" />
                                                        </div>
                                                    </div>
                                                    <div class="mb-3 row">
                                                        <div class="col-sm-3 col-xl-4 d-flex flex-column justify-content-between align-items-start">
                                                            <label class="small mb-1" for="gender">Gender (*)</label>
                                                            <div id="gender">
                                                                <div class="form-check form-check-inline">
                                                                    <input ${userChoose!=null?(userChoose.getUser_id()!=loginUser.getUser_id()&&loginUser.getRole_id()<2?"":"disabled=''"):''} class="form-check-input" type="radio" name="gender" ${userChoose!=null&&userChoose.isGender()?'checked=""':''} id="male" value="1">
                                                                    <label class="form-check-label" for="male">Male</label>
                                                                </div>
                                                                <div class="form-check form-check-inline">
                                                                    <input ${userChoose!=null?(userChoose.getUser_id()!=loginUser.getUser_id()&&loginUser.getRole_id()<2?"":"disabled=''"):''} class="form-check-input" type="radio" name="gender" ${userChoose!=null&&!userChoose.isGender()?'checked=""':''} id="female" value="0">
                                                                    <label class="form-check-label" for="female">Female</label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-sm-9 col-xl-8">
                                                            <label class="small mb-1" for="inputFullName">Full Name (*)</label>
                                                            <input class="form-control ${userChoose==null||(userChoose!=null&&loginUser.getRole_id()>1)?'bg-primary-soft':''}" ${userChoose!=null?(userChoose.getUser_id()!=loginUser.getUser_id()&&loginUser.getRole_id()<2?"":"disabled=''"):''} required="" name="fullname" id="inputFullName" type="text" placeholder="Enter your full name" value="${userChoose!=null?userChoose.getFull_name():''}"/>
                                                        </div>
                                                    </div>
                                                    <div class="row gx-3 mb-3">
                                                        <div class="col-sm-3 col-xl-4">
                                                            <label for="role_id" class="form-label">Role</label>
                                                            <select ${userChoose!=null?(userChoose.getUser_id()!=loginUser.getUser_id()&&loginUser.getRole_id()<2?"":"disabled=''"):''} id="role_id" name="role_id" ${sessionScope.LOGIN_ROLE.getSetting_title().equalsIgnoreCase("admin")&&loginUser.getUser_id()!=userChoose.getUser_id()?"":"disabled=''"} class="form-select form-control ${userChoose==null||(userChoose!=null&&loginUser.getRole_id()>1)?'bg-primary-soft':''}">
                                                                <c:forEach items="${sessionScope.LIST_ROLES_SETTING}" var="role">
                                                                    <c:choose>
                                                                        <c:when test="${userChoose!=null&&role.setting_id==userChoose.role_id}">
                                                                            <option value="${role.setting_id}" selected="">${role.setting_title}</option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="${role.setting_id}">${role.setting_title}</option>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </select>
                                                            <input type="text" name="role_id" value="${userChoose!=null?userChoose.role_id:''}" hidden="" id="changeRole">
                                                        </div>
                                                        <div class="col-sm-9 col-xl-8" id="formRollNum">
                                                            <label for="rollNumber" class="form-label">Roll Number <span class="text-gray-500">(required if user is a student)</span></label>
                                                            <input ${userChoose!=null?(userChoose.getUser_id()!=loginUser.getUser_id()&&loginUser.getRole_id()<2?"":"disabled=''"):''} class="form-control ${userChoose==null||(userChoose!=null&&loginUser.getRole_id()>1)?'bg-primary-soft':''}" ${userChoose!=null&&userChoose.role_id==4?"":"disabled=''"} placeholder="Roll Number" autofocus="" value="${userChoose!=null?userChoose.getRoll_number():''}" type="text" id="rollNumber" name="rollNumber" maxlength="40">
                                                        </div>
                                                    </div>
                                                    <div class="row gx-3 mb-3">
                                                        <div class="col-sm-3 col-xl-4">
                                                            <label class="small mb-1" for="inputPhone">Phone number</label>
                                                            <input class="form-control ${userChoose==null||(userChoose!=null&&loginUser.getRole_id()>1)?'bg-primary-soft':''}" ${userChoose!=null?(userChoose.getUser_id()!=loginUser.getUser_id()&&loginUser.getRole_id()<2?"":"disabled=''"):''} name="mobile" id="inputPhone" type="tel" placeholder="Enter your phone number" value="${userChoose!=null?userChoose.getMobile():''}" />
                                                        </div>
                                                        <div class="col-sm-3 col-xl-4">
                                                            <label class="small mb-1" for="inputBirthday">Birthday</label>
                                                            <input hidden="" type="text" id="birthday" value="${userChoose.getDate_of_birth()}">
                                                            <input class="form-control ${userChoose==null||(userChoose!=null&&loginUser.getRole_id()>1)?'bg-primary-soft':''}" ${userChoose!=null?(userChoose.getUser_id()!=loginUser.getUser_id()&&loginUser.getRole_id()<2?"":"disabled=''"):''} id="inputBirthday" type="date" name="date_of_birth" placeholder="Enter your birthday" value="" />
                                                        </div>
                                                        <div class="col-sm-6 col-xl-4">
                                                            <label class="small mb-1" for="facebookLink">Facebook</label>
                                                            <input ${userChoose!=null?(userChoose.getUser_id()!=loginUser.getUser_id()&&loginUser.getRole_id()<2?"":"disabled=''"):''} class="form-control ${userChoose!=null&&loginUser.getUser_id()!=userChoose.getUser_id()?"bg-primary-soft":""}" name="facebook_link" type="url" placeholder="${userChoose!=null&&loginUser.getUser_id()!=userChoose.getUser_id()?'You are not allow to edit this field':'Enter your facebook link'}" ${userChoose!=null&&loginUser.getUser_id()!=userChoose.getUser_id()?"disabled=''":""} value="${userChoose!=null?userChoose.getFacebook_link():''}" />
                                                        </div>
                                                    </div>
                                                    <c:if test="${userChoose!=null?(userChoose.getUser_id()!=loginUser.getUser_id()&&loginUser.getRole_id()<2):loginUser.getRole_id()<2}">
                                                        <button class="btn btn-primary" name="service" value="update" type="submit">Save changes</button>
                                                        <button class="btn btn-light" type="reset">Cancel</button>
                                                    </c:if>
                                                </div>
                                            </form>
                                    </div>
                                    <c:if test="${userChoose!=null&&loginUser.getUser_id()==userChoose.getUser_id()}">
                                        <div class="card mb-4">
                                            <div class="card-header">Change Password</div>
                                            <div class="card-body">
                                                <form action="profile" method="POST">
                                                    <input class="form-control" name="email" hidden="" type="email" placeholder="Enter your email address" value="${userChoose!=null?userChoose.getEmail():''}" />
                                                    <div class="wrap-form-field col">
                                                        <label for="passwordCurrent" class="form-label">Current Password</label>
                                                        <div class="form-group group-width-icon">
                                                            <i class="fa-solid fa-lock"></i>
                                                            <input type="password" id="passwordCurrent" class="form-control" placeholder="Password" autocomplete="off" data-val="true" data-val-required="Password is required" required="" id="passwordCurrent" maxlength="40" name="passwordCurrent">
                                                            <label for="passwordCurrent" onclick="showPassword(this)">
                                                                <i class="fa-solid fa-eye eye-icon"></i>
                                                            </label>
                                                        </div>
                                                        <span class="text-danger field-validation-valid" data-valmsg-for="Password" data-valmsg-replace="true"></span>
                                                    </div>
                                                    <div class="wrap-form-field col">
                                                        <label for="password" class="form-label">Password</label>
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
                                                        <label for="passwordCf" class="form-label">Confirm password</label>
                                                        <div class="form-group group-width-icon">
                                                            <i class="fa-solid fa-lock"></i>
                                                            <input type="password" id="passwordCf" class="form-control" placeholder="Password" autocomplete="off" data-val="true" data-val-required="Password is required" required="" maxlength="40" name="passwordCf">
                                                            <label for="passwordCf" onclick="showPassword(this)">
                                                                <i class="fa-solid fa-eye eye-icon"></i>
                                                            </label>
                                                        </div>
                                                        <span class="text-danger field-validation-valid" data-valmsg-for="Password" data-valmsg-replace="true"></span>
                                                    </div>
                                                    <button class="btn btn-primary" type="submit" name="service" value="changePW">Save</button>
                                                    <button class="btn btn-light" type="reset">Cancel</button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </main>
                    <jsp:include page="../included/footer.jsp"/>
                </div>
            </div>
        </div>
        <script>
            function readURL(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        console.log(e.target.result);
                        var ava = document.querySelector('#avata_link');
                        while (ava.firstChild) {
                            ava.removeChild(ava.firstChild);
                        }
                        var image = document.createElement('img');
                        image.classList.add('img-account-profile', 'rounded-circle', 'mb-2');
                        image.alt = 'Avatar image';
                        image.src = e.target.result !== "" ? e.target.result : "${userChoose.getAvatar_link()!=null?userChoose.getAvatar_link():!userChoose.isGender()?"assets/img/illustrations/profiles/profile-1.png":"assets/img/illustrations/profiles/profile-2.png"}";
                        ava.appendChild(image);
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }
            $("#role_id").on("change", function () {
                if (this.value == 4) {
                    document.getElementById("rollNumber").disabled = false;
                    document.getElementById("rollNumber").classList.remove('bg-primary-soft');
                    $('#changeRole').value = this.value;
                } else {
                    document.getElementById("rollNumber").disabled = true;
                    document.getElementById("rollNumber").classList.add('bg-primary-soft');
                    $('#changeRole').value = '';
                }
            });
            window.addEventListener('DOMContentLoaded', event => {
                var bir = document.querySelector('#birthday');
                if (bir != null && bir.value != '') {
                    var day = bir.value.split(' ')[0].split('-');
                    var time = bir.value.split(' ')[1].split(':');
                    document.querySelector('#inputBirthday').value = moment(new Date(day[0], day[1] - 1, day[2], time[0], time[1])).format('YYYY-MM-DD');
                }
                document.querySelector('#inputBirthday').setAttribute("max", moment.now());
                document.querySelector('#inputBirthday').max = new Date().toISOString().split("T")[0];
            });
        </script>
        <script src="js/scripts.js"></script>
    </body>
</html>
