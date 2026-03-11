package com.spring.eze.show.dao.Show;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.spring.eze.show.dto.Show.ShowDTO;

public interface ShowDAO {

	//상단 공연정보 표기
	public List<ShowDTO> selectShowMainList(Map<String, Object> map);
	
	//하단 오픈예정 표기
	public List<ShowDTO> selectShowUpcoming();
	
	//장르별 상세페이지 가져오기
	public List<ShowDTO> getShowListByCategory(@Param("category") String category, @Param("subCategory") String subCategory);
	
	//개별 상세페이지 가져오기
	public ShowDTO getShowDetail(@Param("showId") String showId);
	
	//날짜,회차 리스트만 가져오도록 
	public List<ShowDTO> getShowSchedule(@Param("showID") String showId, @Param("playDate") String playDate);
}
