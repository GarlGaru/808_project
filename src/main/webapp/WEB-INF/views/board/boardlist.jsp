<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BoardList</title>		
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>

<link rel="stylesheet" href="${path}/resources/common/css/style.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
.container {
	margin: 0 auto;
	max-width: 1100px;
	padding: 20px;
}

/* [상단 옵션 영역: 라디오 버튼] */
.board-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-end;
	margin-bottom: 25px;
	padding: 0 10px;
}

.sort-radio-group {
	display: flex;
	gap: 20px;
}

.radio-container {
	cursor: pointer;
	position: relative;
	padding-left: 28px;
	font-size: 15px;
	font-weight: 700;
	color: rgba(255, 255, 255, 0.7);
	transition: 0.3s;
}

.radio-container input {
	position: absolute;
	opacity: 0;
	cursor: pointer;
}

.checkmark {
	position: absolute;
	top: 0;
	left: 0;
	height: 20px;
	width: 20px;
	background-color: rgba(255, 255, 255, 0.1);
	border-radius: 50%;
	border: 2px solid #ffcc00;
}

.radio-container input:checked ~ .checkmark {
	background-color: #ffcc00;
}

.radio-container input:checked {
	color: #ffcc00;
}

.checkmark:after {
	content: "";
	position: absolute;
	display: none;
	top: 5px;
	left: 5px;
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: #2b1407;
}

.radio-container input:checked ~ .checkmark:after {
	display: block;
}

.radio-container:hover {
	color: #ffcc00;
}

/* [게시판 테이블 스타일] */
.main-card {
	background: rgba(255, 255, 255, 0.05);
	backdrop-filter: blur(15px);
	border-radius: 20px;
	border: 1px solid rgba(255, 255, 255, 0.1);
	overflow: hidden;
	box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
}

.board-table {
	width: 100%;
	border-collapse: collapse;
	text-align: center;
}

.board-table th {
	background: rgba(0, 0, 0, 0.2);
	padding: 20px;
	color: #ffcc00;
	font-size: 14px;
	text-transform: uppercase;
	letter-spacing: 1px;
}

