package com.spring.eze.show.service.show;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.spring.eze.show.dao.Seat.SeatDAO;

@Component
public class SeatCleanupScheduler {

	@Autowired
	private SeatDAO dao;
	
	@Scheduled(fixedDelay = 60000)	//1분마다 실행
	public void releaseExpiredSeats() {
		// SQL : UPDATE seat_table SET seat_status = 'AVAILABLE'
		//		 WHERE seat_status = 'HELD' AND hold_at < 5분 전 시간
		dao.updateReleaseExpiredSeats();
	}
}
