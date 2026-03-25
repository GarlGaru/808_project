<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html lang="ko" data-context-path="${pageContext.request.contextPath}"> <%-- js 에서도 path 인식할 수 있게 추가 --%>
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Music Main Page">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Music</title>

    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">

    <!-- 음악 페이지 전용 CSS -->
    <!-- 전체 레이아웃 전용 -->
    <link rel="stylesheet" href="${path}/resources/music/css/music-layout.css">
    <!-- 왼쪽 사이드바 전용 -->
    <link rel="stylesheet" href="${path}/resources/music/css/music-sidebar.css">
    <!-- 메인스토리(카드 리스트, 슬라이더) 전용 -->
    <link rel="stylesheet" href="${path}/resources/music/css/music-mainstory.css">
    <!-- 하단 플레이어 전용 -->
    <link rel="stylesheet" href="${path}/resources/music/css/music-player.css">
    <!-- 상세페이지 전용 -->
    <link rel="stylesheet" href="${path}/resources/music/css/music-detail.css">
    <!-- 랭킹 전용 -->
    <link rel="stylesheet" href="${path}/resources/music/css/music-ranking.css">
</head>
<body class="dark-mode">

<%-- template : 랜더링 되지 않음, js에서 가져다 쓰는 용도 --%>
    <%-- 슬라이더 template --%>
    <template id="music-slider-template">
        <section class="music-home-block">
            <div class="music-home-header">
                <div>
                    <h2 class="music-home-title" data-slot="title"></h2>
                    <p class="music-home-desc" data-slot="subtitle"></p>
                </div>

                <div class="music-home-controls">
                    <button type="button"
                            class="music-home-arrow"
                            data-action="prev">
                        ‹
                    </button>
                    <button type="button"
                            class="music-home-arrow"
                            data-action="next">
                        ›
                    </button>
                </div>
            </div>

            <div class="music-home-viewport" data-slot="viewport">
                <div class="music-home-track" data-slot="track">
                    <!-- 카드들이 JS에 의해 여기에 주입됩니다 -->
                </div>
            </div>

            <div class="music-home-empty" data-slot="empty" style="display:none;"></div>
        </section>
    </template>

    <%-- 카드 template --%>
    <template id="music-card-template">
        <div class="music-home-card" data-song-id="">
            <div class="music-home-thumb-wrap">
                <img class="music-home-thumb" src="" alt="">
                <button type="button"
                        class="music-home-play-btn js-play-song"
                        data-song-id=""
                        data-title=""
                        data-artist=""
                        data-cover=""
                        aria-label="">
                    ▶
                </button>
            </div>
            <div class="music-home-body">
                <div class="music-home-song" data-slot="title"></div>
                <div class="music-home-artist" data-slot="artist"></div>
                <div class="music-home-score" data-slot="label"></div>
            </div>
        </div>
    </template>
<%-- template 끝 --%>


    <!-- 공통 상단 영역 -->
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <!--  music-layout-page: 음악 페이지 전체를 감싸는 최상위 래퍼-->
    <div class="music-layout-page">

        <!-- music-layout-content: 사이드바 + 메인 콘텐츠를 가로로 배치하는 영역-->
        <div class="music-layout-content">

            <!-- music-layout-aside : 왼쪽 사이드바 고정 폭 영역-->
            <aside class="music-layout-aside">
                <%@ include file="/WEB-INF/views/music/aside.jsp" %>
            </aside>

            <!-- music-layout-main: 메인 콘텐츠가 들어가는 영역 현재는 mainstory.jsp를 포함-->
            <main class="music-layout-main">
               <div id="main-content-area"></div>
            </main>
        
        </div>

        <!-- 하단 고정 플레이어 -->
        <%@ include file="/WEB-INF/views/music/player.jsp" %>
    </div>

    <!-- 공통 JS -->
	<script>
	    window.APP_PATH = '${pageContext.request.contextPath}';
	</script>

	<script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
	<script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
	<script src="${path}/resources/common/js/main.js"></script>
	<script src="${path}/resources/music/js/music.js"></script>
	<script src="${path}/resources/music/js/music-like.js"></script>

	 <%-- 추천 js 로딩 --%>
    <script src="${path}/resources/music/js/musicSlider.js"></script>
    <script src="${path}/resources/music/js/slider-init.js"></script>

	<script>
	    window.addEventListener("DOMContentLoaded", function() {
	        loadMainContent("${path}/music/mainstory");
	    });
	</script>
</body>
</html>
