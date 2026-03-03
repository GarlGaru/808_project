package com.spring.eze.show.dao.Show;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.show.dto.Show.ShowDTO;

@Repository
public class ShowDAOImpl implements ShowDAO{

//	@Autowired
//	private SqlSessionTemplate sqlSession;
	
	//공연 메인 목록
	@Override
	public List<ShowDTO> selectShowMainList(Map<String, Object> map) {
//		System.out.println("ShowDAOImpl - selectShowMainList()");
//		ShowDAO dao = sqlSession.getMapper(ShowDAO.class);
//		return dao.selectShowMainList(map);
        return null;
	}

	//오픈 예정 공연
	@Override
	public List<ShowDTO> selectShowUpcoming() {
//		System.out.println("ShowDAOImpl - selectShowUpcoming()");
//		ShowDAO dao = sqlSession.getMapper(ShowDAO.class);
//		return dao.selectShowUpcoming();
        return null;
	}

}
