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
<title>808 Admin - 자유게시판</title>

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
			<li class="nav-item"><a class="nav-link" href="${adminUrl}"><i
					class="fas fa-fw fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
			<li class="nav-item"><a class="nav-link" href="${adminUrl}/user"><i
					class="fas fa-fw fa-users"></i> <span>User Admin</span></a></li>
			<li class="nav-item"><a class="nav-link" href="${adminUrl}/pay"><i
					class="fas fa-fw fa-credit-card"></i> <span>Pay Admin</span></a></li>
			<li class="nav-item active"><a class="nav-link"
				href="${adminUrl}/board"><i class="fas fa-fw fa-clipboard-list"></i>
					<span>Board Admin</span></a></li>
			<li class="nav-item"><a class="nav-link"
				href="${adminUrl}/music"><i class="fas fa-fw fa-music"></i> <span>Music
						Admin</span></a></li>
			<hr class="sidebar-divider d-none d-md-block">
		</ul>

		<div id="content-wrapper" class="d-flex flex-column">
			<div id="content">
				<nav
					class="navbar navbar-expand navbar-light bg-white topbar mb-4 shadow">
					<span class="h5 mb-0 text-gray-800">자유게시판 관리</span>
				</nav>

				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">Board Management</h1>
					<p class="mb-4">자유게시판</p>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">게시글데이터</h6>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered" id="dataTable" width="100%">
									<thead>
										<tr>
											<th>BNO</th>
											<th>USER_ID</th>
											<th>Nickname</th>
											<th>TITLE</th>
											<th>CONTENT</th>
											<th>올린시간</th>
											<th>VIEW</th>
											<th>LIKE</th>
											<th>URL</th>
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
													style="text-decoration: none; color: inherit;"> <c:choose>
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
												<td>${row.regdate}</td>
												<td>${row.viewcnt}</td>
												<td>${row.likeCount}</td>
												<td>${row.youtubeUrl}</td>
												<td>
													<button type="button"
														onclick="deletePost('${row.bno}', '${row.userId}')"
														class="btn btn-danger btn-sm">삭제</button>
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>

								<div class="row mt-3">
<div class="col-sm-12 col-md-5">
        <div class="dataTables_info" role="status" aria-live="polite">
            ${paging.startRow} ~ ${paging.endRow > paging.totalCount ? paging.totalCount : paging.endRow} 
            / 총 ${paging.totalCount}개
        </div>
    </div>
									<div class="col-sm-12 col-md-7">
										<ul class="pagination justify-content-end">
											<c:if test="${paging.prev >= 0}">

												<ul class="pagination justify-content-end">
													<li class="page-item ${paging.prev <= 0 ? 'disabled' : ''}">
														<a
														href="${paging.prev > 0 ? ctx.concat('/admin/board?pageNum=').concat(paging.prev).concat('&pageSize=').concat(paging.pageSize) : '#'}"
														class="page-link">이전</a>
													</li>

													<c:forEach var="i" begin="${paging.startPage}"
														end="${paging.endPage}">
														<li
															class="page-item ${paging.currentPage == i ? 'active' : ''}">
															<a
															href="${ctx}/admin/board?pageNum=${i}&pageSize=${paging.pageSize}"
															class="page-link">${i}</a>
														</li>
													</c:forEach>

													<li class="page-item ${paging.next <= 0 ? 'disabled' : ''}">
														<a
														href="${paging.next > 0 ? ctx.concat('/admin/board?pageNum=').concat(paging.next).concat('&pageSize=').concat(paging.pageSize) : '#'}"
														class="page-link">다음</a>
													</li>
												</ul>
											</c:if>


										</ul>
									</div>
								</div>
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
	<a class="scroll-to-top rounded" href="#page-top"><i
		class="fas fa-angle-up"></i></a>

	<script src="${adminRes}/vendor/jquery/jquery.min.js"></script>
	<script src="${adminRes}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="${adminRes}/vendor/jquery-easing/jquery.easing.min.js"></script>
	<script src="${adminRes}/js/sb-admin-2.min.js"></script>
	<script src="${adminRes}/vendor/datatables/jquery.dataTables.min.js"></script>
	<script
		src="${adminRes}/vendor/datatables/dataTables.bootstrap4.min.js"></script>

	<script>
		$(document)
				.ready(
						function() {
							// 서버에서 넘어온 현재 pageSize 값을 자바스크립트 변수로 저장
							const currentPageSize = '${paging.pageSize}'
									|| '10';

							if ($.fn.DataTable.isDataTable('#dataTable')) {
								$('#dataTable').DataTable().destroy();
							}

							const table = $('#dataTable')
									.DataTable(
											{
												"paging" : true,
												"pageLength" : parseInt(currentPageSize),
												"lengthMenu" : [ 10, 25, 50,
														100 ],
												"info" : false,
												"ordering" : true,
												"searching" : true,
												"autoWidth" : false,
												"language" : {
													"lengthMenu" : "_MENU_ 개씩 보기",
													"search" : "검색:",
													"zeroRecords" : "검색 결과가 없습니다.",
													"emptyTable" : "데이터가 없습니다."
												},
												"dom" : '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>rt'
											});

							// 핵심 수정 부분: DataTable의 기본 동작을 막고 강제로 페이지 이동
							// 'select' 태그의 change 이벤트를 직접 잡는 것이 가장 확실합니다.
							$(document)
									.on(
											'change',
											'select[name="dataTable_length"]',
											function() {
												const len = $(this).val();
												const ctx = "${ctx}";
												// 페이지 번호는 1로 리셋하고 선택한 개수(len)를 서버로 보냄
												location.href = ctx
														+ "/admin/board?pageNum=1&pageSize="
														+ len;
											});
						});

		function deletePost(bno, userId) {
			if (confirm(bno + "번 게시글은 영구 삭제되어 복구할 수 없습니다.")) {
				const pageNum = '${paging.currentPage}';
				const pageSize = '${paging.pageSize}'; // 삭제 후 돌아올 때도 개수 유지
				location.href = "${ctx}/board/board_delete?bno=" + bno
						+ "&user_id=" + userId + "&pageNum=" + pageNum
						+ "&pageSize=" + pageSize + "&target=admin";
			}
		}
	</script>
</body>
</html>