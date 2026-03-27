package com.spring.eze.show.service.ranking;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.eze.show.dao.ranking.RankingDAO;
import com.spring.eze.show.dto.ranking.RankingDTO;

@Service
public class RankingServiceImpl implements RankingService {

	@Autowired
	private RankingDAO rankingDAO;

	//[랭킹화면]-----
	@Override
	public List<RankingDTO> getTicketRanking(String category) {
		System.out.println("RankingServiceImpl - getTicketRanking()");
		return rankingDAO.getTicketRanking(category);
	}
}
