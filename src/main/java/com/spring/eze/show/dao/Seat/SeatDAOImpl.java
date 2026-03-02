package com.spring.eze.show.dao.Seat;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.show.dto.Seat.SeatDTO;

@Repository
public class SeatDAOImpl implements SeatDAO {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	// 좌석 조회
	@Override
	public List<SeatDTO> selectSeatList(Map<String, Object> map) {
		System.out.println("SeatDAOImpl - selectSeatList()");
		
		SeatDAO dao = sqlSession.getMapper(SeatDAO.class);
		List<SeatDTO> list = dao.selectSeatList(map);
		
		return list;
	}

	@Override
	public List<SeatDTO> selectSeatStatus(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int updateHoldSeats(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateReleaseSeats(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return 0;
	}

}


