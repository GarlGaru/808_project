package com.spring.eze.show.service.review;

import java.util.List;

import com.spring.eze.show.dto.review.ReviewDTO;

public interface ReviewService {

	// 후기 목록 가져오기
	public List<ReviewDTO> getReviewList(String showId);

	// 후기 작성
	public void insertReview(ReviewDTO dto);

	// 4. 후기 수정 처리
	public boolean reviewUpdateAction(ReviewDTO dto);

	// 5. 후기 삭제 처리
	public boolean deleteReview(int reviewId, int userId);

	// 평균 별점
	double getAvgRating(String showId);

	// 페이징	
	List<ReviewDTO> getReviewPaging(String showId, int page, String sort);

}
