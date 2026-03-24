<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 레이아웃 확인을 위한 하드코딩 jsp -->

<div class="ranking-container">
	<div class="ranking-header">
		<h2 class="ranking-title">
			<c:choose>
			<c:when test="${currentCategory == 'concer'}">콘서트 실시간 랭킹</c:when>		
			<c:when test="${currentCategory == 'musical'}">뮤지컬 실시간 랭킹</c:when>
			<c:when test="${currentCategory == 'play'}">연극 실시간 랭킹</c:when>
			<c:otherwise>실시간 랭킹</c:otherwise>
			</c:choose>
			- <span>2026.03.23(월) 현재</span>
		</h2>	
		
		<div class="tooltip-wrap">
			<button class="btn-ranking-info" id="btnRankInfo">랭킹 기준 ⓘ</button>
			
			<div class="ranking-tooltip" id="rankTooltip">
				<div class="tooltip-header">
					<h4>집계 기간/기준</h4>
					<button class="btn-close-tooltip" id="btnCloseTooltip">✕</button>
				</div>
				<div class="tooltip-body">
					<p class="date">2026.03.23(월) 00:00 ~ 16:00 </p>
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
		<li class="ranking-item">
			<div class="rank-num text-orange">1</div>
			<div class="rank-poster">
			<img src="https://via.placeholder.com/120x160/222/ED6701?text=Poster" alt="포스터 임시">
            </div>
            <div class="rank-info">
                <span class="badge">단독판매</span>
                <h3 class="show-title">사운드 플래닛 페스티벌 2026</h3>
                <p class="show-date">2026.05.15 ~ 2026.05.16</p>
                <p class="show-venue">올림픽공원 88잔디마당</p>
            </div>
            <div class="rank-action">
                <button class="btn-reserve-sm">예매하기</button>
            </div>
        </li>
        
        <li class="ranking-item">
            <div class="rank-num">2</div>
            <div class="rank-poster">
                <img src="https://via.placeholder.com/120x160/222/aaa?text=Poster" alt="포스터 임시">
            </div>
            <div class="rank-info">
                <h3 class="show-title">혼네 10주년 기념 내한공연</h3>
                <p class="show-date">2026.07.15 ~ 2026.07.18</p>
                <p class="show-venue">KBS 아레나</p>
            </div>
            <div class="rank-action">
                <button class="btn-reserve-sm">예매하기</button>
            </div>
        </li>
    </ul>
</div>

<%-- <h2>랭킹입니다</h2>
<p>현재 탭 : ${currentCategory}</p> --%>