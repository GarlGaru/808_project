<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>마이티켓</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
    <link rel="stylesheet" href="${path}/resources/show/css/show.css">
    <link rel="stylesheet" href="${path}/resources/show/css/myTicket.css">
</head>
<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="show-wrap">
        <div class="show-top-menu-wrap">
            <nav class="show-top-menu">
                <a href="${path}/show/showList?category=concert&subCategory=all"
                   class="menu-item ${menu eq 'concert' ? 'active' : ''}">콘서트</a>

                <a href="${path}/show/showList?category=musical&subCategory=all"
                   class="menu-item ${menu eq 'musical' ? 'active' : ''}">뮤지컬</a>

                <a href="${path}/show/showList?category=play&subCategory=all"
                   class="menu-item ${menu eq 'play' ? 'active' : ''}">연극</a>

                <a href="${path}/show/ranking"
                   class="menu-item ${menu eq 'ranking' ? 'active' : ''}">랭킹</a>

                <a href="${path}/show/mypage/myTicket"
                   class="menu-item ${menu eq 'myticket' ? 'active' : ''}">마이티켓</a>
            </nav>
        </div>

        <div class="myticket-container">
        	<c:set var="approvedCnt" value="0" />
        	<c:set var="cancelCnt" value="0" />
        	<c:forEach var="t" items="${list}">
        		<c:if test="${t.status eq 'APPROVED'}">
        			<c:set var="approvedCnt" value="${approvedCnt + 1}" />
        		</c:if>
        		<c:if test="${t.status eq 'CANCEL'}">
        			<c:set var="cancelCnt" value="${cancelCnt + 1}" />
        		</c:if>
        	</c:forEach>
        	
            <div class="myticket-summary">
                <div class="summary-user">
                    <div class="summary-title">기본정보</div>
                    <div class="summary-nickname">${loginUser.nickname}</div>
                    <div class="summary-email">${loginUser.email}</div>
                </div>

                <div class="summary-count-wrap" style="display: flex; gap: 40px;">
                    <div class="summary-count-box">
                        <div class="count-number">${approvedCnt}</div>
                        <div class="count-label">예매내역</div>
                    </div>
                    <div class="summary-count-box">
                    	<div class="count-number" style="color: #999;">${cancelCnt}</div>
                    	<div class="count-label">취소내역</div>
                    </div>
                </div>
            </div>

            <div class="myticket-list-section">
                <div class="section-header">
                    <h2>최근 예매내역</h2>
                </div>

                <div class="ticket-header-row">
                    <div class="col-date">예매일</div>
                    <div class="col-show">공연정보</div>
                    <div class="col-booking">예매정보</div>
                    <div class="col-status">상태</div>
                </div>

                <c:choose>
                    <c:when test="${empty list}">
                        <div class="empty-ticket">
                            예매 내역이 없습니다.
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="t" items="${list}">
                            <div class="ticket-item">
                                <div class="col-date ticket-date">
                                    ${t.approvedAt}
                                </div>

                                <div class="col-show ticket-show">
                                    <div class="ticket-poster">
                                        <img src="${t.posterUrl}" alt="${t.title}">
                                    </div>

                                    <div class="ticket-show-info">
                                        <div class="ticket-title">
                                        	<a href="${path}/show/showDetail?showId=${t.showId}" class="title-link">${t.title}
                                        	</a>
                                        </div>
                                        <div class="ticket-period">
                                            ${t.startDate} ~ ${t.endDate}
                                        </div>
                                        <div class="ticket-venue">${t.venueName}</div>
                                    </div>
                                </div>

                                <div class="col-booking ticket-booking">
                                    <div><span class="label">예매번호</span> ${t.orderId}</div>
                                    <div><span class="label">관람일</span> ${t.playDate}</div>
                                    <div><span class="label">매수</span> ${t.quantity}매</div>
                                    
                                    <div>
                                    	<span class="label">취소가능</span> 
                                    	<c:choose>
                                    		<c:when test="${t.status eq 'CANCEL'}">불가</c:when>
                                    		<c:otherwise>${t.cancelAvailable}</c:otherwise>
                                    	</c:choose>
                                    </div>
                                </div>

                                <div class="col-status ticket-status">
                                    <div class="status-text">
                                        <c:choose>
                                            <c:when test="${t.status eq 'APPROVED'}">예매완료</c:when>
                                            <c:when test="${t.status eq 'CANCEL'}">
                                            	<span style="color: #999;">취소완료</span>
                                            </c:when>
                                            <c:otherwise>${t.status}</c:otherwise>
                                        </c:choose>
                                    </div>

                                    <c:if test="${t.cancelAvailable eq '가능' and t.status eq 'APPROVED'}">
                                        <button type="button" class="cancel-btn" data-order-id="${t.orderId}">예매 취소</button>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/show/js/myTicket.js"></script>
    
    <script>
    $(document).ready(function(){
    	
    	// 예매 취소 버튼 클릭
    	$('.cancel-btn').click(function() {
    		//클릭한 버튼의 data-order-id 값 불러오기
    		let orderId = $(this).data('order-id');
    	
    		//취소 확인 알람창
    		if (!confirm('정말 예매를 취소하시겠습니까?\n결제된 금액은 전액 환불됩니다.')) {
    			return;
    		}
    		
    		// 백엔드로 취소 요청 (ajax)
    		$.ajax({
    			url: '${path}/show/mypage/cancelTicket', 
    			type: 'POST',
    			data: {orderId: orderId},
    			dataType: 'json',
    			success: function(map){
    				if (map.status === 'success') {
    					alert(map.message);
    					location.reload();
    				} else {
    					alert("취소실패: " + map.message);
    				}
    			},
    			error: function(xhr, status, error) {
    				console.error('Ajax 통신 에러: ', error);
    				alert("서버와 통신 중 문제가 발생했습니다. 잠시 후 다시 시도해주세요.");
    			}
    		});
    	});
    });
    </script>
</body>
</html>