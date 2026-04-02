package com.spring.eze.show.dao.ranking;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.eze.show.dto.ranking.RankingDTO;

public interface RankingDAO {

	public List<RankingDTO> getTicketRanking(@Param("category") String category);
}
