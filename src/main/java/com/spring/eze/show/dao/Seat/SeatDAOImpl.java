package com.spring.eze.show.dao.Seat;

import java.util.HashMap;
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
//		System.out.println("SeatDAOImpl - selectSeatList()");
//
//		SeatDAO dao = sqlSession.getMapper(SeatDAO.class);
//		List<SeatDTO> list = dao.selectSeatList(map);
//
//		return list;
		  return sqlSession.selectList(
			        "com.spring.eze.show.dao.Seat.SeatDAO.selectSeatList",
			        map
			    );
			}

	@Override
	public List<SeatDTO> selectSeatStatus(Map<String, Object> map) {
		return sqlSession.selectList("com.spring.eze.show.dao.Seat.SeatDAO.selectSeatStatus", map);
	}

	@Override
	public int updateHoldSeats(Map<String, Object> map) {
		
		return sqlSession.update("com.spring.eze.show.dao.Seat.SeatDAO.updateHoldSeats",map);
	}

	@Override
	public int updateReleaseSeats(Map<String, Object> map) {
		return sqlSession.update("com.spring.eze.show.dao.Seat.SeatDAO.updateReleaseSeats", map);
	}

	@Override
	public int updateReleaseExpiredSeats() {
		// TODO Auto-generated method stub
		return sqlSession.update("com.spring.eze.show.dao.Seat.SeatDAO.updateReleaseExpiredSeats");
	}

	@Override
	public int lockAndHoldSeats(Map<String, Object> map) {
		return sqlSession.selectOne("com.spring.eze.show.dao.Seat.SeatDAO.lockAndHoldSeats", map);
	}

	@Override
	public int holdSeatsNow(Map<String, Object> map) {
		return sqlSession.update("com.spring.eze.show.dao.Seat.SeatDAO.holdSeatsNow", map);
	}

	@Override
	public List<SeatDTO> selectSeatLayout(String venueName) {
		
		System.out.println("=== selectVenueName 결과: " + venueName);
		return sqlSession.selectList("com.spring.eze.show.dao.Seat.SeatDAO.selectSeatLayout", venueName);
	}

	
}


