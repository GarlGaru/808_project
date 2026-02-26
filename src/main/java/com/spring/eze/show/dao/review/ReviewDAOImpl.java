package com.spring.eze.show.dao.review;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.show.dto.review.ReviewDTO;

@Repository
public class ReviewDAOImpl implements ReviewDAO {

	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public List<ReviewDTO> getReviewList(String concertTitle, int startRow, int pageSize) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int getTotalCount(String concertTitle) {
		// TODO Auto-generated method stub
		return 0;
	}

}
