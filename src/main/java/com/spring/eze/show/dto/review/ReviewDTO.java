package com.spring.eze.show.dto.review;

import java.util.Date;

public class ReviewDTO {

	// 1. DB 테이블 컬럼과 매칭되는 변수들
	 		
    private int reviewId;      // review_id (NUMBER)
    private int userNum;       // user_id (NUMBER) - DB상의 고유번호
    private String showId;    // kopis_id (VARCHAR2) - 공연 ID
    private int rating;        // rating (NUMBER) - 별점
    private String content;    // content (CLOB) - 후기 내용
    private Date createdAt;    // created_at (DATE) - 작성일

    // 2. 화면(JSP)에 보여주기 위해 추가로 필요한 변수들
    private int userId;     // 실제 사용자 아이디 (마스킹 처리할 대상)
    private String profileImg; // 프로필 사진 경로
    private String concertTitle; // 공연 제목
    
    
	public ReviewDTO() {
		super();
		// TODO Auto-generated constructor stub
	}




	public ReviewDTO( int reviewId, int userNum, String showId, int rating, String content,
			Date createdAt, int userId, String profileImg, String concertTitle) {
		super();
		
		this.reviewId = reviewId;
		this.userNum = userNum;
		this.showId = showId;
		this.rating = rating;
		this.content = content;
		this.createdAt = createdAt;
		this.userId = userId;
		this.profileImg = profileImg;
		this.concertTitle = concertTitle;
	}


	public int getReviewId() {
		return reviewId;
	}


	public void setReviewId(int reviewId) {
		this.reviewId = reviewId;
	}


	public int getUserNum() {
		return userNum;
	}


	public void setUserNum(int userNum) {
		this.userNum = userNum;
	}


	public String getShowId() {
		return showId;
	}


	public void setShowId(String showId) {
		this.showId = showId;
	}


	public int getRating() {
		return rating;
	}


	public void setRating(int rating) {
		this.rating = rating;
	}


	public String getContent() {
		return content;
	}


	public void setContent(String content) {
		this.content = content;
	}


	public Date getCreatedAt() {
		return createdAt;
	}


	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}


	public int getUserId() {
		return userId;
	}


	public void setUserId(int userId) {
		this.userId = userId;
	}


	public String getProfileImg() {
		return profileImg;
	}


	public void setProfileImg(String profileImg) {
		this.profileImg = profileImg;
	}


	public String getConcertTitle() {
		return concertTitle;
	}


	public void setConcertTitle(String concertTitle) {
		this.concertTitle = concertTitle;
	}





	@Override
	public String toString() {
		return "ReviewDTO [ reviewId=" + reviewId + ", userNum=" + userNum + ", kopisId="
				+ showId + ", rating=" + rating + ", content=" + content + ", createdAt=" + createdAt + ", userId="
				+ userId + ", profileImg=" + profileImg + ", concertTitle=" + concertTitle + "]";
	}
	
    
	  
}
