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

	private static final String NAMESPACE = "com.spring.eze.show.dao.review.ReviewDAO.";
	
	@Override
	public List<ReviewDTO> getReviewList() {
		return sqlSession.selectList(NAMESPACE + "getReviewList");
	}

	@Override
	public int getTotalCount() {
		return sqlSession.selectOne(NAMESPACE + "getTotalCount");
	}

	@Override
	public ReviewDTO getReviewDetail(int reviewId) {
		return sqlSession.selectOne(NAMESPACE + "getReviewDetail", reviewId);
		
	}

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
	public void plusReadCnt(int reviewId) {
		sqlSession.update(NAMESPACE + "plusReadCnt", reviewId);
		
	}

	@Override
	public List<String> getConcertTitles() {
		return sqlSession.selectList(NAMESPACE + "getConcertTitles");
	}

	@Override
	public List<ReviewDTO> getReviewByShowId(String showId) {
		// TODO Auto-generated method stub
		return sqlSession.selectList(NAMESPACE + "getReviewByShowId", showId);
	}
	

}
