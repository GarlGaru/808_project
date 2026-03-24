<!-- ##### Header Area Start ##### -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<header class="header-area">


	<div class="oneMusic-main-menu">
		<div class="classy-nav-container breakpoint-off">
			<div class="container">
				<nav class="classy-navbar justify-content-between" id="oneMusicNav">
					<a href="${path}/main" class="nav-brand"> <img
						src="${path}/resources/common/img/core-img/808_logo(white).png"
						alt="808 logo">
					</a>
					<div class="classy-navbar-toggler">
						<span class="navbarToggler"><span></span><span></span><span></span></span>
					</div>
					<div class="classy-menu">
						<div class="classycloseIcon">
							<div class="cross-wrap">
								<span class="top"></span><span class="bottom"></span>
							</div>
						</div>
						<div class="classynav">
							<ul>
								<li><a href="${path}/main">Home</a></li>
								<li><a href="${path}/music">Music</a></li>
								<li><a href="${path}/show">Show</a></li>
								<c:choose>
									<%-- 로그인완료시 --%>
									<c:when test="${not empty sessionScope.loginUser}">
								 	<li>
							        	<a href="javascript:void(0);" onclick="openSubscribeModal()">Subscribe</a>
							    	</li>
							   		</c:when>
							   	</c:choose>
								<c:if test="${sessionScope.loginUser.nickname == 'admin'}">
									<li><a href="${path}/admin">ADMIN</a></li>
								</c:if>
								<c:if test="${sessionScope.loginUser.nickname != 'admin'}">

									<li><a href="${path}/board/list">Community</a></li>
								</c:if>
							</ul>
							<div class="login-register-cart-button d-flex align-items-center">
								<c:choose>
									<%-- 로그인 된 상태: 닉네임 클릭 → openMypage() --%>
									<c:when test="${not empty sessionScope.loginUser}">
										<div class="login-register-btn mr-15">
										  <a href="javascript:void(0)" onclick="openMypage()">
										    ${sessionScope.loginUser.nickname}
										    <i class="fa-solid fa-circle-user"></i>
										    <!-- <i class="fa-solid fa-user"></i> -->
										  </a>
										</div>
										<div class="login-register-btn">
											<a href="${path}/logout">Logout</a>
										</div>
									</c:when>
									<%-- 로그인 안 된 상태 --%>
									<c:otherwise>
										<div class="login-register-btn mr-15">
											<a href="javascript:void(0)" onclick="openAuthModal()">Join</a>
										</div>
							<!-- 			<div class="login-register-btn">
											<a href="javascript:void(0)" onclick="openAuthModal('register')">Register</a>
										</div> -->
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div>
				</nav>
			</div>
		</div>
	</div>
</header>

<jsp:include page="/WEB-INF/views/common/subscribeModal.jsp"/>
<script src="${path}/resources/common/js/subscribe.js"></script>
<!-- ##### Header Area End ##### -->

<%-- 로그인/회원가입, 마이페이지 --%>
<%@ include file="/WEB-INF/views/user/mypageModal.jsp" %>
<%@ include file="/WEB-INF/views/user/authModal.jsp" %>
