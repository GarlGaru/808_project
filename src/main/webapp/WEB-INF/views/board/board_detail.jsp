<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Premium Orange Board - ${dto.title}</title>
    
    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        /* [배경 및 전체 스타일] */
        body {
            background: radial-gradient(circle at top, #ff6b13 0%, #2b1407 100%) !important;
            padding-top: 130px !important;
            margin: 0; min-height: 100vh;
            font-family: 'Pretendard', sans-serif; color: #ffffff;
        }
        .table_div { margin: 0 auto !important; max-width: 950px; padding: 20px; }

        /* [카드 스타일] */
        .post-header-card {
            background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 20px;
            padding: 30px; margin-bottom: 25px; box-shadow: 0 15px 35px rgba(0,0,0,0.4);
        }
        .post-title-text {
            font-size: 26px; font-weight: 800; margin-bottom: 25px; color: #ffffff;
            border-left: 6px solid #ffcc00; padding-left: 20px; line-height: 1.4;
        }
        .meta-grid {
            display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px;
            border-top: 1px solid rgba(255, 255, 255, 0.2); padding-top: 20px;
        }
        .meta-box { display: flex; flex-direction: column; gap: 5px; }
        .meta-key { color: #ffcc00; font-size: 11px; font-weight: 800; text-transform: uppercase; }
        .meta-val { font-size: 15px; color: #ffffff; font-weight: 500; }

        .post-main-content {
            background: rgba(0, 0, 0, 0.45); border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px; padding: 45px; min-height: 450px; line-height: 2.1;
            font-size: 18px; color: #ffffff !important; white-space: pre-wrap;
            box-shadow: inset 0 0 50px rgba(0,0,0,0.6);
        }

        /* [버튼 스타일] */
        .btn-container { display: flex; justify-content: center; gap: 15px; margin: 45px 0; }
        .pill-button {
            padding: 15px 40px; border-radius: 50px; font-weight: 700; border: none;
            cursor: pointer; transition: all 0.3s ease; font-size: 15px;
            display: flex; align-items: center; gap: 8px;
        }
        .btn-green { background: #ffcc00; color: #331a00; }
        .btn-dark { background: rgba(0,0,0,0.6); color: #fff; border: 1px solid rgba(255,255,255,0.3); }
        .btn-red { background: #ffffff; color: #ff6b13; }
        .btn-red.active {
            background: #ff6b13 !important; color: #ffffff !important;
            box-shadow: 0 0 25px rgba(255, 107, 19, 0.6); transform: scale(1.05);
        }
        .pill-button:hover { transform: translateY(-5px); filter: brightness(1.1); }

        /* [댓글 스타일] */
        .comment-box-card {
            background: rgba(0, 0, 0, 0.3); border-radius: 25px;
            padding: 40px; border: 1px solid rgba(255, 255, 255, 0.15);
        }
        #reply_content {
            width: 100%; background: rgba(255, 255, 255, 0.1) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important; border-radius: 15px;
            color: #ffffff !important; padding: 20px; box-sizing: border-box; resize: none;
        }
    </style>

    <script>
        var path = "${pageContext.request.contextPath}";
        var loginUserId = "${sessionScope.loginUser.userId}";

        $(function() {
            // 1. 목록가기
            $('#btnList').click(function() { location.href = path + "/board/list"; });

            // 2. 수정/삭제
            $('#btnEdit').click(function() {
                if (confirm("게시글을 수정 또는 삭제하시겠습니까?")) {
                    location.href = path + "/board/board_update?bno=${dto.bno}&user_id=" + loginUserId;
                }
            });

            // 3. 좋아요 클릭
            $('#btnLike').click(function() {
                if (!loginUserId) {
                    alert("로그인이 필요한 서비스입니다.");
                    return;
                }
                $.ajax({
                    url: path + "/like/selest",
                    type: "post",
                    data: { "bno": "${dto.bno}", "userId": loginUserId },
                    success: function() { getLikeInfo(); },
                    error: function() { alert("좋아요 처리 중 오류 발생"); }
                });
            });

            // 4. 댓글 등록 버튼 클릭
            $('#btnReply').click(function() {
                var content = $('#reply_content').val();
                if (!loginUserId) {
                    alert("로그인이 필요한 서비스입니다.");
                    return;
                }
                if (content.trim() == "") {
                    alert("댓글 내용을 입력해주세요.");
                    $('#reply_content').focus();
                    return;
                }
                $.ajax({
                    url: path + "/reply/insert",
                    type: "post",
                    data: { 
                        "content": content, 
                        "bno": "${dto.bno}", 
                        "userId": loginUserId 
                    },
                    success: function(res) {
                        alert("댓글이 등록되었습니다.");
                        $('#reply_content').val(""); 
                        $("#comment_list").html(res); 
                    },
                    error: function() { alert("댓글 등록 중 오류 발생"); }
                });
            });

            // 5. 초기 데이터 로드
            listReply();
            getLikeInfo();
        }); // $(function) 끝

        // [좋아요 정보 갱신]
        function getLikeInfo() {
            if(!loginUserId) return;
            $.ajax({
                url: path + "/like/getLikeInfo",
                type: "get",
                data: { "bno": "${dto.bno}", "userId": loginUserId },
                success: function(data) {
                    $("#likeCount").text(data.count);
                    if(data.isLiked > 0) {
                        $("#btnLike").addClass("active").find("#likeText").text("LIKED");
                    } else {
                        $("#btnLike").removeClass("active").find("#likeText").text("LIKE");
                    }
                }
            });
        }

        // [댓글 목록 갱신]
        function listReply() {
            $.ajax({
                url: path + "/reply/list",
                type: "get",
                data: { "bno": "${dto.bno}" },
                success: function(res) {
                    $("#comment_list").html(res);
                }
            });
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
                    <div class="meta-box"><span class="meta-key">Post No.</span><span class="meta-val">${dto.bno}</span></div>
                    <div class="meta-box"><span class="meta-key">Author</span><span class="meta-val">${dto.nickname}</span></div>
                    <div class="meta-box"><span class="meta-key">Views</span><span class="meta-val">${dto.viewcnt}</span></div>
                    <div class="meta-box">
                        <span class="meta-key">Permission</span>
                        <span class="meta-val">
                            <c:choose>
                                <c:when test="${sessionScope.loginUser.userId eq dto.userId}"><span style="color:#ffcc00;">● Owner</span></c:when>
                                <c:otherwise>Read Only</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>

            <div class="post-main-content">${dto.content}</div>

            <div class="btn-container">
                <c:if test="${sessionScope.loginUser.userId eq dto.userId}">
                    <button class="pill-button btn-green" id="btnEdit">EDIT / DELETE</button>
                </c:if>
                <button class="pill-button btn-dark" id="btnList">BACK TO LIST</button>
                <button class="pill-button btn-red" id="btnLike">
                    <span id="likeText">LIKE</span>
                    <span id="likeCount" style="margin-left:8px; font-weight: 800;">0</span>
                </button>
            </div>

            <div class="comment-box-card">
                <h3 style="color:#ffcc00; margin-bottom:20px; font-weight:800;">COMMENTS</h3>
                <textarea id="reply_content" rows="3" placeholder="댓글을 입력하세요."></textarea>
                <div style="text-align: right; margin-top:10px;">
                    <button type="button" id="btnReply" class="pill-button btn-green" style="padding: 10px 30px;">SUBMIT</button>
                </div>
                <div id="comment_list" style="margin-top: 30px;"></div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>