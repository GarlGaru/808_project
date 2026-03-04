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
	public List<ShowDTO> getShowListByCategory(String category) {
		System.out.println("ShowDAOImpl - getShowListByCategory()");
		
		//1. 파라미터를 명확히 하기 위해 map 생성
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category", category);
		
		// sqlSession을 통해 mapper xml의 특정 id 호출 파라미터 전달
		return sqlSession.selectList("com.spring.eze.show.dao.Show.ShowDAO.getShowListByCategory", category);
	}
}
