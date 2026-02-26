package com.spring.eze.show.service.review;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import com.spring.eze.show.dto.review.ReviewDTO;

public interface ReviewService {
	// 1. 후기 목록 가져오기 (공연 제목별 필터링 + 페이지 번호)
    // 공연 제목이 없으면 전체, 있으면 해당 공연만!
    public List<ReviewDTO> getReviewList(HttpServletRequest request, HttpServletResponse response, Model model);

    // 2. 전체 후기 개수 가져오기 (상단에 "총 n개" 표시용 + 페이지네이션 계산용)
    public int getTotalReviewCount(HttpServletRequest request, HttpServletResponse response, Model model);

    // 3. 아이디 마스킹 처리 로직 (이건 ServiceImpl 내부에서 써도 되고, 필요하면 밖으로 뺄 수도 있어)
    public String maskUserId(HttpServletRequest request, HttpServletResponse response, Model model);

    // 4. (추가 기능 제안) 후기 작성하기
    public void registerReview(ReviewDTO dto);
    
    public String[] getConcertList();
    
}
