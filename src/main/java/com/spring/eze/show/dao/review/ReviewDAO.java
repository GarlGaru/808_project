package com.spring.eze.show.dao.review;

import java.util.List;


import com.spring.eze.show.dto.review.ReviewDTO;

public interface ReviewDAO {

	// 1. 후기 목록 가져오기

    public List<ReviewDTO> getReviewList();

    // 2. 전체 후기 개수 가져오기 
    public int getTotalCount();
    
    // 3. (필요하다면) 특정 후기 상세 보기
    public ReviewDTO getReviewDetail(int reviewId);
    
    public void updateReview(ReviewDTO dto);
    
    public void deleteReview(int reviewId);
    
    public void insertReview(ReviewDTO dto);
    
    //조회수 증가
    public void plusReadCnt(int reviewId);
	
    public List<String> getConcertTitles();
    
    public List<ReviewDTO> getReviewByShowId(String showId);
    
    public List<ReviewDTO> getShowListForReview();
   
}
