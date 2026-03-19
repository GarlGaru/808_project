<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>808 SHOW</title>
    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
    <link rel="stylesheet" href="${path}/resources/show/css/show.css">
</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <!-- <br><br><br><br><br><br> -->

<%-- 
	<div class="section" style="justify-content-center">
		<a href="${path}/show/seat-detail">
			<img src="${path}/resources/presentation/show.png">
		</a>
    </div> --%>
 

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
		
		        <a href="javascript:void(0)" onclick="openAuthModal()"
		           class="menu-item ${menu eq 'myticket' ? 'active' : ''}">마이티켓
		        </a>
		    </nav>
		</div>
			
	       <div class="main-show-section-full">
	    <div class="section">
	        <h2 class="section-title" id="main-section-title">공연</h2>
	
	        <div id="mainShowCarousel" class="carousel slide main-show-carousel" data-ride="carousel" data-interval="false">
	            <div class="carousel-inner">
	
	                <c:forEach var="s" items="${list}" varStatus="st">
	                    <c:if test="${st.index % 4 == 0}">
	                        <div class="carousel-item ${st.first ? 'active' : ''}">
	                            <div class="main-show-row">
	                    </c:if>
	
	                                <div class="main-show-col">
	                                    <a href="${path}/show/showDetail?showId=${s.showId}" class="main-show-link">
	                                        <div class="main-show-card">
	                                            <img class="main-show-poster" src="${s.posterUrl}" alt="${s.title}">
	                                            <div class="main-show-title">${s.title}</div>
	                                            <div class="main-show-sub">${s.venueName}</div>
	                                        </div>
	                                    </a>
	                                </div>
	
	                    <c:if test="${st.index % 4 == 3 || st.last}">
	                            </div>
	                        </div>
	                    </c:if>
	                </c:forEach>
	
	            </div>
	
	            <a class="carousel-control-prev main-show-control" href="#mainShowCarousel" role="button" data-slide="prev">
	                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
	                <span class="sr-only">이전</span>
	            </a>
	
	            <a class="carousel-control-next main-show-control" href="#mainShowCarousel" role="button" data-slide="next">
	                <span class="carousel-control-next-icon" aria-hidden="true"></span>
	                <span class="sr-only">다음</span>
	            </a>
	        </div>
	    </div>
	</div>


       <!--  <div id="sub-category-area" style="display:none;">
            <div class="divider"></div>
            <div class="category-tabs text-center mb-4" id="sub-category-tabs">
                <button class='tab-btn sub-tab-btn active' onclick="loadSubCategory('all', this)">전체</button>
                <button class='tab-btn sub-tab-btn' onclick="loadSubCategory('pop', this)">콘서트</button>
                <button class='tab-btn sub-tab-btn' onclick="loadSubCategory('classic', this)">클래식</button>
                <button class='tab-btn sub-tab-btn' onclick="loadSubCategory('dance', this)">무용</button>
                <button class='tab-btn sub-tab-btn' onclick="loadSubCategory('circus', this)">서커스/마술</button>
                <button class='tab-btn sub-tab-btn' onclick="loadSubCategory('gugak', this)">국악</button>
            </div>
            <div id="showList" class="container row mx-auto justify-content-center"></div>
        </div> -->

       <div id="upcoming-section" class="section">
    <div class="divider"></div>
    <h2 class="section-title">오픈 예정 공연</h2>

    <div id="upcomingShowCarousel" class="carousel slide upcoming-show-carousel" data-ride="carousel" data-interval="false">
	        <div class="carousel-inner">
	
	            <c:forEach var="u" items="${upcomingList}" varStatus="st">
	                <c:if test="${st.index % 4 == 0}">
	                    <div class="carousel-item ${st.first ? 'active' : ''}">
	                        <div class="upcoming-show-row">
	                </c:if>
	
	                            <div class="upcoming-show-col">
	                                <a href="${path}/show/showDetail?showId=${u.showId}" class="upcoming-show-link">
	                                    <div class="upcoming-show-card">
	                                        <img class="upcoming-show-poster" src="${u.posterUrl}" alt="${u.title}">
	                                        <div class="upcoming-show-date">${u.startDate}</div>
	                                    </div>
	                                </a>
	                            </div>
	
	                <c:if test="${st.index % 4 == 3 || st.last}">
	                        </div>
	                    </div>
	                </c:if>
	            </c:forEach>
	
	        </div>
	
	        <a class="carousel-control-prev upcoming-show-control" href="#upcomingShowCarousel" role="button" data-slide="prev">
	            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
	            <span class="sr-only">이전</span>
	        </a>
	
	        <a class="carousel-control-next upcoming-show-control" href="#upcomingShowCarousel" role="button" data-slide="next">
	            <span class="carousel-control-next-icon" aria-hidden="true"></span>
	            <span class="sr-only">다음</span>
	        </a>
	    </div>
	</div>

    <br><br><br><br>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/show/js/show.js"></script>
    <script>
        let contextPath = '${path}'; // JS에서 사용할 서버 경로
    </script>
</body>
</html>