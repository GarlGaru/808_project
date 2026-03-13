<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Seat Preview</title>
<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>



	<div class="seat-preview-wrapper">
	
		<h3 class="preview-title">좌석 프리뷰</h3>
	<div id="seatCarousel" class="carousel slide" data-ride="carousel">
	<div class="carousel-inner">
	
	<!-- 첫 슬라이드 -->
	<div class="carousel-item active">
	<div class="row">
	
	<div class="col-md-3 preview-item">
	<img src="${pageContext.request.contextPath}/resources/images/show/img1.png" class="img-fluid">
	<p>I열</p>
	</div>
	
	<div class="col-md-3 preview-item">
	<img src="${pageContext.request.contextPath}/resources/images/show/img2.png" class="img-fluid">
	<p>D열</p>
	</div>
	
	<div class="col-md-3 preview-item">
	<img src="${pageContext.request.contextPath}/resources/images/show/img3.png" class="img-fluid">
	<p>H열</p>
	</div>
	
	<div class="col-md-3 preview-item">
	<img src="${pageContext.request.contextPath}/resources/images/show/img4.png" class="img-fluid">
	<p>L열</p>
	</div>
	
	</div>
	
	</div>
	</div>
	</div>
	</div>
	
	
	<!-- 두번째 슬라이드 -->
	<div class="carousel-item">
	<div class="row">
	
	<div class="col-md-3 preview-item">
	<img src="${pageContext.request.contextPath}/resources/images/show/img5.png" class="img-fluid">
	<p>J열</p>
	</div>
	
	<div class="col-md-3 preview-item">
	<img src="${pageContext.request.contextPath}/resources/images/show/img6.png" class="img-fluid">
	<p>A열</p>
	</div>
	
	<div class="col-md-3 preview-item">
	<img src="${pageContext.request.contextPath}/resources/images/show/img7.png" class="img-fluid">
	<p>C열</p>
	</div>
	
	<div class="col-md-3 preview-item">
	<img src="${pageContext.request.contextPath}/resources/images/show/img8.png" class="img-fluid">
	<p>F열</p>
	</div>
	
	</div>
	
	</div>
	
	<!-- 세번째 슬라이드 -->
	<div class="carousel-item">
	<div class="row">
	
	<div class="col-md-3 preview-item">
	<img src="${pageContext.request.contextPath}/resources/images/show/img9.png" class="img-fluid">
	<p>W열</p>
	</div>
	
	<div class="col-md-3 preview-item">
	<img src="${pageContext.request.contextPath}/resources/images/show/img10.png" class="img-fluid">
	<p>Q열</p>
	</div>
	
	<div class="col-md-3 preview-item">
	<img src="${pageContext.request.contextPath}/resources/images/show/img11.png" class="img-fluid">
	<p>E열</p>
	</div>
	
	<div class="col-md-3 preview-item">
	<img src="${pageContext.request.contextPath}/resources/images/show/img12.png" class="img-fluid">
	<p>Y열</p>
	</div>
	
	</div>
	
	</div>
	
	<!--좌우 버튼 -->
	<a class="carousel-control-prev" href="#seatCarousel" role="button" data-slide="prev">
	<span class="carousel-control-prev-icon"></span>
	</a>
	
	<a class="carousel-control-next" href="#seatCarousel" role="button" data-slide="next">
	<span class="carousel-control-next-icon"></span>
	</a>
</body>
</html>