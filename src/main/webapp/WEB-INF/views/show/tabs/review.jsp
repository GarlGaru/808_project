<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="tab-section">
    <h3>공연후기</h3>
</div>
<%String path = request.getContextPath(); %>

<div class="tab-section review-tab-wrap">

    <%-- 리뷰 작성 영역 --%>
    <div id="writeArea" class="review-write-area">
        <h3 class="review-section-title">리뷰 작성</h3>

        <div id="starArea" class="review-star-area">
            <span class="star" data-value="1">⭐</span>
            <span class="star" data-value="2">⭐</span>
            <span class="star" data-value="3">⭐</span>
            <span class="star" data-value="4">⭐</span>
            <span class="star" data-value="5">⭐</span>
        </div>

        <input type="hidden" id="reviewRating">

        <textarea id="reviewContent" rows="4" placeholder="내용을 입력하세요." class="review-textarea"></textarea>

        <button class="review-submit-btn" onclick="writeReview()">리뷰 작성</button>
    </div>

    <hr class="review-divider">

    <%-- 리뷰 목록 영역 --%>
    <div class="review-list-header">
        <h3 class="review-section-title">리뷰 목록</h3>
        <div class="review-list-controls">
            <select id="reviewSortSelect" class="review-sort-select">
                <option value="latest">최신순</option>
                <option value="rating">평점순</option>
            </select>
            <span class="avg-rating-label">평균 별점 : ⭐ <span id="avgRating">0</span></span>
        </div>
    </div>

    <hr class="review-divider">

    <div id="reviewList"></div>

    <button id="reviewMoreBtn" class="review-more-btn">더보기</button>

</div>