.board-table td {
	padding: 18px 15px;
	border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.board-table tr:hover {
	background: rgba(255, 255, 255, 0.03);
	cursor: pointer;
}

.title-td {
	text-align: left;
	padding-left: 30px !important;
}

.title-td a {
	color: #fff;
	text-decoration: none;
	font-weight: 600;
}

.title-td a:hover {
	color: #ffcc00;
}

/* [페이징 스타일] */
.pagination {
	display: flex;
	justify-content: center;
	gap: 10px;
	margin-top: 40px;
}

.page-link {
	padding: 8px 16px;
	border-radius: 10px;
	background: rgba(255, 255, 255, 0.1);
	color: #fff;
	text-decoration: none;
	font-weight: 700;
	transition: 0.3s;
}

.page-link.active {
	background: #ED6701;
	color: #2b1407;
}

.page-link:hover:not(.active) {
	background: rgba(255, 255, 255, 0.3);
}

/* [글쓰기 버튼] */
/* [글쓰기 버튼: 그라데이션 적용] */
.btn-write {
	display: inline-block;
	padding: 12px 35px;
	/* 왼쪽에서 오른쪽으로 흐르는 오렌지-옐로우 그라데이션 */
	background: linear-gradient(90deg, #DF8845 0%, #ED6701 100%);;
	color: #2b1407;
	border-radius: 50px;
	font-weight: 800;
	text-decoration: none;
	float: right;
	margin-top: 20px;
	transition: all 0.4s ease; /* 부드러운 전환 효과 */
	box-shadow: 0 4px 15px rgba(255, 149, 0, 0.4);
	border: none;
	cursor: pointer;
}

/* 마우스 올렸을 때 (Hover) 효과 */
.btn-write:hover {
	transform: translateY(-3px) scale(1.05); /* 살짝 커지면서 위로 이동 */
	/* 호버 시 그라데이션 방향이나 색상을 반전시켜 생동감 부여 */
	background: linear-gradient(135deg, #ff9500 0%, #ffcc00 100%);
	box-shadow: 0 8px 25px rgba(255, 149, 0, 0.6);
	filter: brightness(1.1);
}

/* 버튼을 눌렀을 때 (Active) 효과 */
.btn-write:active {
	transform: translateY(-1px);
	box-shadow: 0 4px 10px rgba(255, 149, 0, 0.3);
}

.search-area form {
	display: flex; /* 요소들을 가로로 배치 */
	justify-content: center; /* 중앙 정렬 */
	align-items: center; /* 세로 높이 맞춤 */
	gap: 10px; /* 요소 사이 간격 */
	margin-top: 30px;
}

/* 검색창과 셀렉트 박스 높이 통일 및 여백 제거 */
.search-area select, .search-area input[name="keyword"], .search-area button
	{
	margin: 0; /* 기본 마진 제거 */
	height: 45px; /* 모든 요소 높이 통일 */
	box-sizing: border-box; /* 패딩 포함 높이 계산 */
	vertical-align: middle;
}

.search-area button.page-link {
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 0 20px; /* 버튼 옆 여백 */
}
/* 베스트 게시글 행 스타일 */
.best-row {
	background: rgba(255, 204, 0, 0.08) !important; /* 은은한 골드 배경 */
	border-left: 4px solid #ffcc00; /* 왼쪽에 골드 라인 */
}

.best-badge {
	background: linear-gradient(135deg, #ED6701 0%, #ff9500 100%);
	color: #2b1407;
	padding: 3px 10px;
	border-radius: 20px;
	font-size: 11px;
	font-weight: 800;
	box-shadow: 0 2px 10px rgba(255, 204, 0, 0.3);
}

.best-row .title-td a {
	color: #ffcc00 !important; /* 제목 강조 */
}

/* 순위 표시용 아이콘 */
.rank-icon {
	font-style: italic;
	font-weight: 900;
	color: #ED6701;
}

.nav-link:hover {
    color: #ffcc00 !important; /* 마우스 올리면 시그니처 오렌지색 */
}

</style>
<script>
	$(function() {
		// 1. 라디오 버튼 클릭 시 즉시 정렬 변경
		$('input[name="sort"]').on('click change', function() {
			var sort = $(this).val();
			// 검색 키워드와 타입을 유지하며 정렬만 변경하기 위해 파라미터 추가 
			var searchType = "${searchType}";
			var keyword = "${keyword}";
			
			location.href = "${path}/board/list?sort=" + sort + "&pageNum=1" 
			                + "&searchType=" + searchType + "&keyword=" + keyword;
		});

		// 2. 테이블 행 클릭 시 상세 페이지 이동
		// 컨트롤러의 plusReadCnt 메서드로 연결하여 조회수를 올리고 상세페이지로 이동 
		$('.board-row').on('click', function() {
			var bno = $(this).data('bno');
			if (bno) {
				location.href = "${path}/board/plusReadCnt?bno=" + bno;
			}
		});
	});
</script>
</head>
<body class="dark-mode">
	<!-- 공통 상단 영역 -->
	<%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

	<div class="container">
		<br>
		<br>
		
		<div class="board-header">
			<div class="total-info">
				Total <span style="color: #ffcc00; font-weight: bold;">${paging.totalCount}</span>
			</div>

			<div class="sort-radio-group">
				<label class="radio-container"> 
                    <input type="radio" name="sort" value="new" ${empty sort or sort eq 'new' ? 'checked' : ''}> 
                    <span class="checkmark"></span> 최신순
				</label> 
                <label class="radio-container"> 
                    <input type="radio" name="sort" value="view" ${sort eq 'view' ? 'checked' : ''}>
					<span class="checkmark"></span> 조회순
				</label> 
                <label class="radio-container"> 
                    <input type="radio" name="sort" value="like" ${sort eq 'like' ? 'checked' : ''}>
					<span class="checkmark"></span> 추천순 
				</label>
			</div>
		</div>

		<div class="main-card">
			<table class="board-table">
				<thead>
					<tr>
						<th style="width: 80px;">No.</th>
						<th>Title</th>
						<th style="width: 150px;">Author</th>
						<th style="width: 120px;">Date</th>
						<th style="width: 80px;">Views</th>
						<th style="width: 80px;">Likes</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="best" items="${bestList}" varStatus="status">
						<tr class="board-row best-row" data-bno="${best.bno}">
							<td><span class="rank-icon">TOP ${status.count}</span></td>
							<td class="title-td">
                                <span class="best-badge">BEST</span> 
                                <a href="${path}/board/plusReadCnt?bno=${best.bno}">${best.title}</a>
								<c:if test="${not empty best.youtubeUrl}">
									<span style="color: #ff4444; font-size: 12px; margin-left: 5px;">[VIDEO]</span>
								</c:if>
                            </td>
							<td>${best.nickname}</td>
							<td><fmt:formatDate value="${best.regdate}" pattern="yyyy-MM-dd" /></td>
							<td>${best.viewcnt}</td>
							<td style="color: #ED6701; font-weight: bold;">${best.likeCount}</td>
						</tr>
					</c:forEach>

					<c:if test="${not empty bestList}">
						<tr style="height: 10px; background: rgba(255, 255, 255, 0.02);"><td colspan="6"></td></tr>
					</c:if>

					<c:forEach var="b" items="${list}">
						<tr class="board-row" data-bno="${b.bno}">
							<td>${b.bno}</td>
							<td class="title-td">
                                <a href="${path}/board/plusReadCnt?bno=${b.bno}">${b.title}</a> 
                                <c:if test="${not empty b.youtubeUrl}">
									<span style="color: #ff4444; font-size: 12px; margin-left: 5px;">[VIDEO]</span> 
								</c:if>
                            </td>
							<td>${b.nickname}</td>
							<td><fmt:formatDate value="${b.regdate}" pattern="yyyy-MM-dd" /></td>
							<td>${b.viewcnt}</td>
							<td style="color: #ED6701; font-weight: bold;">${b.likeCount}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
        
		<div style="width: 100%; overflow: hidden; margin-top: 20px;">
			<a href="${path}/board/wrter" class="btn-write">글쓰기</a> 
		</div>

		<div class="pagination">
			<c:if test="${paging.startPage > 1}">
				<a href="${path}/board/list?pageNum=${paging.startPage-1}&sort=${sort}&searchType=${searchType}&keyword=${keyword}" class="page-link">PREV</a>
			</c:if>

			<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
				<a href="${path}/board/list?pageNum=${i}&sort=${sort}&searchType=${searchType}&keyword=${keyword}"
					class="page-link ${i == paging.currentPage ? 'active' : ''}">${i}</a> 
			</c:forEach>

			<c:if test="${paging.endPage < paging.totalPage}">
				<a href="${path}/board/list?pageNum=${paging.endPage+1}&sort=${sort}&searchType=${searchType}&keyword=${keyword}" class="page-link">NEXT</a>
			</c:if>
		</div>

		<div class="search-area">
			<form action="${path}/board/list" method="get">
				<input type="hidden" name="pageNum" value="1"> 
                <input type="hidden" name="sort" value="${sort}"> 
                <select name="searchType">
					<option value="title" ${searchType eq 'title' ? 'selected' : ''}>제목</option>
					<option value="content" ${searchType eq 'content' ? 'selected' : ''}>내용</option>
					<option value="writer" ${searchType eq 'writer' ? 'selected' : ''}>작성자</option>
				</select> 
                <input type="text" name="keyword" value="${keyword}" placeholder="검색어를 입력하세요">
				<button type="submit" class="page-link">검색</button>
			</form>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>