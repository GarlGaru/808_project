<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminRes" value="${ctx}/resources/common/admin" />
<c:set var="adminUrl" value="${ctx}/admin" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Admin - Charts</title>

    <!-- FontAwesome -->
    <link href="${adminRes}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">

    <!-- SB Admin CSS -->
    <link href="${adminRes}/css/sb-admin-2.min.css" rel="stylesheet">
</head>

<body id="page-top">

<div id="wrapper">

    <!-- Sidebar -->
    <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion">

        <a class="sidebar-brand d-flex align-items-center justify-content-center" href="${adminUrl}">
            <div class="sidebar-brand-icon rotate-n-15">
                <i class="fas fa-chart-area"></i>
            </div>
            <div class="sidebar-brand-text mx-3">Admin</div>
        </a>

        <hr class="sidebar-divider my-0">

        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}">
                <i class="fas fa-fw fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>

        <li class="nav-item active">
            <a class="nav-link" href="${adminUrl}/charts">
                <i class="fas fa-fw fa-chart-area"></i>
                <span>Charts</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}/cards">
                <i class="fas fa-fw fa-id-card"></i>
                <span>Cards</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}/buttons">
                <i class="fas fa-fw fa-cog"></i>
                <span>Buttons</span>
            </a>
        </li>

        <hr class="sidebar-divider d-none d-md-block">

    </ul>

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

        <div id="content">

            <!-- Topbar -->
            <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 shadow">
                <span class="h5 mb-0 text-gray-800">Charts Page</span>
            </nav>

            <!-- Page Content -->
            <div class="container-fluid">

                <h1 class="h3 mb-4 text-gray-800">Charts</h1>

                <div class="row">

                    <!-- Area Chart -->
                    <div class="col-xl-8 col-lg-7">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Area Chart</h6>
                            </div>
                            <div class="card-body">
                                <div class="chart-area">
                                    <canvas id="myAreaChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Bar Chart -->
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Bar Chart</h6>
                            </div>
                            <div class="card-body">
                                <div class="chart-bar">
                                    <canvas id="myBarChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Pie Chart -->
                    <div class="col-xl-4 col-lg-5">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Donut Chart</h6>
                            </div>
                            <div class="card-body">
                                <div class="chart-pie pt-4">
                                    <canvas id="myPieChart"></canvas>
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
                <span>Copyright &copy; Admin 2026</span>
            </div>
        </footer>

    </div>

</div>

<!-- Scroll Top -->
<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>

<!-- JS -->
<script src="${adminRes}/vendor/jquery/jquery.min.js"></script>
<script src="${adminRes}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${adminRes}/vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="${adminRes}/js/sb-admin-2.min.js"></script>

<!-- Chart.js -->
<script src="${adminRes}/vendor/chart.js/Chart.min.js"></script>



<script>
$(function () {

  var areaChart = null;
  var barChart  = null;
  var pieChart  = null;

  /* =======================
     1. Line (가입자)
  ======================= */
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
            ticks: { beginAtZero: true }
          }]
        }
      }
    });
  }

  /* =======================
     2. Bar (결제 승인)
  ======================= */
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
            ticks: { beginAtZero: true }
          }]
        }
      }
    });
  }

  /* =======================
     3. Pie (결제 상태)
  ======================= */
  function buildPieChart(labels, data) {
    var ctx = document.getElementById('myPieChart').getContext('2d');
    if (pieChart) pieChart.destroy();

    var colorMap = {
      READY: "#f6c23e",
      APPROVED: "#1cc88a",
      FAIL: "#e74a3b",
      CANCEL: "#858796"
    };

    var colors = labels.map(function(l){
      return colorMap[l] || "#4e73df";
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
        legend: { position: 'bottom' }
      }
    });
  }

  /* =======================
     API 호출
  ======================= */

  $.getJSON('<c:url value="/admin/api/stats/signupLast5"/>', function(res){
    var labels = res.map(function(x){ return x.label; });
    var data   = res.map(function(x){ return x.cnt; });
    buildLineChart(labels, data);
  });

  $.getJSON('<c:url value="/admin/api/stats/payLast5"/>', function(res){
    var labels = res.map(function(x){ return x.label; });
    var data   = res.map(function(x){ return x.cnt; });
    buildBarChart(labels, data);
  });

  $.getJSON('<c:url value="/admin/api/stats/payStatus"/>', function(res){
    var labels = res.map(function(x){ return x.label; });
    var data   = res.map(function(x){ return x.cnt; });
    buildPieChart(labels, data);
  });

});
</script>

</body>
</html>