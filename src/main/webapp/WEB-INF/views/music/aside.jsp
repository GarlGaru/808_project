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
                    onclick="location.href='${path}/music'">
                MUSIC HOME
            </button>

            <!-- 추천 페이지로 이동 -->
            <button type="button"
                    class="music-side-btn"
                    onclick="location.href='${path}/music/recommend'">
                추천별 보기
            </button>

            <!-- 랭킹 페이지로 이동 -->
            <button type="button"
                    class="music-side-btn"
                    onclick="location.href='${path}/music/ranking'">
                랭킹별 보기
            </button>
        </div>

        <!-- 구분선 -->
        <hr class="music-side-divider">

        <!-- 
            플레이리스트/라이브러리 영역
        -->
        <div class="music-side-section" id="sidePlaylist">

            <!-- 내 플레이리스트 -->
            <div class="music-side-item create-playlist">
                <div class="music-side-icon">+</div>
                <div class="music-side-info">
                    <div class="music-side-title">내 플레이리스트</div>
                    <div class="music-side-meta">새 리스트 만들기</div>
                </div>
            </div>

            <!-- 좋아요 리스트 -->
            <div class="music-side-item">
                <div class="music-side-icon">♥</div>
                <div class="music-side-info">
                    <div class="music-side-title">좋아요 표시한 곡</div>
                    <div class="music-side-meta">내 라이브러리</div>
                </div>
            </div>

            <!-- 최근 재생 -->
            <div class="music-side-item">
                <div class="music-side-icon">♪</div>
                <div class="music-side-info">
                    <div class="music-side-title">최근 재생한 곡</div>
                    <div class="music-side-meta">최근 청취 기록</div>
                </div>
            </div>

        </div>
    </div>
</div>