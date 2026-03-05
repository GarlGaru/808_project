<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<script>
function loadCategory(genreId){

    $.ajax({
        url: '${pageContext.request.contextPath}/category/songs',
        type: 'POST',
        data: { genreId : genreId },
        success: function(result){
            $('#songArea').html(result);
        },
        error: function(){
            alert('카테고리 로딩 실패');
        }
    });

}
</script>

<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Bootstrap 4 Spotify-style buttons sample">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Music</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">

	<!-- 이 페이지에서만 쓰는 간단한 음악 카드 스타일 -->
	<style>
	/* ==========================================
	   1. 상단 Hero + 기본 카드 공통 스타일
	   ========================================== */
	
	/* 상단 Hero 높이 */
	.music-hero {
	    height: 250px;
	}
	
	/* 음악 카드 기본 */
	.music-card {
	    cursor: pointer;
	    border: none;
	    background: transparent;
	    transition: transform 0.15s ease, box-shadow 0.15s ease;
	}
	
	/* 카드 Hover 효과 */
	.music-card:hover {
	    transform: translateY(-4px);
	    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.4);
	}
	
	/* 카드 이미지 영역 (정사각형 비율 유지) */
	.music-card .card-img-top-wrapper {
	    position: relative;
	    padding-top: 100%; /* 1:1 정사각형 */
	    overflow: hidden;
	    border-radius: 0;
	}
	
	/* 실제 이미지 */
	.music-card img.card-img-top {
	    position: absolute;
	    top: 0;
	    left: 0;
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	}
	
	/* placeholder 용 (커버 없을 때) */
	.music-card .placeholder-cover {
	    position: absolute;
	    top: 0;
	    left: 0;
	    width: 100%;
	    height: 100%;
	    background: #333;
	    border-radius: 0.75rem;
	}
	.music-card .placeholder-cover span {
	    color: #777;
	    font-size: 0.8rem;
	}
	
	/* 카드 텍스트 영역 */
	.music-card .card-body {
	    background: linear-gradient(
	        to top,
	        rgba(0, 0, 0, 0.95),
	        rgba(0, 0, 0, 0.75)
	    );
	    border-radius: 0 0 14px 14px;       /* 아래 모서리만 둥글게 */
	    padding: 6px 8px 8px;              /* 위, 좌우, 아래 */
	    min-height: 70px;
	    margin-top: 4px;                   /* 이미지와 약간 간격 */
	    border-top: 1px solid rgba(255, 255, 255, 0.04);
	}
	
	.music-card .card-title {
	    font-size: 0.9rem;
	    font-weight: 600;
	    margin-bottom: 4px;
	}
	
	.music-card .card-text {
	    font-size: 0.8rem;
	    color: #bbb;
	    margin-bottom: 4px;
	}
	
	/* 카드 하단 작은 메타 정보 */
	.music-meta {
	    font-size: 0.75rem;
	    color: #888;
	}
	
	/* 섹션 제목/부제목 */
	.music-section-title {
	    color: #fff;
	}
	
	.music-section-subtitle,
	.section-subtitle {
	    font-size: 0.9rem;
	    color: #aaa;
	}
	
	/* 아티스트 링크 */
	.artist-link {
	    color: #bbb;
	    text-decoration: none;
	    transition: color 0.2s ease;
	}
	.artist-link:hover {
	    color: #1DB954; /* Spotify 초록 */
	}
	
	
	/* ==========================================
	   2. 주간 랭킹 영역 (가로 스크롤 캐러셀)
	   ========================================== */
	
	.weekly-rank-container {
	    position: relative;
	}
	
	/* 가로 스크롤 래퍼 */
	.weekly-rank-wrapper {
	    overflow-x: auto;       /* 가로 스크롤 */
	    overflow-y: hidden;
	    padding-bottom: 10px;
	    margin-left: -10px;     /* 카드 여백 보정 */
	    margin-right: -10px;
	}
	
	/* 스크롤 안에서 카드들 한 줄로 */
	.weekly-rank-track {
	    display: flex;
	    flex-wrap: nowrap;      /* 줄 바꿈 금지 */
	    gap: 24px;              /* 카드 사이 간격 */
	    padding: 0 10px;
	}
	
	/* 주간 랭킹에 들어가는 카드 너비 고정 */
	.weekly-rank-track .music-card {
	    flex: 0 0 180px;        /* 고정 폭 180px */
	}
	
	/* 스크롤바 스타일 (필요 없으면 이 파트 삭제해도 됨) */
	.weekly-rank-wrapper::-webkit-scrollbar {
	    height: 6px;
	}
	.weekly-rank-wrapper::-webkit-scrollbar-track {
	    background: rgba(0, 0, 0, 0.1);
	}
	.weekly-rank-wrapper::-webkit-scrollbar-thumb {
	    background: rgba(255, 255, 255, 0.4);
	    border-radius: 3px;
	}
	
	/* 주간 랭킹 좌우 버튼 영역 */
	.weekly-arrows {
	    margin-left: auto;
	    display: flex;
	    gap: 8px;
	}
	
	/* 좌우 화살표 버튼 */
	.weekly-arrow-btn {
	    width: 32px;
	    height: 32px;
	    border-radius: 50%;
	    border: none;
	    background: rgba(0, 0, 0, 0.6);
	    color: #fff;
	    font-size: 18px;
	    display: inline-flex;
	    align-items: center;
	    justify-content: center;
	    cursor: pointer;
	}
	.weekly-arrow-btn:hover {
	    background: rgba(255, 255, 255, 0.8);
	    color: #000;
	}
	.weekly-arrow-btn:focus {
	    outline: none;
	}
	
	
	/* ==========================================
	   3. 하단 플레이어 바 (footer 위에 위치)
	   ========================================== */
	
	/* 전체 플레이어 바 */
	.bottom-player {
	    height: 70px;
	    background: rgba(0, 0, 0, 0.95);
	    border-top: 1px solid rgba(255, 255, 255, 0.08);
	    display: flex;
	    align-items: center;
	    padding: 0 24px;
	    font-size: 0.85rem;
	}
	
	/* 왼쪽: 앨범 커버 + 곡 정보 */
	.bottom-player .player-left {
	    display: flex;
	    align-items: center;
	    min-width: 220px;
	    gap: 10px;
	}
	
	/* 중앙: 재생 버튼 + 진행바 */
	.bottom-player .player-center {
	    flex: 1;
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    justify-content: center;
	    padding: 0 40px;
	}
	
	/* 오른쪽: 각종 아이콘 / 볼륨 */
	.bottom-player .player-right {
	    min-width: 220px;
	    display: flex;
	    align-items: center;
	    justify-content: flex-end;
	    gap: 10px;
	}
	
	/* 앨범 커버 이미지 */
	.player-cover {
	    width: 48px;
	    height: 48px;
	    border-radius: 4px;
	    overflow: hidden;
	    flex-shrink: 0;
	}
	.player-cover img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	    display: block;
	}
	
	/* 곡 제목 / 아티스트 텍스트 */
	.player-track-info {
	    display: flex;
	    flex-direction: column;
	    overflow: hidden;
	}
	.player-track-title {
	    color: #fff;
	    font-size: 0.9rem;
	    font-weight: 600;
	    white-space: nowrap;
	    text-overflow: ellipsis;
	    overflow: hidden;
	}
	.player-track-artist {
	    color: #bbb;
	    font-size: 0.78rem;
	    white-space: nowrap;
	    text-overflow: ellipsis;
	    overflow: hidden;
	}
	
	/* 재생 컨트롤 버튼 묶음 */
	.player-controls {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    gap: 16px;
	    margin-bottom: 4px;
	}
	
	/* 컨트롤 버튼 공통 */
	.player-btn {
	    width: 32px;
	    height: 32px;
	    border-radius: 50%;
	    border: none;
	    background: transparent;
	    color: #fff;
	    display: inline-flex;
	    align-items: center;
	    justify-content: center;
	    cursor: pointer;
	    font-size: 16px;
	}
	.sidebar .player-btn{
	  width: 100%;          /* 또는 auto */
	  height: auto;         /* 32px 제거 */
	  border-radius: 10px;  /* 원형 제거 */
	  padding: 10px 12px;
	  justify-content: flex-start; /* 왼쪽 정렬 */
	  white-space: nowrap;  /* 한 줄 고정 */
	}
	/* 재생/일시정지 메인 버튼 */
	.player-btn.main {
	    width: 40px;
	    height: 40px;
	    border-radius: 50%;
	    background: #fff;
	    color: #000;
	    font-size: 18px;
	}
	.player-btn:hover {
	    background: rgba(255, 255, 255, 0.12);
	}
	.player-btn.main:hover {
	    background: #1db954; /* 초록 원형 버튼 */
	    color: #fff;
	}
	
	/* 진행 바 전체 라인 */
	.player-progress-row {
	    width: 100%;
	    display: flex;
	    align-items: center;
	    gap: 10px;
	    font-size: 0.75rem;
	    color: #ccc;
	}
	.player-time {
	    width: 40px;
	    text-align: center;
	    font-variant-numeric: tabular-nums;
	}
	
	/* 회색 진행 바 배경 */
	.player-progress {
	    flex: 1;
	    height: 4px;
	    border-radius: 999px;
	    background: #444;
	    cursor: pointer;
	    overflow: hidden;
	}
	
	/* 흰색 실제 진행 부분 */
	.player-progress-fill {
	    height: 100%;
	    width: 0%;
	    background: #fff;
	}
	
	/* 오른쪽 아이콘/볼륨 */
	.player-right .icon-btn {
	    border: none;
	    background: transparent;
	    color: #fff;
	    font-size: 14px;
	    cursor: pointer;
	}
	
	/* 볼륨 영역 */
	.player-volume-wrap {
	    display: flex;
	    align-items: center;
	    gap: 6px;
	    min-width: 120px;
	}
	.player-volume-bar {
	    flex: 1;
	    height: 3px;
	    border-radius: 999px;
	    background: #444;
	    overflow: hidden;
	    cursor: pointer;
	}
	.player-volume-fill {
	    width: 60%;
	    height: 100%;
	    background: #fff;
	}
	
	
	/* ==========================================
	   4. 오디오 기본 컨트롤 숨기기
	   ========================================== */
	
	/* 프로젝트 내 모든 audio 태그 숨김 (JS로만 제어) */
	audio {
	    display: none !important;
	}
	</style>
