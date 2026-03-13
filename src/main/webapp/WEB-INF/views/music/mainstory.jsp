<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<div class="music-home-wrap">

    <!-- ========================= 1) 주간 인기곡 ========================= -->
    <section class="music-home-block">
        <div class="music-home-header">
            <div>
                <h2 class="music-home-title">주간 인기곡</h2>
                <p class="music-home-desc">이번 주 가장 많이 사랑받은 곡들이에요.</p>
            </div>

            <div class="music-home-controls">
                <button type="button"
                        class="music-home-arrow"
                        onclick="moveSlider('weeklySlider', -1)"
                        aria-label="주간 인기곡 이전">
                    ‹
                </button>
                <button type="button"
                        class="music-home-arrow"
                        onclick="moveSlider('weeklySlider', 1)"
                        aria-label="주간 인기곡 다음">
                    ›
                </button>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty weeklyRanking}">
                <div class="music-home-viewport" id="weeklySlider">
                    <div class="music-home-track">
                        <c:forEach var="song" items="${weeklyRanking}">
                            <div class="music-home-card"
                                 onclick="location.href='${path}/music/detail?songId=${song.songId}'">

                                <div class="music-home-thumb-wrap">
                                    <c:choose>
                                        <c:when test="${not empty song.coverImageUrl}">
                                            <img class="music-home-thumb"
                                                 src="${path}${song.coverImageUrl}"
                                                 alt="${song.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="music-home-thumb"
                                                 src="${path}/resources/music/img/default_album.jpg"
                                                 alt="default album">
                                        </c:otherwise>
                                    </c:choose>

                                    <button type="button"
                                            class="music-home-play"
                                            onclick="playFromCard(event, this)"
                                            data-song-id="${song.songId}"
                                            data-title="${song.title}"
                                            data-artist="${song.artistName}"
                                            data-cover="${empty song.coverImageUrl ? '/resources/music/img/default_album.jpg' : song.coverImageUrl}"
                                            aria-label="${song.title} 재생">
                                        ▶
                                    </button>
                                </div>

                                <div class="music-home-body">
                                    <div class="music-home-song">${song.title}</div>
                                    <div class="music-home-artist">${song.artistName}</div>
                                    <div class="music-home-score">주간 인기곡</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="music-home-empty">주간 인기곡 데이터가 없습니다.</div>
            </c:otherwise>
        </c:choose>
    </section>

    <!-- ========================= 2) 오늘의 히트곡 ========================= -->
    <section class="music-home-block">
        <div class="music-home-header">
            <div>
                <h2 class="music-home-title">오늘의 히트곡</h2>
                <p class="music-home-desc">오늘 많이 재생된 곡들을 모아봤어요.</p>
            </div>

            <div class="music-home-controls">
                <button type="button"
                        class="music-home-arrow"
                        onclick="moveSlider('todaySlider', -1)"
                        aria-label="오늘의 히트곡 이전">
                    ‹
                </button>
                <button type="button"
                        class="music-home-arrow"
                        onclick="moveSlider('todaySlider', 1)"
                        aria-label="오늘의 히트곡 다음">
                    ›
                </button>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty todayHitSongs}">
                <div class="music-home-viewport" id="todaySlider">
                    <div class="music-home-track">
                        <c:forEach var="song" items="${todayHitSongs}">
                            <div class="music-home-card"
                                 onclick="location.href='${path}/music/detail?songId=${song.songId}'">

                                <div class="music-home-thumb-wrap">
                                    <c:choose>
                                        <c:when test="${not empty song.coverImageUrl}">
                                            <img class="music-home-thumb"
                                                 src="${path}${song.coverImageUrl}"
                                                 alt="${song.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="music-home-thumb"
                                                 src="${path}/resources/music/img/default_album.jpg"
                                                 alt="default album">
                                        </c:otherwise>
                                    </c:choose>

                                    <button type="button"
                                            class="music-home-play"
                                            onclick="playFromCard(event, this)"
                                            data-song-id="${song.songId}"
                                            data-title="${song.title}"
                                            data-artist="${song.artistName}"
                                            data-cover="${empty song.coverImageUrl ? '/resources/music/img/default_album.jpg' : song.coverImageUrl}"
                                            aria-label="${song.title} 재생">
                                        ▶
                                    </button>
                                </div>

                                <div class="music-home-body">
                                    <div class="music-home-song">${song.title}</div>
                                    <div class="music-home-artist">${song.artistName}</div>
                                    <div class="music-home-score">오늘의 히트곡</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="music-home-empty">오늘의 히트곡 데이터가 없습니다.</div>
            </c:otherwise>
        </c:choose>
    </section>

    <!-- ========================= 3) 장르 인기곡 ========================= -->
    <section class="music-home-block">
        <div class="music-home-header">
            <div>
                <h2 class="music-home-title">장르 인기곡</h2>
                <p class="music-home-desc">지금 인기 있는 장르별 추천 곡이에요.</p>
            </div>

            <div class="music-home-controls">
                <button type="button"
                        class="music-home-arrow"
                        onclick="moveSlider('genreSlider', -1)"
                        aria-label="장르 인기곡 이전">
                    ‹
                </button>
                <button type="button"
                        class="music-home-arrow"
                        onclick="moveSlider('genreSlider', 1)"
                        aria-label="장르 인기곡 다음">
                    ›
                </button>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty genreRanking}">
                <div class="music-home-viewport" id="genreSlider">
                    <div class="music-home-track">
                        <c:forEach var="song" items="${genreRanking}">
                            <div class="music-home-card"
                                 onclick="location.href='${path}/music/detail?songId=${song.songId}'">

                                <div class="music-home-thumb-wrap">
                                    <c:choose>
                                        <c:when test="${not empty song.coverImageUrl}">
                                            <img class="music-home-thumb"
                                                 src="${path}${song.coverImageUrl}"
                                                 alt="${song.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="music-home-thumb"
                                                 src="${path}/resources/music/img/default_album.jpg"
                                                 alt="default album">
                                        </c:otherwise>
                                    </c:choose>

                                    <button type="button"
                                            class="music-home-play"
                                            onclick="playFromCard(event, this)"
                                            data-song-id="${song.songId}"
                                            data-title="${song.title}"
                                            data-artist="${song.artistName}"
                                            data-cover="${empty song.coverImageUrl ? '/resources/music/img/default_album.jpg' : song.coverImageUrl}"
                                            aria-label="${song.title} 재생">
                                        ▶
                                    </button>
                                </div>

                                <div class="music-home-body">
                                    <div class="music-home-song">${song.title}</div>
                                    <div class="music-home-artist">${song.artistName}</div>
                                    <div class="music-home-score">장르 인기곡</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="music-home-empty">장르 인기곡 데이터가 없습니다.</div>
            </c:otherwise>
        </c:choose>
    </section>

