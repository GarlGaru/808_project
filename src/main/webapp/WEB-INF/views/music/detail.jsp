<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Music Detail Page">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>${song.title}</title>



    <!-- 음악 페이지 전용 CSS -->

    <link rel="stylesheet" href="${path}/resources/music/css/music-detail.css">
</head>
<body class="dark-mode">

    <div class="music-layout-page">
        <div class="music-layout-content">



            <!-- 상세 본문 -->
            <main class="music-layout-main">
                <div class="music-detail-page">

                    <!-- =========================
                         1) 상단 히어로 영역
                         ========================= -->
                    <section class="music-detail-hero">
                        <!-- 배경 오버레이 -->
                        <div class="music-detail-hero-overlay"></div>

                        <!-- 커버 이미지 -->
                        <div class="music-detail-hero-cover-wrap">
                            <c:choose>
                                <c:when test="${not empty song.coverImageUrl}">
                                    <img src="${path}${song.coverImageUrl}"
                                         alt="${song.title}"
                                         class="music-detail-hero-cover">
                                </c:when>
                                <c:otherwise>
                                    <img src="${path}/resources/music/img/default_album.jpg"
                                         alt="default album"
                                         class="music-detail-hero-cover">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- 곡 정보 -->
                        <div class="music-detail-hero-info">
                            <div class="music-detail-type">곡 상세</div>

                            <h1 class="music-detail-main-title">${song.title}</h1>

                            <div class="music-detail-sub-line">
                                <span class="music-detail-artist-name">${song.artistName}</span>
                                <span class="music-detail-dot">•</span>
                                <span>${song.albumTitle}</span>
                                <span class="music-detail-dot">•</span>
                                <span>${song.genreName}</span>
                            </div>

                            <div class="music-detail-desc">
                                지금 재생 중인 곡의 상세 정보와 같은 장르의 추천곡을 확인할 수 있습니다.
                            </div>
                        </div>
                    </section>

                    <!-- =========================
                         2) 액션 버튼 영역
                         ========================= -->
                    <section class="music-detail-actions">
                        <!-- 큰 재생 버튼 -->
                    <button type="button"
                        class="music-detail-row-play-btn js-play-song"
                        data-song-id="${song.songId}"
                        data-title="${song.title}"
                        data-artist="${song.artistName}"
                        data-cover="${song.coverImageUrl}">
                        ▶
                    </button>

                        <!-- 좋아요 -->
                        <button type="button" class="music-detail-icon-btn" title="좋아요">
                            ♡
                        </button>

                        <!-- 추가 -->
                        <button type="button" class="music-detail-icon-btn" title="추가">
                            ＋
                        </button>

                        <!-- 더보기 -->
                        <button type="button" class="music-detail-icon-btn" title="더보기">
                            ⋯
                        </button>
                    </section>

                    <!-- =========================
                         3) 곡 메타 정보 박스
                         ========================= -->
                    <section class="music-detail-meta-box">
                        <div class="music-detail-meta-card">
                            <div class="music-detail-meta-label">제목</div>
                            <div class="music-detail-meta-value">${song.title}</div>
                        </div>

                        <div class="music-detail-meta-card">
                            <div class="music-detail-meta-label">아티스트</div>
                            <div class="music-detail-meta-value">${song.artistName}</div>
                        </div>

                        <div class="music-detail-meta-card">
                            <div class="music-detail-meta-label">앨범</div>
                            <div class="music-detail-meta-value">${song.albumTitle}</div>
                        </div>

                        <div class="music-detail-meta-card">
                            <div class="music-detail-meta-label">장르</div>
                            <div class="music-detail-meta-value">${song.genreName}</div>
                        </div>
                    </section>

                    <!-- =========================
                         4) 유사곡 리스트
                         ========================= -->
                    <section class="music-detail-list-section">
                        <div class="music-detail-list-header">
                            <h2 class="music-detail-list-title">유사 곡 추천</h2>
                            <p class="music-detail-list-desc">이 곡과 같은 장르의 추천곡입니다.</p>
                        </div>

                        <!-- 테이블 헤더 -->
                        <div class="music-detail-table-head">
                            <div class="music-detail-col-index">#</div>
                            <div class="music-detail-col-song">제목</div>
                           	<div class="music-detail-col-artist">아티스트</div>
                            <div class="music-detail-col-album">앨범</div>
                            <div class="music-detail-col-genre">장르</div>
                            <div class="music-detail-col-play">재생</div>
                        </div>

             			<!-- 추천곡들이 들어가는 전체 박스 -->
						<div class="music-detail-table-body">
						
						    <!-- similarList 안의 곡들을 하나씩 반복 -->
						    <c:forEach var="sim" items="${similarList}" varStatus="st">
						
						        <!-- 곡 한 줄 / 클릭 시 상세페이지 이동 -->
						        <div class="music-detail-row"
						             onclick="loadMainContent('${path}/music/detail?songId=${sim.songId}')">

						
						            <!-- 몇 번째 곡인지 번호 표시 -->
						            <div class="music-detail-col-index">
						                ${st.index + 1}
						            </div>
						
						            <!-- 곡 정보가 들어가는 칸 -->
						            <div class="music-detail-col-song">
						
						                <!-- 앨범 썸네일 박스 -->
						                <div class="music-detail-song-thumb-wrap">
						
						                 
						                    <c:choose>
						                        <c:when test="${not empty sim.coverImageUrl}">
						                            <img src="${path}${sim.coverImageUrl}"
						                                 alt="${sim.title}"
						                                 class="music-detail-song-thumb">
						                        </c:when>
						                        <c:otherwise>
						                            <img src="${path}/resources/music/img/default_album.jpg"
						                                 alt="default album"
						                                 class="music-detail-song-thumb">
						                        </c:otherwise>
						                    </c:choose>
						                </div>
                                        <div class="music-detail-song-info">
                                            <div class="music-detail-song-title">${sim.title}</div>
                                        </div>
										
									</div>
									
									<div class="music-detail-col-artist">
										${sim.artistName}
										</div>
										
                                    <div class="music-detail-col-album">
                                        ${sim.albumTitle}
                                    </div>

                                    <div class="music-detail-col-genre">
                                        ${sim.genreName}
                                    </div>

                                    <div class="music-detail-col-play">
                                   <button type="button"
								        class="music-detail-hero-play-btn js-play-song"
								        data-song-id="${sim.songId}"
								        data-title="${sim.title}"
								        data-artist="${sim.artistName}"
								        data-cover="${sim.coverImageUrl}">
									    ▶ 재생
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
    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>

</body>
</html>
