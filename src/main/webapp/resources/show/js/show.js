/* resources/show/js/show.js */

// [기존] 메인화면 슬라이더 스크롤 함수
function scrollTrack(trackId, dir) {
    var el = document.getElementById(trackId);
    if (!el) return;
    el.scrollBy({ left: dir * 420, behavior: 'smooth' });
}

// [신규] 공통 카테고리 필터 함수 (Ajax)
function filterCategory(category, contextPath) {
    // 1. 버튼 활성화 UI 처리
    if($('.tab-btn').length > 0) {
        $('.tab-btn').removeClass('active');
        $('.tab-btn[onclick*="' + category + '"]').addClass('active');
    }
    
    if($('.genre-bar a').length > 0) {
        $('.genre-bar a').removeClass('active');
        $('.genre-bar a[onclick*="' + category + '"]').addClass('active');
    }

    // 2. Ajax 호출
	    $.ajax({
	        url: contextPath + "/show/showListAjax", 
	        type: "GET",
	        data: { category: category },
	        success: function(res) {
	            // 3. 페이지 구조에 따라 데이터 주입
	            if ($('#showList').length > 0) {
	                $('#showList').html(res);
	            } 
	            
	            if ($('#mainTrack').length > 0) {
	                $('#mainTrack').html(res);
	            }
	            
	            // 4. 리스트 페이지일 경우만 URL 업데이트
	            if (window.location.pathname.indexOf('showList') !== -1) {
	                var newUrl = window.location.pathname + '?category=' + category;
	                history.pushState({ category: category }, '', newUrl);
	            }
	        },
	        error: function(err) {
	            console.error("데이터 로드 실패:", err);
	        }
   		 });
   		 
   		 
/* ========================================================
   [장르별 상세페이지 전용] 메인 장르 & 서브 장르(콘서트) 필터 로직
   ======================================================== */
	var currentCategory = 'concert';
	var currentSubCategory = 'all';

	function loadShowList(category, btnElement) {
	    currentCategory = category;
	    currentSubCategory = 'all';
	
	    // 메인 장르 탭 active 처리
	    if (btnElement) {
	        $('#main-category-tabs .tab-btn').removeClass('active');
	        $(btnElement).addClass('active');
	    } else {
	        $('#main-category-tabs .tab-btn').removeClass('active');
	        $('#main-category-tabs .tab-btn').each(function() {
	            if ($(this).text().trim() === getCategoryName(category)) {
	                $(this).addClass('active');
	            }
	        });
	    }

	    // 제목 변경
	    $('#genre-page-title').text(getCategoryName(category));
	
	    // 콘서트일 때만 세부탭 표시
	    if (category === 'concert') {
	        $('#sub-category-tabs').show();
	        $('#sub-category-tabs .sub-tab-btn').removeClass('active');
	        $('#sub-category-tabs .sub-tab-btn:first').addClass('active');
	    } else {
	        $('#sub-category-tabs').hide();
	    }
	
	    showListData();
	}

	function loadSubCategory(subCategory, btnElement) {
	    currentSubCategory = subCategory;
	
	    $('#sub-category-tabs .sub-tab-btn').removeClass('active');
	    $(btnElement).addClass('active');
	
	    showListData();
	}

	function showListData() {
	    var cp = typeof contextPath !== 'undefined' ? contextPath : '';
	
	    $.ajax({
	        url: cp + '/show/showListAjax',
	        type: 'GET',
	        data: {
	            category: currentCategory,
	            subCategory: currentCategory === 'concert' ? currentSubCategory : 'all'
	        },
	        success: function(res) {
	            $('#showList').html(res);
	            
	            $('#sub-category-tabs .sub-filter-btn').removeClass('active');
            	$(btnElement).addClass('active');
	        },
	        error: function(xhr, status, error) {
	            console.error('공연 목록 로드 실패');
	            console.error('status:', xhr.status);
	            console.error('response:', xhr.responseText);
	        }
	    });
	}

	function getCategoryName(category) {
	    var titleMap = {
	        concert: '콘서트',
	        musical: '뮤지컬',
	        play: '연극'
	    };
	    return titleMap[category] || '공연';
}
   
   
    //3. 날짜, 회차 호출 코드
	    //$(document).on("click", ".date-btn", function() {
	    //alert("날짜, 회차 호출코드 작동 확인!");
	    //let showId = $("#showId").val();
	    //let playDate = $(this).data("date");
	    
	    //$(".data-btn").removeClass("active");
	    //$(this).addClass("active");
	
	    //$.ajax({
	       // url: $("#contextPath").val() + "/show/getScheduleAjax",
	       // type: "GET",
	       // data: {
	       //     showId: showId,
	       //    playDate: playDate
	       // },
	       // success: function(res) {
	       //     $("#schedule-area").html(res);
	       // },
	       // error: function(xhr, status, error) {
	       //     console.error("회차 조회 실패");
	       //     console.error("status:", xhr.status);
	       //     console.error("response:", xhr.responseText);
	       // }
    //	});
//	});
	
	// 4. 탭 전환 -- main.js의 오류로 인해 showDetail.jsp로 임시로 옮김
	//$(document).on('click', '.tab-menu li', function() {
    //alert("탭 클릭 작동 확인!");
    //const $this = $(this);
    //const tabName = $this.data('tab');
    //const showId = $('#showId').val();
    //const contextPath = $('#contextPath').val();

    //console.log("탭 클릭:", tabName);
    //console.log("showId:", showId);
    //console.log("contextPath:", contextPath);

    //$('.tab-menu li').removeClass('active');
    //$this.addClass('active');

    //$.ajax({
        //url: contextPath + "/getTabContentAjax",
        //type: "GET",
        //data: {
        //    showId: showId,
        //    tabName: tabName
        //},
        //success: function(res) {
        //    console.log("ajax 성공");
        //    $('#tab-content-area').html(res);
        //},
        //error: function(xhr) {
        //    console.log("탭 ajax 실패");
        //    console.log("status:", xhr.status);
        //    console.log("response:", xhr.responseText);
        //}
   // });
//});
}