<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${path}/resources/music/css/side.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<aside class="sidebar">
	<div class="sidebar-inner">

		<!-- 상단 메뉴 -->
		<div class="sidebar-section">
			<button type="button" class="sidebar-menu-btn" id="btnHome"
				onclick="location.href='${path}/music'">
				MUSIC HOME
			</button>

			<button type="button" class="sidebar-menu-btn" id="btnRecomm"
				onclick="location.href='${path}/music/recommend'">
				추천별 보기
			</button>

			<button type="button" class="sidebar-menu-btn" id="btnRank"
				onclick="location.href='${path}/music/ranking'">
				랭킹별 보기
			</button>
		</div>

		<hr>

		<!-- 라이브러리 / 플레이리스트 -->
		<div class="sidebar-section" id="sidePlaylist">

			<div class="playlist-item" id="btnLike">
				<div class="playlist-icon">
					<i class="bi bi-heart-fill"></i>
				</div>
				<div class="playlist-info">
					<div class="playlist-title">좋아요 표시한 곡</div>
					<div class="playlist-meta">내 라이브러리</div>
				</div>
			</div>

			<div class="playlist-item" id="btnHistory">
				<div class="playlist-icon">
					<i class="bi bi-clock-history"></i>
				</div>
				<div class="playlist-info">
					<div class="playlist-title">기록</div>
					<div class="playlist-meta">최근 재생 목록</div>
				</div>
			</div>

			<div class="playlist-item create-playlist" id="btnNewPlaylist">
				<div class="playlist-icon">
					<i class="bi bi-plus-lg"></i>
				</div>
				<div class="playlist-info">
					<div class="playlist-title">새 재생목록</div>
					<div class="playlist-meta">플레이리스트 만들기</div>
				</div>
			</div>

			<c:forEach var="playlist" items="${palylistAll}">
				<div class="playlist-item playlist-btn" data-playlist-id="${playlist.playlistId}">
					<div class="playlist-icon">
						<i class="bi bi-music-note"></i>
					</div>
					<div class="playlist-info">
						<div class="playlist-title">${playlist.title}</div>
						<div class="playlist-meta">플레이리스트</div>
					</div>
				</div>
			</c:forEach>

		</div>

	</div>
</aside>

<script type="module" src="${path}/resources/music/playlist.js"></script>