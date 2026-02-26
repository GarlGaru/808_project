package com.spring.eze.show.service.review;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.eze.show.dao.review.ReviewDAO;
import com.spring.eze.show.dto.review.ReviewDTO;

@Service
public class ReviewServiceImpl implements ReviewService {

	@Autowired
	private ReviewDAO dao;

	@Override
	public List<ReviewDTO> getReviewList(HttpServletRequest request, HttpServletResponse response, Model model) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int getTotalReviewCount(HttpServletRequest request, HttpServletResponse response, Model model) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String maskUserId(HttpServletRequest request, HttpServletResponse response, Model model) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void registerReview(ReviewDTO dto) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public String[] getConcertList() {
		return new String[] {"지킬앤하이드", "레미제라블", "데스노트", "오페라의유령", "위키드", 
                "맘마미아", "시카고", "캣츠", "킹키부츠", "노트르담드파리"};
		
	}


}
