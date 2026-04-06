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
		<br>
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
	

    <br>


    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>
    <script src="${path}/resources/show/js/show.js"></script>
    
    <script>
    $(function() {
        // [중요] 컨텍스트 패스를 자바스크립트 변수로 안전하게 확보
        const contextPath = "${pageContext.request.contextPath}";
        console.log("랭킹 스크립트 로드됨. ContextPath:", contextPath);

        // 1. Ajax 탭 전환 (선택자를 더 확실하게 지정)
        $(document).on("click", "button.ranking-tab", function(e) {
            // 클릭 이벤트 발생 확인용
            console.log("탭 클릭됨!"); 
            
            const $this = $(this);
            const category = $this.data("category");
            console.log("선택된 카테고리:", category);

            // UI 변경
            $(".ranking-tab").removeClass("active");
            $this.addClass("active");
        
            // Ajax 요청
            $.ajax({
                url: contextPath + "/show/rankingAjax",
                type: "GET",
                data: { category: category },
                success: function(data) {
                    $('#rankingContent').html(data);
                    $('#rankingContent').hide().show(0);
                    
                    console.log("CSS 적용 확인 완료");
                    
                    // 1. 타겟 확인
                    const $container = $("#rankingContent");
                    console.log("타겟 요소를 찾았나요?:", $container.length > 0 ? "YES" : "NO");

                    // 2. 강제 교체 및 표시
                    // .empty()로 기존 내용을 싹 비우고 새로 받은 data를 밀어 넣습니다.
                    $container.empty().html(data).show();
                    
                    console.log("화면 업데이트 완료");
                },
                error: function(xhr, status, error) {
                    console.error("Ajax 에러 발생:", status, error);
                    alert("데이터를 불러오지 못했습니다.");
                }
            });
        });

        // 2. 툴팁 관련 (위임 방식 유지)
        $(document).on("click", "#btnRankInfo", function(e) {
            e.stopPropagation();
            $("#rankTooltip").stop().fadeToggle(200);
        });

        $(document).on("click", "#btnCloseTooltip", function(e) {
            $("#rankTooltip").stop().fadeOut(200);
        });

        $(document).on("click", function(e) {
            if(!$(e.target).closest(".tooltip-wrap").length) {
                $("#rankTooltip").stop().fadeOut(200);
            }
        });
    });
    </script>
</body>
</html>
