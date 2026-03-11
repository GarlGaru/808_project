package com.spring.eze.show.service.review;

import java.io.IOException;

import java.util.List;


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

	//후기 목록
	@Override
	public void reviewListAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		 System.out.println("ReviewServiceImpl - reviewListAction()");

		    String concertTitle = request.getParameter("concertTitle");

		    List<ReviewDTO> list;

		    if(concertTitle != null && !concertTitle.isEmpty()) {
		        list = dao.getReviewByShowId(concertTitle);
		    } else {
		        list = dao.getReviewList();
		    }

		    int total = list.size();
		 
		    model.addAttribute("reviews", list);
		    model.addAttribute("totalCount", total);
		    
	}


//전체개수
	@Override
	public int getTotalReviewCount(HttpServletRequest request, HttpServletResponse response, Model model) {
		return dao.getTotalCount();
	}


//후기작성
	@Override
	public void reviewInsertAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {

	    System.out.println("ReviewServiceImpl - reviewInsertAction()");

	    ///HttpSession session = request.getSession();

	    String showId = request.getParameter("showId");  // 이름 나중에 showId로 바꾸는 게 좋음
	    String content = request.getParameter("content");
	    String ratingStr = request.getParameter("rating");

	    int rating = 0;
	    if (ratingStr != null && !ratingStr.equals("")) {
	        rating = Integer.parseInt(ratingStr);
	    }


	    ReviewDTO dto = new ReviewDTO();
	    dto.setUserNum(1);  
	    
	    dto.setRating(rating);
	    dto.setContent(content);
	    dto.setShowId(showId);

	    dao.insertReview(dto);
	    System.out.println("후기작성완료");

	  
		
	}
	
//후기 수정
	@Override
	public void reviewUpdateAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("ReviewServiceImpl - reviewUpdateAction()");
		
		 int reviewId = Integer.parseInt(request.getParameter("reviewId"));
		
		String content = request.getParameter("content");
		String showId = request.getParameter("showId");

		ReviewDTO dto = new ReviewDTO();
		dto.setReviewId(reviewId);
		dto.setContent(content);
		dto.setShowId(showId);

		dao.updateReview(dto);
		
	}

	//후기 삭제
	@Override
	public void reviewDeleteAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("ReviewServiceImpl - reviewDeleteAction()");
		
		int reviewId = Integer.parseInt(request.getParameter("reviewId"));
		dao.deleteReview(reviewId);
	}

	//아이디 마킹처리
	@Override
	public String maskUserId(String userId) {
		if(userId == null || userId.length() < 4) return "****";
		
		return userId.substring(0,2) + "****";
	}

	@Override
	public void getConcertListAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		List<ReviewDTO> showList = dao.getShowListForReview();
		
		model.addAttribute("showList", showList);
	}






    
}
