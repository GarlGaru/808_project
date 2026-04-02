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
<title>Board - 글쓰기</title>

<link rel="stylesheet" href="${path}/resources/common/css/style.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
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
	max-width: 900px;
	background: rgba(255, 255, 255, 0.08);
	backdrop-filter: blur(15px);
	padding: 40px;
	border-radius: 20px;
	border: 1px solid rgba(255, 255, 255, 0.2);
	box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
}

h2 {
	color: #ffffff !important;
	margin-bottom: 40px;
	text-align: center;
	font-weight: 800;
	letter-spacing: 2px;
	text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.write-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
}

.write-table th {
	width: 150px;
	padding: 18px;
	color: #ffcc00 !important;
	text-align: left;
	font-weight: 700;
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	text-transform: uppercase;
	font-size: 14px;
}

.write-table td {
	padding: 15px;
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	color: #ffffff !important;
}

input[type="text"], textarea {
	width: 100%;
	background: rgba(0, 0, 0, 0.3) !important;
	border: 1px solid rgba(255, 255, 255, 0.2) !important;
	border-radius: 12px;
	padding: 15px !important;
	color: #FFFFFF !important;
	font-size: 15px;
	box-sizing: border-box;
	outline: none;
}

input[type="text"]:focus, textarea:focus {
	border-color: #ffcc00 !important;
	background: rgba(0, 0, 0, 0.5) !important;
	box-shadow: 0 0 15px rgba(255, 204, 0, 0.2);
}

.button-area {
	text-align: center;
	margin-top: 40px;
	display: flex;
	justify-content: center;
	gap: 15px;
}

.pill-button {
	padding: 15px 45px;
	border-radius: 50px;
	font-weight: 800;
	cursor: pointer;
	border: none;
	color: #ffffff !important;
	font-size: 16px;
	transition: 0.3s;
}

#btnSave {
	background: linear-gradient(135deg, #ffcc00 0%, #ff6b13 100%) !important;
	color: #2b1407 !important;
	box-shadow: 0 5px 20px rgba(255, 107, 19, 0.4) !important;
}

#btnReset {
	background: rgba(255, 255, 255, 0.1) !important;
	border: 1px solid rgba(255, 255, 255, 0.2) !important;
}

.pill-button:hover {
	transform: translateY(-3px) scale(1.03);
	filter: brightness(1.1);
}

/* 미리보기 이미지 스타일 */
#preview {
	max-width: 200px;
	margin-top: 10px;
	border-radius: 8px;
	border: 1px solid #ffcc00;
	display: none;
}
</style>

<script>
	$(function() {
		// --- 1. 실시간 글자 수 체크 기능 ---
		$('#content').on('input', function() {
			const currLength = $(this).val().length;
			$('#charCount').text(currLength + " / 5000자");

			if (currLength >= 5000) {
				$('#charCount').css('color', '#ff6b13'); // 5000자 도달 시 오렌지색 강조
			} else {
				$('#charCount').css('color', 'rgba(255, 255, 255, 0.5)');
			}
		});

		// --- 2. 작성 완료 클릭 시 유효성 검사 및 전송 ---
		$('#btnSave').click(function() {
			const title = $('#title').val().trim();
			const content = $('#content').val().trim();

			// 제목 검사
			if (!title) {
				alert("제목을 입력해주세요.");
				$('#title').focus();
				return false;
			}
			// 내용 빈값 검사
			if (!content) {
				alert("내용을 입력해주세요.");
				$('#content').focus();
				return false;
			}
			// 5000자 제한 검사 (서버 전송 전 최종 확인)
			if (content.length > 5000) {
				alert("글 내용은 5000자 이내로 작성 가능합니다.");
				$('#content').focus();
				return false;
			}

			// 모든 검사 통과 시 전송
			const form = document.insertForm;
			form.action = "${path}/board/insertBoard";
			form.submit();
		});

		// --- 3. 파일 선택 시 즉시 미리보기 기능 ---
		$('#board-image').change(function(e) {
			const file = e.target.files[0];
			if (file) {
				const ext = file.name.split('.').pop().toLowerCase();
				if ($.inArray(ext, [ 'jpg', 'jpeg', 'png', 'gif' ]) == -1) {
					alert('이미지 파일(jpg, jpeg, png, gif)만 업로드 가능합니다.');
					$(this).val("");
					$('#preview').hide();
					return;
				}

				const reader = new FileReader();
				reader.onload = function(event) {
					$('#preview').attr('src', event.target.result).fadeIn();
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
			<h2>게시글 작성</h2>

			<form name="insertForm" method="post" enctype="multipart/form-data">
				<table class="write-table">
					<tr>
						<th>작성자</th>
						<td style="font-weight: 600; color: #ffcc00 !important;">
							${sessionScope.loginUser.nickname} <input type="hidden"
							name="userId" value="${sessionScope.loginUser.userId}">
						</td>
					</tr>
					<tr>
						<th>글제목</th>
						<td><input type="text" name="title" id="title"
							placeholder="주목받을 수 있는 제목을 입력하세요" required></td>
					</tr>
					<tr>
						<th>글내용</th>
						<td><textarea name="content" id="content" rows="12"
								maxlength="5000" placeholder="자유롭게 의견을 나눠보세요"></textarea>
							<div id="charCount"
								style="text-align: right; color: rgba(255, 255, 255, 0.5); font-size: 12px; margin-top: 5px;">
								0 / 5000자</div></td>
					</tr>
					<tr>
						<th>IMG</th>
						<td><input type="file" name="board-image" id="board-image"
							accept="image/*"> <img id="preview" src="" alt="미리보기">
							<small
							style="color: rgba(255, 255, 255, 0.5); margin-top: 5px; display: block;">
								* 5MB 이하의 이미지 파일(jpg, png 등)만 업로드 가능합니다. </small></td>
					</tr>

					<tr>
						<th>YouTube 링크</th>
						<td><input type="text" name="youtubeUrl" id="youtubeUrl"
							placeholder="https://www.youtube.com/watch?v=영상코드 형식으로 입력하세요">
							<small
							style="color: rgba(255, 255, 255, 0.5); margin-top: 5px; display: block;">
								* 본문에 삽입하고 싶은 유튜브 주소를 입력해주세요. </small></td>
					</tr>
				</table>

				<div class="button-area">
					<button type="button" class="pill-button" id="btnSave">작성완료</button>
					<button type="reset" class="pill-button" id="btnReset"
						onclick="$('#preview').hide();">다시쓰기</button>
					<button type="button" class="pill-button" id="btnReset"
						style="background: #444;" onclick="history.back();">취소</button>
				</div>
			</form>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>