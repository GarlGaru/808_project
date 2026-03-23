<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<body class="dark-mode">



    <div class="music-layout-page">
        <div class="music-layout-content">

            <!-- 랭킹 본문 -->
            <main class="music-layout-main">
                <div class="music-ranking-page">

                    <!-- 1) 최근 인기 랭킹 -->
                    <section class="music-ranking-block">
                        <div class="music-ranking-block-header">
                            <div>
                                <h2 class="music-ranking-block-title">최근 인기 랭킹</h2>
                                <p class="music-ranking-block-desc">가장 많이 재생된 곡들을 확인해보세요.</p>
                            </div>
						
						<!--  슬라이더 버튼 -->
                            <div class="music-ranking-controls">
                                <button type="button"
                                        class="music-ranking-arrow"
                                        onclick="moveRankingSlider('weeklyRankingSlider', -1)">
                                    ‹
                                </button>
                                <button type="button"
                                        class="music-ranking-arrow"
                                        onclick="moveRankingSlider('weeklyRankingSlider', 1)">
                                    ›
                                </button>
                            </div>
                            
                        </div>
<!--주간 랭킹----------------------------------------------------  -->
                        <c:choose>
                            <c:when test="${not empty weeklyRanking}">
                                <div class="music-ranking-viewport" id="weeklyRankingSlider">
                                    <div class="music-ranking-track" data-playlist-scope>
                                        <c:forEach var="song" items="${weeklyRanking}">
                                            <div class="music-ranking-card"
                                                 onclick="loadMainContent('${path}/music/detail?songId=${song.songId}')">

                                                <div class="music-ranking-thumb-wrap">
                                                    <c:choose>
                                                        <c:when test="${not empty song.coverImageUrl}">
                                                            <img src="${path}${song.coverImageUrl}"
                                                                 alt="${song.title}"
                                                                 class="music-ranking-thumb">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${path}/resources/music/img/default_album.jpg"
                                                                 alt="default album"
                                                                 class="music-ranking-thumb">
                                                        </c:otherwise>
                                                    </c:choose>

                                                <button type="button"
												        class="music-ranking-play-btn js-play-song"
												        onclick="playRankingSong(event, this)"
												        data-song-id="${song.songId}"
												        data-title="${song.title}"
												        data-artist="${song.artistName}"
												        data-cover="${empty song.coverImageUrl ? '/resources/music/img/default_album.jpg' : song.coverImageUrl}">
												    ▶
												</button>
                                                </div>

                                                <div class="music-ranking-card-body">
                                                    <div class="music-ranking-card-title">${song.title}</div>
								                        <button type="button"
														        class="music-artist-link"
														        onclick="event.stopPropagation(); loadMainContent('${path}/music/artist?artistId=${song.artistId}');">
														    ${song.artistName}
														</button>
                                                   
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="music-ranking-empty">최근 인기 랭킹 데이터가 없습니다.</div>
                            </c:otherwise>
                        </c:choose>
                    </section>

                    <!-- 2) 오늘의 히트곡 -->
                    <section class="music-ranking-block">
                        <div class="music-ranking-block-header">
                            <div>
                                <h2 class="music-ranking-block-title">오늘의 히트곡</h2>
                                <p class="music-ranking-block-desc">오늘 가장 반응이 좋은 곡입니다.</p>
                            </div>

                            <div class="music-ranking-controls">
                                <button type="button"
                                        class="music-ranking-arrow"
                                        onclick="moveRankingSlider('todayRankingSlider', -1)">
                                    ‹
                                </button>
                                <button type="button"
                                        class="music-ranking-arrow"
                                        onclick="moveRankingSlider('todayRankingSlider', 1)">
                                    ›
                                </button>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${not empty todayHitSongs}">
                                <div class="music-ranking-viewport" id="todayRankingSlider">
                                   <div class="music-ranking-track" data-playlist-scope>
                                        <c:forEach var="song" items="${todayHitSongs}">
                                            <div class="music-ranking-card"
                                                  onclick="loadMainContent('${path}/music/detail?songId=${song.songId}')">

                                                <div class="music-ranking-thumb-wrap">
                                                    <c:choose>
                                                        <c:when test="${not empty song.coverImageUrl}">
                                                            <img src="${path}${song.coverImageUrl}"
                                                                 alt="${song.title}"
                                                                 class="music-ranking-thumb">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${path}/resources/music/img/default_album.jpg"
                                                                 alt="default album"
                                                                 class="music-ranking-thumb">
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <button type="button"
													        class="music-ranking-play-btn js-play-song"
													        onclick="playRankingSong(event, this)"
													        data-song-id="${song.songId}"
													        data-title="${song.title}"
													        data-artist="${song.artistName}"
													        data-cover="${empty song.coverImageUrl ? '/resources/music/img/default_album.jpg' : song.coverImageUrl}">
													    ▶
													</button>
                                                </div>

                                                <div class="music-ranking-card-body">
                                                    <div class="music-ranking-card-title">${song.title}</div>
	                                                     <button type="button"
														        class="music-artist-link"
														        onclick="event.stopPropagation(); loadMainContent('${path}/music/artist?artistId=${song.artistId}');">
														    ${song.artistName}
														</button>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="music-ranking-empty">오늘의 히트곡 데이터가 없습니다.</div>
                            </c:otherwise>
                        </c:choose>
                    </section>

                    <!-- 3) 장르 인기곡 -->
                    <section class="music-ranking-block">
                        <div class="music-ranking-block-header">
                            <div>
                                <h2 class="music-ranking-block-title">장르 인기곡</h2>
                                <p class="music-ranking-block-desc">선택된 장르에서 반응이 높은 곡입니다.</p>
                            </div>

                            <div class="music-ranking-controls">
                                <button type="button"
                                        class="music-ranking-arrow"
                                        onclick="moveRankingSlider('genreRankingSlider', -1)">
                                    ‹
                                </button>
                                <button type="button"
                                        class="music-ranking-arrow"
                                        onclick="moveRankingSlider('genreRankingSlider', 1)">
                                    ›
                                </button>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${not empty genreRanking}">
                                <div class="music-ranking-viewport" id="genreRankingSlider">
                                    <div class="music-ranking-track" data-playlist-scope>
                                        <c:forEach var="song" items="${genreRanking}">
                                            <div class="music-ranking-card"
                                                  onclick="loadMainContent('${path}/music/detail?songId=${song.songId}')">

                                                <div class="music-ranking-thumb-wrap">
                                                    <c:choose>
                                                        <c:when test="${not empty song.coverImageUrl}">
                                                            <img src="${path}${song.coverImageUrl}"
                                                                 alt="${song.title}"
                                                                 class="music-ranking-thumb">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${path}/resources/music/img/default_album.jpg"
                                                                 alt="default album"
                                                                 class="music-ranking-thumb">
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <button type="button"
													        class="music-ranking-play-btn js-play-song"
													        onclick="playRankingSong(event, this)"
													        data-song-id="${song.songId}"
													        data-title="${song.title}"
													        data-artist="${song.artistName}"
													        data-cover="${empty song.coverImageUrl ? '/resources/music/img/default_album.jpg' : song.coverImageUrl}">
													    ▶
													</button>
                                                </div>

                                                <div class="music-ranking-card-body">
                                                    <div class="music-ranking-card-title">${song.title}</div>
	                                                    <button type="button"
														        class="music-artist-link"
														        onclick="event.stopPropagation(); loadMainContent('${path}/music/artist?artistId=${song.artistId}');">
														    ${song.artistName}
														</button>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="music-ranking-empty">장르 인기곡 데이터가 없습니다.</div>
                            </c:otherwise>
                        </c:choose>
                    </section>

                </div>
            </main>
        </div>

    </div>