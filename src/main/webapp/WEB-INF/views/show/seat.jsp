<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Bootstrap 4 Spotify-style buttons sample">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>좌석 선택</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
    <link rel="stylesheet" href="${path}/resources/show/css/seat.css">
   
    
</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    
    <br><br><br><br>

    

<div class="step-header">
		<div class="step-title">
			<span class="step-num">1&nbsp;. </span>&nbsp;좌석 선택
			
		</div>
	</div>

<form id="reserveForm" action="${pageContext.request.contextPath}/show/reserve" method="post">
    <input type="hidden" name="showId" value="${param.showId}">
    <input type="hidden" name="scheduleId" value="${param.scheduleId}">
    <input type="hidden" name="show_title" value="뮤지컬 <한복입은 남자>">

        <div class="seat-wrapper">
        	<div class="seat-box">
        		<div class="stage">STAGE</div>
            <div class="seat-left">
            
            <div class="seat-container">

				<!-- 예약 좌석 문자열 생성 (충돌 방지 구조) -->
				<c:set var="reservedSeats" value=","/>
				<c:forEach var="s" items="${seatList}">
				<c:set var="reservedSeats" value="${reservedSeats}${s.seatLabel},"/>
				</c:forEach>
				
				
				<c:forEach var="row" begin="1" end="10">
				<c:forEach var="col" begin="1" end="10">
				
				<c:set var="rowChar" value="${fn:substring('ABCDEFGHIJ', row-1, row)}"/>
				<c:set var="seatId" value="${rowChar}-${col}"/>
                           <c:set var="checkSeat" value=",${seatId},"/>
							<c:set var="isOccupied" value="${fn:contains(reservedSeats, checkSeat)}"/>
                            <!-- 등급 및 가격 -->
                            <c:choose>

							<c:when test="${row <= 3}">
							<c:set var="gradeClass" value="VIP"/>
							<c:set var="price" value="150000"/>
							</c:when>
							
							<c:when test="${row <= 7}">
							<c:set var="gradeClass" value="R"/>
							<c:set var="price" value="120000"/>
							</c:when>
							
							<c:otherwise>
							<c:set var="gradeClass" value="S"/>
							<c:set var="price" value="90000"/>
							</c:otherwise>
							
							</c:choose>

							<!-- 예약 여부 체크만 따로하기 //중요함// -->
                 			<%-- <c:forEach var="booked" items="${seatList}">
                 			 	<c:if test="${booked.seatLabel eq seatId}">
                 			 		<c:set var="isOccupied" value="true" />
                 			 	</c:if>
                 			 	</c:forEach> --%>
                 			 
                 			 <!-- 체크가 끝난 후 한 번만 좌석 그리기(루프 밖으로 나옴) -->
                            <label class="seat ${gradeClass} ${isOccupied ? 'reserved' : ''}">

							<input type="checkbox"
							name="selectedSeats"
							value="${seatId}"
							data-price="${price}"
							${isOccupied ? 'disabled' : ''}>
							
							<span>${seatId}</span>
							
							</label>
                        </c:forEach>
		                    </c:forEach>
		                </div>
		                </div>
		               </div>
                <div class="price-wrapper">
           		 <div class="seat-right">
                <div class="price-box">
                
                    <h5>좌석 등급별 가격</h5>
                    <p><span class="grade vip"></span> VIP : 150,000원</p>
                    <p><span class="grade r"></span> R : 120,000원</p>
                    <p><span class="grade s"></span> S : 90,000원</p>
                    <hr>
                    
                    <h5>선택한 정보</h5>
                    <p class="selected-info-text">좌석 : <span id="display-seats">없음</span></p>
                    <p class="selected-info-text">총 금액 : <span id="display-price">0</span>원</p>
                </div>

                <div style="margin-top:30px;">
                
                    <button type="button" class="reserve-btn" id="btn-reserve">
                        좌석 선택 완료 &nbsp;&nbsp; >
                    </button>
                </div>
            </div>
        </div>
        </div>
    </form>

		<%@ include file="/WEB-INF/views/common/footer.jsp" %>
  

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>

    <script>
    $(document).ready(function() {

        /* // 실시간 좌석 상태 업데이트
        function updateSeatStatus() {
        	
       	   const showId = $("input[name='showId']").val();
           const scheduleId = $("input[name='scheduleId']").val();

        $.ajax({
            url: "${path}/show/seatStatus",
            type: "GET",
            data: {
                showId: showId,
                scheduleId: scheduleId
            },
            success: function(res){
                console.log(res);
            },
            error: function(){
                console.log("실시간 업데이트 실패");
            }
        });
    }
 */
        //updateSeatStatus();
        
        //setInterval(updateSeatStatus, 5000);

        // 좌석 선택 이벤트
        $("input[name='selectedSeats']").on("change", function() {
            const selectedCount = $("input[name='selectedSeats']:checked").length;

            if (selectedCount > 4) {
                $(this).prop("checked", false);
                alert("좌석은 최대 4매까지 선택 가능합니다.");
                return;
            }

            let selectedSeats = [];
            let totalPrice = 0;

            $("input[name='selectedSeats']:checked").each(function() {
                selectedSeats.push($(this).val());
                totalPrice += parseInt($(this).data("price"));
            });

            $("#display-seats").text(selectedSeats.length ? selectedSeats.join(", ") : "없음");
            $("#display-price").text(selectedSeats.length ? totalPrice.toLocaleString() : "0");
        });

    });

        // 예매 버튼 이벤트
       $(document).on("click", "#btn-reserve", function() {
    const selectedSeats = [];
    $("input[name='selectedSeats']:checked").each(function() {
        selectedSeats.push($(this).val());
    });
    
    // 1. 좌석 선택 안 했으면 막기 (이건 최소한의 예의!)
    if (selectedSeats.length === 0) {
        alert("좌석을 하나 이상 선택해 주세요.");
        return;
    }
    
    // 2. 그냥 바로 넘어가기 (서버에 물어보지 않음)
    if (confirm(selectedSeats.length + "개의 좌석을 예약하시겠습니까?")) {
        console.log("발표 모드: 서버 체크 생략하고 바로 결과 페이지로 이동!");

        const popupName = "seatPopup";
        const popupWidth = 900;
        const popupHeight = 700;
        const left = (window.screen.width - popupWidth) / 2;
        const top = (window.screen.height - popupHeight) / 2;
        const specs = 'width=' + popupWidth + ',height=' + popupHeight + ',left=' + left + ',top=' + top;
        
        // 팝업창 먼저 열기
        window.open("", popupName, specs);
        
        // 폼 타겟을 팝업으로 설정하고 바로 전송!
        const $form = $("#reserveForm");
        $form.attr("target", popupName);
        $form.submit();
    }
});
    </script>
</body>
</html>
