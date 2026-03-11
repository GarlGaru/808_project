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
    <title>808 SHOW</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
	<link rel="stylesheet" href="${path}/resources/show/css/show.css">
	
</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    <br><br><br><br>
    <br><br><br><br>
<%-- 
	<div class="section" style="justify-content-center">
		<a href="${path}/show/seat-detail">
			<img src="${path}/resources/presentation/show.png">
		</a>
    </div> --%>
 
    <div class="show-wrap">
     	<!-- 1) 장르 배너 시작 -->
     	<div class="genre-bar">
     		<a href="${path}/show/showList?category=concert">콘서트</a>
     		<a href="${path}/show/showList?category=musical">뮤지컬</a>
     		<a href="${path}/show/showList?category=play">연극</a>
     	</div>
     	<!-- 1) 장르 배너 종료 -->
     	
     	<!-- 2) 메인 공연 목록 슬라이딩 시작 -->
     	<div class="section">
     		<h2 class="section-title">공연
     		<c:choose>
     			<c:when test="${currentCategory == 'concert'}"> 콘서트 </c:when>
     			<c:when test="${currentCategory == 'musical'}"> 뮤지컬 </c:when>
     			<c:when test="${currentCategory == 'play'}"> 연극 </c:when>
     		</c:choose>
     		</h2>
     		<div class="slider">
     			<button type="button" class="nav-btn nav-left" onclick="scrollTrack('mainTrack', -1)"></button>
 				
 				<div id="mainTrack" class="track">
 					<c:forEach var="s" items="${list}">
 						<div class="card-item">
 							<!-- 포스터 추가 -->
 							<img class="poster" src="${s.posterUrl}" alt="${s.title}">
 							<div class="title">${s.title}</div>
 							<div class="sub">${s.venueName}</div>
 						</div>
 					</c:forEach>
 					
 					<c:if test="${empty list}">
 						<div style="padding: 10px 44px; opacity: .8; color:#fff;">(테스트) list의 데이터가 없습니다.</div>
 					</c:if>	
 				</div>    
 				
 				<button type="button" class="nav-btn nav-right" onclick="scrollTrack('mainTrack', 1)"></button>
     		</div>
     	</div>
     
     	<div class="divder"></div>
     	
     	<!-- 3) 오픈 예정 공연목록 슬라이딩 -->
     	<div class="section">
     		<h2 class="section-title">오픈 예정 공연</h2>
     		
     		<div class="slider" style="position: relative;">
     		<button type="button" class="nav-btn nav-left" onclick="scrollTrack('upcomingTrack', -1)"></button>
     		<div id="upcomingTrack" class="track">
     			<c:forEach var="u" items="${upcomingList}">
     				<div class="card-item">
     					<img class="poster" src="${u.posterUrl}" alt="${u.title}">
     					<div class="sub">
     						<c:choose>
     							<c:when test="${not empty u.startDate}">
     								${u.startDate}
     							</c:when>
     							<c:otherwise>
     								(시작일 미정)
     							</c:otherwise>
     						</c:choose>
     					</div>
     				</div>
     			</c:forEach>
     			<c:if test="${empty upcomingList}">
     				<div style="padding: 10px 44px; opacity: .8; color:#fff;"> (테스트) 오픈 예정 공연 데이터가 없습니다. </div>
     			</c:if>
     		
     			</div> <button type="button" class="nav-btn nav-right" onclick="scrollTrack('upcomingTrack', 1)"></button>
     		</div>
     	</div>
    </div> 
 

    <br><br><br><br>


    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>
    <script src="${path}/resources/show/js/show.js"></script>
    
</body>
</html>
