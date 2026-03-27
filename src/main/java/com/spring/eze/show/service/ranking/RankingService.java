package com.spring.eze.show.service.ranking;

import java.util.List;

import com.spring.eze.show.dto.ranking.RankingDTO;

public interface RankingService {

	public List<RankingDTO> getTicketRanking(String category);
}
