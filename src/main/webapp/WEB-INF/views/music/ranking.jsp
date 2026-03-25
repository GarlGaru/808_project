<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

<div class="music-ranking-page">
    <div data-init="initRanking">
        <div id="weekly-ranking-mount"></div>
        <div id="today-ranking-mount"></div>
        <div id="genre-ranking-mount"></div>
    </div>
</div>