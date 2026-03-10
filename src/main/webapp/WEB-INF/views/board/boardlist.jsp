<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Premium Orange Board - List</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
  /* 1. 배경 및 전체 레이아웃: 더 부드러운 오렌지 그라데이션 */
        body {
            /* 하단의 어두운 색을 #2b1407(딥브라운)에서 #4a3326(소프트브라운) 정도로 연하게 조정 */
            background: radial-gradient(circle at top, #ff7b29 0%, #4a3326 100%) !important;
            padding-top: 130px !important;
            margin: 0;
            min-height: 100vh;
            font-family: 'Pretendard', sans-serif;
            color: #ffffff;
        }

        /* 2. 게시판 컨테이너 (더 투명한 유리 배경 효과) */
        .table_div {
            margin: 0 auto !important;
            max-width: 1000px;
            /* 불투명도를 0.08 -> 0.05로 낮춰 배경이 더 잘 비치게 함 */
            background: rgba(255, 255, 255, 0.05); 
            /* 블러 강도를 높여 뒤쪽 오렌지 빛을 더 부드럽게 확산 */
            backdrop-filter: blur(20px); 
            padding: 40px;
            border-radius: 20px;
            /* 테두리 농도를 0.2 -> 0.12로 낮춰 더 은은하게 처리 */
            border: 1px solid rgba(255, 255, 255, 0.12);
            /* 그림자도 조금 더 연하게 퍼지도록 조정 */
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }
        h2 {
            color: #ffffff !important;
            text-align: center;
            margin-bottom: 40px;
            font-weight: 800;
            letter-spacing: 2px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        /* 3. 테이블 디자인 */
        .board-table {
            width: 100%;
            border-collapse: collapse;
        }

        .board-table th {
            border-bottom: 2px solid #ffcc00; /* 옐로우 골드 라인 */
            padding: 15px 10px;
            color: #ffcc00;
            font-size: 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .board-table td {
            padding: 20px 10px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
            color: #eeeeee;
            font-size: 15px;
        }

        /* 제목 링크 */
        .title-link a {
            text-decoration: none;
            color: #ffffff;
            font-weight: 500;
            transition: 0.3s;
        }

        .title-link a:hover {
            color: #ffcc00;
            padding-left: 5px; /* 살짝 밀리는 효과 */
        }

        /* 4. 페이징 디자인 */
        .paginations {
            text-align: center;
            margin-top: 40px;
        }

        .paginations a, .paginations span {
            padding: 10px 18px;
            margin: 0 5px;
            border-radius: 50px;
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            text-decoration: none;
            transition: 0.3s;
            font-size: 14px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .paginations a:hover {
            background: #ff6b13;
            border-color: #ffcc00;
            transform: translateY(-2px);
        }

        .paginations .active {
            background: #ff6b13 !important;
            color: white !important;
            font-weight: bold;
            box-shadow: 0 0 15px rgba(255, 107, 19, 0.5);
            border: 1px solid #ffcc00 !important;
        }

        /* 5. 글쓰기 버튼 (오렌지/옐로우 그라데이션) */
        #btnSave {
            background: linear-gradient(135deg, #ffcc00 0%, #ff6b13 100%) !important; 
            color: #2b1407 !important; /* 어두운 글자색으로 대비 */
            border: none !important;
            border-radius: 50px !important; 
            padding: 15px 45px !important;
            font-weight: 800;
            font-size: 16px;
            cursor: pointer;
            box-shadow: 0 5px 20px rgba(255, 107, 19, 0.4) !important; 
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            display: inline-block !important;
        }

        #btnSave:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 8px 25px rgba(255, 107, 19, 0.6) !important;
            filter: brightness(1.1);
        }

        /* 추천 하트 색상 */
        .like-heart {
            color: #ffcc00; /* 오렌지 테마에 맞춰 옐로우로 변경 */
            font-weight: bold;
        }
    </style>
</head>

<body>
    <%@ include file="/WEB-INF/views/common/common.jsp"%>
    <%@ include file="/WEB-INF/views/common/header.jsp"%>

    <div class="table_div">
        <h2>자유게시판</h2>

        <form name="boardList">
            <table class="board-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th style="width: 45%;">제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>추천</th>
                        <th>조회</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="dto" items="${list}">
                        <tr>
                            <td>${dto.bno}</td>
                            <td class="title-link">
                                <a href="${pageContext.request.contextPath}/board/plusReadCnt?bno=${dto.bno}">
                                    ${dto.title}
                                </a>
                            </td>
                            <td>${dto.nickname}</td>
                            <td>
                                <fmt:formatDate value="${dto.regdate}" pattern="yyyy-MM-dd" />
                            </td>
                            <td><span class="like-heart">❤ ${dto.likeCount}</span></td>
                            <td>${dto.viewcnt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </form>

        <div style="text-align: right; margin-top: 40px;">
            <input class="inputButton" id="btnSave" type="button" value="글쓰기"
                onclick="location.href='${pageContext.request.contextPath}/board/wrter'">
        </div>

        <div class="paginations">
            <c:if test="${paging.startPage > paging.pageSize}">
                <a href="${path}/board/list?pageNum=${paging.prev}">이전</a>
            </c:if>
            
            <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
                <c:choose>
                    <c:when test="${i == paging.currentPage}">
                        <span class="active">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="${path}/board/list?pageNum=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            
            <c:if test="${paging.endPage < paging.pageCount}">
                <a href="${path}/board/list?pageNum=${paging.next}">다음</a>
            </c:if>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>