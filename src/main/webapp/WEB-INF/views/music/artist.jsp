<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" href="${path}/resources/music/css/music-layout.css">
<link rel="stylesheet" href="${path}/resources/music/css/music-artist.css">

<div class="music-layout-page">
    <div class="music-layout-content">

        <main class="music-layout-main">
            <div class="music-artist-page">

                <!-- 1) 상단 히어로 -->
                <section class="music-artist-hero">
                    <div class="music-artist-hero-bg">
                        <c:choose>
                            <c:when test="${not empty artist.profileImageUrl}">
                                <img src="${path}${artist.profileImageUrl}"
                                     alt="${artist.name}"
                                     class="music-artist-hero-bg-img">
                            </c:when>
                            <c:otherwise>
                                <img src="${path}/resources/music/img/default_artist.jpg"
                                     alt="default artist"
                                     class="music-artist-hero-bg-img">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="music-artist-hero-overlay"></div>

                    <div class="music-artist-hero-content">
                        <div class="music-artist-verified">ARTIST</div>

                        <h1 class="music-artist-main-title">${artist.name}</h1>

                        <div class="music-artist-sub-line">
                            <span class="music-artist-listener">월별 리스너 3,224,448명</span>
                        </div>
                    </div>
                </section>

                <!-- 2) 액션 버튼 -->
                <section class="music-artist-actions">
					<c:if test="${not empty artistSongs}">
					    <button type="button"
					            class="music-artist-play-main-btn js-play-song"
					            data-song-id="${artistSongs[0].songId}"
					            data-title="${artistSongs[0].title}"
					            data-artist="${artistSongs[0].artistName}"
					            data-cover="${empty artistSongs[0].coverImageUrl ? '/resources/music/img/default_album.png' : artistSongs[0].coverImageUrl}"
					            onclick="event.stopPropagation(); playerManager.playByButton(this);">
					        ▶
					    </button>
					</c:if>


                    <button type="button" class="music-artist-more-btn">
                        ···
                    </button>
                </section>

                <!-- 3) 인기곡 리스트 -->
                <section class="music-artist-list-section">
                    <div class="music-artist-list-header">
                        <h2 class="music-artist-list-title">인기</h2>
                    </div>

                    <div class="music-artist-table-body" data-playlist-scope>
                        <c:forEach var="song" items="${artistSongs}" varStatus="st">
                            <div class="music-artist-row"
                                 onclick="loadMainContent('${path}/music/detail?songId=${song.songId}')">

                                <div class="music-artist-col-index">
                                    ${st.index + 1}
                                </div>

                                <div class="music-artist-col-song">
                                    <div class="music-artist-song-thumb-wrap">
                                        <c:choose>
                                            <c:when test="${not empty song.coverImageUrl}">
                                                <img src="${song.coverImageUrl}"
                                                     alt="${song.title}"
                                                     class="music-artist-song-thumb">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${path}/resources/music/img/default_album.png"
                                                     alt="default album"
                                                     class="music-artist-song-thumb">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="music-artist-song-info">
                                        <div class="music-artist-song-title">${song.title}</div>
                                    </div>
                                </div>

                                <div class="music-artist-col-stream">
                                    124,472,307
                                </div>

                                <div class="music-artist-col-time">
                                    3:31
                                </div>

                                <div class="music-artist-col-play">
									  <button type="button"
									        class="music-artist-play-btn js-play-song"
									        data-song-id="${song.songId}"
									        data-title="${song.title}"
									        data-artist="${song.artistName}"
									        data-cover="${empty song.coverImageUrl ? '/resources/music/img/default_album.png' : song.coverImageUrl}"
									        onclick="event.stopPropagation(); playerManager.playByButton(this);">
									    ▶
									</button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </section>

            </div>
        </main>
    </div>
</div>