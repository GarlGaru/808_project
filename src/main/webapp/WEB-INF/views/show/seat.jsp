<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    
    <style>
    
    
.seat-container {
    display: grid;
    grid-template-columns: repeat(10, 38px); 
    gap: 6px; 
    justify-content: center;
    margin-top: 30px;
}

.seat {
    position: relative;
}

.seat input {
    display: none;
}

.seat span {
    display: block;
    width: 38px;   
    height: 38px;  
    text-align: center;
    line-height: 38px; 
    border-radius: 6px;
    font-size: 11px;
    cursor: pointer;
    border: 1px solid #aaa;
    background-color: #ffffff;
    color: #000;
}

/* 등급별 색상 */
.VIP span { background-color: gold; }
.R span { background-color: #F54927; }
.S span { background-color: #E427F5; }

/* 선택 좌석 */
.seat input:checked + span {
    background: linear-gradient(135deg, #DF8845, #ED6701);
    color: white;
    box-shadow: 0 4px 8px rgba(0,0,0,0.3);
    transform: scale(1.05);
}

/* 예약된 좌석 */
.reserved span {
    background-color: #444 !important;
    cursor: not-allowed;
    color: #999;
}

.seat-wrapper {
    display: flex;
    justify-content: center;
    gap: 80px;
    margin-top: 40px;
}

/* 왼쪽 좌석 */
.seat-left {
}

/* 오른쪽 영역 */
.seat-right {
    width: 250px;
}

/* 가격 박스 */
.price-box {
    background: #ffffff;
    padding: 20px;
    border-radius: 10px;
    color: #000;
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
}

/* 등급 컬러 표시 */
.grade {
    display: inline-block;
    width: 15px;
    height: 15px;
    border-radius: 3px;
    margin-right: 8px;
}

.grade.vip { background: gold; }
.grade.r { background: #F54927; }
.grade.s { background: #E427F5; }

/* 예약 버튼 (주황 그라데이션) */
.reserve-btn {
    width: 100%;
    background: linear-gradient(135deg, #DF8845, #ED6701);
    border: none;
    color: white;
    padding: 12px;
    border-radius: 25px;
    font-weight: bold;
    transition: all 0.3s ease;
}

.reserve-btn:hover {
    transform: scale(1.05);
    box-shadow: 0 6px 12px rgba(0,0,0,0.3);
}

</style>
    
</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    <br><br><br><br>

    

<h5 style="text-align: center;">원하시는 좌석을 선택해주세요.</h5>

<form id="reserveForm" action="${pageContext.request.contextPath}/show/seat" method="post">
    <input type="hidden" name="show_id" value="${param.showId}">
    <input type="hidden" name="schedule_id" value="${param.scheduleId}">

        <div class="seat-wrapper">
            <div class="seat-left">
                <div class="seat-container">
                    <c:forEach var="row" begin="1" end="10">
                        <c:forEach var="col" begin="1" end="10">
                            <c:set var="rowChar" value="${fn:substring('ABCDEFGHIJ', row-1, row)}"/>
                            <c:set var="seatId" value="${rowChar}-${col}" />
                            
                            <c:choose>
                                <c:when test="${row <= 3}"><c:set var="gradeClass" value="VIP"/><c:set var="price" value="150000"/></c:when>
                                <c:when test="${row <= 7}"><c:set var="gradeClass" value="R"/><c:set var="price" value="120000"/></c:when>
                                <c:otherwise><c:set var="gradeClass" value="S"/><c:set var="price" value="90000"/></c:otherwise>
                            </c:choose>

                 
                            <label class="seat ${gradeClass}">
                                <input type="checkbox" name="selectedSeats" value="${seatId}" data-price="${price}">
                                <span>${seatId}</span>
                            </label>
                        </c:forEach>
                    </c:forEach>
                </div>
            </div>

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
                        예매하기
                    </button>
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
    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script>
    $(document).ready(function() {
 
    	// 1. 좌석 선택 시 (개수 제한 + 가격 계산)
        $("input[name='selectedSeats']").on("change", function() {
            var selectedCount = $("input[name='selectedSeats']:checked").length;

            // [추가] 4개 제한 로직
            if (selectedCount > 4) {
                $(this).prop("checked", false); // 방금 누른 거 취소
                alert("좌석은 1인당 최대 4매까지 선택 가능합니다.");
                return; 
            }

            // [기존] 좌석 정보 및 가격 업데이트 로직
            var selectedSeats = [];
            var totalPrice = 0;

            $("input[name='selectedSeats']:checked").each(function() {
                selectedSeats.push($(this).val()); 
                totalPrice += parseInt($(this).data("price")); 
            });

            if(selectedSeats.length > 0) {
                $("#display-seats").text(selectedSeats.join(", "));
                $("#display-price").text(totalPrice.toLocaleString()); 
            } else {
                $("#display-seats").text("없음");
                $("#display-price").text("0");
            }
        });
       
        
        $("#btn-reserve").on("click", function() {
            const count = $("input[name='selectedSeats']:checked").length;
            
            
            if (count === 0) {
                alert("좌석을 하나 이상 선택해주세요.");
                return;
            }
            
         
            console.log("===== SQL =====");
            console.log(`
        <select id="selectSeatList" parameterType="map" resultType="com.spring.eze.show.dto.Seat.SeatDTO">
            SELECT
                seat_id, show_id, schedule_id, user_id, res_seat_label,
                seat_label, seat_grade, seat_status, hold_at
            FROM seat_tbl
            WHERE show_id = \#{showId, jdbcType=VARCHAR}
              AND schedule_id = \#{scheduleId, jdbcType=INTEGER}
            ORDER BY seat_label
        </select>`);

            
            if (confirm(count + "개의 좌석을 예약하시겠습니까?")) {
                
                const popupName = "seatPopup"; 
                
                
                window.open("", popupName, "width=600, height=800, resizable=yes, scrollbars=yes");
                
               
                const $form = $("#reserveForm");
                $form.attr("target", popupName); 
                
                
                $form.submit();
            }
        });
    });
    </script>
</body>
</html>
