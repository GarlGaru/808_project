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
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateReleaseExpiredSeats() {
		// TODO Auto-generated method stub
		return sqlSession.update("com.spring.eze.show.dao.Seat.SeatDAO.updateReleaseExpiredSeats");
	}

	@Override
	public boolean checkAndLockSeats(String showId, int scheduleId, List<String> seats) {
		 for(String seat : seats){

			// 1. 안전하게 주머니(Map)를 직접 만들기
		        Map<String, Object> paramMap = new HashMap<>();
		        paramMap.put("showId", showId);
		        paramMap.put("scheduleId", scheduleId);
		        paramMap.put("seatLabel", seat);

		        // 2. 만든 주머니를 전달하기
		        SeatDTO seatInfo = sqlSession.selectOne(
		            "com.spring.eze.show.dao.Seat.SeatDAO.lockSeat",
		            paramMap // <--- 새로 만든 안전한 주머니 투입!
		        );

		        if(seatInfo != null){
		            return false; // 이미 누가 가져갔음
		        }
		    }
		    return true;
		}

}


