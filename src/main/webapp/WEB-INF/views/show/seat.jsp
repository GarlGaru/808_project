<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>좌석 선택</title>
    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
    <link rel="stylesheet" href="${path}/resources/show/css/seat.css">
    
</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>

   <div class="page-container">
    <div class="step-header">
        <div class="step-title">
            <span class="step-num">1&nbsp;. </span>&nbsp;좌석 선택
        </div>
    </div>
   
    <form id="reserveForm" action="${pageContext.request.contextPath}/show/reserve" method="post">
        <input type="hidden" name="showId" value="${showId}">
        <input type="hidden" name="scheduleId" value="${scheduleId}">
        <input type="hidden" name="show_title" value="${dto.title}">

        <div class="seat-wrapper">
            <div class="seat-box">
                <div class="stage">STAGE</div>
                <div class="seat-left">

                    <div class="seat-container">

                        <!-- 예약 좌석 문자열 생성 -->
                        <c:set var="reservedSeats" value=","/>
                        <c:forEach var="s" items="${seatList}">
                            <c:set var="reservedSeats" value="${reservedSeats}${s.seatLabel},"/>
                        </c:forEach>

                        <!-- 최대 열 수 계산 -->
                        <c:set var="maxCol" value="0"/>
                        <c:forEach var="seat" items="${layoutList}">
                            <c:if test="${seat.colNo > maxCol}">
                                <c:set var="maxCol" value="${seat.colNo}"/>
                            </c:if>
                        </c:forEach>

                        <!-- 좌석 그리기 -->
                        <c:forEach var="seat" items="${layoutList}">
                            <c:set var="checkSeat" value=",${seat.seatLabel},"/>
                            <c:set var="isOccupied" value="${fn:contains(reservedSeats, checkSeat)}"/>

                            <c:choose>
                                <c:when test="${seat.seatGrade eq 'VIP'}">
                                    <c:set var="price" value="150000"/>
                                </c:when>
                                <c:when test="${seat.seatGrade eq 'R'}">
                                    <c:set var="price" value="120000"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="price" value="90000"/>
                                </c:otherwise>
                            </c:choose>

                            <label class="seat ${seat.seatGrade} ${isOccupied ? 'reserved' : ''}">
                                <input type="checkbox"
                                       name="selectedSeats"
                                       value="${seat.seatLabel}"
                                       data-price="${price}"
                                       ${isOccupied ? 'disabled' : ''}>
                                <span>${seat.seatLabel}</span>
                            </label>

                            <!-- 행 끝나면 줄바꿈 -->
                            <c:if test="${seat.colNo eq maxCol}">
                                <div style="clear:both; width:100%;"></div>
                            </c:if>

                        </c:forEach>

                    </div>
                </div>
            </div>

            <div class="price-wrapper">
                <div class="seat-right">
                    <div class="price-box">
                        <h5>공연명</h5>
                        <p>${dto.title}</p>
                        <hr>
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
</div>
    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>

    <script>
   $(document).ready(function(){

    function autoResizePopup() {
        if (window.opener) {
           if(window.outerWidth >= 1200 && window.outerHeight >= 800) return;
            const contentWidth  = document.body.scrollWidth  + 60;
            const contentHeight = document.body.scrollHeight + 60;
            const maxWidth = window.screen.availWidth - 50;
            const maxHeight = window.screen.availHeight - 50;
            const finalWidth  = Math.min(Math.max(contentWidth,  1200), maxWidth);
            const finalHeight = Math.min(Math.max(contentHeight, 800), maxHeight);
            window.resizeTo(finalWidth, finalHeight);
            const left = (window.screen.width  - finalWidth)  / 2;
            const top  = (window.screen.height - finalHeight) / 2;
            window.moveTo(left, top);
        }
    }

    $(window).on("load", function() {
        setTimeout(autoResizePopup, 100);
    });
    setTimeout(autoResizePopup, 300);

    // ✅ 좌석 체크박스
    $("input[name='selectedSeats']").on("change", function() {
       
       const loginUserId = "${sessionScope.loginUser.userId}";
       if(!loginUserId){
          $(this).prop("checked",false);
          alert("로그인 후 이용해주세요.");
          return;
       }
       
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

    // ✅ 좌석 선택 완료 버튼
    $(document).on("click", "#btn-reserve", function() {
        const selectedSeats = [];
        $("input[name='selectedSeats']:checked").each(function() {
            selectedSeats.push($(this).val());
        });
        if (selectedSeats.length === 0) {
            alert("좌석을 하나 이상 선택해주세요.");
            return;
        }

        const showId = $("input[name='showId']").val();
        const scheduleId = $("input[name='scheduleId']").val();

        $.ajax({
            url: "${path}/show/reserveCheck",
            type: "POST",
            traditional: true,
            data: {
                showId: showId,
                scheduleId: scheduleId,
                selectedSeats: selectedSeats
            },
            success: function(res){
                if(res === "success"){
                    
                    $("#reserveForm").removeAttr("target");
                    $("#reserveForm").submit();
                    
                } else if(res === "login_required") {
                    alert("로그인 후 이용해주세요.");
                } else {
                    alert("이미 선택된 좌석입니다. 다시 선택해주세요.");
                    location.reload();
                }
            },
            error: function(){
                alert("좌석 확인 중 오류 발생");
            }
        });
    });

});
</script>
</body>
</html>