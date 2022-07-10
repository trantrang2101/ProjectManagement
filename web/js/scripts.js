/*!
 * Start Bootstrap - SB Admin Pro v2.0.3 (https://shop.startbootstrap.com/product/sb-admin-pro)
 * Copyright 2013-2021 Start Bootstrap
 * Licensed under SEE_LICENSE (https://github.com/StartBootstrap/sb-admin-pro/blob/master/LICENSE)
 */
function showPassword(item) {
    var inputPW = item.parentElement.getElementsByClassName('form-control')[0];
    console.log(inputPW);
    var eye = item.parentElement.getElementsByClassName('eye-icon')[0];
    console.log(eye);
    if (inputPW.type === 'text') {
        inputPW.type = 'password';
        eye.classList = "fa-solid fa-eye eye-icon";
    } else {
        inputPW.type = 'text';
        eye.classList = "fa-solid fa-eye-slash eye-icon";
    }
}
var labels = document.getElementsByTagName('LABEL');
function findLableForControl(el) {
    for (var i = 0; i < labels.length; i++) {
        if (labels[i].htmlFor != '') {
            if (labels[i].htmlFor == el) {
                return labels[i];
            }
        }
    }
    return null;
}
function changeStatus(id, trueValue, falseValue) {
    var label = findLableForControl(id);
    if (document.getElementById(id)&&document.getElementById(id).tagName=='input'&&document.getElementById(id).type=='checkbox') {
        if (document.getElementById(id).checked) {
            label.innerHTML = trueValue;
        } else {
            label.innerHTML = falseValue;
        }
    }
}
if ($("textarea") != null) {
    $("textarea").each(function () {
        this.setAttribute("style", "height:" + (this.scrollHeight) + "px;overflow-y:hidden;");
    }).on("input", function () {
        this.style.height = "auto";
        this.style.height = (this.scrollHeight) + "px";
    });
}
window.addEventListener('DOMContentLoaded', event => {
    changeStatus('status', 'Activate', 'Deactivate');
    changeStatus('leader', 'Leader', 'Member');
    changeStatus('block5', 'Block 5', 'Block 10');
    feather.replace();
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
    const stickyNav = document.body.querySelector('#stickyNav');
    if (stickyNav) {
        new bootstrap.ScrollSpy(document.body, {
            target: '#stickyNav',
            offset: 82,
        });
    }
    const sidebarToggle = document.body.querySelector('#sidebarToggle');
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', event => {
            event.preventDefault();
            document.body.classList.toggle('sidenav-toggled');
            localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sidenav-toggled'));
            console.log(sidebarToggle);
        });
    }
    const sidenavContent = document.body.querySelector('#layoutSidenav_content');
    if (sidenavContent) {
        sidenavContent.addEventListener('click', event => {
            const BOOTSTRAP_LG_WIDTH = 992;
            if (window.innerWidth >= 992) {
                return;
            }
            if (document.body.classList.contains("sidenav-toggled")) {
                document.body.classList.toggle("sidenav-toggled");
            }
        });
    }

    let activatedPath = window.location.pathname.match(/([\w-]+\.html)/, '$1');

    if (activatedPath) {
        activatedPath = activatedPath[0];
    } else {
        activatedPath = 'index.html';
    }

    const targetAnchors = document.body.querySelectorAll('[href="' + activatedPath + '"].nav-link');

    targetAnchors.forEach(targetAnchor => {
        let parentNode = targetAnchor.parentNode;
        while (parentNode !== null && parentNode !== document.documentElement) {
            if (parentNode.classList.contains('collapse')) {
                parentNode.classList.add('show');
                const parentNavLink = document.body.querySelector(
                        '[data-bs-target="#' + parentNode.id + '"]'
                        );
                parentNavLink.classList.remove('collapsed');
                parentNavLink.classList.add('active');
            }
            parentNode = parentNode.parentNode;
        }
        targetAnchor.classList.add('active');
    });
    var pagePagnation = document.querySelectorAll('.page-pagination');
    if (pagePagnation !== null && pagePagnation.length > 0) {
        var pageNormal = document.querySelectorAll('.page-normal');
        var k = 9 - Number(pagePagnation.length - pageNormal.length);
        var thisPage = Number(document.querySelector('#thisPage').value);
        for (var i = 0, max = pageNormal.length; i < max; i++) {
            if (k === 6) {
                if (i > thisPage + k - 2 || i < thisPage - k) {
                    pageNormal[i].classList.add('fade');
                }
            } else {
                if (i < thisPage - Math.floor(k / 2) - 1 || i > thisPage + Math.floor(k / 2) - 1) {
                    pageNormal[i].classList.add('fade');
                }
            }
        }
    }
});