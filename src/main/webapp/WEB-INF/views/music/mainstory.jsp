<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${path}/resources/music/css/mainstory.css">

<div class="container mt-4 mb-5">

    <!-- 장르 랭킹 영역 -->
    <div id="genreSongArea">
        <c:if test="${empty songList}">
            <div class="alert alert-secondary">
                등록된 곡이 없습니다. 곡 데이터를 먼저 추가해 주세요.
            </div>
        </c:if>

        <c:if test="${not empty songList}">
            <div class="weekly-rank-container">

                <div class="d-flex align-items-center mb-3">
                    <span style="font-size:1.4rem; margin-right:8px;">🔥</span>
                    <span class="section-title text-white"
                          style="font-size:1.2rem; font-weight:700;">장르 랭킹</span>

                    <div class="weekly-arrows">
                        <button type="button"
                                class="weekly-arrow-btn"
                                onclick="scrollRank('genreWeeklyRankWrapper', -1)">&lt;</button>
                        <button type="button"
                                class="weekly-arrow-btn"
                                onclick="scrollRank('genreWeeklyRankWrapper', 1)">&gt;</button>
                    </div>
                </div>

                <div class="weekly-rank-wrapper" id="genreWeeklyRankWrapper">
                    <div class="weekly-rank-track" id="genreWeeklyRankTrack">
                        <c:forEach var="song" items="${songList}">
                            <div class="card bg-dark text-white music-card"
                                 onclick="location.href='${path}/music/detail?songId=${song.songId}'">

                                <div class="card-img-top-wrapper position-relative">
                                    <c:choose>
                                        <c:when test="${not empty song.coverImageUrl}">
                                            <img class="card-img-top"
                                                 src="${path}${song.coverImageUrl}"
                                                 alt="${song.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="card-img-top"
                                                 src="${path}/resources/music/img/default_album.jpg"
                                                 alt="default">
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="card-body px-1 py-2">
                                    <h6 class="card-title mb-1 text-truncate">
                                        ${song.title}
                                    </h6>
                                    <p class="card-text mb-1 text-truncate"
                                       style="font-size:0.85rem; color:#bbb;">
                                        ${song.artistName}
                                    </p>
                                    <div class="music-meta">
                                        ▶ ${song.playCount} · ♥ ${song.likeCount}
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <br>

    <!-- 추천 랭킹 영역 -->
    <div id="recommendSongArea">
        <c:if test="${empty songList}">
            <div class="alert alert-secondary">
                등록된 곡이 없습니다. 곡 데이터를 먼저 추가해 주세요.
            </div>
        </c:if>

        <c:if test="${not empty songList}">
            <div class="weekly-rank-container">

                <div class="d-flex align-items-center mb-3">
                    <span style="font-size:1.4rem; margin-right:8px;">🔥</span>
                    <span class="section-title text-white"
                          style="font-size:1.2rem; font-weight:700;">추천 랭킹</span>

                    <div class="weekly-arrows">
                        <button type="button"
                                class="weekly-arrow-btn"
                                onclick="scrollRank('recommendWeeklyRankWrapper', -1)">&lt;</button>
                        <button type="button"
                                class="weekly-arrow-btn"
                                onclick="scrollRank('recommendWeeklyRankWrapper', 1)">&gt;</button>
                    </div>
                </div>

                <div class="weekly-rank-wrapper" id="recommendWeeklyRankWrapper">
                    <div class="weekly-rank-track" id="recommendWeeklyRankTrack">
                        <c:forEach var="song" items="${songList}">
                            <div class="card bg-dark text-white music-card"
                                 onclick="location.href='${path}/music/detail?songId=${song.songId}'">

                                <div class="card-img-top-wrapper position-relative">
                                    <c:choose>
                                        <c:when test="${not empty song.coverImageUrl}">
                                            <img class="card-img-top"
                                                 src="${path}${song.coverImageUrl}"
                                                 alt="${song.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="card-img-top"
                                                 src="${path}/resources/music/img/default_album.jpg"
                                                 alt="default">
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="card-body px-1 py-2">
                                    <h6 class="card-title mb-1 text-truncate">
                                        ${song.title}
                                    </h6>
                                    <p class="card-text mb-1 text-truncate"
                                       style="font-size:0.85rem; color:#bbb;">
                                        ${song.artistName}
                                    </p>
                                    <div class="music-meta">
                                        ▶ ${song.playCount} · ♥ ${song.likeCount}
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</div>

<script>
function scrollRank(wrapperId, direction) {
    const wrapper = document.getElementById(wrapperId);
    if (!wrapper) return;

    const moveAmount = 300;
    wrapper.scrollBy({
        left: direction * moveAmount,
        behavior: 'smooth'
    });
}
</script>