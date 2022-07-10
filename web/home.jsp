    <%-- 
    Document   : home
    Created on : 10-05-2022, 19:50:37
    Author     : hanhu
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="included/head.jsp"/>
        <link href="css/styles.css" rel="stylesheet" />
        <title>Home Page</title>
    </head>
    <body>
        <jsp:include page="included/header.jsp"/>
        <main id="site-main" class="site-main">
            <section id="top-head" class="landing-section gray-bg">
                <div class="container">
                    <div class="row">
                        <div class="col-12 col-md-6 d-flex align-items-center mg-b-20">
                            <div class="wrap-content">
                                <h2 class="title-section fs-32 mg-b-10 text-bold">Social Constructive Learning</h2>
                                <p class="fs-18 mg-b-15">Construct knowledge and personalize the learning way to empower learners' full potential.</p>
                                <a href="login.jsp" class="signup-link btn btn-primary btn-main-v4 btn-large-v4 ttf-none" title="Join now">Join now</a>
                            </div>
                        </div>
                        <div class="col-12 col-md-6 d-flex align-items-center mg-b-20">
                            <img src="https://fustatic.edunext.vn/assets/parts/landing-2/imgs/landing-pc-1.png" alt="Banner EduProject" lazied="">
                        </div>
                    </div>
                </div>
            </section>
            <section id="why-constructive" class="landing-section">
                <div class="container">
                    <h2 class="title-section fs-32 mg-b-30 align-center text-bold text-center">Personalization In Learning</h2>
                    <div class="row">
                        <div class="col-12 col-md-6 d-flex align-items-center mg-b-20">
                            <img src="https://fustatic.edunext.vn/assets/parts/landing-2/imgs/landing-pc-2.png" alt=">Personalization In Learning" lazied="">
                        </div>
                        <div class="col-12 col-md-6 d-flex align-items-center mg-b-20">
                            <div class="wrap-content">
                                <p>Self-paced learning means you are in control of what you learn and when you learn it.</p>
                                <p>Construct knowledge and discuss in groups with high quality mentors and friends.</p>
                            </div>
                        </div>

                    </div>
                </div>
            </section>
            <section id="persionalized-learning" class="landing-section gray-bg">
                <div class="container">
                    <h2 class="title-section fs-32 mg-b-30 align-center text-bold text-center">Comprehensive Constructive Platform</h2>
                    <div class="row">
                        <div class="col-12 col-md-6 d-flex align-items-center mg-b-20">
                            <ul class="wrap-content none-list pd-0">
                                <li class="mg-b-30 hidden">
                                    <img src="https://fustatic.edunext.vn/assets/parts/landing-2/imgs/landing-pc-3-1.png" alt="Learn at the individual pace" lazied="">
                                    <div class="right-list-content pd-l-15">
                                        <h3 class="fs-20 mg-b-5">Learn at the individual pace</h3>
                                        <p class="mg-0">Personalized learning involves learners in deciding their learning process. Thus, learners can level up according to their strengths and weaknesses.</p>
                                    </div>
                                </li>
                                <li class="mg-b-30">
                                    <img src="https://fustatic.edunext.vn/assets/parts/landing-2/imgs/landing-pc-3-2.png" alt="Provide constructive teaching tools" lazied="">
                                    <div class="right-list-content pd-l-15">
                                        <h3 class="fs-20 mg-b-5">Provide constructive teaching tools</h3>
                                        <p class="mg-0">Using a variety of tools provided on the EduProject for constructive teaching and learning.</p>
                                    </div>
                                </li>
                                <li>
                                    <img src="https://fustatic.edunext.vn/assets/parts/landing-2/imgs/landing-pc-3-3.png" alt="Group discussion 24/7" lazied="">
                                    <div class="right-list-content pd-l-15">
                                        <h3 class="fs-20 mg-b-5">Group discussion 24/7</h3>
                                        <p class="mg-0">Discuss with friends and mentors anytime, anywhere.</p>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-12 col-md-6 d-flex align-items-center wrap-pic mg-b-20">
                            <img src="https://fustatic.edunext.vn/assets/parts/landing-2/imgs/landing-pc-3.png" alt="Persionalized Learning" lazied="">
                        </div>
                    </div>
                </div>
            </section>
        </main>
        <jsp:include page="included/footer.jsp"/>
    <script src="js/scripts.js"></script>
</body>
</html>
