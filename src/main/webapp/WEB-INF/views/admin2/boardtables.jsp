<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminRes" value="${ctx}/resources/common/admin" />
<c:set var="adminUrl" value="${ctx}/admin" />

<!DOCTYPE html>
<html lang="ko">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Admin - Tables</title>

<link href="${adminRes}/vendor/fontawesome-free/css/all.min.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900"
	rel="stylesheet">
<link href="${adminRes}/css/sb-admin-2.min.css" rel="stylesheet">
<link href="${adminRes}/vendor/datatables/dataTables.bootstrap4.min.css"
	rel="stylesheet">

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

			<li class="nav-item"><a class="nav-link" href="${adminUrl}">
					<i class="fas fa-fw fa-tachometer-alt"></i> <span>Dashboard</span>
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

			<hr class="sidebar-divider d-none d-md-block">

		</ul>

		<!-- Content Wrapper -->
		<div id="content-wrapper" class="d-flex flex-column">

			<div id="content">

				<!-- Topbar -->
				<nav
					class="navbar navbar-expand navbar-light bg-white topbar mb-4 shadow">
					<span class="h5 mb-0 text-gray-800">Tables Page</span>
				</nav>

				<!-- Page Content -->
				<div class="container-fluid">

					<h1 class="h3 mb-2 text-gray-800">Tables</h1>

					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">DataTables
								Example</h6>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered" id="dataTable" width="100%">
									<thead>
										<tr>
											<th>BNO</th>
											<th>USER_ID</th>
											<th>nickname</th>
											<th>TITLE</th>
											<th>CONTENT</th>
											<th>VIEWCNT</th>
											<th>YOUTUBE_URL</th>
											<th>관리</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="row" items="${list}">
											<tr>
												<td>${row.bno}</td>
												<td>${row.userId}</td>
												<td>${row.nickname}</td>
												<td>${row.title}</td>
												<td><a
													href="${ctx}/board/board_update?bno=${row.bno}&user_id=${row.userId}"
													style="text-decoration: none; color: inherit;"> 
													    <c:choose>
															<c:when test="${not empty row.content}">
																<c:set var="cont" value="${row.content}" />
																<c:out
																	value="${fn:length(cont) > 10 ? fn:substring(cont, 0, 10).concat('...') : cont}" />
															</c:when>
															<c:otherwise>
																<span style="color: #999;">내용 없음</span>
															</c:otherwise>
														</c:choose>
												</a></td>
												<td>${row.viewcnt}</td>
												<td>${row.youtubeUrl}</td>
												<td>
													<div class="btn-group">
														<button type="button"
															onclick="deletePost('${row.bno}', '${row.userId}')"
															class="btn btn-danger btn-sm ml-1">삭제</button>
													</div>
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
								<div class="card-body">
									<div class="table-responsive">
										<table class="table table-bordered" id="dataTable"
											width="100%">
										</table>

										<div class="row mt-3">
											<div class="col-sm-12 col-md-5">
												<div class="dataTables_info" role="status"
													aria-live="polite">전체 ${paging.totalCount}건 중
													${paging.currentPage}페이지 표시</div>
											</div>

											<div class="col-sm-12 col-md-7">
												<div class="dataTables_paginate paging_simple_numbers">
													<ul class="pagination justify-content-end">
														<c:if test="${paging.prev > 0}">
															<li class="paginate_button page-item previous"><a
																href="${ctx}/admin/board?pageNum=${paging.prev}"
																class="page-link">이전</a></li>
														</c:if>

														<c:forEach var="i" begin="${paging.startPage}"
															end="${paging.endPage}">
															<li
																class="paginate_button page-item ${paging.currentPage == i ? 'active' : ''}">
																<a href="${ctx}/admin/board?pageNum=${i}"
																class="page-link">${i}</a>
															</li>
														</c:forEach>

														<c:if test="${paging.next > 0}">
															<li class="paginate_button page-item next"><a
																href="${ctx}/admin/board?pageNum=${paging.next}"
																class="page-link">다음</a></li>
														</c:if>

													</ul>
												</div>
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
			<a class="scroll-to-top rounded" href="#page-top"> <i
				class="fas fa-angle-up"></i>
			</a>
			<script src="${adminRes}/vendor/jquery/jquery.min.js"></script>
			<script src="${adminRes}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
			<script src="${adminRes}/vendor/jquery-easing/jquery.easing.min.js"></script>
			<script src="${adminRes}/js/sb-admin-2.min.js"></script>
			<script src="${adminRes}/vendor/datatables/jquery.dataTables.min.js"></script>
			<script
				src="${adminRes}/vendor/datatables/dataTables.bootstrap4.min.js"></script>

			<script>
				$(document).ready(function() {
					// 기존 테이블 파괴 후 재생성
					if ($.fn.DataTable.isDataTable('#dataTable')) {
						$('#dataTable').DataTable().destroy();
					}

					$('#dataTable').DataTable({
						"paging" : false, // 자동 페이징 끔 (우리가 만든 하단 버튼 사용)
						"info" : false, // "전체 X건 중..." 텍스트 숨김 (커스텀 가능)
						"ordering" : true, // 정렬 유지
						"searching" : true, // 상단 검색창 UI 유지
						"lengthChange" : true, // 상단 "개씩 보기" UI 유지
						"autoWidth" : false,
						"language" : {
							"lengthMenu" : "_MENU_ 개씩 보기",
							"search" : "검색:",
							"emptyTable" : "데이터가 없습니다."
						}
					});
				});
				function deletePost(bno, userId) {
				    if (confirm(bno + "번 게시글은 영구 삭제되어 복구할 수 없습니다. ")) {
				        const pageNum = '${paging.currentPage}';
				        const pageSize = '${paging.pageSize}';
				        
				        // target=admin 파라미터를 추가하여 컨트롤러가 관리자 페이지로 리다이렉트하게 함
				        location.href = "${ctx}/board/board_delete?bno=" + bno 
				                      + "&user_id=" + userId 
				                      + "&pageNum=" + pageNum 
				                      + "&pageSize=" + pageSize
				                      + "&target=admin"; // 이 부분 추가
				    }
				}
			</script>
</body>
</html>