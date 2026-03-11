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
	public int updateReview(ReviewDTO dto) {
		return sqlSession.update(NAMESPACE + "updateReview", dto);
		
	}

	@Override
	public int deleteReview(Map<String,Object>map) {
		return sqlSession.delete(NAMESPACE + "deleteReview", map);
		
		
		
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
