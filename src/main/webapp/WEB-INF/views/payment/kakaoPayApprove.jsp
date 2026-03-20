<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Bootstrap 4 Spotify-style buttons sample">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Approve</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
    
    <style>
	.payment-dev {
		display: table;
		margin-left: auto;
		margin-right: auto;
	}
	</style>

</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    <br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<div class="payment-dev">
		<h2>승인 완료</h2>
		<p>orderId : ${orderId}</p>
		<p>tid : ${approve.tid}</p>
		<p>상품명 : ${approve.item_name}</p>
		<p>승인시간 : ${approve['approved_at']}</p>
		<a href="${pageContext.request.contextPath}/kakaopay/form">다시</a>
	</div>
</body>
</html>