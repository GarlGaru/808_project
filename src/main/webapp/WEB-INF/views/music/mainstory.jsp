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
    <div data-init="initMainStory">
        <div id="weekly-slider-mount"></div>
        <div id="today-slider-mount"></div>
        <div id="genre-slider-mount"></div>
    </div>
</div>
