<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Bootstrap 4 Spotify-style buttons sample">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>808 SHOW Ranking</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
	<link rel="stylesheet" href="${path}/resources/show/css/show.css">
	<link rel="stylesheet" href="${path}/resources/show/css/showRanking.css">
	
</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    <br><br><br><br>
    <br><br><br><br>

	<section class="ranking-section">
        <div class="ranking-title">랭킹</div>

        <div class="ranking-tab-box">
            <button type="button"
                    class="ranking-tab ${currentCategory == 'concert' ? 'active' : ''}"
                    data-category="concert">콘서트</button>

            <button type="button"
                    class="ranking-tab ${currentCategory == 'musical' ? 'active' : ''}"
                    data-category="musical">뮤지컬</button>

            <button type="button"
                    class="ranking-tab ${currentCategory == 'play' ? 'active' : ''}"
                    data-category="play">연극</button>
        </div>

        <div id="rankingContent">
            <jsp:include page="rankingContent.jsp" />
        </div>
    </section>
	

    <br><br><br><br>


    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>
    <script src="${path}/resources/show/js/show.js"></script>
    
    <script>
    $(function() {
        $(".ranking-tab").on("click", function() {
            let category = $(this).data("category");

            $(".ranking-tab").removeClass("active");
            $(this).addClass("active");

            $.ajax({
                url: "${path}/show/rankingAjax",
                type: "GET",
                data: { category: category },
                success: function(data) {
                    $("#rankingContent").html(data);
                },
                error: function() {
                    alert("랭킹 탭 ajax 오류");
                }
            });
        });
    });
    
    </script>
</body>
</html>
