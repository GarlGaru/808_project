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

   

	<section class="ranking-section">
	 <div class="show-wrap">
	      <div class="show-top-menu-wrap">
		    <nav class="show-top-menu">
		        <a href="${path}/show/showList?category=concert&subCategory=all"
		           class="menu-item ${menu eq 'concert' ? 'active' : ''}">콘서트</a>
		
		        <a href="${path}/show/showList?category=musical&subCategory=all"
		           class="menu-item ${menu eq 'musical' ? 'active' : ''}">뮤지컬</a>
		
		        <a href="${path}/show/showList?category=play&subCategory=all"
		           class="menu-item ${menu eq 'play' ? 'active' : ''}">연극</a>
		
		        <a href="${path}/show/ranking"
		           class="menu-item ${menu eq 'ranking' ? 'active' : ''}">랭킹</a>
		
		        <a href="${path}/show/mypage/myTicket"
		           class="menu-item ${menu eq 'myticket' ? 'active' : ''}">마이티켓
		        </a>
		        
		       <!--  <a href="javascript:void(0)" onclick="openAuthModal()" -->
		    </nav>
		</div>
	<br><br>
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
    	// 기존 ajax 탭 전환 코드
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
    	
    	// -- 툴팁 열기/닫기 (ajax 로드 이후에도 동작하도록 document에 위임)
   		
    	// 1. 랭킹 기준 버튼 클릭시 툴팁 토굴
    	$(document).on("click", "#btnRankInfo", function(e) {
    		e.stopPropagation(); // 클릭이벤트 문서전체 퍼지는 것 방지
    		$("#rankTooltip").fadeToggle(200);
    	});
    	
    	// 2. 툴팁 내 X버튼 클릭시 닫기
    	$(document).on("click", "#btnCloseTooltip", function(e) {
    		e.stopPropagation();
    		$("#rankTooltip").fadeOut(200);
    	});
    	
    	// 3. 툴팁 바깥(문서 빈 공간) 클릭 시 툴팁 닫기
    	$(document).on("click", function(e) {
    		if(!$(e.target).closest(".tootil-wrap").length) {
    			$("#rankTooltip").fadeOut(200);
    		}
    	});
    });
    </script>
</body>
</html>
