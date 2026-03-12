<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!-- 
    music-home-wrap
    : 메인스토리 전체 래퍼
-->
<div class="music-home-wrap">

    <!-- =========================
         1) 주간 인기곡
         ========================= -->
    <section class="music-home-block">

        <!-- 제목 + 좌우 버튼 -->
        <div class="music-home-header">
            <h2 class="music-home-title">주간 인기곡</h2>

            <div class="music-home-controls">
                <button type="button"
                        class="music-home-arrow"
                        onclick="moveSlider('weeklySlider', -1)">
                    ‹
                </button>
                <button type="button"
                        class="music-home-arrow"
                        onclick="moveSlider('weeklySlider', 1)">
                    ›
                </button>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty weeklyRanking}">

                <!-- 
                    slider-viewport
                    : 화면에 보이는 영역
                -->
                <div class="music-home-viewport" id="weeklySlider">

                    <!-- 
                        slider-track
                        : 좌우 이동되는 실제 카드 줄
                    -->
                    <div class="music-home-track">
                        <c:forEach var="song" items="${weeklyRanking}">
                            <div class="music-home-card"
                                 onclick="location.href='${path}/music/detail?songId=${song.songId}'">

                                <!-- 앨범 이미지 영역 -->
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

                                    <!-- 
                                        카드 안의 작은 재생 버튼
                                        카드 전체 클릭과 분리하기 위해 stopPropagation 사용
                                    -->
                                    <button type="button"
                                            class="music-home-play"
                                            onclick="playFromCard(event, this)"
                                            data-song-id="${song.songId}"
                                            data-title="${song.title}"
                                            data-artist="${song.artistName}"
                                            data-cover="${song.coverImageUrl}"
                                            >
                                        ▶
                                    </button>
                                </div>

                                <!-- 곡 정보 -->
                                <div class="music-home-body">
                                    <div class="music-home-song">${song.title}</div>
                                    <div class="music-home-artist">${song.artistName}</div>
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

    <!-- =========================
         2) 오늘의 히트곡
         ========================= -->
    <section class="music-home-block">
        <div class="music-home-header">
            <h2 class="music-home-title">오늘의 히트곡</h2>

            <div class="music-home-controls">
                <button type="button"
                        class="music-home-arrow"
                        onclick="moveSlider('todaySlider', -1)">
                    ‹
                </button>
                <button type="button"
                        class="music-home-arrow"
                        onclick="moveSlider('todaySlider', 1)">
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
                                            data-cover="${song.coverImageUrl}"
                                           >
                                        ▶
                                    </button>
                                </div>

                                <div class="music-home-body">
                                    <div class="music-home-song">${song.title}</div>
                                    <div class="music-home-artist">${song.artistName}</div>
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

    <!-- =========================
         3) 장르 인기곡
         ========================= -->
    <section class="music-home-block">
        <div class="music-home-header">
            <h2 class="music-home-title">장르 인기곡</h2>

            <div class="music-home-controls">
                <button type="button"
                        class="music-home-arrow"
                        onclick="moveSlider('genreSlider', -1)">
                    ‹
                </button>
                <button type="button"
                        class="music-home-arrow"
                        onclick="moveSlider('genreSlider', 1)">
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
                                            data-cover="${song.coverImageUrl}"
                                            >
                                        ▶
                                    </button>
                                </div>

                                <div class="music-home-body">
                                    <div class="music-home-song">${song.title}</div>
                                    <div class="music-home-artist">${song.artistName}</div>
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
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</div>

<script>
    /* 
        슬라이더 현재 위치를 저장하는 객체
        예: weeklySlider -> 현재 몇 칸 이동했는지
    */
    const sliderState = {};

    /* 
        화면 너비에 따라 한 번에 보일 카드 수 결정
        - 큰 화면: 8개
        - 중간: 6개
        - 태블릿: 4개
        - 모바일: 2개
    */
    function getVisibleCount() {
        const width = window.innerWidth;

        if (width <= 768) return 2;
        if (width <= 1200) return 4;
        if (width <= 1600) return 6;
        return 8;
    }

    /* 
        좌우 버튼 클릭 시 슬라이더 이동
        sliderId  : 어떤 슬라이더인지
        direction : -1 왼쪽, 1 오른쪽
    */
    function moveSlider(sliderId, direction) {
        const viewport = document.getElementById(sliderId);
        if (!viewport) return;

        const track = viewport.querySelector('.music-home-track');
        const cards = track.querySelectorAll('.music-home-card');
        if (!cards.length) return;

        const visibleCount = getVisibleCount();
        const maxIndex = Math.max(0, cards.length - visibleCount);

        if (!sliderState[sliderId]) {
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

    /* 
        브라우저 크기가 바뀌면 슬라이더 위치 초기화
        화면 폭이 바뀌면 카드 개수 계산이 달라지기 때문
    */
    window.addEventListener('resize', function() {
        Object.keys(sliderState).forEach(function(sliderId) {
            sliderState[sliderId] = 0;

            const viewport = document.getElementById(sliderId);
            if (!viewport) return;

            const track = viewport.querySelector('.music-home-track');
            track.style.transform = 'translateX(0)';
        });
    });

    /* 
        카드 안 재생 버튼 클릭 시
        - 카드 전체 클릭(상세 이동)은 막고
        - 플레이어에 현재 곡 정보만 세팅
    */
    function playFromCard(event, btn) {
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