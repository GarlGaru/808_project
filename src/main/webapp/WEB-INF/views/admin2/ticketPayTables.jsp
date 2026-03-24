<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminRes" value="${ctx}/resources/common/admin" />
<c:set var="adminUrl" value="${ctx}/admin" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin - Ticket Pay Tables</title>

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

        .badge {
            font-size: 0.85rem;
            padding: 0.45em 0.7em;
            border-radius: 0.35rem;
        }
    </style>
</head>

<body id="page-top">

<div id="wrapper">

    <!-- Sidebar -->
		<ul
			class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion"
			id="accordionSidebar">

			<a
				class="sidebar-brand d-flex align-items-center justify-content-center"
				href="${adminUrl}">
				<div class="sidebar-brand-icon">
					<i class="fas fa-user-shield"></i>
				</div>
				<div class="sidebar-brand-text mx-3">808 ADMIN</div>
			</a>

			<hr class="sidebar-divider my-0">

			<li class="nav-item"><a class="nav-link"
				href="${adminUrl}"> <i class="fas fa-fw fa-tachometer-alt"></i>
					<span>Dashboard</span>
			</a></li>

			<li class="nav-item"><a class="nav-link" href="${adminUrl}/user">
					<i class="fas fa-fw fa-users"></i> <span>User Admin</span>
			</a></li>

			<li class="nav-item"><a class="nav-link" href="${adminUrl}/pay">
					<i class="fas fa-fw fa-credit-card"></i> <span>Pay Admin</span>
			</a></li>

			<li class="nav-item"><a class="nav-link"
				href="${adminUrl}/board"> <i class="fas fa-fw fa-clipboard-list"></i>
					<span>Board Admin</span>
			</a></li>

			<li class="nav-item"><a class="nav-link"
				href="${adminUrl}/music"> <i class="fas fa-fw fa-music"></i> <span>Music
						Admin</span>
			</a></li>
			
			<li class="nav-item active">
			    <a class="nav-link" href="${adminUrl}/ticketpay">
			        <i class="fas fa-fw fa-ticket-alt"></i>
			        <span>Ticket Pay Admin</span>
			    </a>
			</li>

			<hr class="sidebar-divider d-none d-md-block">

		</ul>
		<!-- End Sidebar -->

    <div id="content-wrapper" class="d-flex flex-column">
        <div id="content">

            <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 shadow">
                <span class="h5 mb-0 text-gray-800">티켓 결제 관리</span>
            </nav>

            <div class="container-fluid">
                <h1 class="h3 mb-2 text-gray-800">TICKET PAY Tables</h1>
                <p class="page-title-sub">티켓 결제 데이터 조회</p>

                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="font-weight-bold text-primary">티켓결제데이터</h6>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered" id="dataTable" width="100%">
                                <thead>
                                <tr>
                                    <th>주문번호</th>
                                    <th>좌석번호</th>
                                    <th>공연ID</th>
                                    <th>회차ID</th>
                                    <th>좌석가격</th>
                                    <th>티켓상태</th>
                                    <th>생성일</th>
                                    <th>취소일</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="t" items="${ticketPayList}">
                                    <tr data-status="${t.ticketStatus}">
                                        <td>${t.orderId}</td>
                                        <td>${t.seatId}</td>
                                        <td>${t.showId}</td>
                                        <td>${t.scheduleId}</td>
                                        <td>${t.ticketPrice}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${t.ticketStatus eq 'APPROVED'}">
                                                    <span class="badge badge-success">APPROVED</span>
                                                </c:when>
                                                <c:when test="${t.ticketStatus eq 'CANCEL'}">
                                                    <span class="badge badge-warning">CANCEL</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-dark">${t.ticketStatus}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><fmt:formatDate value="${t.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                        <td><fmt:formatDate value="${t.canceledAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>

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

        $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
            if (settings.nTable.id !== 'dataTable') {
                return true;
            }

            var selectedStatus = $('#statusFilter').val();
            if (!selectedStatus) {
                return true;
            }

            var rowNode = settings.aoData[dataIndex].nTr;
            var rowStatus = $(rowNode).attr('data-status');

            return rowStatus === selectedStatus;
        });

        var table = $('#dataTable').DataTable({
            "pageLength": 10,
            "lengthMenu": [10, 25, 50, 100],
            "ordering": true,
            "order": [[6, "desc"]],
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
            },
            "initComplete": function () {
                var filterHtml =
                    '<label style="margin-left:10px;">' +
                    '상태:' +
                    '<select id="statusFilter" class="custom-select custom-select-sm form-control form-control-sm" ' +
                    'style="width:auto; display:inline-block; margin-left:5px;">' +
                    '<option value="">전체</option>' +
                    '<option value="APPROVED">APPROVED</option>' +
                    '<option value="CANCEL">CANCEL</option>' +
                    '</select>' +
                    '</label>';

                $('#dataTable_filter').append(filterHtml);

                $('#statusFilter').on('change', function () {
                    table.draw();
                });
            }
        });
    });
</script>

</body>
</html>