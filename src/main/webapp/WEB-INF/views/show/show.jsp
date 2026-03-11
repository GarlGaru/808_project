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
    <br><br><br><br><br><br>

    <div class="show-wrap">
        <div class="genre-bar">
	    <a href="${path}/show/showList?category=concert&subCategory=all">콘서트</a>
	    <a href="${path}/show/showList?category=musical&subCategory=all">뮤지컬</a>
	    <a href="${path}/show/showList?category=play&subCategory=all">연극</a>
	    <a href="#">랭킹</a>
	    <a href="#">후기</a>
	</div>

        <div class="section">
            <h2 class="section-title" id="main-section-title">공연</h2>
            <div class="slider">
                <button type="button" class="nav-btn nav-left" onclick="scrollTrack('mainTrack', -1)"></button>
                <div id="mainTrack" class="track">
                    <c:forEach var="s" items="${list}">
                        <a href="${path}/show/showDetail?showId=${s.showId}"> 
                            <div class="card-item"> 
                                <img class="poster" src="${s.posterUrl}" alt="${s.title}"> 
                                <div class="title">${s.title}</div> 
                                <div class="sub">${s.venueName}</div> 
                            </div> 
                        </a>
                    </c:forEach>
                </div> 
                <button type="button" class="nav-btn nav-right" onclick="scrollTrack('mainTrack', 1)"></button>
            </div>
        </div>

        <div id="sub-category-area" style="display:none;">
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
        </div>

        <div id="upcoming-section" class="section">
            <div class="divider"></div>
            <h2 class="section-title">오픈 예정 공연</h2>
            <div class="slider">
                <button type="button" class="nav-btn nav-left" onclick="scrollTrack('upcomingTrack', -1)"></button>
                <div id="upcomingTrack" class="track">
                    <c:forEach var="u" items="${upcomingList}">
                        <a href="${path}/show/showDetail?showId=${u.showId}">
                            <div class="card-item">
                                <img class="poster" src="${u.posterUrl}" alt="${u.title}">
                                <div class="sub">${u.startDate}</div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
                <button type="button" class="nav-btn nav-right" onclick="scrollTrack('upcomingTrack', 1)"></button>
            </div>
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