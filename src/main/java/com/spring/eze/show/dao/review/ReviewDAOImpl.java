package com.spring.eze.show.dao.review;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.show.dto.review.ReviewDTO;

@Repository
public class ReviewDAOImpl implements ReviewDAO {

	@Autowired
	private SqlSession sqlSession;

	private static final String NAMESPACE = "com.spring.eze.show.dao.review.ReviewDAO.";
	


	@Override
	public void updateReview(ReviewDTO dto) {
		sqlSession.update(NAMESPACE + "updateReview", dto);
		
	}

	@Override
	public void deleteReview(int reviewId) {
		sqlSession.delete(NAMESPACE + "deleteReview", reviewId);
		
	}

	@Override
	public void insertReview(ReviewDTO dto) {
		sqlSession.insert(NAMESPACE + "insertReview", dto);
		
	}


	@Override
	public List<ReviewDTO> getReviewByShowId(String showId) {
		
		return sqlSession.selectList(NAMESPACE + "getReviewByShowId", showId);
	}

	



	@Override
	public double getAvgRating(String showId) {
		
		return sqlSession.selectOne(NAMESPACE+"getAvgRating" ,showId);
	}

	@Override
	public List<ReviewDTO> getReviewPaging(Map<String, Object> map) {
		
		return sqlSession.selectList(NAMESPACE + "getReviewPaging", map);
	}

	

}
