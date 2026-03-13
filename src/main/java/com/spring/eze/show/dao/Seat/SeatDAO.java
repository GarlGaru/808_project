package com.spring.eze.show.dao.Seat;

import java.util.List;
import java.util.Map;

import com.spring.eze.show.dto.Seat.SeatDTO;

public interface SeatDAO {

	// 좌석 전체 조회 (공연 + 회차 기준)
	public List<SeatDTO> selectSeatList(Map<String, Object> map);
	// map: show_id, schedule_id

	// 좌석 상태만 조회 (실시간 새로고침/AJAX용)
	public List<SeatDTO> selectSeatStatus(Map<String, Object> map);
	// map: show_id, schedule_id
	
	// 좌석 선택(홀드) - available => held
	public int updateHoldSeats(Map<String, Object> map);
	// map: show_id, schedule_id, user_id, seatLabels(list) or seat_label
	
	// 좌석 선택(취소) - held => available
	public int updateReleaseSeats(Map<String, Object> map);
	// map: show_id, schedule_id, user_id, seatLabels(list) or seat_label
	
	public int updateReleaseExpiredSeats();
	
	public boolean checkAndLockSeats(String showId, int scheduleId, List<String> seats);
	
}
