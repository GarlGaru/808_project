package com.spring.eze.show.dao.Seat;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.show.dto.Seat.SeatDTO;
@Repository
public class SeatDAOImpl implements SeatDAO {

	@Autowired
    private SqlSession sqlSession;
	
	
	 @Override
	    public List<SeatDTO> getSeatList(String schedule_id) {
	        return sqlSession.selectList("ReservationSeat.getSeatList", schedule_id);
	    }
	
	@Override
	public int holdSeat(int seat_id, String user_id) {
     
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("seatId", seat_id);
        params.put("userId", user_id);
        params.put("expireMinutes", 5); // 10분간 선점

        return sqlSession.update("ReservationSeat.holdSeat", params);
    }

	@Override
	public int releaseExpiredSeats() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertReservationSeat(SeatDTO dto) {
		// TODO Auto-generated method stub
		return sqlSession.insert("ReservationSeatMapper.insertReservationSeat", dto);
	}

	  @Override
	    public List<SeatDTO> getSeatsByReservation(int reservationId) {
	        return sqlSession.selectList(
	            "ReservationSeatMapper.getSeatsByReservation",
	            reservationId
	        );
	    }



	}


