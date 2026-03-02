<head>
<meta charset="UTF-8">
<meta name="description"
	content="Bootstrap 4 Spotify-style buttons sample">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>결제실패</title>

<link rel="stylesheet" href="${path}/resources/common/css/style.css">
<link rel="stylesheet" href="${path}/resources/common/style.css">
</head>
<body class="dark-mode">
	<%@ include file="/WEB-INF/views/common/common.jsp"%>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<h2>결제에 실패했습니다.</h2>

	<p>orderId: ${orderId}</p>

	<a href="${pageContext.request.contextPath}/kakaopay/form">다시 결제하기</a>
</body>
</html>