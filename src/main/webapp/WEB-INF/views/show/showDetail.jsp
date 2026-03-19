<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/views/common/common.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<head>
    <meta charset="UTF-8">
    <title>808 SHOW</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/dark.css">
	<link rel="stylesheet" href="${path}/resources/show/css/showDetail.css">
	
</head>
<body class="dark-mode">
	<input type="hidden" id="showId" value="${dto.showId}">
	<input type="hidden" id="contextPath" value="${pageContext.request.contextPath}">
    <!-- 상단 공연 상세 페이지 -->
    <div class="show-detail-wrapper">

    <!-- 상단 공연 기본정보 -->
    <section class="detail-top">
        <div class="poster-area">
            <img src="${dto.posterUrl}" alt="${dto.title} 포스터">
        </div>

        <div class="info-area">
            <h2 class="show-title">${dto.title}</h2>

            <ul class="info-list">
                <li><strong>장소</strong> <span>${dto.venueName}</span></li>
                <li><strong>공연기간</strong>
                    <span>
                        <c:choose>
                            <c:when test="${oneDay}">
                                ${dto.startDate}
                            </c:when>
                            <c:otherwise>
                                ${dto.startDate} ~ ${dto.endDate}
                            </c:otherwise>
                        </c:choose>
                    </span>
                </li>
                <li><strong>티켓가격</strong> <span>${dto.ticketPrice}</span></li>
            </ul>
        </div>
    </section>

    <!-- 날짜 / 회차 선택 -->
    <section class="booking-area">
        <div class="booking-top">
            <div class="date-area">
                <h3>날짜 선택</h3>
				<input type="text" id="datePicker" placeholder="날짜를 선택하세요" style="display:none;">
            </div>

            <div class="time-area">
                <h3>회차 선택</h3>
                <div id="schedule-area">
                    날짜를 선택해주세요.
                </div>
            </div>
        </div>

        <div class="booking-bottom">
            <button type="button" class="btn-booking">예매하기</button>
        </div>
    </section>

    <!-- 하단 탭 -->
    <section class="detail-bottom">
        <ul class="tab-menu">
            <li class="active" data-tab="info">상세정보</li>
            <li data-tab="casting">캐스팅</li>
            <li data-tab="venue">공연장 정보</li>
            <li data-tab="review">공연 후기</li>
            <li data-tab="preview">좌석 프리뷰</li>
        </ul>

        <div id="tab-content-area" class="tab-content">
            <jsp:include page="/WEB-INF/views/show/tabs/info.jsp" />
        </div>
    </section>
