<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<div class="music-search-page">
    
    <c:choose>
        
        <%-- 검색어가 없을 때 --%>
        <c:when test="${empty keyword}">
            <div class="music-search-state-box">
                <h2 class="music-search-state-title">검색</h2>
                <p class="music-search-state-desc">검색어를 입력해주세요.</p>
            </div>
        </c:when>

        <%-- 검색 결과가 없을 때 --%>
        <c:when test="${not empty keyword and empty searchList}">
            <div class="music-search-state-box">
                <h2 class="music-search-state-title">‘${keyword}’ 검색 결과</h2>
                <p class="music-search-state-desc">검색 결과가 없습니다.</p>
            </div>
        </c:when>

        <%-- 검색 결과가 있을 때 --%>
        <c:otherwise>
            <div class="music-search-header">
                <h2 class="music-search-title">‘${keyword}’ 검색 결과</h2>
            </div>

            <div class="music-search-top-layout">
                
                <%-- 상위 결과 --%>
                <div class="music-search-top-result">
                    <h3 class="music-search-section-title">상위 결과</h3>

                    <c:forEach var="topSong" items="${searchList}" begin="0" end="0">
                        <div class="music-search-top-card"
                             onclick="location.href='${path}/music/detail?songId=${topSong.songId}'">

                            <div class="music-search-top-cover-wrap">
                                <img
                                    class="music-search-top-cover"
                                    src="${empty topSong.coverImageUrl ? '/resources/music/img/default_album.jpg' : topSong.coverImageUrl}"
                                    alt="${topSong.title}">
                            </div>

                            <div class="music-search-top-info">
                                <div class="music-search-top-name">${topSong.title}</div>
                                <div class="music-search-top-sub">
                                    <span class="music-search-top-badge">곡</span>
                                    <span>${topSong.artistName}</span>
                                </div>
                            </div>

                            <button type="button"
                                    class="music-search-top-play-btn js-play-song"
                                    onclick="event.stopPropagation();"
                                    data-song-id="${topSong.songId}"
                                    data-title="${topSong.title}"
                                    data-artist="${topSong.artistName}"
                                    data-cover="${empty topSong.coverImageUrl ? '/resources/music/img/default_album.jpg' : topSong.coverImageUrl}">
                                ▶
                            </button>
                        </div>
                    </c:forEach>
                </div>

                <%-- 곡 목록 --%>
                <div class="music-search-song-result">
                    <h3 class="music-search-section-title">곡</h3>

                    <div class="music-search-song-list">
                        <c:forEach var="song" items="${searchList}" begin="0" end="3">
                            <div class="music-search-song-row"
                                 onclick="location.href='${path}/music/detail?songId=${song.songId}'">

                                <div class="music-search-song-left">
                                    <img
                                        class="music-search-song-cover"
                                        src="${empty song.coverImageUrl ? '/resources/music/img/default_album.jpg' : song.coverImageUrl}"
                                        alt="${song.title}">

                                    <div class="music-search-song-meta">
                                        <div class="music-search-song-title">${song.title}</div>
                                        <div class="music-search-song-artist">${song.artistName}</div>
                                    </div>
                                </div>

                                <div class="music-search-song-right">
                                       <button type="button"
									        class="music-detail-row-play-btn js-play-song"
									        data-song-id="${song.songId}"
									        data-title="${song.title}"
									        data-artist="${song.artistName}"
									        data-cover="${empty song.coverImageUrl ? '/resources/music/img/default_album.jpg' : song.coverImageUrl}">
									 		   ▶
										</button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <%-- 앨범 섹션 --%>
            <section class="music-search-section">
                <h3 class="music-search-section-title">앨범</h3>

                <div class="music-search-card-grid music-search-album-grid">
                    <c:forEach var="song" items="${searchList}" begin="0" end="5">
                        <div class="music-search-media-card">
                            <div class="music-search-media-thumb-wrap">
                                <img
                                    class="music-search-media-thumb"
                                    src="${empty song.coverImageUrl ? '/resources/music/img/default_album.jpg' : song.coverImageUrl}"
                                    alt="${song.albumTitle}">
                            </div>

                            <div class="music-search-media-info">
                                <div class="music-search-media-title">
                                    ${empty song.albumTitle ? song.title : song.albumTitle}
                                </div>
                                <div class="music-search-media-sub">
                                    앨범 · ${song.artistName}
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>

           
        </c:otherwise>
    </c:choose>
</div>