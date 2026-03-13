<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html lang="ko">
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
</head>
<body class="dark-mode">

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
                <%@ include file="/WEB-INF/views/music/mainstory.jsp" %>
            </main>
        
        </div>

        <!-- 하단 고정 플레이어 -->
        <%@ include file="/WEB-INF/views/music/player.jsp" %>
    </div>

    <!-- 공통 JS -->
    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>

</body>
</html>