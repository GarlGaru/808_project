package com.spring.eze.show.dao.review;

import java.util.List;
import java.util.Map;

import com.spring.eze.show.dto.review.ReviewDTO;

public interface ReviewDAO {

	// 1. 후기 목록 가져오기
    public List<ReviewDTO> getReviewByShowId(String showId);
    
    //페이징 목록
    public List<ReviewDTO> getReviewPaging(Map<String,Object>map);

    //리뷰작성
    public void insertReview(ReviewDTO dto);
    
    //리뷰수정
    public int updateReview(ReviewDTO dto);
    
    //리뷰삭제
    public int deleteReview(Map<String, Object>map);
 
    
    double getAvgRating(String showId); //평균별점
   
}
