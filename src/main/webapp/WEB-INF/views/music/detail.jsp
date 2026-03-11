<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${song.title} - 상세</title>
    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
    <link rel="stylesheet" href="${path}/resources/music//css/detail.css">
    
</head>
<body class="dark-mode">
<%@ include file="/WEB-INF/views/common/common.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/music/aside.jsp"%>

<div class="container mt-4 mb-5 detail-wrapper">

    <!-- 뒤로가기 -->
    <p style="font-size:0.85rem;">
        <a href="${pageContext.request.contextPath}/music" style="color:#bbb; text-decoration:none;">
            ← 목록으로
        </a>
    </p>

    <!-- 상단: 앨범 커버 + 곡 정보 -->
	  <div class="row mt-3 gx-4 gy-4">
	    <div class="col-md-4 mb-3 detail-cover-col">
	        <div class="detail-cover-wrapper">
	            <c:choose>
	                <c:when test="${not empty song.coverImageUrl}">
	                    <img src="${path}${song.coverImageUrl}"
	                         alt="${song.title}">
	                </c:when>
	                <c:otherwise>
	                    <img src="${path}/resources/music/img/default_album.jpg"
	                         alt="default">
	                </c:otherwise>
	            </c:choose>
	        </div>
	    </div>

        <div class="col-md-8">
            <h2 style="color:#fff; margin-bottom:8px;">${song.title}</h2>
            <p style="color:#bbb; margin-bottom:4px; font-size:1rem;">
                ${song.artistName}
            </p>
            <p style="color:#888; margin-bottom:4px; font-size:0.9rem;">
                앨범: ${song.albumTitle}
            </p>
            <p style="color:#888; margin-bottom:4px; font-size:0.9rem;">
                장르: ${song.genreName}
            </p>
            <p style="color:#777; margin-top:12px; font-size:0.85rem;">
                ▶ 재생 ${song.playCount} · ♥ 좋아요 ${song.likeCount}
            </p>
        </div>
    </div>
   <div class="similar-section">
    <h4 class="similar-section-title">유사 곡 추천</h4>
    <p class="similar-section-subtitle">이 곡 기준으로 함께 많이 재생된 곡입니다.</p>

    <c:if test="${empty similarList}">
        <p style="color:#777; font-size:0.9rem;">
            아직 유사 곡 추천이 없습니다.
        </p>
    </c:if>

    <c:if test="${not empty similarList}">
    <div class="similar-header">
    <div class="col-index">#</div>
    <div class="col-title">제목</div>
    <div class="col-album">앨범</div>
    <div class="col-meta">재생</div>
</div>
        <div class="similar-list">
            <c:forEach var="sim" items="${similarList}" varStatus="st">
                <div class="similar-row"
                     onclick="location.href='${pageContext.request.contextPath}/music/detail?songId=${sim.songId}'">
                    
                    <!-- 번호 -->
                    <div class="similar-index">
                        ${st.index + 1}
                    </div>

                    <!-- 썸네일 -->
                    <div class="similar-thumb">
                        <c:choose>
                            <c:when test="${not empty sim.coverImageUrl}">
                                <img src="${path}${sim.coverImageUrl}" alt="${sim.title}">
                            </c:when>
                            <c:otherwise>
                                <img src="${path}/resources/music/img/default_album.jpg" alt="default">
                            </c:otherwise>
                        </c:choose>
                    </div>

                <!-- 제목 + 아티스트 -->
							<div class="similar-main" style="flex: 1;">
								<div class="similar-title">${sim.title}</div>
								<div class="similar-artist">${sim.artistName}</div>
							</div>

							<!-- 앨범명 -->
							<div style="width: 150px; color: #fff; font-size: 0.8rem;">
								${sim.albumTitle}</div>

							<!-- 재생수 -->
							<div
								style="width: 80px; text-align: right; color: #fff; font-size: 0.8rem;">
								${sim.playCount}</div>
						</div>
            </c:forEach>
        </div>
    </c:if>
</div>
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</div>


<%@ include file="/WEB-INF/views/music/player.jsp" %>
</body>
</html>
