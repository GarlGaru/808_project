<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="description"
	content="Bootstrap 4 Spotify-style buttons sample">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>결제취소</title>

<link rel="stylesheet" href="${path}/resources/common/css/style.css">
<link rel="stylesheet" href="${path}/resources/common/style.css">
</head>
<body class="dark-mode">
	<%@ include file="/WEB-INF/views/common/common.jsp"%>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<h2>결제가 취소되었습니다.</h2>

	<p>orderId: ${orderId}</p>

	<a href="${pageContext.request.contextPath}/kakaopay/form">다시 결제하기</a>


</body>
</html>