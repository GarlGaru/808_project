<!-- ##### Header Area Start ##### -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<header class="header-area">
	<div class="oneMusic-main-menu">
		<div class="classy-nav-container breakpoint-off">
			<div class="container">
				<nav class="classy-navbar justify-content-between" id="oneMusicNav">
					<a href="#" class="nav-brand"> <img
						src="${path}/resources/common/img/core-img/logo.png"
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
								<c:if test="${sessionScope.loginUser.nickname == 'admin'}">
									<li><a href="${path}/admin">ADMIN</a></li>
								</c:if>
								<c:if test="${sessionScope.loginUser.nickname != 'admin'}">
									<li><a href="${path}/main/board">Board</a></li>
								</c:if>
							</ul>
							<div class="login-register-cart-button d-flex align-items-center">
								<c:choose>
									<%-- 로그인 된 상태: 닉네임 클릭 → openMypage() --%>
									<c:when test="${not empty sessionScope.loginUser}">
										<div class="login-register-btn mr-15">
											<a href="javascript:void(0)" onclick="openMypage()">${sessionScope.loginUser.nickname}님 👤</a>
										</div>
										<div class="login-register-btn">
											<a href="${path}/logout">Logout</a>
										</div>
									</c:when>
									<%-- 로그인 안 된 상태 --%>
									<c:otherwise>
										<div class="login-register-btn mr-15">
											<a href="javascript:void(0)" onclick="openAuthModal()">Login</a>
										</div>
										<div class="login-register-btn">
											<a href="javascript:void(0)" onclick="openAuthModal('register')">Register</a>
										</div>
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
<!-- ##### Header Area End ##### -->

<%-- 로그인/회원가입, 마이페이지 --%>
<%@ include file="/WEB-INF/views/user/mypageModal.jsp" %>
<%@ include file="/WEB-INF/views/user/authModal.jsp" %>