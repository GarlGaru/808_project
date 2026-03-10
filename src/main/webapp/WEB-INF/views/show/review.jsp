<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%String path = request.getContextPath(); %>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Bootstrap 4 Spotify-style buttons sample">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>리뷰 페이지</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
    <link rel="stylesheet" href="${path}/resources/show/css/review.css">
    
   
    
</head>

<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
   
    <!-- ##### Hero Area Start ##### -->
	<h2>공연 리뷰</h2>
	
	<select id="sortSelect">
	<option value="latest">최신순</option>
	<option value="rating">평점순</option>
	</select>
	
	<div>
	평균 별점 : ⭐ <span id="avgRating">0</span>
	</div>

	<hr>
	
	<h3>리뷰 작성</h3>
	
	<br><br>
	
	<div id="starArea">
	<span class="star" data-value="1">⭐</span>
	<span class="star" data-value="2">⭐</span>
	<span class="star" data-value="3">⭐</span>
	<span class="star" data-value="4">⭐</span>
	<span class="star" data-value="5">⭐</span>
	</div>

	<input type="hidden" id="rating">
	
	<br><br>
	
	<textarea id="content" rows="4" cols="50"></textarea>
	
	<br><br>
	
	<button onclick="writeReview()">리뷰 작성</button>
	
	<hr>
	
	<h3>리뷰 목록</h3>
	
	
	<div id="reviewList"></div>
	<br>
	
	<button id="moreBtn">더보기</button>
	
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>
    
    <script>
    function formatDate(dateString) {
        if (!dateString) return "-";
        const d = new Date(dateString);
        if (isNaN(d.getTime())) return "-"; // 유효하지 않은 날짜 처리

        const year = d.getFullYear();
        const month = ("0" + (d.getMonth() + 1)).slice(-2);
        const day = ("0" + d.getDate()).slice(-2);

        return `\${year}-\${month}-\${day}`; // YYYY-MM-DD 형식
    }
    
    
    
    const path="<%=path%>";
    const showId="PF281626";  //실제 상세페이지에는 const showId="${show.showId}";
    
    let page=1;
    let sort="latest";
    
    $(document).ready(function(){
    	loadReview();
    	loadAvgRating();
    	
    	 $(".star").click(function(){
    	    	let value=$(this).data("value");
    	    	$("#rating").val(value);
    	    	$(".star").css("opacity","0.3");
    	    	$(this).prevAll().addBack().css("opacity","1");
    	    
    	    });
    	 

    	    /* 더보기 */
    	    $("#moreBtn").click(function(){
    	    	page++;
    	    	loadReview();
    	    });
    	    
    	    /* 정렬변경 */
    	    $("#sortSelect").change(function(){
    	    	sort=$(this).val();
    	    	page=1;
    	    	loadReview();
    	    	
    	    });
    
    });
    
    
    
    /* 리뷰 목록 */
    function loadReview(){
    	$.ajax({
    		url: path + "/show/reviewList",
    		type:"GET",
    		data:{
    			"showId":showId,
    			"page":page,
    			"sort":sort
    		},
    		success:function(data){
    			let html="";
    			if(data.length==0 && page==1){
    				html="<p>아직 리뷰가 없습니다.</p>";
    			}else{
    				data.forEach(function(r){
    					html+=`
    					<div class="review-box">
    					<div class="review-header">
    					<span class="review-writer">\${r.nickname}</span>
    					<span class="review-rating">⭐ \${r.rating}</span>
    					</div>
    					<div class="review-content" id="content\${r.reviewId}">\${r.content}</div>
    					<div class="review-footer">
    					<span class="review-date">\${formatDate(r.createdAt)}</span>
    					
    					<div>
    					
    					<button onclick="editReview(\${r.reviewId})">수정</button>
    					<button class="delete-btn" onclick="deleteReview(${r.reviewId})">삭제</button>
    					
    					</div>
    					</div>
    					</div>
    					`;
    				});
    				
    			}
    			if(page==1){
    				$("#reviewList").html(html);
    			}else{
    				$("#reviewList").append(html);
    			}
    		}
    	
    	});
    	
    }
    
    /* 리뷰 작성 */
    function writeReview(){
    	const rating=$("#rating").val();
    	const content=$("#content").val();
    	
    	if(!rating || rating == "0") {
            alert("별점을 선택해주세요.");
            return;
        }
        if(!content){
            alert("내용을 입력해주세요.");
            return;
        }
        
    	const reviewData={
    			"showId":showId,
    			"userNum":1,
    			"nickname":"테스트유저",
    			"rating":rating,
    			"content":content
    	};
    	
    	$.ajax({
    		url:path+"/show/reviewInsert",
    		type:"POST",
    		contentType:"application/json",
    		data:JSON.stringify(reviewData),
    		success:function(res){
    			if(res === "success"){
    				alert("리뷰 등록 완료");
    				location.reload();
    			}
    			
    		},
    		error: function(xhr){
    			console.log(xhr.responseText);
    			alert("저장 실패. 콘솔 에러 확인요망");
    		}
    	});
    }
    
    /* 수정페이지  */
    function editReview(reviewId, content, rating){
    	let html=`
    		<textarea id="editContent${reviewId}" rows="3">${content}</textarea>
    		<br>
    		<select id="editRating${reviewId}">
    			<option value="1">⭐1</option>
    			<option value="2"}>⭐2</option>
    			<option value="3"}>⭐3</option>
    			<option value="4"}>⭐4</option>
    			<option value="5"}>⭐5</option>
    		</select>
    		
    		<button onclick="updateReview(${reviewId})">저장</button>
    		<button onclick="loadReview()">취소</button>
    		`;
    		$("#content" + reviewId).html(html);
    }
    
    /* 리뷰 수정 */
    function updateReview(reviewId){
    	const content=$("#editContent" + reviewId).val();
    	const rating=$("#editRating" + reviewId).val();
    	
    	const reviewData={
    			reviewId:reviewId,
    			content:content,
    			rating:rating
    	};
    	
    	$.ajax({
			url:path+"/show/reviewUpdate",
			type:"POST",
			contentType:"application/json",
			data:JSON.stringify(reviewData),
			
			success:function(res){
				if(res=="success"){
					alert("수정 완료");
					
					page=1;
					loadReview();
					loadAvgRating();
					
				}else{
					
					alert("수정 실패");
				}
				
			}
    		
    		
    	});
    	
    	
    }
    
    /* 리뷰 삭제 */
    function deleteReview(reviewId){
    	$.ajax({
    		url:path+"/show/reviewDelete",
    		type:"POST",
    		data:{
    			reviewId:reviewId
    		},
    		success:function(res){
    			if(res=="success"){
    				alert("삭제 완료");
    				page=1;
    				loadReview();
    				loadAvgRating();
    			}else{
    				alert("삭제 실패");
    			}
    		}
    	});
    	
    }
    
    /* 평균 별점 */
    function loadAvgRating(){
    	$.ajax({
    		url:path+"/show/reviewAvg",
    		type:"GET",
    		data:{showId:showId},
    		success:function(data){
    			$("#avgRating").text(data);
    		}
    		
    	});
    	
    }
    
    
    </script>
    
</body>
</html>
