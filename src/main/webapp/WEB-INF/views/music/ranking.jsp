<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<style>
.music-page{
    padding-top: 85px;
    padding-bottom: 90px;
    min-height: 100vh;
    background: #000;
    box-sizing: border-box;
}

.music-content{
    margin-left: 220px;
    min-height: calc(100vh - 85px - 90px);
    padding: 24px;
    box-sizing: border-box;
}

.ranking-wrap{
    min-height: 600px;
    background: linear-gradient(to right, #e6bea0, #eb7a1a);
}
</style>
<html>
<head>
<meta charset="UTF-8">
<meta name="description" content="Bootstrap 4 Spotify-style buttons sample">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<title>RANKING</title>
<link rel="stylesheet" href="${path}/resources/common/css/style.css">
<link rel="stylesheet" href="${path}/resources/common/style.css">

</head>
<body>
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <main class="music-page">
        <%@ include file="/WEB-INF/views/music/aside.jsp" %>

        <section class="music-content">
            <div class="ranking-wrap">
                <!-- 여기에 랭킹 본문 -->
                		     
            </div>

            <%@ include file="/WEB-INF/views/common/footer.jsp" %>
        </section>
    </main>

    <%@ include file="/WEB-INF/views/music/player.jsp" %>
</body>

    <!-- 공통 JS -->
    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>
</html>