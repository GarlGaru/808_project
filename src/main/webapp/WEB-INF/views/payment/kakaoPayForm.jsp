<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="description"
	content="Bootstrap 4 Spotify-style buttons sample">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>kakaoPay Form</title>

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
	<%@ include file="/WEB-INF/views/common/common.jsp"%>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>

	<section class="hero-area">
		<div class="payment-dev">
			<h2>카카오페이 결제</h2>
		</div>
		
		<form action="${pageContext.request.contextPath}/kakaopay/ready"
			method="post">
			
			<table class="payment-dev" border="1" style="width:400px;">

			    <tr>
			        <th style="width:120px;">상품명</th>
			        <td>
			            <select name="paymentType" required>
			                <option value="TICKET" selected>TICKET</option>
			                <option value="SUBSCRIBE">SUBSCRIBE</option>
			            </select>
			        </td>
			    </tr>
			</table>


			<div class="payment-dev">
				<label>상품명</label><br/> 
				<input type="text" name="itemName"
					placeholder="상품명을 입력하세요" required />
			</div>

			<div class="payment-dev">
				<label>수량</label><br/> 
				<input type="number" name="quantity"
					value="1" min="1" required />
			</div>

			<div class="payment-dev">
				<label>총액</label><br/> 
				<input type="number" name="totalPrice"
					value="1000" min="100" required />
			</div>
			<br/>
				<button class="payment-dev" type="submit">결제하기</button>
		</form>
	</section>

	<br>
	<br>
	<br>
	<br>




	<%@ include file="/WEB-INF/views/common/footer.jsp"%>

	<script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
	<script
		src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
	<script src="${path}/resources/common/js/plugins/plugins.js"></script>
	<script src="${path}/resources/common/js/active.js"></script>
	<script src="${path}/resources/common/js/main.js"></script>
</body>
</html>