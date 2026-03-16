<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="tab-section">
    <h3>공연장 정보</h3>
    <p>${dto.venueName}</p>

    <input type="hidden" id="venueKeyword" value="${dto.venueName} ${dto.area}">
    <div id="kakaoMap" style="width:100%; height:400px; margin-top:20px; border-radius:12px; overflow:hidden;"></div>
</div>