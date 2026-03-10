<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="path" value="${pageContext.request.contextPath}" /> 

<aside class="sidebar">
	<br><br><br>
	<div>
		<div type="button" class="player-btn" id="btnHome" onclick="location.href='${path}/music'">MUSIC HOME</div>
	</div>
	<div>
		<div type="button" class="player-btn" id="btnRecomm" onclick="location.href='${path}/music/recommend'">추천별 보기</div>
	</div>
	<div>
		<div type="button" class="player-btn" id="btnRank" onclick="location.href='${path}/music/ranking'">랭킹별 보기</div>
	</div>
	<hr>
	<div id="sidePlaylist">
		<div type="button" class="player-btn" id="btnLike">
			좋아요 표시한 곡
		</div>
		<div type="button" class="player-btn" id="btnHistory">
			기록
		</div>



		<div type="button" class="player-btn" id="btnNewPlaylist">+ 새 재생목록</div>
		<c:forEach var="playlist" items="${palylistAll}">
			<div type="button" class="player-btn">
				${playlist.title}
			</div>
		</c:forEach>
			<div type="button" class="player-btn">
				플레이리스트
			</div>
			<div type="button" class="player-btn">
				플레이리스트
			</div>
	</div>
</aside>

<script type="module" src="${path}/resources/music/playlist.js"></script>











