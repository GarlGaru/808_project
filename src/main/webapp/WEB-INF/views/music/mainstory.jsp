<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<div class="music-home-wrap">
	<!-- 검색  -->
    <form class="music-search-form music-search-expand"
        onsubmit="event.preventDefault(); submitMusicSearch(this);">

        <input type="text" name="keyword" placeholder="검색">

        <button type="submit" class="music-search-btn" aria-label="검색">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="7"></circle>
                <line x1="16.65" y1="16.65" x2="21" y2="21"></line>
            </svg>
        </button>
    </form>
    <hr>


        <div id="ai-chat-input-wrap">
            <div id="ai-chat-input-bar">
            <textarea id="ai-chat-msg" rows="1" placeholder="메시지를 입력하세요..."></textarea>
            <button id="ai-chat-send" onclick="loadMainContent('${path}/music/chat')">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2"/></svg>
            </button>
            </div>
        </div>

    <div data-init="initMainStory">
        <div id="weekly-slider-mount"></div>
        <div id="today-slider-mount"></div>
        <div id="genre-slider-mount"></div>
    </div>
</div>
