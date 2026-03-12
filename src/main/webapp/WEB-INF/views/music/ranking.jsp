<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Music Ranking Page">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>랭킹</title>

    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">

    <!-- 음악 전용 CSS -->
    <link rel="stylesheet" href="${path}/resources/music/css/music-layout.css">
    <link rel="stylesheet" href="${path}/resources/music/css/music-sidebar.css">
    <link rel="stylesheet" href="${path}/resources/music/css/music-player.css">
    <link rel="stylesheet" href="${path}/resources/music/css/music-ranking.css">
</head>
<body class="dark-mode">

    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="music-layout-page">
        <div class="music-layout-content">

            <!-- 왼쪽 사이드바 -->
            <aside class="music-layout-aside">
                <%@ include file="/WEB-INF/views/music/aside.jsp" %>
            </aside>

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

                        <c:choose>
                            <c:when test="${not empty weeklyRanking}">
                                <div class="music-ranking-viewport" id="weeklyRankingSlider">
                                    <div class="music-ranking-track">
                                        <c:forEach var="song" items="${weeklyRanking}">
                                            <div class="music-ranking-card"
                                                 onclick="location.href='${path}/music/detail?songId=${song.songId}'">

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
                                                            class="music-ranking-play-btn"
                                                            onclick="playRankingSong(event, this)"
                                                            data-song-id="${song.songId}"
                                                            data-title="${song.title}"
                                                            data-artist="${song.artistName}"
                                                            data-cover="${song.coverImageUrl}"
                                                           >
                                                        ▶
                                                    </button>
                                                </div>

                                                <div class="music-ranking-card-body">
                                                    <div class="music-ranking-card-title">${song.title}</div>
                                                    <div class="music-ranking-card-sub">${song.artistName}</div>
                                                    <div class="music-ranking-card-meta">점수 ${song.totalScore}</div>
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
                                    <div class="music-ranking-track">
                                        <c:forEach var="song" items="${todayHitSongs}">
                                            <div class="music-ranking-card"
                                                 onclick="location.href='${path}/music/detail?songId=${song.songId}'">

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
                                                            class="music-ranking-play-btn"
                                                            onclick="playRankingSong(event, this)"
                                                            data-song-id="${song.songId}"
                                                            data-title="${song.title}"
                                                            data-artist="${song.artistName}"
                                                            data-cover="${song.coverImageUrl}"
                                                            >
                                                        ▶
                                                    </button>
                                                </div>

                                                <div class="music-ranking-card-body">
                                                    <div class="music-ranking-card-title">${song.title}</div>
                                                    <div class="music-ranking-card-sub">${song.artistName}</div>
                                                    <div class="music-ranking-card-meta">점수 ${song.totalScore}</div>
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
                                    <div class="music-ranking-track">
                                        <c:forEach var="song" items="${genreRanking}">
                                            <div class="music-ranking-card"
                                                 onclick="location.href='${path}/music/detail?songId=${song.songId}'">

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
                                                            class="music-ranking-play-btn"
                                                            onclick="playRankingSong(event, this)"
                                                            data-song-id="${song.songId}"
                                                            data-title="${song.title}"
                                                            data-artist="${song.artistName}"
                                                            data-cover="${song.coverImageUrl}"
                                                           >
                                                        ▶
                                                    </button>
                                                </div>

                                                <div class="music-ranking-card-body">
                                                    <div class="music-ranking-card-title">${song.title}</div>
                                                    <div class="music-ranking-card-sub">${song.artistName}</div>
                                                    <div class="music-ranking-card-meta">점수 ${song.totalScore}</div>
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
            <%@ include file="/WEB-INF/views/common/footer.jsp" %>

        <%@ include file="/WEB-INF/views/music/player.jsp" %>
    </div>

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>

    <script>
        const rankingSliderState = {};

        function getRankingVisibleCount() {
            const width = window.innerWidth;
            if (width <= 768) return 2;
            if (width <= 1200) return 4;
            if (width <= 1600) return 6;
            return 8;
        }

        function moveRankingSlider(sliderId, direction) {
            const viewport = document.getElementById(sliderId);
            if (!viewport) return;

            const track = viewport.querySelector('.music-ranking-track');
            const cards = track.querySelectorAll('.music-ranking-card');
            if (!cards.length) return;

            const visibleCount = getRankingVisibleCount();
            const maxIndex = Math.max(0, cards.length - visibleCount);

            if (!rankingSliderState[sliderId]) {
                rankingSliderState[sliderId] = 0;
            }

            rankingSliderState[sliderId] += direction * visibleCount;

            if (rankingSliderState[sliderId] < 0) rankingSliderState[sliderId] = 0;
            if (rankingSliderState[sliderId] > maxIndex) rankingSliderState[sliderId] = maxIndex;

            const cardWidth = cards[0].offsetWidth;
            const gap = 18;
            const moveX = (cardWidth + gap) * rankingSliderState[sliderId];

            track.style.transform = 'translateX(-' + moveX + 'px)';
        }

        window.addEventListener('resize', function() {
            Object.keys(rankingSliderState).forEach(function(sliderId) {
                rankingSliderState[sliderId] = 0;
                const viewport = document.getElementById(sliderId);
                if (!viewport) return;
                const track = viewport.querySelector('.music-ranking-track');
                track.style.transform = 'translateX(0)';
            });
        });

        function playRankingSong(event, btn) {
            event.stopPropagation();

            const songId = btn.dataset.songId;
            const title = btn.dataset.title;
            const artist = btn.dataset.artist;
            const cover = btn.dataset.cover;

            $.ajax({
                url: '${path}/music/songPath',
                type: 'GET',
                data: { songId: songId },
                success: function(songPath) {
                    if (!songPath || songPath.trim() === '') {
                        alert('이 곡의 재생 파일 경로가 없습니다.');
                        return;
                    }

                    const song = {
                        songId: songId,
                        title: title,
                        artistName: artist,
                        coverImageUrl: cover,
                        songPath: songPath
                    };

                    if (window.setPlayerSong) {
                        window.setPlayerSong(song);
                    } else {
                        alert('플레이어 함수가 연결되지 않았습니다.');
                    }
                },
                error: function() {
                    alert('곡 경로를 불러오지 못했습니다.');
                }
            });
        }
    </script>
</body>
</html>