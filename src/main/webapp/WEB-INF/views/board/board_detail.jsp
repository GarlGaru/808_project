<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Premium Orange Board - ${dto.title}</title>

<link rel="stylesheet" href="${path}/resources/common/css/style.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
/* [기존 스타일 유지] */
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
	max-width: 950px;
	padding: 20px;
}

.post-header-card {
	background: rgba(255, 255, 255, 0.1);
	backdrop-filter: blur(15px);
	border: 1px solid rgba(255, 255, 255, 0.2);
	border-radius: 20px;
	padding: 30px;
	margin-bottom: 25px;
	box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
}

.post-title-text {
	font-size: 26px;
	font-weight: 800;
	margin-bottom: 25px;
	color: #ffffff;
	border-left: 6px solid #ffcc00;
	padding-left: 20px;
	line-height: 1.4;
}

.meta-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 15px;
	border-top: 1px solid rgba(255, 255, 255, 0.2);
	padding-top: 20px;
}

.meta-box {
	display: flex;
	flex-direction: column;
	gap: 5px;
}

.meta-key {
	color: #ffcc00;
	font-size: 11px;
	font-weight: 800;
	text-transform: uppercase;
}

.meta-val {
	font-size: 15px;
	color: #ffffff;
	font-weight: 500;
}

.post-main-content {
	background: rgba(0, 0, 0, 0.45);
	border: 1px solid rgba(255, 255, 255, 0.1);
	border-radius: 20px;
	padding: 45px;
	min-height: 200px;
	line-height: 2.1;
	font-size: 18px;
	color: #ffffff !important;
	white-space: pre-wrap;
	box-shadow: inset 0 0 50px rgba(0, 0, 0, 0.6);
}

.video-wrapper {
	margin: 30px 0;
	border-radius: 20px;
	overflow: hidden;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
	border: 1px solid rgba(255, 255, 255, 0.1);
}

.video-container {
	position: relative;
	padding-bottom: 56.25%;
	height: 0;
}

.video-container iframe {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
}

.btn-container {
	display: flex;
	justify-content: center;
	gap: 15px;
	margin: 45px 0;
}

.pill-button {
	padding: 15px 40px;
	border-radius: 50px;
	font-weight: 700;
	border: none;
	cursor: pointer;
	transition: all 0.3s ease;
	font-size: 15px;
	display: flex;
	align-items: center;
	gap: 8px;
}

.btn-green {
	background: #ffcc00;
	color: #331a00;
}

.btn-dark {
	background: rgba(0, 0, 0, 0.6);
	color: #fff;
	border: 1px solid rgba(255, 255, 255, 0.3);
}

.btn-red {
	background: #ffffff;
	color: #ff6b13;
}

.btn-red.active {
	background: #ff6b13 !important;
	color: #ffffff !important;
	box-shadow: 0 0 25px rgba(255, 107, 19, 0.6);
	transform: scale(1.05);
}

.comment-box-card {
	background: rgba(0, 0, 0, 0.3);
	border-radius: 25px;
	padding: 40px;
	border: 1px solid rgba(255, 255, 255, 0.15);
}

/* 댓글 스타일 */
#reply_content {
	width: 100%;
	background: rgba(255, 255, 255, 0.1) !important;
	border: 1px solid rgba(255, 255, 255, 0.2) !important;
	border-radius: 15px;
	color: #ffffff !important;
	padding: 20px;
	box-sizing: border-box;
	resize: none;
}

.char-count-reply {
	font-size: 12px;
	color: rgba(255, 255, 255, 0.4);
	margin-top: 5px;
}
</style>

<script>
	const path = "${pageContext.request.contextPath}";
	const loginUserId = "${sessionScope.loginUser.userId}";

	$(function() {
		// 1. 목록으로 이동
		$('#btnList').click(function() {
			location.href = path + "/board/list";
		});

		// 2. 수정/삭제 이동
		$('#btnEdit').click(
				function() {
					if (confirm("게시글을 수정 또는 삭제하시겠습니까?")) {
						location.href = path
								+ "/board/board_update?bno=${dto.bno}&user_id="
								+ loginUserId;
					}
				});

		// 3. 좋아요 처리
		$('#btnLike').click(function() {
			if (!loginUserId) {
				alert("로그인이 필요한 서비스입니다.");
				return;
			}
			$.ajax({
				url : path + "/like/selest",
				type : "post",
				data : {
					"bno" : "${dto.bno}",
					"userId" : loginUserId
				},
				success : function() {
					getLikeInfo();
				},
				error : function() {
					alert("좋아요 처리 중 오류 발생");
				}
			});
		});

		// 4. 실시간 댓글 글자 수 체크 (200자 제한)
		$(document).on('input', '#reply_content', function() {
			const currLength = $(this).val().length;
			$('#replyCharCount').text(currLength + " / 200자");
			if (currLength >= 200) {
				$('#replyCharCount').css('color', '#ff4757');
			} else {
				$('#replyCharCount').css('color', 'rgba(255, 255, 255, 0.4)');
			}
		});

		// 5. 댓글 등록 (AJAX)
		$('#btnReply').click(function() {
			const content = $('#reply_content').val().trim();
			if (!loginUserId) {
				alert("로그인이 필요한 서비스입니다.");
				return;
			}
			if (!content) {
				alert("댓글 내용을 입력해주세요.");
				$('#reply_content').focus();
				return;
			}
			if (content.length > 200) {
				alert("댓글은 200자 이내로 작성 가능합니다.");
				return;
			}

			$.ajax({
				url : path + "/reply/insert",
				type : "post",
				data : {
					"content" : content,
					"bno" : "${dto.bno}",
					"userId" : loginUserId
				},
				success : function(res) {
					alert("댓글이 등록되었습니다.");
					$('#reply_content').val("");
					$('#replyCharCount').text("0 / 200자");
					$("#comment_list").html(res);
				},
				error : function() {
					alert("댓글 등록 중 오류가 발생했습니다.");
				}
			});
		});

		// 초기 로드
		listReply();
		getLikeInfo();
	});

	function getLikeInfo() {
		if (!loginUserId)
			return;
		$.ajax({
			url : path + "/like/getLikeInfo",
			type : "get",
			data : {
				"bno" : "${dto.bno}",
				"userId" : loginUserId
			},
			success : function(data) {
				$("#likeCount").text(data.count);
				if (data.isLiked > 0) {
					$("#btnLike").addClass("active").find("#likeText").text(
							"LIKED");
				} else {
					$("#btnLike").removeClass("active").find("#likeText").text(
							"LIKE");
				}
			}
		});
	}

	function listReply() {
		$.ajax({
			url : path + "/reply/list",
			type : "get",
			data : {
				"bno" : "${dto.bno}"
			},
			success : function(res) {
				$("#comment_list").html(res);
			}
		});
	}

	function deleteReply(cno, bno) {
		if (confirm("이 댓글을 정말 삭제하시겠습니까?")) {
			$.ajax({
				url : path + "/reply/delete",
				type : "post",
				data : {
					"cno" : cno,
					"bno" : bno
				},
				success : function(res) {
					alert("댓글이 삭제되었습니다.");
					$("#comment_list").html(res);
				},
				error : function() {
					alert("삭제 처리 중 오류 발생");
				}
			});
		}
	}