</head>
	<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
    <!-- 상단 Hero 영역 -->
    <div class="container music-hero d-flex align-items-center">
    
	<%@ include file="/WEB-INF/views/music/aside.jsp" %>
   

    <!-- 메인 컨텐츠 영역 -->
    <div class="container mt-4 mb-5">
      <br><br><br>
  	
        <!-- (옵션) 장르 필터 버튼 - 필요하면 주석 해제 -->
        <!--
        <div class="mb-3">
            <button class="btn btn-sm btn-outline-light mr-2" onclick="loadCategory(1)">POP</button>
            <button class="btn btn-sm btn-outline-light mr-2" onclick="loadCategory(2)">HIPHOP</button>
            <button class="btn btn-sm btn-outline-light mr-2" onclick="loadCategory(3)">BALAD</button>
        </div>
        -->
           
		       <!-- 장르랭킹 리스트 Ajax 교체 영역 -->
        <div id="songArea">
            <c:if test="${empty songList}">
                <div class="alert alert-secondary">
                    등록된 곡이 없습니다. 곡 데이터를 먼저 추가해 주세요.
                </div>
            </c:if>

            <c:if test="${not empty songList}">
                <div class="weekly-rank-container">

                    <!-- 🔥 타이틀 + 좌우 화살표 -->
                    <div class="d-flex align-items-center mb-3">
                        <span style="font-size:1.4rem; margin-right:8px;">🔥</span>
                        <span class="section-title text-white"
                              style="font-size:1.2rem; font-weight:700;">장르 랭킹</span>

                        <div class="weekly-arrows">
                            <button type="button"
                                    class="weekly-arrow-btn weekly-arrow-left">&lt;</button>
                            <button type="button"
                                    class="weekly-arrow-btn weekly-arrow-right">&gt;</button>
                        </div>
                    </div>

                    <!-- 🔥 가로 스크롤 래퍼 -->
                    <div class="weekly-rank-wrapper" id="weeklyRankWrapper">
                        <div class="weekly-rank-track" id="weeklyRankTrack">
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
                                        <!-- 필요하면 여기 play 아이콘 오버레이 넣기 -->
                                        <!-- <div class="play-overlay">▶</div> -->
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
        <!-- #장르랭킹 리스트 Area 끝 -->
        <br><br><br>
        <!-- 추천랭킹 Ajax 교체 영역 -->
        <div id="songArea">
            <c:if test="${empty songList}">
                <div class="alert alert-secondary">
                    등록된 곡이 없습니다. 곡 데이터를 먼저 추가해 주세요.
                </div>
            </c:if>

            <c:if test="${not empty songList}">
                <div class="weekly-rank-container">

                    <!-- 🔥 타이틀 + 좌우 화살표 -->
                    <div class="d-flex align-items-center mb-3">
                        <span style="font-size:1.4rem; margin-right:8px;">🔥</span>
                        <span class="section-title text-white"
                              style="font-size:1.2rem; font-weight:700;">추천 랭킹</span>

                        <div class="weekly-arrows">
                            <button type="button"
                                    class="weekly-arrow-btn weekly-arrow-left">&lt;</button>
                            <button type="button"
                                    class="weekly-arrow-btn weekly-arrow-right">&gt;</button>
                        </div>
                    </div>

                    <!-- 🔥 가로 스크롤 래퍼 -->
                    <div class="weekly-rank-wrapper" id="weeklyRankWrapper">
                        <div class="weekly-rank-track" id="weeklyRankTrack">
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
                                        <!-- 필요하면 여기 play 아이콘 오버레이 넣기 -->
                                        <!-- <div class="play-overlay">▶</div> -->
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
        <!-- #추천랭킹 끝 -->
    </div> <!-- .container 끝 -->
  </div>
  <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
   <%@ include file="/WEB-INF/views/music/player.jsp" %>
