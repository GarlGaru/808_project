<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>

<div id="carouselExample" class="carousel slide">


  <div class="carousel-inner">
  
    <div class="carousel-item active">
    <div class="container">
    <div class="row">
    
    <div class="col-md-4">
      <img src="${pageContext.request.contextPath}/resources/images/show/img1.png" class="img-fluid d-block mx-auto">
    </div>
    
    <div class="col-md-4">
<img src="${pageContext.request.contextPath}/resources/images/show/img2.png" class="img-fluid d-block mx-auto">
</div>

<div class="col-md-4">
<img src="${pageContext.request.contextPath}/resources/images/show/img3.png" class="img-fluid d-block mx-auto">
</div>

</div>
</div>
</div>


<div class="carousel-item">
    <div class="container">
    <div class="row">
    
    <div class="col-md-4">
      <img src="${pageContext.request.contextPath}/resources/images/show/img4.png" class="img-fluid d-block mx-auto">
    </div>
    
    <div class="col-md-4">
<img src="${pageContext.request.contextPath}/resources/images/show/img5.png" class="img-fluid d-block mx-auto">
</div>

<div class="col-md-4">
<img src="${pageContext.request.contextPath}/resources/images/show/img6.png" class="img-fluid d-block mx-auto">
</div>

</div>
</div>
</div>

</div>

<div class="carousel-item">
    <div class="container">
    <div class="row">
    
    <div class="col-md-4">
      <img src="${pageContext.request.contextPath}/resources/images/show/img7.png" class="img-fluid d-block mx-auto">
    </div>
    
    <div class="col-md-4">
<img src="${pageContext.request.contextPath}/resources/images/show/img8.png" class="img-fluid d-block mx-auto">
</div>

<div class="col-md-4">
<img src="${pageContext.request.contextPath}/resources/images/show/img9.png" class="img-fluid d-block mx-auto">
</div>

</div>
</div>
</div>

</div>

<div class="carousel-item">
    <div class="container">
    <div class="row">
    
    <div class="col-md-4">
      <img src="${pageContext.request.contextPath}/resources/images/show/img10.png" class="img-fluid d-block mx-auto">
    </div>
    
    <div class="col-md-4">
<img src="${pageContext.request.contextPath}/resources/images/show/img11.png" class="img-fluid d-block mx-auto">
</div>

<div class="col-md-4">
<img src="${pageContext.request.contextPath}/resources/images/show/img12.png" class="img-fluid d-block mx-auto">
</div>

</div>
</div>
</div>


<!-- 이전 -->
<button class="carousel-control-prev" type="button"
data-bs-target="#carouselExample"
data-bs-slide="prev">

<span class="carousel-control-prev-icon"></span>

</button>


<!-- 다음 -->
<button class="carousel-control-next" type="button"
data-bs-target="#carouselExample"
data-bs-slide="next">

<span class="carousel-control-next-icon"></span>

</button>

  
 
</body>
</html>