package com.spring.eze.show.dao.review;

import java.util.List;

import com.spring.eze.show.dto.review.ReviewDTO;

public interface ReviewDAO {

	// 1. 후기 목록 가져오기
    // 매개변수가 여러 개일 때는 Map이나 @Param을 사용해 (공연제목, 시작페이지 등)
    public List<ReviewDTO> getReviewList(String concertTitle, int startRow, int pageSize);

    // 2. 전체 후기 개수 가져오기 (특정 공연 혹은 전체)
    public int getTotalCount(String concertTitle);
    
    // 3. (필요하다면) 특정 후기 상세 보기
    //public ReviewDTO getReviewDetail(int reviewId);
	
}
