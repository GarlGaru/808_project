<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminUrl" value="${ctx}/admin" />
<c:set var="adminRes" value="${ctx}/resources/common/admin" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Admin - Dashboard</title>

    <!-- fonts -->
    <link href="${adminRes}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">

    <!-- SB Admin CSS -->
    <link href="${adminRes}/css/sb-admin-2.min.css" rel="stylesheet">
</head>

<body id="page-top">

<div id="wrapper">

    <!-- Sidebar -->
    <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

        <a class="sidebar-brand d-flex align-items-center justify-content-center" href="${adminUrl}">
            <div class="sidebar-brand-icon rotate-n-15">
                <i class="fas fa-laugh-wink"></i>
            </div>
            <div class="sidebar-brand-text mx-3">808 ADMIN</div>
        </a>

        <hr class="sidebar-divider my-0">

        <li class="nav-item active">
            <a class="nav-link" href="${adminUrl}">
                <i class="fas fa-fw fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>

        <hr class="sidebar-divider">

        <div class="sidebar-heading">Components</div>

        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}/buttons">
                <i class="fas fa-fw fa-cog"></i>
                <span>Buttons</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}/cards">
                <i class="fas fa-fw fa-layer-group"></i>
                <span>Cards</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}/charts">
                <i class="fas fa-fw fa-chart-area"></i>
                <span>Charts</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}/user">
                <i class="fas fa-fw fa-table"></i>
                <span>User Admin</span>
            </a>
        </li>
        
        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}/pay">
                <i class="fas fa-fw fa-table"></i>
                <span>Pay Admin</span>
            </a>
        </li>
        
        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}/board">
                <i class="fas fa-fw fa-table"></i>
                <span>Board Admin</span>
            </a>
        </li>
        
        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}/music">
                <i class="fas fa-fw fa-table"></i>
                <span>Music Admin</span>
            </a>
        </li>

        <hr class="sidebar-divider d-none d-md-block">

    </ul>
    <!-- End Sidebar -->

    <div id="content-wrapper" class="d-flex flex-column">
        <div id="content">

            <!-- Topbar -->
            <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
                <span class="navbar-brand">808 Admin Dashboard</span>
            </nav>

            <!-- Page Content -->
            <div class="container-fluid">

                <div class="row">

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-primary shadow h-100 py-2">
                            <div class="card-body">
                                <div class="h5 mb-0 font-weight-bold text-gray-800">$40,000</div>
                                <div class="text-xs font-weight-bold text-primary text-uppercase">
                                    Earnings (Monthly)
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-success shadow h-100 py-2">
                            <div class="card-body">
                                <div class="h5 mb-0 font-weight-bold text-gray-800">$215,000</div>
                                <div class="text-xs font-weight-bold text-success text-uppercase">
                                    Earnings (Annual)
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Chart Area -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Earnings Overview</h6>
                    </div>
                    <div class="card-body">
                        <canvas id="myAreaChart"></canvas>
                    </div>
                </div>

            </div>
        </div>

        <!-- Footer -->
        <footer class="sticky-footer bg-white">
            <div class="container my-auto text-center">
                <span>Copyright &copy; Admin 2026</span>
            </div>
        </footer>

    </div>
</div>

<!-- Scroll Button -->
<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>

<!-- JS (절대 삭제 금지 영역) -->
<script src="${adminRes}/vendor/jquery/jquery.min.js"></script>
<script src="${adminRes}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${adminRes}/vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="${adminRes}/js/sb-admin-2.min.js"></script>
<script src="${adminRes}/vendor/chart.js/Chart.min.js"></script>
<script src="${adminRes}/js/demo/chart-area-demo.js"></script>
<script src="${adminRes}/js/demo/chart-pie-demo.js"></script>

</body>
</html>