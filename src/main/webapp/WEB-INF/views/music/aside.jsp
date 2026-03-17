<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!-- 
    music-side-wrap
    : 사이드바 전체 영역
-->
<div class="music-side-wrap">

    <!-- 
        music-side-inner
        : 실제 배경 박스 역할
    -->
    <div class="music-side-inner">

        <!-- 
            상단 메뉴 버튼 영역
        -->
        <div class="music-side-section">

            <!-- 메인 홈으로 이동 -->
            <button type="button"
                    class="music-side-btn"
                    onclick="loadMainContent('${path}/music/mainstory')">
                MUSIC HOME
            </button>

            <!-- 추천 페이지로 이동 -->
            <button type="button"
                    class="music-side-btn"
                    onclick="loadMainContent('${path}/music/recommend')">
                추천별 보기
            </button>

            <!-- 랭킹 페이지로 이동 -->
            <button type="button"
                    class="music-side-btn"
                    onclick="loadMainContent('${path}/music/ranking')">
                랭킹별 보기
            </button>
        </div>

        <!-- 구분선 -->
        <hr class="music-side-divider">


        <!-- 플레이리스트/라이브러리 영역 -->
        <div class="music-side-section" id="sidePlaylist">

            <!-- 좋아요 리스트 -->
            <div class="music-side-item" id="btnLike">
                <div class="music-side-icon">
                    <i class="bi bi-heart-fill"></i>
                </div>
                <div class="music-side-info">
                    <div class="music-side-title">좋아요 표시한 곡</div>
                    <div class="music-side-meta">내 라이브러리</div>
                </div>
            </div>
            <!-- 최근 재생 -->
            <div class="music-side-item" id="btnHistory">
                <div class="music-side-icon">
                    <i class="bi bi-clock-history"></i>
                </div>
                <div class="music-side-info">
                    <div class="music-side-title">기록</div>
                    <div class="music-side-meta">최근 재생 목록</div>
                </div>
            </div>

            <!-- 새 재생목록 만들기 -->
            <div class="music-side-item create-playlist" id="btnNewPlaylist">
                <div class="music-side-icon">
                    <i class="bi bi-plus-lg"></i>
                </div>
                <div class="music-side-info">
                    <div class="music-side-title">새 재생목록</div>
                    <div class="music-side-meta">플레이리스트 만들기</div>
                </div>
            </div>

            <!-- NORMAL 플레이리스트 컨테이너 -->
            <div id="normalPlaylistContainer"></div>

        </div>


    </div>
</div>

<script type="module" src="${path}/resources/music/js/playlist.js"></script>
