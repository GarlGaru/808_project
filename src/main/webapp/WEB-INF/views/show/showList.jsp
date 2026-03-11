<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>808 ShowList</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
    <link rel="stylesheet" href="${path}/resources/show/css/show.css">
    <link rel="stylesheet" href="${path}/resources/show/css/showList.css">
</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <br><br><br><br><br>

    <div class="container show-list-page">

        <!-- 상단 메인 장르 탭 -->
        <div class="main-category-wrap">
            <button class="tab-btn ${currentCategory == 'concert' ? 'active' : ''}"
                    onclick="location.href='${path}/show/showList?category=concert&subCategory=all'">콘서트</button>
            <button class="tab-btn ${currentCategory == 'musical' ? 'active' : ''}"
                    onclick="location.href='${path}/show/showList?category=musical&subCategory=all'">뮤지컬</button>
            <button class="tab-btn ${currentCategory == 'play' ? 'active' : ''}"
                    onclick="location.href='${path}/show/showList?category=play&subCategory=all'">연극</button>
        </div>

        <!-- 제목 -->
        <h2 class="genre-title">${pageTitle}</h2>

        <!-- 슬라이더 영역 -->
        <div class="top-slider-wrap">
            <button type="button" class="slider-arrow left" onclick="scrollTrack('genreTrack', -1)">&#10094;</button>

            <div id="genreTrack" class="genre-track">
                <c:forEach var="s" items="${list}">
                    <div class="genre-slide-item">
                        <a href="${pageContext.request.contextPath}/show/showDetail?showId=${s.showId}">
                            <img src="${s.posterUrl}"
                                 alt="${s.title}"
                                 class="genre-slide-poster"
                                 onerror="this.src='${pageContext.request.contextPath}/resources/show/images/no-images.png'">
                        </a>
                        <div class="genre-slide-title text-truncate">${s.title}</div>
                        <div class="genre-slide-sub text-truncate">${s.venueName}</div>
                    </div>
                </c:forEach>
            </div>

            <button type="button" class="slider-arrow right" onclick="scrollTrack('genreTrack', 1)">&#10095;</button>
        </div>

        <!-- 중분류 + 정렬 -->
        <div class="filter-sort-wrap">

           <%--  <c:if test="${currentCategory == 'concert'}"> --%>
                <%-- <div class="sub-category-wrap" id="sub-category-tabs">
                    <button class="sub-tab-btn ${subCategory == 'all' ? 'active' : ''}" onclick="loadSubCategory('all', this)">전체</button>
                    <button class="sub-tab-btn ${subCategory == 'pop' ? 'active' : ''}" onclick="loadSubCategory('pop', this)">콘서트</button>
                    <button class="sub-tab-btn ${subCategory == 'classic' ? 'active' : ''}" onclick="loadSubCategory('classic', this)">서양음악(클래식)</button>
                    <button class="sub-tab-btn ${subCategory == 'combination' ? 'active' : ''}" onclick="loadSubCategory('combination', this)">복합</button>
                    <button class="sub-tab-btn ${subCategory == 'dance' ? 'active' : ''}" onclick="loadSubCategory('dance', this)">무용</button>
                    <button class="sub-tab-btn ${subCategory == 'circus' ? 'active' : ''}" onclick="loadSubCategory('circus', this)">서커스/마술</button>
                    <button class="sub-tab-btn ${subCategory == 'gugak' ? 'active' : ''}" onclick="loadSubCategory('gugak', this)">국악</button>
                </div> --%>
         <%--    </c:if> --%>
         
         	<div class="sub-filter-line" id="sub-category-tabs">
			    <button type="button" class="sub-filter-btn ${subCategory == 'all' ? 'active' : ''}" onclick="loadSubCategory('all', this)">전체</button>
			    <button type="button" class="sub-filter-btn ${subCategory == 'pop' ? 'active' : ''}" onclick="loadSubCategory('pop', this)">대중음악</button>
			    <button type="button" class="sub-filter-btn ${subCategory == 'classic' ? 'active' : ''}" onclick="loadSubCategory('classic', this)">서양음악(클래식)</button>
			    <button type="button" class="sub-filter-btn ${subCategory == 'combination' ? 'active' : ''}" onclick="loadSubCategory('combination', this)">복합</button>
			    <button type="button" class="sub-filter-btn ${subCategory == 'dance' ? 'active' : ''}" onclick="loadSubCategory('dance', this)">무용(서양/한국무용)</button>
			    <button type="button" class="sub-filter-btn ${subCategory == 'circus' ? 'active' : ''}" onclick="loadSubCategory('circus', this)">서커스/마술</button>
			    <button type="button" class="sub-filter-btn ${subCategory == 'gugak' ? 'active' : ''}" onclick="loadSubCategory('gugak', this)">한국음악(국악)</button>
			</div>


            <div class="sort-wrap">
                <button type="button" class="sort-btn active">인기순</button>
                <button type="button" class="sort-btn">공연임박순</button>
                <button type="button" class="sort-btn">최신순</button>
            </div>
        </div>

        <!-- 카드 리스트 -->
        <div id="showList" class="row show-card-list">
            <c:choose>
                <c:when test="${not empty list}">
                    <c:forEach var="s" items="${list}">
                        <div class="col-lg-3 col-md-4 col-sm-6 col-12 mb-4 d-flex justify-content-center">
                            <div class="card show-card">
                                <a href="${pageContext.request.contextPath}/show/showDetail?showId=${s.showId}">
                                    <img src="${s.posterUrl}"
                                         class="card-img-top show-poster"
                                         alt="${s.title}"
                                         loading="lazy"
                                         onerror="this.src='${pageContext.request.contextPath}/resources/show/images/no-images.png'">
                                </a>

                                <div class="card-body px-2 py-2">
                                    <h5 class="card-title show-title" title="${s.title}">
                                        ${s.title}
                                    </h5>

                                    <p class="card-text show-meta">
                                        <span class="d-block text-truncate">${s.venueName}</span>
                                        <span class="d-block">
                                            <fmt:formatDate value="${s.startDate}" pattern="yyyy.MM.dd"/>
                                        </span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <div class="col-12 text-center py-5">
                        <p class="show-empty-message">해당 카테고리의 공연 정보가 없습니다.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <br><br><br><br>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/show/js/show.js"></script>

    <script>
        let contextPath = '${path}';
        let currentCategory = '${currentCategory}';

        function scrollTrack(trackId, direction) {
            const track = document.getElementById(trackId);
            if (!track) return;
            const move = 320;
            track.scrollBy({
                left: direction * move,
                behavior: 'smooth'
            });
        }
    </script>
</body>
</html>