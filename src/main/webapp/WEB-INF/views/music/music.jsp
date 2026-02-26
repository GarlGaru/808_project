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
	.music-hero {
		height: 250px;
	}
	
	.music-card {
		cursor: pointer;
		border: none;
		background: transparent;
		transition: transform 0.15s ease, box-shadow 0.15s ease;
	}
	/* 주간 랭킹 가로 스크롤 래퍼 */
	.weekly-rank-wrapper {
	    overflow-x: auto;          /* 가로 스크롤 */
	    overflow-y: hidden;
	    padding-bottom: 10px;
	    margin-left: -10px;        /* 카드 사이 여백 맞추기용 (원하면 조정) */
	    margin-right: -10px;
	}
	
	/* 주간 랭킹 안에서 카드들을 한 줄로 쭉 나열 */
	.weekly-rank-track {
	    display: flex;
	    flex-wrap: nowrap;         /* 줄 바꿈 금지 → 한 줄 */
	    gap: 24px;                 /* 카드 사이 간격 */
	    padding: 0 10px;
	}
	
	/* 주간 랭킹 카드 한 개의 너비 고정 */
	.weekly-rank-track .music-card {
	    flex: 0 0 180px;           /* 고정 폭 180px, 줄 바꿈 안 되게 */
	}
	
	/* (선택) 스크롤바 살짝만 보이게 / 숨기기용 - 필요 없으면 지워도 됨 */
	.weekly-rank-wrapper::-webkit-scrollbar {
	    height: 6px;
	}
	.weekly-rank-wrapper::-webkit-scrollbar-track {
	    background: rgba(0,0,0,0.1);
	}
	.weekly-rank-wrapper::-webkit-scrollbar-thumb {
	    background: rgba(255,255,255,0.4);
	    border-radius: 3px;
	}
	.music-card:hover {
		transform: translateY(-4px);
		box-shadow: 0 10px 20px rgba(0, 0, 0, 0.4);
	}
	
	.music-card .card-img-top-wrapper {
		position: relative;
		padding-top: 100%; /* 1:1 정사각형 */
		overflow: hidden;
		border-radius: 0;
	}
	
	.music-card img.card-img-top {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	
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
	
	.music-section-title {
		color: #fff;
	}
	
	.music-section-subtitle {
		color: #aaa;
		font-size: 0.9rem;
	}
	
	.music-meta {
		font-size: 0.8rem;
		color: #888;
	}
	/* 카드 아래 정보 영역 (제목/아티스트/재생수 부분) */
	.music-card .card-body {
		background: linear-gradient(to top, rgba(0, 0, 0, 0.95),
			rgba(0, 0, 0, 0.75));
		/* 아래쪽은 진한 검정, 위로 갈수록 살짝 투명해짐 */
		border-radius: 0 0 14px 14px; /* 🔹 아래 모서리만 둥글게 */
		padding: 6px 8px 8px; /* 위, 좌우, 아래 */
		min-height: 70px; /* 너무 커지지 않도록 제한 */
		margin-top: 4px; /* 🔹 이미지랑 살짝 간격 */
		border-top: 1px solid rgba(255, 255, 255, 0.04); /* 아주 약한 구분선 느낌 */
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
	
	.music-meta {
		font-size: 0.75rem;
		color: #888;
	}
	
	.section-subtitle {
		font-size: 0.9rem;
		color: #aaa;
	}
	
	.artist-link {
		color: #bbb;
		text-decoration: none;
		transition: color 0.2s ease;
	}
	
	.artist-link:hover {
		color: #1DB954; /* Spotify 초록 */
	}
	/* 🔥 주간 랭킹 : 가로 스크롤 + 캐러셀용 스타일 */
	.weekly-rank-container {
	    position: relative;
	}
	
	.weekly-rank-wrapper {
	    overflow-x: auto;
	    overflow-y: hidden;
	    padding-bottom: 10px;
	}
	
	.weekly-rank-track {
	    display: flex;
	    flex-wrap: nowrap;
	    gap: 24px;
	}
	
	/* 카드 너비 고정해서 한 줄로 쭉 */
	.weekly-rank-track .music-card {
	    flex: 0 0 180px;
	}
	
	/* 스크롤바 살짝만 보이게 (원하면 지워도 됨) */
	.weekly-rank-wrapper::-webkit-scrollbar {
	    height: 6px;
	}
	.weekly-rank-wrapper::-webkit-scrollbar-track {
	    background: rgba(0,0,0,0.1);
	}
	.weekly-rank-wrapper::-webkit-scrollbar-thumb {
	    background: rgba(255,255,255,0.4);
	    border-radius: 3px;
	}
	
	/* 좌우 화살표 버튼 */
	.weekly-arrows {
	    margin-left: auto;
	    display: flex;
	    gap: 8px;
	}
	
	.weekly-arrow-btn {
	    width: 32px;
	    height: 32px;
	    border-radius: 50%;
	    border: none;
	    background: rgba(0,0,0,0.6);
	    color: #fff;
	    font-size: 18px;
	    display: inline-flex;
	    align-items: center;
	    justify-content: center;
	    cursor: pointer;
	}
	.weekly-arrow-btn:hover {
	    background: rgba(255,255,255,0.8);
	    color: #000;
	}
	.weekly-arrow-btn:focus {
	    outline: none;
	}
	</style>
</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    <br><br><br><br>

    <!-- 상단 Hero 영역 -->
    <div class="container music-hero d-flex align-items-center">
        <div>
            <h1 class="music-section-title mb-2">Music</h1>
            <p class="music-section-subtitle mb-0">
                가장 많이 재생된 곡 순으로 정렬된 음악 리스트입니다.
            </p>
        </div>
    </div>


    <div class="container mt-4 mb-5">

        <!-- 나중에 loadCategory()로 장르 필터 버튼 쓸 수 있는 영역 (원하면 사용) -->
        <!--
        <div class="mb-3">
            <button class="btn btn-sm btn-outline-light mr-2" onclick="loadCategory(1)">POP</button>
            <button class="btn btn-sm btn-outline-light mr-2" onclick="loadCategory(2)">HIPHOP</button>
            <button class="btn btn-sm btn-outline-light mr-2" onclick="loadCategory(3)">BALAD</button>
        </div>
        -->

        <!-- 곡 리스트 -->
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
	                      style="font-size:1.2rem; font-weight:700;">주간 랭킹</span>
	
	                <!-- 오른쪽 화살표 버튼들 -->
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
	                             onclick="location.href='${pageContext.request.contextPath}/music/detail?songId=${song.songId}'">
	
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
	
	                                <div class="play-overlay">▶</div>
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

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>
	<script>
	    $(function() {
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
	
	            $wrapper.stop().animate({scrollLeft: next}, 600);
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
	
	            $wrapper.stop().animate({scrollLeft: next}, 600);
	        }
	
	      // 자동 스크롤 시작
	        function startAuto() {
	            if (autoTimer) return;
	            autoTimer = setInterval(scrollRight, autoInterval);
	        }
	
	        // 자동 스크롤 멈춤
	        function stopAuto() {
	            if (autoTimer) {
	                clearInterval(autoTimer);
	                autoTimer = null;
	            }
	        } 
	
	        // 좌우 버튼 클릭 이벤트
	        $('.weekly-arrow-right').on('click', function() {
	            stopAuto();
	            scrollRight();
	        });
	
	        $('.weekly-arrow-left').on('click', function() {
	            stopAuto();
	            scrollLeft();
	        });
	
	        // 마우스 올리면 자동 스크롤 잠시 멈춤 / 떼면 다시 시작
	        $wrapper.on('mouseenter', function() {
	            stopAuto();
	        }).on('mouseleave', function() {
	            startAuto();
	        });
	
	        // 페이지 로드 후 자동 스크롤 시작
	        startAuto();
	    });
	</script>
</body>
</html>
