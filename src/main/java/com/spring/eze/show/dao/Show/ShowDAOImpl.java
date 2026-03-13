package com.spring.eze.show.dao.Show;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.show.dto.Show.ShowDTO;

@Repository
public class ShowDAOImpl implements ShowDAO{

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	//공연 메인 목록
	@Override
	public List<ShowDTO> selectShowMainList(Map<String, Object> map) {
		System.out.println("ShowDAOImpl - selectShowMainList()");
		ShowDAO dao = sqlSession.getMapper(ShowDAO.class);
		return dao.selectShowMainList(map);
      
	}

	//오픈 예정 공연
	@Override
	public List<ShowDTO> selectShowUpcoming() {
		System.out.println("ShowDAOImpl - selectShowUpcoming()");
		ShowDAO dao = sqlSession.getMapper(ShowDAO.class);
		return dao.selectShowUpcoming();
  
	}

	// 장르별 상세페이지
	@Override
	public List<ShowDTO> getShowListByCategory(String category, String subCategory) {
		System.out.println("ShowDAOImpl - getShowListByCategory()");
		
		//1. 파라미터를 명확히 하기 위해 map 생성
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category", category);
		map.put("subCategory", subCategory);
		
		// sqlSession을 통해 mapper xml의 특정 id 호출 파라미터 전달
		return sqlSession.selectList("com.spring.eze.show.dao.Show.ShowDAO.getShowListByCategory", map);
	}

	// 개별 상세페이지
	@Override
	public ShowDTO getShowDetail(String showId) {
		System.out.println("ShowDAOImpl - getShowDetail()");
		
		return sqlSession.selectOne("com.spring.eze.show.dao.Show.ShowDAO.getShowDetail", showId);
	}

	// 개별 상세페이지-날짜, 회차 선택
	@Override
	public List<ShowDTO> getShowSchedule(String showId, String playDate) {
		System.out.println("ShowDAOImpl - getShowSchedule()");
		
		//1. 파라미터를 명확히 하기 위한 map 생성
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("showId", showId);
		map2.put("playDate", playDate);
		
		//2. sqlSession 통해 mapper xml 특정 파라미터 전달
		return sqlSession.selectList("com.spring.eze.show.dao.Show.ShowDAO.getShowSchedule", map2);
	}

	// 랭킹 페이지
	@Override
	public List<ShowDTO> getShowRanking(String genre) {
		System.out.println("ShowDAOImpl - getShowRanking()");
		
		return sqlSession.selectList("com.spring.eze.show.dao.Show.ShowDAO.getShowRanking", genre);
	}

}
