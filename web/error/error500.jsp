<%-- 
    Document   : error
    Created on : May 13, 2022, 8:42:48 PM
    Author     : win
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>500 Error - SB Admin Pro</title>
        <link href="css/styles.css" rel="stylesheet" />
        <jsp:include page="../included/head.jsp"/>
    </head>
    <body class="bg-white">
        <jsp:include page="../included/header.jsp"/>
        <div id="layoutError">
            <div id="layoutError_content">
                <main>
                    <div class="container-xl px-4">
                        <div class="row justify-content-center">
                            <div class="col-lg-6">
                                <div class="text-center mt-4">
                                    <img class="img-fluid p-4" src="assets/img/illustrations/500-internal-server-error.svg" alt="" />
                                    <p class="lead">The server encountered an internal error or misconfiguration and was unable to complete your request.</p>
                                    <a class="text-arrow-icon" href="javascript:history.back()">
                                        <i class="ms-0 me-1" data-feather="arrow-left"></i>
                                        Return to previous page
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <jsp:include page="../included/footer.jsp"/>
        <script>
            $('#sidebarToggle').hide();
        </script>
    <script src="js/scripts.js"></script>
</body>
</html>