</script>
</head>

<body>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>
	<div class="wrap">
		<div class="table_div">
			<div class="post-header-card">
				<div class="post-title-text">${dto.title}</div>
				<div class="meta-grid">
					<div class="meta-box">
						<span class="meta-key">Post No.</span><span class="meta-val">${dto.bno}</span>
					</div>
					<div class="meta-box">
						<span class="meta-key">Author</span><span class="meta-val">${dto.nickname}</span>
					</div>
					<div class="meta-box">
						<span class="meta-key">Views</span><span class="meta-val">${dto.viewcnt}</span>
					</div>
					<div class="meta-box">
						<span class="meta-key">Permission</span> <span class="meta-val">
							<c:choose>
								<c:when test="${sessionScope.loginUser.userId eq dto.userId}">
									<span style="color: #ffcc00;">● Owner</span>
								</c:when>
								<c:otherwise>Read Only</c:otherwise>
							</c:choose>
						</span>
					</div>
				</div>
			</div>

			<c:if test="${not empty dto.board_image}">
				<div class="board-image-view"
					style="margin: 20px 0; text-align: center;">
					<img src="${path}/resources/images/board-image/${dto.board_image}"
						alt="첨부 이미지"
						style="max-width: 100%; height: auto; border-radius: 10px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);">
				</div>
			</c:if>

			<div class="post-main-content">${dto.content}</div>

			<%-- 유튜브 영상 출력 영역 --%>
			<c:if test="${not empty dto.youtubeUrl}">
				<c:set var="u_url" value="${dto.youtubeUrl}" />
				<%
				String url = (String) pageContext.getAttribute("u_url");
				String vId = "";
				try {
					if (url != null && url.contains("v=")) {
						vId = url.split("v=")[1];
						int amp = vId.indexOf("&");
						if (amp != -1)
					vId = vId.substring(0, amp);
					} else if (url != null && url.contains("youtu.be/")) {
						vId = url.substring(url.lastIndexOf("/") + 1);
					}
					pageContext.setAttribute("vId", vId);
				} catch (Exception e) {
					vId = "";
				}
				%>
				<c:if test="${not empty vId}">
					<div class="video-wrapper">
						<div class="video-container">
							<iframe src="https://www.youtube.com/embed/${vId.trim()}"
								frameborder="0" allowfullscreen></iframe>
						</div>
					</div>
				</c:if>
			</c:if>

			<div class="btn-container">
				<c:if test="${sessionScope.loginUser.userId eq dto.userId}">
					<button class="pill-button btn-green" id="btnEdit">EDIT /
						DELETE</button>
				</c:if>
				<button class="pill-button btn-dark" id="btnList">BACK TO
					LIST</button>
				<button class="pill-button btn-red" id="btnLike">
					<span id="likeText">LIKE</span> <span id="likeCount"
						style="margin-left: 8px; font-weight: 800;">0</span>
				</button>
			</div>

			<div class="comment-box-card">
				<h3 style="color: #ffcc00; margin-bottom: 20px; font-weight: 800;">COMMENTS</h3>
				<textarea id="reply_content" rows="3" maxlength="200"
					placeholder="댓글을 입력하세요. (최대 200자)"></textarea>
				<div
					style="display: flex; justify-content: space-between; align-items: center; margin-top: 10px;">
					<span id="replyCharCount" class="char-count-reply">0 / 200자</span>
					<button type="button" id="btnReply" class="pill-button btn-green"
						style="padding: 10px 30px;">SUBMIT</button>
				</div>
				<div id="comment_list" style="margin-top: 30px;"></div>
			</div>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>