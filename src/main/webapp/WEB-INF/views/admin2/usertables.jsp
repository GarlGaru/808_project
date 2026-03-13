<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminRes" value="${ctx}/resources/common/admin" />
<c:set var="adminUrl" value="${ctx}/admin" />

<!DOCTYPE html>
<html lang="ko">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Admin - User Tables</title>

<link href="${adminRes}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">
<link href="${adminRes}/css/sb-admin-2.min.css" rel="stylesheet">
<link href="${adminRes}/vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">

<style>
    .table td, .table th {
        vertical-align: middle;
        text-align: center;
    }

    .card-header h6 {
        margin-bottom: 0;
    }

    .table thead th {
        background-color: #f8f9fc;
        font-weight: 700;
        white-space: nowrap;
    }

    .table tbody tr:hover {
        background-color: #f8f9fc;
    }

    .table td {
        white-space: nowrap;
    }

    .page-title-sub {
        color: #858796;
        margin-bottom: 1.5rem;
    }
</style>

</head>

<body id="page-top">

<div id="wrapper">

    <!-- Sidebar -->
    <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

        <a class="sidebar-brand d-flex align-items-center justify-content-center" href="${adminUrl}">
            <div class="sidebar-brand-icon">
                <i class="fas fa-user-shield"></i>
            </div>
            <div class="sidebar-brand-text mx-3">808 ADMIN</div>
        </a>

        <hr class="sidebar-divider my-0">

        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}">
                <i class="fas fa-fw fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>

        <li class="nav-item active">
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

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

        <div id="content">

            <!-- Topbar -->
            <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 shadow">
                <span class="h5 mb-0 text-gray-800">회원 관리</span>
            </nav>

            <!-- Page Content -->
            <div class="container-fluid">

                <h1 class="h3 mb-2 text-gray-800">회원관리</h1>
                <p class="page-title-sub">회원 목록 및 계정 정보 확인</p>

                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="font-weight-bold text-primary">회원데이터</h6>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered" id="dataTable" width="100%">
                                <thead>
                                    <tr>
                                        <th>유저번호</th>
                                        <th>유저아이디</th>
                                        <th>비밀번호</th>
                                        <th>닉네임</th>
                                        <th>이메일인증여부 0/1</th>
                                        <th>가입일</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${userList}">
                                        <tr>
                                            <td>${user.userId}</td>
                                            <td>${user.email}</td>
                                            <td>${user.password}</td>
                                            <td>${user.nickname}</td>
                                            <td>${user.emailVerified}</td>
                                            <td>${user.createdAt}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
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

<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>

<script src="${adminRes}/vendor/jquery/jquery.min.js"></script>
<script src="${adminRes}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${adminRes}/vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="${adminRes}/js/sb-admin-2.min.js"></script>
<script src="${adminRes}/vendor/datatables/jquery.dataTables.min.js"></script>
<script src="${adminRes}/vendor/datatables/dataTables.bootstrap4.min.js"></script>

<script>
    $(document).ready(function() {
        $('#dataTable').DataTable({
            "pageLength": 10,
            "lengthMenu": [10, 25, 50, 100],
            "ordering": true,
            "searching": true,
            "language": {
                "search": "검색:",
                "lengthMenu": "_MENU_ 개씩 보기",
                "info": "_START_ ~ _END_ / 총 _TOTAL_개",
                "paginate": {
                    "first": "처음",
                    "last": "마지막",
                    "next": "다음",
                    "previous": "이전"
                },
                "zeroRecords": "검색 결과가 없습니다.",
                "infoEmpty": "데이터가 없습니다."
            }
        });
    });
</script>

</body>
</html>