<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
/* 리스트 전용 스타일만 남김 */
.reply-container {
	width: 100%;
	margin-top: 20px;
}

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
	border-color: rgba(255, 204, 0, 0.3);
}

.reply-info {
	margin-bottom: 12px;
	display: flex;
	align-items: center;
	gap: 12px;
}

.reply-nickname {
	color: #ffcc00;
	font-weight: 800;
	font-size: 15px;
}

.reply-date {
	color: rgba(255, 255, 255, 0.3);
	font-size: 12px;
}

.reply-content {
	color: #dddddd;
	line-height: 1.7;
	font-size: 15px;
	white-space: pre-wrap;
}

.btn-reply-delete {
	background: rgba(255, 71, 87, 0.1);
	color: #ff4757;
	border: 1px solid rgba(255, 71, 87, 0.2);
	padding: 6px 14px;
	border-radius: 8px;
	font-size: 11px;
	font-weight: 800;
	cursor: pointer;
	transition: all 0.2s;
}

.btn-reply-delete:hover {
	background: #ff4757;
	color: white;
}

.no-reply {
	text-align: center;
	padding: 60px 0;
	color: rgba(255, 255, 255, 0.2);
	font-style: italic;
	background: rgba(255, 255, 255, 0.02);
	border-radius: 15px;
	border: 1px dashed rgba(255, 255, 255, 0.1);
}
</style>

<div class="reply-container">
	<c:forEach var="row" items="${list}">
		<div class="reply-item">
			<div style="flex: 1;">
				<div class="reply-info">
					<span class="reply-nickname">${row.nickname}</span> <span
						class="reply-date"> <fmt:formatDate value="${row.regdate}"
							pattern="yyyy-MM-dd HH:mm" />
					</span>
					<c:if test="${sessionScope.loginUser.nickname eq row.nickname}">
						<span
							style="color: #ffcc00; font-size: 10px; border: 1px solid #ffcc00; padding: 1px 4px; border-radius: 4px;">MY</span>
					</c:if>
				</div>
				<div class="reply-content">${row.content}</div>
			</div>
			<div class="reply-actions">
				<c:if
					test="${sessionScope.loginUser.nickname eq row.nickname or sessionScope.loginUser.userId eq 'admin'}">
					<button type="button" class="btn-reply-delete"
						onclick="deleteReply('${row.cno}', '${row.bno}')">DELETE
					</button>
				</c:if>
			</div>
		</div>
	</c:forEach>

	<c:if test="${empty list}">
		<div class="no-reply">
			<p style="font-size: 16px; margin-bottom: 8px;">아직 작성된 댓글이 없습니다.</p>
			<p style="font-size: 13px; opacity: 0.6;">첫 번째 소중한 의견을 남겨보세요!</p>
		</div>
	</c:if>
</div>