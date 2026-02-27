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
    <title>Bootstrap 4 Button Sample</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">

<style>
/*===== page container ====*/
.show-wrap {max-width: 1200px; magin: 0 auto; padding: 10px 16px 40px;}
.section{margin-top: 28px;}
.section-title{font-size: 22px; font-weight: 700; margin: 0 0 14px}

/*==== Genre Banner ====*/
.genre-bar { display: flex; gap: 12px; align-items: center; margin: 6px 0 18px; flex-wrap: wrap;}
.genre-bar a {
	display: inline-block;
	padding: 8px 14px;
	border-radius: 999px;
	text-decoration: none;
	font-weight: 700;
	border: 1px solid rgba(255,255,255,0.18);
	background: rgba(255,255,255,0.08);
	color:#fff;
}

.genre-bar a:hover {background: rgba(255,255,255,0.14);}

/*==== slider ====*/
.slider {position: relative;}
.track {
	display: flex;
	gat: 26px;
	overflow-x: auto;
	scroll-behavior: smooth;
	padding:15px 44px;
}

.track::-webkit-scrollbar { height: 8px;}
.track::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.25); border-radius: 999px; }

.nav-btn {
	position: absolute;
	top: 40%;
	transform: translateY(-50%);
	width: 36px;
	height: 36px;
	border-radius: 999px;
	border: 1px solid rgba(255,255,255,0.22);
	background: rgba(0,0,0,0.35);
	color: #fff;
	cursor: pointer;
	display: flex;
	align-items: center;
	user-select: none;
	z-index: 2;
}
.nav-btn:hover { background: rgba(0,0,0,0.55);}
.nav-left {left: 6px;}
.nav-right {right: 6px;}

/*==== cards ====*/
.card-item {width: 180px; flex: 0 0 auto; margin-right: 10px; margin-left: 10px;}
.poster {
	width: 180px;
	height: 250px;
	border-radius: 10px;
	object-fit: cover;
	display: block;
	background: rgba(255,255,255,0.88);
}
.meta { margin-top: 8px;}
.title {
	font-size:13px;
	font-weight: 800;
	line-height: 1.2;
	color: #fff;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}
.sub {
	margin-top: 4px;
	font-size: 12px;
	opacity: 0.75;
	color: #fff;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}
.divider { height: 1px; background: rgba(255,255,255,0.12); margin: 28px 0;}
</style>


</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    <br><br><br><br>

    

    <div class="show-wrap">
     	<!-- 1) 장르 배너 시작 -->
     	<div class="genre-bar">
     		<a href="#">콘서트</a>
     		<a href="#">뮤지컬</a>
     		<a href="#">연극</a>
     	</div>
     	<!-- 1) 장르 배너 종료 -->
     	
     	<!-- 2) 메인 공연 목록 슬라이딩 시작 -->
     	<div class="section">
     		<h2 class="section-title">공연</h2>
     		
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
     		
     			<button type="button" class="nav-btn nav-right" onclick="scrollTrack('upcomingTrack', 1)"></button>
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
    
    <script>
    	function scrollTrack(trackId, dir) {
    		var el = document.getElementById(trackId);
    		if(!el) return;
    		el.scrollBy({ left: dir * 420, behavior: 'smooth'})
    	}
    </script>
</body>
</html>
