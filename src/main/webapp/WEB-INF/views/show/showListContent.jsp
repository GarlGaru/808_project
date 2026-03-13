<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:choose>
    <c:when test="${not empty list}">
        <c:forEach var="s" items="${list}">
            <div class="col-lg-3 col-md-4 col-sm-6 col-12 mb-4 d-flex justify-content-center">
                <div class="card show-card">
                    <a href="${pageContext.request.contextPath}/show/showDetail?showId=${s.showId}">
                        <img src="${s.posterUrl}"
                             class="card-img-top show-poster"
                             alt="${s.title}"
                             loading="lazy"
                             onerror="this.src='${pageContext.request.contextPath}/resources/show/images/no-images.png'">
                    </a>

                    <div class="card-body px-2 py-2">
                        <h5 class="card-title show-title" title="${s.title}">
                            ${s.title}
                        </h5>

                        <p class="card-text show-meta">
                            <span class="d-block text-truncate">${s.venueName}</span>
                            <span class="d-block">
                                <fmt:formatDate value="${s.startDate}" pattern="yyyy.MM.dd"/>
                            </span>
                        </p>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:when>

    <c:otherwise>
        <div class="col-12 text-center py-5">
            <p class="show-empty-message">해당 카테고리의 공연 정보가 없습니다.</p>
        </div>
    </c:otherwise>
</c:choose>