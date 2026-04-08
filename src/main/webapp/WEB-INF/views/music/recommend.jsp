<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

<c:choose>
    <%-- 로그인 된 상태: 닉네임 클릭 → openMypage() --%>
    <c:when test="${not empty sessionScope.loginUser}">

        <div class="music-home-wrap">
            <div data-init="initMusicReco">
                <%-- 각 슬라이더의 마운트 포인트 --%>
                <div id="personal-recommend-mount"></div>
                <div id="reco-popular-slider-mount"></div>
                <div id="reco-latest-slider-mount"></div>

            </div>
        </div>

    </c:when>
    <%-- 로그인 안 된 상태 --%>
    <c:otherwise>
        <div data-init="openAuthModal" />
    </c:otherwise>
</c:choose>



