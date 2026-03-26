<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

<div class="music-home-wrap">
    <div data-init="initMusicReco">
        <%-- 각 슬라이더의 마운트 포인트 --%>
        <div id="personal-recommend-mount"></div>
        <div id="today-slider-mount"></div>
        <div id="genre-slider-mount"></div>

    </div>
</div>
