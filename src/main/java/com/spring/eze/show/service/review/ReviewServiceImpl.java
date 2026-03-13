package com.spring.eze.show.service.review;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.eze.show.dao.review.ReviewDAO;
import com.spring.eze.show.dto.review.ReviewDTO;

@Service
public class ReviewServiceImpl implements ReviewService {

	@Autowired
	private ReviewDAO dao;

//후기 수정
	@Override
	public boolean reviewUpdateAction(ReviewDTO dto) {
		System.out.println("ReviewServiceImpl - reviewUpdateAction()");
		
		int result = dao.updateReview(dto);
		
		return result > 0;

	}

//리뷰 목록
	@Override
	public List<ReviewDTO> getReviewList(String showId) {

		return dao.getReviewByShowId(showId);
	}

	// 리뷰작성
	@Override
	public void insertReview(ReviewDTO dto) {

		dao.insertReview(dto);

	}

	// 리뷰삭제
	@Override
	public boolean deleteReview(int reviewId, int userId) {
		
		Map<String,Object>map = new HashMap<>();
		map.put("reviewId", reviewId);
		map.put("userNum", userId);
		
		int result = dao.deleteReview(map);
		
		return result > 0;
		
		
	}

	//평균 별점
	@Override
	public double getAvgRating(String showId) {

		return dao.getAvgRating(showId);
	}
	
	//페이징
	@Override
	public List<ReviewDTO> getReviewPaging(String showId, int page, String sort) {
		int size = 5;

		int start = (page - 1) * size + 1;
		int end = page * size;

		Map<String, Object> map = new HashMap<>();

		map.put("showId", showId);
		map.put("start", start);
		map.put("end", end);
		map.put("sort", sort);

		return dao.getReviewPaging(map);
	}

    @Override
    public void reviewListAction(HttpServletRequest request, HttpServletResponse response, Model model) {

    }

}
