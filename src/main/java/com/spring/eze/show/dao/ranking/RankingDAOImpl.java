package com.spring.eze.show.dao.ranking;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.show.dto.ranking.RankingDTO;

@Repository
public class RankingDAOImpl implements RankingDAO {

	@Autowired
	private SqlSession sqlSession;

	// [랭킹화면] ------
	@Override
	public List<RankingDTO> getTicketRanking(String category) {
		System.out.println("RankingDAOImpl - getTicketRanking()");
		return sqlSession.selectList("com.spring.eze.show.dao.ranking.RankingDAO.getTicketRanking", category);
	}
}