</div>

<script>
    const sliderState = {};

    function getVisibleCount() {
        const width = window.innerWidth;
        if (width <= 768) return 2;
        if (width <= 1200) return 4;
        if (width <= 1600) return 6;
        return 8;
    }

    function moveSlider(sliderId, direction) {
        const viewport = document.getElementById(sliderId);
        if (!viewport) return;

        const track = viewport.querySelector('.music-home-track');
        const cards = track.querySelectorAll('.music-home-card');
        if (!cards.length) return;

        const visibleCount = getVisibleCount();
        const maxIndex = Math.max(0, cards.length - visibleCount);

        if (sliderState[sliderId] == null) {
            sliderState[sliderId] = 0;
        }

        sliderState[sliderId] += direction * visibleCount;

        if (sliderState[sliderId] < 0) sliderState[sliderId] = 0;
        if (sliderState[sliderId] > maxIndex) sliderState[sliderId] = maxIndex;

        const cardWidth = cards[0].offsetWidth;
        const gap = 18;
        const moveX = (cardWidth + gap) * sliderState[sliderId];

        track.style.transform = 'translateX(-' + moveX + 'px)';
    }

    window.addEventListener('resize', function() {
        Object.keys(sliderState).forEach(function(sliderId) {
            sliderState[sliderId] = 0;

            const viewport = document.getElementById(sliderId);
            if (!viewport) return;

            const track = viewport.querySelector('.music-home-track');
            if (track) {
                track.style.transform = 'translateX(0)';
            }
        });
    });

    function playFromCard(event, btn) {
        event.stopPropagation();

        const songId = btn.dataset.songId;
        const title = btn.dataset.title;
        const artist = btn.dataset.artist;
        let cover = btn.dataset.cover;

        if (cover && !cover.startsWith('/resources')) {
            cover = '${path}' + cover;
        } else if (cover && cover.startsWith('/resources')) {
            cover = '${path}' + cover;
        }

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