<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Bootstrap 4 Spotify-style buttons sample">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>공연 후기 게시판</title>

<style>
        /* 후기 게시판 전용 스타일 (다크모드 맞춤) */
        .review-section { color: #fff; padding: 50px 0; }
        .review-header { display: flex; justify-content: space-between; align-items: flex-end; border-bottom: 1px solid #444; padding-bottom: 20px; margin-bottom: 30px; }
        .review-card { background: #222; border-radius: 10px; padding: 20px; margin-bottom: 15px; border: 1px solid #333; }
        .user-info { display: flex; align-items: center; margin-bottom: 10px; }
        .profile-img { width: 40px; height: 40px; border-radius: 50%; background: #555; margin-right: 12px; overflow: hidden; }
        .profile-img img { width: 100%; height: 100%; object-fit: cover; }
        .user-id { font-weight: bold; margin-right: 10px; color: #1DB954; } /* 스포티파이 그린 느낌 */
        .reg-date { font-size: 0.85rem; color: #888; }
        .review-content { line-height: 1.6; color: #ccc; }
        .rating { color: #ffc107; margin-left: auto; }
        
        /* 페이지네이션 스타일 */
        .pagination-container { margin-top: 40px; }
        .pagination .page-link { background-color: #222; border-color: #444; color: #fff; }
        .pagination .page-item.active .page-link { background-color: #1DB954; border-color: #1DB954; }
        
        /* 공연 선택 셀렉트박스 */
        .concert-filter { background: #333; color: #fff; border: 1px solid #555; padding: 5px 10px; border-radius: 5px; }
    </style>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    <br><br><br>
    
    
   <div class="container review-section">
        <div class="review-header">
            <div>
                <h1 class="display-4 font-weight-bold" style="color: white !important;">공연 후기</h1>
                <p class="text-muted">총 ${totalCount}개의 생생한 후기가 있습니다.</p>
            </div>
            
            <div class="text-right">
                <%-- <button class="btn btn-outline-success mb-3" onclick="location.href='${path}/show/writeReview'">후기 작성하기</button> --%>
                <br>
                <select class="concert-filter" onchange="location.href='${path}/show/reviewList?concertTitle=' + this.value">
                    <option value="">전체 공연 보기</option>
                    <c:forEach var="title" items="${concertList}">
                        <option value="${title}" ${param.concertTitle == title ? 'selected' : ''}>${title}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="review-list">
            <c:if test="${empty reviews}">
                <p class="text-center py-5">등록된 후기가 없습니다. 첫 후기를 남겨보세요!</p>
            </c:if>
            
            <c:forEach var="review" items="${reviews}">
                <div class="review-card">
                    <div class="user-info">
<%--                         <div class="profile-img">
                           <img src="${review.profileImg != null ? review.profileImg : path}/resources/images/default-profile.png">
                        </div> --%>
                      <c:choose>
				    <c:when test="${not empty review.profileImg}">
				        <img src="${review.profileImg}">
				    </c:when>
				    <c:otherwise>
				        <img src="${path}/resources/images/default-profile.png">
				    </c:otherwise>
				</c:choose>
                        <span class="user-id">${review.userId}</span>
                        <span class="reg-date">
						    <fmt:formatDate value="${review.createdAt}" pattern="yyyy-MM-dd" />
						</span>
                        
                    </div>
                    <div class="review-content">
                        <strong>[${review.concertTitle}]</strong><br>
                        ${review.content}
                    </div>
                </div>
            </c:forEach>
        </div>

       <nav class="pagination-container d-flex justify-content-center align-items-center" 
     style="position: relative; width: 100%; ">
    
    <ul class="pagination mb-0">
        <li class="page-item"><a class="page-link" href="#">이전</a></li>
        <c:forEach var="i" begin="1" end="5">
            <li class="page-item ${param.page == i ? 'active' : ''}">
                <a class="page-link" href="${path}/show/reviewList?page=${i}">${i}</a>
            </li>
        </c:forEach>
        <li class="page-item"><a class="page-link" href="#">다음</a></li>
    </ul>

   <button class="btn" 
        style="border-radius: 50px; font-weight: bold; padding: 10px 25px; 
               position: absolute; right: 0; color: white; border: none;
               background-image: linear-gradient(to right, #DF8845, #ED6701);" 
        onclick="location.href='${path}/show/writeReview'">
    후기 작성하기
</button>
</nav>
    </div>


	<script>
     
        var msg = "${msg}";
        if(msg === "insertSuccess") {
            alert("후기가 성공적으로 등록되었습니다!");
        }
    </script>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>
</body>
</html>
