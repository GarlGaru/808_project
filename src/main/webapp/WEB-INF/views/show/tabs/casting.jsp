<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="tab-section cast-section"> <!-- casting.css는 show.css에 -->
    <h3 class="tab-title">캐스팅</h3>
    <p class="tab-desc">출연 배우 정보를 확인해보세요.</p>

    <div class="cast-box">
        <div class="cast-list">
            <c:forEach var="actor" items="${fn:split(dto.castInfo, ',')}">
                <span class="cast-item">${fn:trim(actor)}</span>
            </c:forEach>
        </div>
    </div>
</div>