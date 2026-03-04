<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>예매 확인 및 결제</title>
    <style>
        body { 
            background-color: #121212; color: #fff; 
            font-family: 'Pretendard', sans-serif; margin: 0; padding: 20px; 
        }
        .wrapper { display: flex; gap: 20px; max-width: 900px; margin: auto; }
        
        /* 왼쪽 섹션 */
        .left-side { flex: 1.5; }
        .section-box { background: #1e1e1e; border: 1px solid #333; border-radius: 10px; padding: 20px; margin-bottom: 15px; }
        h3 { color: #ED6701; font-size: 18px; margin-top: 0; border-bottom: 1px solid #333; padding-bottom: 10px; }
        
        .seat-tag { display: inline-block; background: gold; color: #000; padding: 2px 8px; border-radius: 4px; font-weight: bold; margin-right: 5px; font-size: 12px; }
        .R-tag { background: #F54927; color: #fff; }
        .S-tag { background: #E427F5; color: #fff; }

        .guide-box { background: #2a2a2a; padding: 15px; border-radius: 8px; font-size: 13px; color: #bbb; line-height: 1.6; height: 120px; overflow-y: auto; }
        .agree-area { text-align: right; margin-top: 10px; font-size: 14px; }

        /* 오른쪽 섹션 */
        .right-side { flex: 1; }
        .summary-box { background: #1e1e1e; border: 1px solid #333; border-radius: 10px; padding: 20px; position: sticky; top: 20px; }
        .info-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 14px; }
        .total-row { border-top: 1px solid #444; margin-top: 15px; padding-top: 15px; font-weight: bold; font-size: 18px; color: #ED6701; }
        
        .cancel-notice { font-size: 11px; color: #888; margin-top: 15px; line-height: 1.4; }

        /* 버튼 */
        .footer-btns { display: flex; gap: 10px; margin-top: 20px; }
        .btn { flex: 1; padding: 12px; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; }
        .btn-prev { background: #444; color: white; }
        .btn-next { background: linear-gradient(135deg, #DF8845, #ED6701); color: white; }
    </style>
</head>
<body>

<c:set var="vipCnt" value="0"/>
<c:set var="rCnt" value="0"/>
<c:set var="sCnt" value="0"/>
<c:set var="totalTicketPrice" value="0"/>

<c:forEach var="seat" items="${paramValues.selectedSeats}">
    <c:choose>
        <c:when test="${fn:startsWith(seat, 'A') || fn:startsWith(seat, 'B') || fn:startsWith(seat, 'C')}">
            <c:set var="vipCnt" value="${vipCnt + 1}"/><c:set var="totalTicketPrice" value="${totalTicketPrice + 150000}"/>
        </c:when>
        <c:when test="${fn:startsWith(seat, 'D') || fn:startsWith(seat, 'E') || fn:startsWith(seat, 'F') || fn:startsWith(seat, 'G')}">
            <c:set var="rCnt" value="${rCnt + 1}"/><c:set var="totalTicketPrice" value="${totalTicketPrice + 120000}"/>
        </c:when>
        <c:otherwise>
            <c:set var="sCnt" value="${sCnt + 1}"/><c:set var="totalTicketPrice" value="${totalTicketPrice + 90000}"/>
        </c:otherwise>
    </c:choose>
</c:forEach>

<div class="wrapper">
    <div class="left-side">
        <div class="section-box">
            <h3>가격 선택 / 좌석 확인</h3>
            <p style="font-size: 15px;">
                <c:if test="${vipCnt > 0}">VIP석 ${vipCnt}매 </c:if>
                <c:if test="${rCnt > 0}">R석 ${rCnt}매 </c:if>
                <c:if test="${sCnt > 0}">S석 ${sCnt}매 </c:if>
                선택
            </p>
            <div style="margin: 10px 0;">
                <c:forEach var="seat" items="${paramValues.selectedSeats}">
                    <span class="seat-tag ${fn:substring(seat,0,1) >= 'D' ? (fn:substring(seat,0,1) >= 'H' ? 'S-tag' : 'R-tag') : ''}">${seat}</span>
                </c:forEach>
            </div>
            <p style="color: #aaa; font-size: 14px;">기본가 : <fmt:formatNumber value="${totalTicketPrice}" type="number"/>원</p>
        </div>

        <div class="section-box">
            <h3>예매 및 환불 안내</h3>
            <div class="guide-box">
                [예매 안내]<br>
                - 본 공연은 1인당 최대 4매까지 예매 가능합니다.<br>
                - 예매 완료 후 회차 변경은 불가하며, 재예매를 이용해야 합니다.<br><br>
                [환불 안내]<br>
                - 관람일 전일 17시까지 취소 가능하며 이후에는 취소가 불가합니다.<br>
                - 취소 시점에 따라 취소 수수료가 차등 부과됩니다.
            </div>
            <div class="agree-area">
                <input type="checkbox" id="chk-agree"> <label for="chk-agree">위 내용을 확인했습니다.</label>
            </div>
        </div>

        <div class="footer-btns">
            <button class="btn btn-prev" onclick="window.close()">이전</button>
            <button class="btn btn-next" onclick="alert('결제 페이지로 이동!')">다음단계</button>
        </div>
    </div>

    <div class="right-side">
        <div class="summary-box">
            <h3>공연 정보</h3>
            <p><strong>${param.show_title != null ? param.show_title : '선택하신 공연'}</strong></p>
            <p style="font-size: 13px; color: #aaa;">날짜: 2026-03-20 (금)</p>
            <p style="font-size: 13px; color: #aaa;">시간: 19:30</p>
            
            <h3 style="margin-top: 30px;">결제 금액</h3>
            <div class="info-row"><span>티켓금액</span><span><fmt:formatNumber value="${totalTicketPrice}" type="number"/>원</span></div>
            <div class="info-row"><span>기본가</span><span><fmt:formatNumber value="${totalTicketPrice}" type="number"/>원</span></div>
            <div class="info-row"><span>예매수수료</span><span>0원</span></div>
            
            <div class="info-row total-row">
                <span>총 결제금액</span>
                <span><fmt:formatNumber value="${totalTicketPrice}" type="number"/>원</span>
            </div>

            <div class="cancel-notice">
                ※ 취소기한: 관람 전일 17:00까지<br>
                ※ 취소수수료: 티켓금액의 0~30% 발생
            </div>
        </div>
    </div>
</div>

</body>
</html>