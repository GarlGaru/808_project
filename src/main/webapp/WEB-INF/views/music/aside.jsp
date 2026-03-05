<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="path" value="${pageContext.request.contextPath}" /> 

<aside class="sidebar">
	<br><br><br>
	<div>
		<button type="button" class="player-btn" id="btnPrev" onclick="location.href='${path}/music'">MUSIC HOME</button>
	</div>
	<div>
		<button type="button" class="player-btn" id="btnPrev" onclick="location.href='${path}/music/recommend'">추천별 보기</button>
	</div>
	<div>
		<button type="button" class="player-btn" id="btnPrev" onclick="location.href='${path}/music/ranking'">랭킹별 보기</button>
	</div>
	<div>
		<button type="button" class="player-btn" id="btnPrev">+ 새 재생목록</button>
	</div>
</aside>













