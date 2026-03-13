<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>좌석 예약하기</title>
<style>
    /* 좌석 스타일링 */
    .seat-container {
        display: grid;
        grid-template-columns: repeat(10, 40px); /* 10열로 정렬 */
        gap: 10px;
        justify-content: center;
        margin-top: 20px;
    }
    .seat {
        width: 40px;
        height: 40px;
        background-color: #ddd;
        border: 1px solid #bbb;
        text-align: center;
        line-height: 40px;
        cursor: pointer;
        border-radius: 5px;
    }
    /* 체크박스는 숨기고, 라벨(좌석)을 클릭하게 만듦 */
    .seat input {
        display: none;
    }
    /* 선택된 좌석 색깔 변하게 하기 */
    .seat input:checked + span {
        background-color: #4CAF50;
        color: white;
        display: block;
        width: 100%;
        height: 100%;
        border-radius: 5px;
    }
</style>
</head>
<body>

<h2 style="text-align: center;">원하는 좌석을 골라봐!</h2>

<form action="reserve_process.jsp" method="post">
    <div class="seat-container">
        <% 
            // 10행 10열 좌석 만들기
            for(int row = 1; row <= 10; row++) {
                for(int col = 1; col <= 10; col++) {
                    String seatId = (char)('A' + row - 1) + "-" + col; // 예: A-1, B-2
        %>
            <label class="seat">
                <input type="checkbox" name="selectedSeats" value="<%= seatId %>">
                <span><%= seatId %></span>
            </label>
        <% 
                }
            }
        %>
    </div>
    <div style="text-align: center; margin-top: 30px;">
        <button type="submit" style="padding: 10px 20px; font-size: 16px;">예약하기</button>
    </div>
</form>

</body>
</html>