<!-- ============================================================================================ -->

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <!-- 공통 JS -->
    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>

    <!-- Music 페이지 전용 JS -->
    <script>
        // 장르 버튼 클릭 시 카테고리 로딩
        function loadCategory(genreId) {
            $.ajax({
                url: '${pageContext.request.contextPath}/category/songs',
                type: 'POST',
                data: { genreId: genreId },
                success: function (result) {
                    $('#songArea').html(result);
                },
                error: function () {
                    alert('카테고리 로딩 실패');
                }
            });
        }

        $(function () {
            /* ------------------------------
               1) 주간 랭킹 가로 스크롤 자동 이동
               ------------------------------ */
            var $wrapper = $('#weeklyRankWrapper');
            var scrollAmount = 220;        // 한 번에 움직일 픽셀 (카드 하나 정도)
            var autoInterval = 4000;       // 자동 스크롤 간격(ms)
            var autoTimer = null;

            function scrollRight() {
                if ($wrapper.length === 0) return;

                var maxScroll = $wrapper[0].scrollWidth - $wrapper.outerWidth();
                var current = $wrapper.scrollLeft();
                var next = current + scrollAmount;

                // 끝에 거의 다 왔으면 처음으로
                if (next >= maxScroll - 5) {
                    next = 0;
                }

                $wrapper.stop().animate({ scrollLeft: next }, 600);
            }

            function scrollLeft() {
                if ($wrapper.length === 0) return;

                var maxScroll = $wrapper[0].scrollWidth - $wrapper.outerWidth();
                var current = $wrapper.scrollLeft();
                var next = current - scrollAmount;

                // 맨 앞으로 오면 끝으로 점프
                if (next <= 0) {
                    next = maxScroll;
                }

                $wrapper.stop().animate({ scrollLeft: next }, 600);
            }

            function startAuto() {
                if (autoTimer) return;
                autoTimer = setInterval(scrollRight, autoInterval);
            }

            function stopAuto() {
                if (autoTimer) {
                    clearInterval(autoTimer);
                    autoTimer = null;
                }
            }

            // 좌우 버튼
            $('.weekly-arrow-right').on('click', function () {
                stopAuto();
                scrollRight();
            });
            $('.weekly-arrow-left').on('click', function () {
                stopAuto();
                scrollLeft();
            });

            // 마우스 올리면 자동 스크롤 잠시 멈춤 / 떼면 다시 시작
            $wrapper.on('mouseenter', function () {
                stopAuto();
            }).on('mouseleave', function () {
                startAuto();
            });

            // 자동 시작
            startAuto();


            /* ------------------------------
               2) 하단 플레이어 기본 동작
               ------------------------------ */
            var audio = document.getElementById('audioPlayer');
            var $btnPlayPause = $('#btnPlayPause');
            var $currentTime = $('#currentTime');
            var $totalTime = $('#totalTime');
            var $progress = $('#playerProgress');
            var $progressFill = $('#playerProgressFill');
            var $volumeBar = $('#playerVolumeBar');
            var $volumeFill = $('#playerVolumeFill');

            // 재생 / 일시정지 버튼
            $btnPlayPause.on('click', function () {
                if (audio.paused) {
                    audio.play();
                    $btnPlayPause.html('&#10074;&#10074;'); // 일시정지(II)
                } else {
                    audio.pause();
                    $btnPlayPause.html('&#9658;');          // 재생(▶)
                }
            });

            // 메타데이터 로딩 후 총 시간 표시
            audio.addEventListener('loadedmetadata', function () {
                $totalTime.text(formatTime(audio.duration));
            });

            // 재생 중 시간/진행바 업데이트
            audio.addEventListener('timeupdate', function () {
                $currentTime.text(formatTime(audio.currentTime));
                if (audio.duration) {
                    var percent = (audio.currentTime / audio.duration) * 100;
                    $progressFill.css('width', percent + '%');
                }
            });

            // 진행바 클릭으로 위치 이동
            $progress.on('click', function (e) {
                var rect = this.getBoundingClientRect();
                var offsetX = e.clientX - rect.left;
                var ratio = offsetX / rect.width;
                if (audio.duration) {
                    audio.currentTime = audio.duration * ratio;
                }
            });

            // 볼륨 바 클릭
            $volumeBar.on('click', function (e) {
                var rect = this.getBoundingClientRect();
                var offsetX = e.clientX - rect.left;
                var ratio = offsetX / rect.width;
                ratio = Math.max(0, Math.min(1, ratio));
                audio.volume = ratio;
                $volumeFill.css('width', (ratio * 100) + '%');
            });

            function formatTime(sec) {
                sec = Math.floor(sec || 0);
                var m = Math.floor(sec / 60);
                var s = sec % 60;
                if (s < 10) s = '0' + s;
                return m + ':' + s;
            }
        });
    </script>
</body>
</html>
</html>