<script>
(function() {
  
    const path = "<%=path%>";
    // 공연 상세 페이지에서는 아래 showId를 실제 값으로 교체하세요.
    
    const showId = $('#showId').val();
    //const showId = "${show.showId}";
    const loginUserId = "${sessionScope.loginUser.userId}";

    let reviewPage = 1;
    let reviewSort = "latest";
    let editingReviewId = null;

    /* ── 날짜 포맷 ── */
    function formatDate(dateString) {
        if (!dateString) return "-";
        const d = new Date(dateString);
        if (isNaN(d.getTime())) return "-";
        const year = d.getFullYear();
        const month = ("0" + (d.getMonth() + 1)).slice(-2);
        const day   = ("0" + d.getDate()).slice(-2);
        return `\${year}-\${month}-\${day}`;
    }

    /* ── 초기화 ── */
    function initReviewTab() {

        /* 비로그인 시 작성 영역 교체 */
        if (!loginUserId) {
            document.getElementById("writeArea").innerHTML =
                '<p class="review-login-msg">로그인이 필요합니다.</p>';
        }

        loadReview();
        loadAvgRating();

        /* 별점 클릭 */
        document.querySelectorAll(".review-tab-wrap .star").forEach(function(star) {
            star.addEventListener("click", function() {
                const value = this.dataset.value;
                document.getElementById("reviewRating").value = value;
                document.querySelectorAll(".review-tab-wrap .star").forEach(function(s) {
                    s.style.opacity = "0.3";
                });
                let current = this;
                while (current) {
                    current.style.opacity = "1";
                    current = current.previousElementSibling;
                }
                this.style.opacity = "1";
            });
        });

        /* 더보기 */
        document.getElementById("reviewMoreBtn").addEventListener("click", function() {
            reviewPage++;
            loadReview();
        });

        /* 정렬 변경 */
        document.getElementById("reviewSortSelect").addEventListener("change", function() {
            reviewSort = this.value;
            reviewPage = 1;
            loadReview();
        });
    }

    /* ── 리뷰 목록 ── */
    function loadReview() {
        $.ajax({
            url: path + "/show/reviewList",
            type: "GET",
            data: { showId: showId, page: reviewPage, sort: reviewSort },
            success: function(data) {
                let html = "";
                if (data.length === 0 && reviewPage === 1) {
                    html = '<p class="review-empty">아직 리뷰가 없습니다.</p>';
                } else {
                    data.forEach(function(r) {
                        let buttons = "";
                        if (loginUserId == r.userNum) {
                            buttons = `
                                <button class="btn btn-sm btn-secondary" onclick="reviewEditReview(\${r.reviewId}, \${r.rating})">수정</button>
                                <button class="btn btn-sm btn-danger"    onclick="reviewDeleteReview(\${r.reviewId})">삭제</button>`;
                        }
                        html += `
                        <div class="review-box" id="review\${r.reviewId}">
                            <div class="review-header">
                                <span class="review-writer">\${r.nickname}</span>
                                <span class="review-rating">⭐ \${r.rating}</span>
                            </div>
                            <div class="review-content" id="reviewContent\${r.reviewId}">\${r.content}</div>
                            <div class="review-footer">
                                <span class="review-date">\${formatDate(r.createdAt)}</span>
                                <div class="review-btn-zone">\${buttons}</div>
                            </div>
                        </div>`;
                    });
                }
                if (reviewPage === 1) {
                    document.getElementById("reviewList").innerHTML = html;
                } else {
                    document.getElementById("reviewList").insertAdjacentHTML("beforeend", html);
                }
            }
        });
    }

    /* ── 리뷰 작성 ── */
    window.writeReview = function() {
        const rating  = document.getElementById("reviewRating").value;
        const content = document.getElementById("reviewContent").value.trim();

        if (!rating || rating === "0") { alert("별점을 선택해주세요."); return; }
        if (!content)                  { alert("내용을 입력해주세요.");  return; }

        $.ajax({
            url: path + "/show/reviewInsert",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({ showId: showId, rating: rating, content: content }),
            success: function(res) {
                if (res === "success") {
                    alert("리뷰 등록이 완료되었습니다.");
                    reviewPage = 1;
                    loadReview();
                    loadAvgRating();
                    document.getElementById("reviewContent").value = "";
                    document.getElementById("reviewRating").value  = "";
                    document.querySelectorAll(".review-tab-wrap .star").forEach(function(s) {
                        s.style.opacity = "0.3";
                    });
                } else if (res === "login_required") {
                    alert("로그인 후 이용 가능합니다.");
                    if (typeof openAuthModal === "function") openAuthModal();
                } else {
                    alert("리뷰 저장 실패");
                }
            },
            error: function(xhr) {
                console.error(xhr.responseText);
                alert("저장 실패. 콘솔 에러 확인요망");
            }
        });
    };

    /* ── 수정 진입 ── */
    window.reviewEditReview = function(reviewId, rating) {
        if (editingReviewId !== null) { alert("이미 수정 중인 리뷰가 있습니다."); return; }
        editingReviewId = reviewId;

        const $contentDiv  = $("#reviewContent" + reviewId);
        const originalText = $contentDiv.text().trim();
        $contentDiv.attr("data-old", originalText);

        const options = [1,2,3,4,5].map(function(v) {
            return `<option value="\${v}" ${rating == v ? "selected" : ""}>⭐\${v}</option>`;
        }).join("");

        $contentDiv.html(`
            <textarea id="editReviewContent\${reviewId}" class="form-control review-edit-textarea" rows="3">\${originalText}</textarea>
            <div class="review-edit-controls mt-2">
                <select id="editReviewRating\${reviewId}" class="custom-select col-3">\${options}</select>
                <button class="btn btn-sm btn-primary"  onclick="reviewUpdateReview(\${reviewId})">저장</button>
                <button class="btn btn-sm btn-warning"  onclick="reviewCancelEdit(\${reviewId})">취소</button>
            </div>`);

        $contentDiv.closest(".review-box").find(".review-btn-zone").hide();
    };

    /* ── 수정 취소 ── */
    window.reviewCancelEdit = function(reviewId) {
        const $contentDiv = $("#reviewContent" + reviewId);
        $contentDiv.html($contentDiv.attr("data-old"));
        $contentDiv.closest(".review-box").find(".review-btn-zone").show();
        editingReviewId = null;
    };

    /* ── 수정 저장 ── */
    window.reviewUpdateReview = function(reviewId) {
        const content = $("#editReviewContent" + reviewId).val().trim();
        if (content.length < 1) { alert("내용을 입력하세요."); return; }
        const rating = $("#editReviewRating" + reviewId).val();

        $.ajax({
            url: path + "/show/reviewUpdate",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({ reviewId: reviewId, content: content, rating: rating }),
            success: function(res) {
                if (res === "success") {
                    alert("수정이 완료되었습니다.");
                    editingReviewId = null;
                    reviewPage = 1;
                    loadReview();
                    loadAvgRating();
                }
            }
        });
    };

    /* ── 삭제 ── */
    window.reviewDeleteReview = function(reviewId) {
        if (!confirm("정말 삭제하시겠습니까?")) return;

        $.ajax({
            url: path + "/show/reviewDelete",
            type: "POST",
            data: { reviewId: reviewId },
            success: function(res) {
                if (res === "success") {
                    alert("삭제 되었습니다.");
                    reviewPage = 1;
                    loadReview();
                    loadAvgRating();
                } else if (res === "login_required") {
                    alert("로그인 후 이용이 가능합니다.");
                    if (typeof openAuthModal === "function") openAuthModal();
                } else {
                    alert("삭제 실패");
                }
            }
        });
    };

   
    function loadAvgRating() {
        $.ajax({
            url: path + "/show/reviewAvg",
            type: "GET",
            data: { showId: showId },
            success: function(data) {
                document.getElementById("avgRating").textContent = data;
            }
        });
    }

  
    initReviewTab();

})();
</script>
