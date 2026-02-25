package com.spring.eze.show.dao.Seat;

import java.util.List;

import com.spring.eze.show.dto.Seat.SeatDTO;

public interface SeatDAO {

	// 1. 특정 공연 회차(scheduleId)의 모든 좌석 상태 보기
    List<SeatDTO> getSeatList(String schedule_id);

    // 2. 좌석 선점하기 (상태를 'HOLD'로 바꾸고 만료 시간 설정)
    int holdSeat(int seat_id, String user_id);

    // 3. 결제 완료 후 최종 예약 확정
   // int confirmSeat(int seat_id, Long reservationId);

    // 4. 시간이 지난 선점 좌석 다시 풀어주기 (스케줄링용)
    int releaseExpiredSeats();
    
    // 1. 좌석 확정 저장
    int insertReservationSeat(SeatDTO dto);

    // 2. 특정 예매의 좌석 조회
    List<SeatDTO> getSeatsByReservation(int reservationId);
    
}
