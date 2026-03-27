<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>알림</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
    <link rel="stylesheet" href="${path}/resources/show/css/show.css">
    <link rel="stylesheet" href="${path}/resources/show/css/myTicket.css">
</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <script>
        // 컨트롤러에서 넘겨준 메시지를 띄움
        alert('${msg}');
        
        // 컨트롤러에서 넘겨준 주소로 이동 (주소가 없으면 뒤로가기)
        <c:choose>
            <c:when test="${not empty url}">
                location.href = '${path}${url}';
            </c:when>
            <c:otherwise>
                history.back();
            </c:otherwise>
        </c:choose>
    </script>
     <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>