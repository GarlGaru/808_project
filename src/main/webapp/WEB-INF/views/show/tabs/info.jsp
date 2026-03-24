<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="tab-section">
    <h3>상세정보</h3>
    
    <div class="detail-info-box">
	    <p>러닝타임 : ${dto.runtime}</p>
	    <p>관람연령 : ${dto.ageLimit}</p>
	    <p>티켓가격 : ${dto.ticketPrice}</p>
	</div>	
	<br><br>
	
    <h3>예매 안내</h3>

    <div class="show-notice-wrap">
        <img src="${pageContext.request.contextPath}/resources/show/images/show_notice.png" 
             alt="예매 전 확인 안내"
             class="show-notice-img">
    </div>
</div>