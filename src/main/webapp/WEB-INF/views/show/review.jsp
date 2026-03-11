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
	
	<div id="writeArea">
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
	
	</div>
	
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
    const loginUserId="${sessionScope.loginUser.userId}";
    
    
    let page=1;
    let sort="latest";
    let editingReviewId = null;
    
    $(document).ready(function(){
    	
    	if(!loginUserId){
    		$("#writeArea").html(
    		` <p style="color:gray; margin-top:20px;"> 로그인이 필요합니다. </p>
    		<buttom class="btn btn-sm btn-outline-light" onclick="location.href='${path}/user/authModal'">
    		로그인 하러가기 </button>`
    		);
    	}
    	
    	loadReview();
    	loadAvgRating();
    	
    	$(document).on("click", ".star", function(){
            let value = $(this).data("value");
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
    					
    					let buttons = "";
    					
    					if(loginUserId == r.userNum) {
    						buttons = `
    							<button class="btn btn-sm btn-secondary" onclick="editReview(\${r.reviewId}, \${r.rating})">수정</button>
                                <button class="btn btn-sm btn-danger" onclick="deleteReview(\${r.reviewId})">삭제</button> `;
    					}
    					html+=`
    					<div class="review-box" id="review\${r.reviewId}">
    					<div class="review-header">
    					<span class="review-writer">\${r.nickname}</span>
    					<span class="review-rating">⭐ \${r.rating}</span>
    					</div>
    					
    					<div class="review-content" id="content\${r.reviewId}">\${r.content}</div>
    					<div class="review-footer">
    					<span class="review-date">\${formatDate(r.createdAt)}</span>
    					
    					<div class="review-btn-zone"> \${buttons}
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
    				alert("리뷰 등록이 완료되었습니다.");
    				location.reload();
    			}
    			else if(res === "login_required"){
    				alert("로그인 후 이용 가능합니다.");
    				location.href = path + "/user/authModal";
    			}
    			else{
    				alert("리뷰 저장 실패");
    			}
    		},
    		error: function(xhr){
    			console.log(xhr.responseText);
    			alert("저장 실패. 콘솔 에러 확인요망");
    		}
    	});
    }
    
    /* 수정페이지  */
    function editReview(reviewId, rating){
    	
    	if(editingReviewId !== null) {
    		alert("이미 수정 중인 리뷰가 있습니다.");
    		return;
    	}
    	editingReviewId = reviewId;
    	
    	// 1. 대상을 변수에 담기 (타이핑 줄이기)
        const $contentDiv = $("#content" + reviewId);
        
        // 2. 원래 써있던 '글자'만 가져오기
        const originalText = $contentDiv.text().trim();
        
        // 3. [중요] 취소할 때를 대비해 원본 글을 '데이터 주머니(data-old)'에 저장!
        $contentDiv.attr("data-old", originalText);
    	
    	let html=`
    		 <textarea id="editContent\${reviewId}" class="form-control" rows="3">\${originalText}</textarea>
            <br>
            
            <div class="mt-2">
    		
            <select id="editRating\${reviewId}" class="custom-select col-3">
            <option value="1" \${rating == 1 ? 'selected' : ''}>⭐1</option>
            <option value="2" \${rating == 2 ? 'selected' : ''}>⭐2</option>
            <option value="3" \${rating == 3 ? 'selected' : ''}>⭐3</option>
            <option value="4" \${rating == 4 ? 'selected' : ''}>⭐4</option>
            <option value="5" \${rating == 5 ? 'selected' : ''}>⭐5</option>
	        </select>
	        <button class="btn btn-sm btn-primary" onclick="updateReview(\${reviewId})">저장</button>
	        <button class="btn btn-sm btn-warning" onclick="cancelEdit(\${reviewId})">취소</button>
    		</div>`;
    	    
	    	$contentDiv.html(html);
	        
	        // 5. 수정/삭제 버튼 뭉치 숨기기
	    	$contentDiv.closest(".review-box").find(".review-btn-zone").hide();
    }
    
    /* 수정 취소 */
    	function cancelEdit(reviewId){
	    const $contentDiv = $("#content" + reviewId);
	    
	    // 1. 주머니(data-old)에 넣어뒀던 원본 글을 다시 꺼내서 채움
	    const originalText = $contentDiv.attr("data-old");
	    $contentDiv.html(originalText);
	    
	    // 2. 숨겼던 버튼 박스 다시 보여주기
	    $contentDiv.closest(".review-box").find(".review-btn-zone").show();
	    
	    // 3. 수정 중인 상태 해제 (오타 주의: editing)
	    editingReviewId = null;
	}
    
    
    /* 리뷰 수정 */
    function updateReview(reviewId){
    	
    	let content = $("#editContent" + reviewId).val().trim();
    	
    	if(content.length < 1){
    		alert("내용을 입력하세요.");
    		return;
    	}
    	
    	let rating = $("#editRating" + reviewId).val();
    	
    	 $.ajax({
    	        url: path+"/show/reviewUpdate",
    	        type:"POST",
    	        contentType:"application/json",
    	        data:JSON.stringify({
    	            reviewId:reviewId,
    	            content:content,
    	            rating:rating
    	        }),
    	        success:function(res){
    	            if(res==="success"){
    	                alert("수정이 완료되었습니다.");
    	                editingReviewId = null;
    	                page = 1;
    	                loadReview();
    	                loadAvgRating();
    	            }
    	        }
    	    });
    	}
    
    /* 리뷰 삭제 */
    function deleteReview(reviewId){
    	
    	if(!confirm("정말 삭제하시겠습니까?")){
    		return;
    	}
    	
    	$.ajax({
    		url:path+"/show/reviewDelete",
    		type:"POST",
    		data:{reviewId:reviewId},
    		success:function(res){
    			if(res==="success"){
    				alert("삭제 되었습니다.");
    				page = 1;
    				loadReview();
    				loadAvgRating();
    			}
    			else if(res==="login_required"){
    				alert("로그인 후 이용이 가능합니다.");
    				location.href = path + "/user/authModal";
    			}else {
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