</div> 
	
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>
    <script src="${path}/resources/show/js/show.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
	<script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>
	<!-- 카카오 지도 api 추가 -->
    <script type="text/javascript" 
    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=394bafcd3005391aa7325bac6f719474&libraries=services">
    </script>

	<!-- 카카오맵 api 함수 -->
	<script>
	function loadKakaoVenueMap() {
	    const mapContainer = document.getElementById("kakaoMap");
	    const keywordInput = document.getElementById("venueKeyword");
	    const addressText = document.getElementById("venueDetailAddress");
	
	    if (!mapContainer || !keywordInput) return;
	
	    const venueKeyword = keywordInput.value.trim();
	    if (!venueKeyword) return;
	
	    const mapOption = {
	        center: new kakao.maps.LatLng(37.566826, 126.9786567),
	        level: 3
	    };
	
	    const map = new kakao.maps.Map(mapContainer, mapOption);
	    map.setDraggable(true);
	    map.setZoomable(true);
	
	    const zoomControl = new kakao.maps.ZoomControl();
	    map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
	
	    const ps = new kakao.maps.services.Places();
	
	    ps.keywordSearch(venueKeyword, function(data, status) {
	        if (status === kakao.maps.services.Status.OK) {
	            const place = data[0];
	            const coords = new kakao.maps.LatLng(place.y, place.x);
	
	            const marker = new kakao.maps.Marker({
	                map: map,
	                position: coords
	            });
	
	            const detailAddress = place.road_address_name && place.road_address_name.trim() !== ""
	                ? place.road_address_name
	                : place.address_name;
	
	            const infowindow = new kakao.maps.InfoWindow({
	                content:
	                    '<div style="padding:6px 10px; font-size:13px; color:#000; background:#fff; white-space:nowrap;">'
	                    + place.place_name +
	                    '<br><span style="font-size:12px;">' + detailAddress + '</span>'
	                    + '</div>'
	            });
	
	            infowindow.open(map, marker);
	            map.setCenter(coords);
	
	            if (addressText) {
	                addressText.textContent = "상세주소: " + detailAddress;
	            }
	        } else {
	            console.log("장소 검색 실패:", venueKeyword);
	            if (addressText) {
	                addressText.textContent = "상세주소를 찾을 수 없습니다.";
	            }
	        }
	
	        setTimeout(function() {
	            map.relayout();
	        }, 200);
	    });
	}
	</script>
    <!-- 카카오 맵 api 종료 -->

    <script>
    function selectTime(startTime) {
    	console.log("선택한 시간:", startTime);
    }
    </script>
    
   <!-- 상세페이지 -->
    <script>
	 // 4. 상세페이지 탭 전환
	$(document).on('click', '.tab-menu li', function() {
    const $this = $(this);
    const tabName = $this.data('tab');
    const showId = $('#showId').val();
    const contextPath = $('#contextPath').val();

    console.log("탭 클릭:", tabName);
    console.log("showId:", showId);
    console.log("contextPath:", contextPath);

    $('.tab-menu li').removeClass('active');
    $this.addClass('active');

    $.ajax({
        url: contextPath + "/show/getTabContentAjax",
        type: "GET",
        data: {
            showId: showId,
            tabName: tabName
        },
        success: function(res) {
            console.log("ajax 성공");
            $('#tab-content-area').html(res);
            
            if (tabName === 'venue') {
            	setTimeout(function(){
            		loadKakaoVenueMap();
            	}, 100);
            }
        },
        error: function(xhr) {
            console.log("탭 ajax 실패");
            console.log("status:", xhr.status);
            console.log("response:", xhr.responseText);
        }
     });
   });
   </script>
   
   <script>
	// 3. 날짜, 회차 호출 코드 - show.js 에서 임시용
	$(document).ready(function() {
    // 1. 페이지가 열리자마자 바로 달력을 그리기
    const startDate = "<fmt:formatDate value='${dto.startDate}' pattern='yyyy-MM-dd'/>";
    const endDate = "<fmt:formatDate value='${dto.endDate}' pattern='yyyy-MM-dd'/>";
    
    function getScheduleByDate(dateStr) {
    	let showId = $("#showId").val();
    	
    	console.log("ajax 요청 showID: ", showId);
    	console.log("ajax 요청 playDate: ", dateStr);
    	
	   	 $.ajax({
	            url: $("#contextPath").val() + "/show/getScheduleAjax",
	            type: "GET",
	            data: {
	                showId: showId,
	                playDate: dateStr
	            },
	            success: function(res) {
	                $("#schedule-area").html(res);
	            },
	            error: function(xhr) {
	                console.error("회차 조회 실패");
	                console.error(xhr.responseText);
	            }
	        });
    	}
    
    flatpickr("#datePicker", {
        locale: "ko",       // 한국어 설정
        inline: true,
        dateFormat: "Y-m-d",
        enable: [{from: startDate, to: endDate}],
        defaultDate: startDate,
        onChange: function(selectedDates, dateStr, instance) {
            // 2. 달력에서 날짜를 클릭후 실행
            getScheduleByDate(dateStr);
          }
       });
    getScheduleByDate(startDate);
   });
   </script>
   
   <script>
   // show.js에 반영 안함, main.js 오류 해결 후 붙여야됨
   // 시간버튼(.time-btn)을 클릭했을 때 실행
   $(document).on('click', '.time-btn', function(){
	  
	   $('.time-btn').removeClass('active')
	   $(this).addClass('active');

	   console.log("현재 버튼 클래스 상태: ", $(this).attr('class'));
	   //선택한 시간 데이터 확인
	   let selectedTime = $(this).text().trim();
	   console.log("선택 완료된 시간: ", selectedTime);
	   
	   //예매하기 버튼 활성화
	   // $('#bookbtn').prop('disabled', false);
   });
   
// 예매하기 버튼 클릭 이벤트
   $(document).on('click', '.btn-booking', function() {
       const showId = $('#showId').val(); // hidden input에서 가져옴
      
       const scheduleId = $('.time-btn.active').data('schedule-id'); 

       
       if (!scheduleId) {
           alert("날짜를 선택하고 회차(시간)를 클릭해주세요!");
           return;
       }

       // 2. 팝업창 띄우기
       const contextPath = $('#contextPath').val();
       const url = contextPath + "/show/seat?showId=" + showId + "&scheduleId=" + scheduleId;
       const popupName = "seatPopup";
       const specs = "width=1400,height=950,top=50,left=100,scrollbars=yes,resizable=yes";
       window.open(url, popupName, specs);
   });
   </script>
   
</body>
</html>