<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminUrl" value="${ctx}/admin" />
<c:set var="adminRes" value="${ctx}/resources/common/admin" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Admin - Dashboard</title>

    <link href="${adminRes}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">
    <link href="${adminRes}/css/sb-admin-2.min.css" rel="stylesheet">
</head>

<body id="page-top">

<div id="wrapper">

    <!-- Sidebar -->
    <!-- Sidebar -->
<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

    <a class="sidebar-brand d-flex align-items-center justify-content-center" href="${adminUrl}">
        <div class="sidebar-brand-icon">
            <i class="fas fa-user-shield"></i>
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

    <li class="nav-item">
        <a class="nav-link" href="${adminUrl}/user">
            <i class="fas fa-fw fa-users"></i>
            <span>User Admin</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link" href="${adminUrl}/pay">
            <i class="fas fa-fw fa-credit-card"></i>
            <span>Pay Admin</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link" href="${adminUrl}/board">
            <i class="fas fa-fw fa-clipboard-list"></i>
            <span>Board Admin</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link" href="${adminUrl}/music">
            <i class="fas fa-fw fa-music"></i>
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

                <!-- 상단 카드 -->
                <div class="row">

                    <!-- 최근 5일 가입자 총합 -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-primary shadow h-100 py-2">
                            <div class="card-body">
                                <div id="signupTotal" class="h5 mb-0 font-weight-bold text-gray-800">0</div>
                                <div class="text-xs font-weight-bold text-primary text-uppercase">
                                    최근 5일 가입자 합계
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 최근 5일 결제 승인 총합 -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-success shadow h-100 py-2">
                            <div class="card-body">
                                <div id="payTotal" class="h5 mb-0 font-weight-bold text-gray-800">0</div>
                                <div class="text-xs font-weight-bold text-success text-uppercase">
                                    최근 5일 결제 승인 합계
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- READY 건수 -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-warning shadow h-100 py-2">
                            <div class="card-body">
                                <div id="readyCount" class="h5 mb-0 font-weight-bold text-gray-800">0</div>
                                <div class="text-xs font-weight-bold text-warning text-uppercase">
                                    결제 READY
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- APPROVED 건수 -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-info shadow h-100 py-2">
                            <div class="card-body">
                                <div id="approvedCount" class="h5 mb-0 font-weight-bold text-gray-800">0</div>
                                <div class="text-xs font-weight-bold text-info text-uppercase">
                                    결제 APPROVED
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- 차트 영역 -->
                <div class="row">

                    <!-- 가입자 라인차트 -->
                    <div class="col-xl-8 col-lg-7">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">최근 5일 가입자</h6>
                            </div>
                            <div class="card-body">
                                <div style="height:320px;">
                                    <canvas id="myAreaChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 결제 상태 도넛 -->
                    <div class="col-xl-4 col-lg-5">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">결제 상태 분포</h6>
                            </div>
                            <div class="card-body">
                                <div style="height:320px;">
                                    <canvas id="myPieChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- 바차트 -->
                <div class="row">
                    <div class="col-xl-12 col-lg-12">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">최근 5일 결제 승인</h6>
                            </div>
                            <div class="card-body">
                                <div style="height:320px;">
                                    <canvas id="myBarChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- Footer -->
        <footer class="sticky-footer bg-white">
            <div class="container my-auto text-center">
                <span>808 &copy; Admin 2026</span>
            </div>
        </footer>

    </div>
</div>

<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>

<script src="${adminRes}/vendor/jquery/jquery.min.js"></script>
<script src="${adminRes}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${adminRes}/vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="${adminRes}/js/sb-admin-2.min.js"></script>
<script src="${adminRes}/vendor/chart.js/Chart.min.js"></script>

<script>
$(function () {

    var areaChart = null;
    var barChart = null;
    var pieChart = null;

    function sumArray(arr) {
        var total = 0;
        for (var i = 0; i < arr.length; i++) {
            total += Number(arr[i] || 0);
        }
        return total;
    }

    function buildLineChart(labels, data) {
        var ctx = document.getElementById('myAreaChart').getContext('2d');
        if (areaChart) areaChart.destroy();

        areaChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: '가입자',
                    data: data,
                    backgroundColor: "rgba(78, 115, 223, 0.2)",
                    borderColor: "rgba(78, 115, 223, 1)",
                    pointBackgroundColor: "rgba(78, 115, 223, 1)",
                    pointBorderColor: "#fff",
                    pointRadius: 4,
                    fill: true
                }]
            },
            options: {
                maintainAspectRatio: false,
                scales: {
                    yAxes: [{
                        ticks: { beginAtZero: true, precision: 0 }
                    }]
                }
            }
        });
    }

    function buildBarChart(labels, data) {
        var ctx = document.getElementById('myBarChart').getContext('2d');
        if (barChart) barChart.destroy();

        barChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: '결제 승인',
                    data: data,
                    backgroundColor: "rgba(28, 200, 138, 0.7)",
                    borderColor: "rgba(28, 200, 138, 1)",
                    borderWidth: 1
                }]
            },
            options: {
                maintainAspectRatio: false,
                scales: {
                    yAxes: [{
                        ticks: { beginAtZero: true, precision: 0 }
                    }]
                }
            }
        });
    }

    function buildPieChart(labels, data) {
        var ctx = document.getElementById('myPieChart').getContext('2d');
        if (pieChart) pieChart.destroy();

        var colorMap = {
            READY: "#f6c23e",
            APPROVED: "#1cc88a",
            FAIL: "#e74a3b",
            CANCEL: "#858796"
        };

        var colors = labels.map(function(label) {
            return colorMap[label] || "#4e73df";
        });

        pieChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: data,
                    backgroundColor: colors,
                    borderWidth: 1
                }]
            },
            options: {
                maintainAspectRatio: false,
                legend: {
                    position: 'bottom'
                }
            }
        });
    }

    $.getJSON('<c:url value="/admin/api/stats/signupLast5"/>', function(res) {
        var labels = res.map(function(x) { return x.label; });
        var data = res.map(function(x) { return x.cnt; });

        $('#signupTotal').text(sumArray(data));
        buildLineChart(labels, data);
    });

    $.getJSON('<c:url value="/admin/api/stats/payLast5"/>', function(res) {
        var labels = res.map(function(x) { return x.label; });
        var data = res.map(function(x) { return x.cnt; });

        $('#payTotal').text(sumArray(data));
        buildBarChart(labels, data);
    });

    $.getJSON('<c:url value="/admin/api/stats/payStatus"/>', function(res) {
        var labels = res.map(function(x) { return x.label; });
        var data = res.map(function(x) { return x.cnt; });

        buildPieChart(labels, data);

        var statusMap = {};
        for (var i = 0; i < res.length; i++) {
            statusMap[res[i].label] = res[i].cnt;
        }

        $('#readyCount').text(statusMap.READY || 0);
        $('#approvedCount').text(statusMap.APPROVED || 0);
    });

});
</script>

</body>
</html>