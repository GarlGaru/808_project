<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
    /* 댓글 리스트 컨테이너 */
    .reply-container {
        width: 100%;
        margin-top: 20px;
    }

    /* 각 댓글 카드 */
    .reply-item {
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid rgba(255, 255, 255, 0.05);
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 15px;
        transition: all 0.3s ease;
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
    }

    .reply-item:hover {
        background: rgba(255, 255, 255, 0.06);
        transform: translateX(5px);
        border-color: rgba(255, 107, 19, 0.3);
    }

    /* 댓글 정보 (닉네임, 날짜) */
    .reply-info {
        margin-bottom: 10px;
    }

    .reply-nickname {
        color: #ffcc00; /* 옐로우 포인트 */
        font-weight: 800;
        font-size: 15px;
        margin-right: 12px;
    }

    .reply-date {
        color: rgba(255, 255, 255, 0.4);
        font-size: 12px;
    }

    /* 댓글 본문 */
    .reply-content {
        color: #eeeeee;
        line-height: 1.6;
        font-size: 15px;
        white-space: pre-wrap; /* 줄바꿈 유지 */
    }

    /* 삭제 버튼 */
    .btn-reply-delete {
        background: rgba(255, 71, 87, 0.1);
        color: #ff4757;
        border: 1px solid rgba(255, 71, 87, 0.2);
        padding: 6px 12px;
        border-radius: 8px;
        font-size: 12px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.2s;
    }

    .btn-reply-delete:hover {
        background: #ff4757;
        color: white;
        box-shadow: 0 0 10px rgba(255, 71, 87, 0.4);
    }

    /* 댓글 없을 때 */
    .no-reply {
        text-align: center;
        padding: 50px 0;
        color: rgba(255, 255, 255, 0.3);
        font-style: italic;
    }
</style>

<script>
    function deleteReply(cno, bno) {
        var path = "${pageContext.request.contextPath}";
        
        if(confirm("이 댓글을 정말 삭제하시겠습니까?")) {
            $.ajax({
                url: path + "/reply/delete",
                type: "post",
                data: { "cno": cno, "bno": bno },
                success: function(res) {
                    alert("댓글이 삭제되었습니다.");
                    // 부모창(detail.jsp)에 있는 listReply() 함수 호출
                    if(typeof listReply === 'function') {
                        listReply(); 
                    } else {
                        // 만약 함수를 못찾으면 현재 결과물(res)로 영역 갱신
                        $("#comment_list").html(res);
                    }
                },
                error: function() {
                    alert("삭제 중 오류가 발생했습니다.");
                }
            });
        }
    }
</script>

<div class="reply-container">
    <c:forEach var="row" items="${list}">
        <div class="reply-item">
            <div style="flex: 1;">
                <div class="reply-info">
                    <span class="reply-nickname">${row.nickname}</span>
                    <span class="reply-date">
                        <fmt:formatDate value="${row.regdate}" pattern="yyyy-MM-dd HH:mm" />
                    </span>
                </div>
                <div class="reply-content">${row.content}</div>
            </div>
            
            <div class="reply-actions">
                <c:if test="${sessionScope.loginUser.nickname eq row.nickname}">
                    <button type="button" class="btn-reply-delete" 
                            onclick="deleteReply('${row.cno}', '${row.bno}')">
                        DELETE
                    </button>
                </c:if>
            </div>
        </div>
    </c:forEach>

    <c:if test="${empty list}">
        <div class="no-reply">
            <p>아직 작성된 댓글이 없습니다.</p>
            <p style="font-size: 13px;">첫 번째 의견을 남겨보세요!</p>
        </div>
    </c:if>
</div>