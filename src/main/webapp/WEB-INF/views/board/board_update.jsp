<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Premium Orange Board - 수정 및 상세</title>

<link rel="stylesheet" href="${path}/resources/common/css/style.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
/* [스타일 섹션은 기존 디자인 유지를 위해 생략하지 않고 포함합니다] */
body {
    /* style.css에 정의된 변수를 그대로 사용하여 배경 구현 */
    background: linear-gradient(
        180deg,
        #DF8845 0%,    /* --page-bg-start */
        #6B4121 10%,   /* --page-bg-mid */
        #1A0F08 20%,   /* --page-bg-mid-end */
        #000000 100%   /* --page-bg-end */
    ) !important;
    
    /* 배경 고정 및 최소 높이 설정 */
    background-attachment: fixed !important;
    min-height: 100vh;
    margin: 0;
    
    /* 상단 여백 및 기본 텍스트 설정 */
    padding-top: 150px !important; /* style.css의 .sample-main 패딩 기준 */
    font-family: 'Pretendard', -apple-system, sans-serif;
    color: #ffffff;
}

.table_div {
	margin: 0 auto !important;
	max-width: 1000px;
	background: rgba(255, 255, 255, 0.05);
	backdrop-filter: blur(20px);
	padding: 40px;
	border-radius: 20px;
	border: 1px solid rgba(255, 255, 255, 0.12);
	box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

h2 {
	color: #ffffff !important;
	margin-bottom: 40px;
	text-align: center;
	font-weight: 800;
	letter-spacing: 2px;
	text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.update-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
}

.update-table th {
	width: 120px;
	padding: 18px 15px;
	color: #ffcc00 !important;
	text-align: left;
	font-weight: 700;
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	font-size: 14px;
	text-transform: uppercase;
}

.update-table td {
	padding: 15px;
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	color: #ffffff !important;
	font-size: 15px;
}

input[type="text"], textarea {
	width: 100%;
	background: rgba(0, 0, 0, 0.3) !important;
	border: 1px solid rgba(255, 255, 255, 0.2) !important;
	border-radius: 12px;
	padding: 12px 15px !important;
	color: #FFFFFF !important;
	font-size: 15px;
	box-sizing: border-box;
	outline: none;
}

input[type="text"]:focus, textarea:focus {
	border-color: #ffcc00 !important;
	box-shadow: 0 0 15px rgba(255, 204, 0, 0.2);
}

.image-edit-section {
	background: rgba(255, 255, 255, 0.03);
	padding: 20px;
	border-radius: 15px;
	border: 1px dashed rgba(255, 204, 0, 0.3);
	text-align: center;
}

.preview-img {
	max-width: 100%;
	max-height: 400px;
	border-radius: 10px;
	margin-bottom: 15px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
}

.btn-container {
	display: flex;
	justify-content: center;
	gap: 12px;
	margin-top: 40px;
	flex-wrap: wrap;
}

.pill-button {
	padding: 12px 35px;
	border-radius: 50px;
	font-weight: 800;
	cursor: pointer;
	border: none;
	color: #ffffff !important;
	font-size: 15px;
	transition: 0.3s;
}

.btn-save {
	background: linear-gradient(135deg, #ffcc00 0%, #ff6b13 100%) !important;
	color: #2b1407 !important;
}

.btn-delete {
	background-color: #ff4757 !important;
}

.btn-dark {
	background: rgba(255, 255, 255, 0.1) !important;
	border: 1px solid rgba(255, 255, 255, 0.2) !important;
}

.pill-button:hover {
	transform: translateY(-3px);
	filter: brightness(1.1);
}
</style>

<script>
	$(function() {
		// 1. 목록 버튼
		$('#btnList').click(function() {
			location.href = "${path}/board/list";
		});

		// 2. 폼 제출 유효성 검사
		$('#updateForm').submit(function() {
			var fileInput = $("#file");
			if (fileInput.val()) {
				var ext = fileInput.val().split('.').pop().toLowerCase();
				if ($.inArray(ext, [ 'jpg', 'jpeg', 'png', 'gif' ]) == -1) {
					alert('이미지 파일(jpg, jpeg, png, gif)만 업로드 가능합니다.');
					return false;
				}
			}

			if (confirm("변경사항을 저장하시겠습니까?")) {
				return true;
			}
			return false;
		});

		// 3. 삭제 버튼 (컨트롤러 board_delete 매핑 확인)
		$('#btnDelete').click(
				function() {
					if (confirm("정말 삭제하시겠습니까? 삭제 후에는 복구할 수 없습니다.")) {
						var bno = $("input[name='bno']").val();
						var userId = $("input[name='user_id']").val();
						location.href = "${path}/board/board_delete?bno=" + bno
								+ "&user_id=" + userId;
					}
				});

		// 4. 새 이미지 선택 시 미리보기 (UX 개선)
		$("#file")
				.change(
						function(e) {
							var file = e.target.files[0];
							if (file && file.type.match('image.*')) {
								var reader = new FileReader();
								reader.onload = function(e) {
									if ($(".preview-img").length > 0) {
										$(".preview-img").attr("src",
												e.target.result);
									} else {
										$(".image-edit-section")
												.prepend(
														'<img src="'+e.target.result+'" class="preview-img" alt="새 이미지">');
									}
								}
								reader.readAsDataURL(file);
							}
						});
	});
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<div class="wrap">
		<div class="table_div">
			<h2>상세보기 및 수정</h2>

			<form id="updateForm" action="${path}/board/board_update"
				method="post" enctype="multipart/form-data">
				<input type="hidden" name="bno" value="${dto.bno}"> <input
					type="hidden" name="user_id" value="${dto.userId}"> <input
					type="hidden" name="board_image" value="${dto.board_image}">

				<table class="update-table">
					<tr>
						<th>글번호</th>
						<td style="color: #ffcc00 !important; font-weight: bold;">#
							${dto.bno}</td>
						<th>조회수</th>
						<td>${dto.viewcnt}</td>
					</tr>
					<tr>
						<th>작성자</th>
						<td>${dto.nickname}</td>
						<th>등록일</th>
						<td><fmt:formatDate value="${dto.regdate}"
								pattern="yyyy-MM-dd HH:mm" /></td>
					</tr>
					<tr>
						<th>글제목</th>
						<td colspan="3"><input type="text" name="title"
							value="${dto.title}" required></td>
					</tr>
					<tr>
						<th>유튜브 링크</th>
						<td colspan="3"><input type="text" name="youtubeUrl"
							value="${dto.youtubeUrl}" placeholder="유튜브 주소를 입력하세요"></td>
					</tr>

					<tr>
						<th>첨부 이미지</th>
						<td colspan="3">
							<div class="image-edit-section">
								<c:if test="${not empty dto.board_image}">
									<p
										style="margin-bottom: 10px; font-size: 14px; color: #ffcc00;">[
										현재 등록된 이미지 ]</p>
									<img
										src="${path}/resources/images/board-image/${dto.board_image}"
										class="preview-img" alt="첨부 이미지">
								</c:if>
								<c:if test="${empty dto.board_image}">
									<p style="margin-bottom: 10px; font-size: 14px; color: #666;">등록된
										이미지가 없습니다.</p>
								</c:if>

								<div class="file-custom-input">
									<input type="file" name="file" id="file" accept="image/*">
									<p style="margin-top: 8px; color: #888;">* 새로운 이미지를 선택하면 기존
										사진이 교체됩니다.</p>
								</div>
							</div>
						</td>
					</tr>

					<tr>
						<th>글내용</th>
						<td colspan="3"><textarea name="content" rows="12" required>${dto.content}</textarea>
						</td>
					</tr>
				</table>

				<div class="btn-container">
					<c:if
						test="${(sessionScope.loginUser.userId eq dto.userId) or (sessionScope.loginUser.role eq 'ADMIN')}">
						<button type="submit" class="pill-button btn-save">수정완료</button>
						<button type="button" id="btnDelete"
							class="pill-button btn-delete">삭제하기</button>
					</c:if>

					<button type="button" id="btnList" class="pill-button btn-dark">목록으로</button>
					<button type="button" class="pill-button btn-dark"
						onclick="history.back()">이전으로</button>
				</div>
			</form>
		</div>
	</div>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>