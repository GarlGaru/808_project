<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="now" class="java.util.Date" />

<div class="ranking-container">
	<div class="ranking-header">
		<h2 class="ranking-title">
			<c:choose>
				<c:when test="${currentCategory == 'concert'}">콘서트 실시간 랭킹</c:when>		
				<c:when test="${currentCategory == 'musical'}">뮤지컬 실시간 랭킹</c:when>
				<c:when test="${currentCategory == 'play'}">연극 실시간 랭킹</c:when>
				<c:otherwise>실시간 랭킹</c:otherwise>
			</c:choose>
			- <span><fmt:formatDate value="${now}" pattern="yyyy.MM.dd(E)"/> 현재</span>
		</h2>	
		
		<div class="tooltip-wrap">
			<button class="btn-ranking-info" id="btnRankInfo">랭킹 기준 ⓘ</button>
			
			<div class="ranking-tooltip" id="rankTooltip">
				<div class="tooltip-header">
					<h4>집계 기간/기준</h4>
					<button class="btn-close-tooltip" id="btnCloseTooltip">✕</button>
				</div>
				<div class="tooltip-body">
					<p class="date"><fmt:formatDate value="${now}" pattern="yyyy.MM.dd(E)"/> 00:00 ~ <fmt:formatDate value="${now}" pattern="HH:mm"/> </p>
					<ul>
						<li> 집계 대상은 온라인 예매이며 입금 완료된 예매건만 반영됩니다.</li>
						<li> 현재까지의 실시간, 일간, 주간 랭킹 데이터는 1시간 단위로 업데이트 됩니다 </li>
						<li> 랭킹은 예매율(판매매수) 기준으로 집계되어 반영됩니다.</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	
	<ul class="ranking-list">
		<c:forEach var="rank" items="${rankingList}" varStatus="status">
			<li class="ranking-item">
				
				<div class="rank-num ${status.count == 1 ? 'text-orange' : ''}">
					${status.count}
				</div>
				
				<div class="rank-poster">
					<img src="${rank.posterUrl}" alt="${rank.title} 포스터">
				</div>
				
				<div class="rank-info">
					<span class="badge">단독판매</span>
					
					<h3 class="show-title">${rank.title}</h3>
					
					<p class="show-date">
						<fmt:formatDate value="${rank.startDate}" pattern="yyyy.MM.dd"/> ~ 
						<fmt:formatDate value="${rank.endDate}" pattern="yyyy.MM.dd"/>
					</p>
					
					<p class="show-venue">
						${rank.venueName} 
					</p>
				</div>
				
				<div class="rank-action">
					<button type="button" class="btn-reserve-sm" onclick="location.href='${pageContext.request.contextPath}/show/showDetail?showId=${rank.showId}'">예매하기</button>
				</div>
			</li>
		</c:forEach>
		</ul>
</div>