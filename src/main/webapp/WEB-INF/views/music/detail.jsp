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
    
     <!-- detail 페이지 전용 스타일 -->
     <style >
		.similar-section .row {
		    display: flex;
		    flex-wrap: wrap;
		    gap: 25px;   /* 🔥 이게 진짜 간격 */
		}
		
		.similar-section .col-6,
		.similar-section .col-sm-4,
		.similar-section .col-md-3,
		.similar-section .col-lg-2 {
		    flex: 0 0 auto;
		    width: auto;
		}
		/* 유사 곡 카드 영역 (이미지/카드 사이즈 완전 통일) */
		.similar-section .music-card {
			width: 170px; /* 카드 전체 너비 고정 */
			margin: 0 auto;
		}
		
		/* 이미지 영역: 190x190 고정 */
		.similar-section .music-card .card-img-top-wrapper {
			position: relative;
			width: 100%;
			height: 190px; /* 🔥 여기 숫자 바꾸면 이미지 세로 크기 조절 */
			padding-top: 0; /* 이전 100% 비율 설정 무효화 */
			overflow: hidden;
		}
		
		/* 실제 img를 wrapper에 꽉 채우기 */
		.similar-section .music-card img.card-img-top {
			position: absolute;
			top: 0;
			left: 0;
			width: 100%;
			height: 100%;
			object-fit: cover;
		}
		
		/* 아래 검정 영역 높이 고정 */
		.similar-section .music-card .card-body {
			padding: 6px 8px 8px;
			height: 70px; /* 텍스트 영역 고정 */
			overflow: hidden; /* 두 줄 넘어가면 숨김 */
		}
		
		/* 텍스트 줄 간격 줄이기 */
		.similar-section .music-card .card-title {
			font-size: 0.9rem;
			margin-bottom: 2px;
			line-height: 1.1;
		}
		
		.similar-section .music-card .card-text {
			font-size: 0.8rem;
			margin-bottom: 2px;
			line-height: 1.1;
		}
		/* 유사 곡 섹션 전체 여백 */
	    .similar-section {
	        margin-top: 40px;
	    }
	
	    .similar-section-title {
	        color: #fff;
	        font-size: 1.2rem;
	        font-weight: 700;
	        margin-bottom: 4px;
	    }
	
	    .similar-section-subtitle {
	        color: #888;
	        font-size: 0.85rem;
	        margin-bottom: 12px;
	    }
	
	    /* 리스트 박스 */
	    .similar-list {
	        background: rgba(20,30,50,0.1);
	        border-radius: 12px;
	        padding: 10px 18px;
	    }
	
	    /* 한 줄(한 곡) 스타일 */
	    .similar-row {
	        display: flex;
	        align-items: center;
	        padding: 8px 4px;
	        border-radius: 8px;
	        cursor: pointer;
	        transition: background 0.15s ease;
	    }
	    .similar-row:hover {
	        background: rgba(255,255,255,0.06);
	    }
	
	    /* 왼쪽 번호 */
	    .similar-index {
	        width: 32px;
	        text-align: right;
	        margin-right: 12px;
	        color: #777;
	        font-size: 0.85rem;
	    }
	
	    /* 썸네일 */
	    .similar-thumb {
	        width: 50px;
	        height: 50px;
	        border-radius: 6px;
	        overflow: hidden;
	        margin-right: 12px;
	        flex-shrink: 0;
	    }
	    .similar-thumb img {
	        width: 100%;
	        height: 100%;
	        object-fit: cover;
	        display: block;
	    }
	
	    /* 곡 정보 (제목+아티스트) */
	    .similar-main {
	        display: flex;
	        flex-direction: column;
	        min-width: 0;
	    }
	    .similar-title {
	        color: #fff;
	        font-size: 0.95rem;
	        margin-bottom: 2px;
	        white-space: nowrap;
	        overflow: hidden;
	        text-overflow: ellipsis;
	    }
	    .similar-artist {
	        color: #aaa;
	        font-size: 0.8rem;
	        white-space: nowrap;
	        overflow: hidden;
	        text-overflow: ellipsis;
	    }
	
	    /* 오른쪽 메타 (재생수/좋아요 등) */
	    .similar-meta-right {
	        margin-left: auto;
	        text-align: right;
	        color: #999;
	        font-size: 0.8rem;
	        flex-shrink: 0;
	    }
	    /* 유사곡 헤더 */
		.similar-header {
		    display: flex;
		    align-items: center;
		    padding: 8px 4px;
		    margin-bottom: 6px;
		    border-bottom: 1px solid rgba(255,255,255,0.08);
		    color: #fff;
		    font-size: 0.8rem;
		    text-transform: uppercase;
		    letter-spacing: 0.5px;
		}
		
		.similar-header .col-index {
		    width: 32px;
		    text-align: right;
		    margin-right: 12px;
		}
		
		.similar-header .col-title {
		    flex: 1;
		}
		
		.similar-header .col-album {
		    width: 150px;
		    text-align: left;
		}
		
		.similar-header .col-meta {
		    width: 80px;
		    text-align: right;
		}
		.similar-main {
		    flex: 2;
		}
		
		.similar-album {
		    flex: 1;
		    margin-left: 32px;
		}
		</style>
</head>
<body class="dark-mode">
<%@ include file="/WEB-INF/views/common/common.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<br><br><br><br>

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
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
