package com.spring.eze.show.dao.Show;

import java.util.List;
import java.util.Map;

import com.spring.eze.show.dto.Show.ShowDTO;

public interface ShowDAO {

	//상단 공연정보 표기
	public List<ShowDTO> selectShowMainList(Map<String, Object> map);
	
	//하단 오픈예정 표기
	public List<ShowDTO> selectShowUpcoming();
}
