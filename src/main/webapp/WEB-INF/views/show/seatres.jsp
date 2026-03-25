<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">

<link rel="stylesheet" href="${path}/resources/common/css/style.css">
<link rel="stylesheet" href="${path}/resources/common/style.css">
<link rel="stylesheet" href="${path}/resources/show/css/seatres.css">

<title>예매 확인 및 결제</title>

</head>


<body>

	<c:set var="vipCnt" value="0" />
	<c:set var="rCnt" value="0" />
	<c:set var="sCnt" value="0" />
	<c:set var="totalTicketPrice" value="0" />

	<c:forEach var="seat" items="${paramValues.selectedSeats}">
		<c:choose>
			<c:when
				test="${fn:startsWith(seat, 'A') || fn:startsWith(seat, 'B') || fn:startsWith(seat, 'C')}">
				<c:set var="vipCnt" value="${vipCnt + 1}" />
				<c:set var="totalTicketPrice" value="${totalTicketPrice + 150000}" />
			</c:when>
			<c:when
				test="${fn:startsWith(seat, 'D') || fn:startsWith(seat, 'E') || fn:startsWith(seat, 'F') || fn:startsWith(seat, 'G')}">
				<c:set var="rCnt" value="${rCnt + 1}" />
				<c:set var="totalTicketPrice" value="${totalTicketPrice + 120000}" />
			</c:when>
			<c:otherwise>
				<c:set var="sCnt" value="${sCnt + 1}" />
				<c:set var="totalTicketPrice" value="${totalTicketPrice + 90000}" />
			</c:otherwise>
		</c:choose>
	</c:forEach>
	
	<!--위에 헤더 -->
	<div class="step-header" style="display: flex; justify-content: space-between; align-items: center;">
    <div class="step-title">
        <span class="step-num">2&nbsp;. </span>&nbsp;예매 확인
        <span class="show-name-badge">${not empty showTitle ? showTitle : param.show_title}</span>
    </div> <div class="timer-box" style="color: #ED6701; font-weight: bold; font-size: 18px;">
        결제진행시간 <span id="timer">05:00</span>
    </div>
	</div>
	
	<script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
		
		<script>
		$(document).ready(function(){
		    let timeLeft = 300;
		    const $timerDisplay = $('#timer');
		    let isMovingToPayment = false; // 결제 이동 시 beforeunload 방지 플래그
		    
		    // ✅ 좌석 해제 공통 함수 (sendBeacon용 FormData 생성)
		    function buildReleaseFormData() {
		        const data = new FormData();
		        data.append("showId", "${param.showId}");
		        data.append("scheduleId", "${param.scheduleId}");
		        <c:forEach var="s" items="${paramValues.selectedSeats}">
		        data.append("seatLabels[]", "${s}");
		        </c:forEach>
		        return data;
		    }
		    
		    function releaseSeatsAjax(callback) {
		        $.ajax({
		            url: "${path}/show/release",
		            type: "POST",
		            traditional: true,
		            async: false,
		            data: {
		                showId: "${param.showId}",
		                scheduleId: "${param.scheduleId}",
		                "seatLabels[]": [
		                    <c:forEach var="s" items="${paramValues.selectedSeats}" varStatus="status">
		                        "${s}"${!status.last ? ',' : ''}
		                    </c:forEach>
		                ]
		            },
		            complete: function() {
		                if(callback) callback();
		            }
		        });
		    }
		    
		    window.addEventListener("beforeunload", function() {
		        if(isMovingToPayment) return; // 결제 페이지 이동 시엔 해제 안 함
		        navigator.sendBeacon("${path}/show/release", buildReleaseFormData());
		    });
		    
		    const timerInterval = setInterval(function(){
		        let minutes = Math.floor(timeLeft / 60);
		        let seconds = timeLeft % 60;
		        
		        minutes = minutes < 10 ? '0' + minutes : minutes;
		        seconds = seconds < 10 ? '0' + seconds : seconds;
		        $timerDisplay.text(minutes + ":" + seconds);
		        
		        if(timeLeft <= 0) {
		            clearInterval(timerInterval);
		            releaseSeatsAjax(function() {
		                alert("결제시간 초과로 이전 페이지로 돌아갑니다.");
		                location.href = "${path}/show/seat?showId=${param.showId}&scheduleId=${param.scheduleId}";
		            });
		            return;
		        }
		        timeLeft--;
		    }, 1000);
		    
		    $('.btn-next').on('click', function(){
		        if(!$('#chk-agree').is(':checked')) {
		            alert("예매 및 환불 안내 확인 후 체크해주세요.");
		            return;
		        }
		        isMovingToPayment = true; 
		        location.href = "${path}/show/payment";
		    });
		    
		    $('.btn-prev').on('click', function(){
		        releaseSeatsAjax(function() {
		        	
		        	const currentWidth = window.outerWidth;
		        	const currentHeight = window.outerHeight;
		        	const currentLeft = window.screenX;
		        	const currentTop = window.screenY;
		        	
		            location.href = "${path}/show/seat?showId=${param.showId}&scheduleId=${param.scheduleId}";
		            
		            setTimeout(function(){
		            	window.resizeTo(currentWidth, currentHeight);
		            	window.moveTo(currentLeft, currentTop);
		            }, 300);
		        });
		    });
		});
		
		$(document).ready(function() {
		    function resizeToContent() {
		        if (window.opener) {
		          
		            const contentHeight = document.body.scrollHeight + 100; 
		            const currentWidth = window.outerWidth; 
		            
		            const maxHeight = window.screen.availHeight * 0.7;
		            const finalHeight = Math.min(contentHeight, maxHeight);
		            
		            window.resizeTo(currentWidth, finalHeight);
		        }
		    }
		    setTimeout(resizeToContent, 200);
		});
		</script>
	
	<div class="wrapper">
		<div class="left-side">
			<div class="section-box">
				<h3>티켓가격</h3>
				<p style="font-size: 15px;">
					<c:if test="${vipCnt > 0}">VIP석 ${vipCnt}매 </c:if>
					<c:if test="${rCnt > 0}">R석 ${rCnt}매 </c:if>
					<c:if test="${sCnt > 0}">S석 ${sCnt}매 </c:if>
					선택
				</p>
				<div style="margin: 10px 0;">
					<c:forEach var="seat" items="${paramValues.selectedSeats}">
						<span
							class="seat-tag ${fn:substring(seat,0,1) >= 'D' ? (fn:substring(seat,0,1) >= 'H' ? 'S-tag' : 'R-tag') : ''}">${seat}</span>
					</c:forEach>
				</div>
				<p style="color: #aaa; font-size: 14px;">
					기본가 :
					<fmt:formatNumber value="${totalTicketPrice}" type="number" />
					원
				</p>
			</div>

			<div class="section-box">
				<h3>예매 및 환불 안내</h3>
				<div class="guide-box">
					[예매 안내]<br> - 본 공연은 1인당 최대 4매까지 예매 가능합니다.<br> - 예매 완료 후
					회차 변경은 불가하며, 재예매를 이용해야 합니다.<br>
					<br> [환불 안내]<br> - 관람일 전일 13시까지 취소 가능하며 이후에는 취소가 불가합니다.<br>
					- 취소 시점에 따라 취소 수수료가 차등 부과됩니다.
				</div>
				<div class="agree-area">
					<input type="checkbox" id="chk-agree"> <label
						for="chk-agree">위 내용을 확인했습니다.</label>
				</div>
			</div>

			<div class="footer-btns">
				<button class="btn btn-prev" >이전</button> 	<!-- onclick="window.close()" -->
				<button class="btn btn-next" >다음단계</button>
			</div>
		</div>

		<div class="right-side">
			<div class="summary-box">
				<h3>공연 정보</h3>
				<p>
					<strong>${param.show_title != null ? param.show_title : '선택하신 공연'}</strong>
				</p>
				<p style="font-size: 13px; color: #aaa;">
    				날짜: ${scheduleInfo.PLAY_DATE} (${scheduleInfo.PLAY_DAY})
				</p>
				<p style="font-size: 13px; color: #aaa;">시간: ${scheduleInfo.START_TIME}</p>

				<h3 style="margin-top: 30px;">결제 금액</h3>
				<div class="info-row">
					<span>티켓금액</span><span><fmt:formatNumber
							value="${totalTicketPrice}" type="number" />원</span>
				</div>
				<div class="info-row">
					<span>기본가</span><span><fmt:formatNumber
							value="${totalTicketPrice}" type="number" />원</span>
				</div>
				<div class="info-row">
					<span>예매수수료</span><span>0원</span>
				</div>

				<div class="info-row total-row">
					<span>총 결제금액</span> <span><fmt:formatNumber
							value="${totalTicketPrice}" type="number" />원</span>
				</div>

				<div class="cancel-notice">
					※ 취소기한: 관람 전일 17:00까지<br> ※ 취소수수료: 티켓금액의 0~30% 발생
				</div>
			</div>
		</div>
	</div>

</body>
</html>