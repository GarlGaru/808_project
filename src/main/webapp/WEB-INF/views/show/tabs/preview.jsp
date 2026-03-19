<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="${path}/resources/show/css/seatPreview.css">

<div class="tab-section">
    <h3 class="preview-title">좌석 프리뷰</h3>
    <p class="preview-subtitle">일부 좌석에 한하여 프리뷰가 제공됩니다.</p>

    <%-- 구역명 배열 - 원하는 이름으로 바꾸면 됨 --%>
    <c:set var="labels" value="1층 A구역,1층 B구역,1층 C역,1층 D구역,2층 A구역,2층 B구역,2층 C구역,2층 D구역"/>

    <div class="preview-grid">
        <c:forTokens items="${labels}" delims="," var="label" varStatus="st">
            <div class="preview-item">
                <div class="preview-img-wrap">
                    <img src="${path}/resources/show/images/${showId}/seat${st.index + 1}.png"
    				 alt="${label}"
     					onerror="this.onerror=null; this.src='${path}/resources/show/images/default/seat${st.index + 1}.png'">
                </div>
                <p>${label}</p>
            </div>
        </c:forTokens>
    </div>
</div>