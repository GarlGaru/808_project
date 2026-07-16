package com.spring.eze.show.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.spring.eze.show.dao.Seat.SeatDAO;

@Component
public class scheduler {

	@Autowired
	private SeatDAO seatDAO;
	
	@Scheduled(fixedDelay = 30000)
	public void releaseExpiredSeats() {
		int released = seatDAO.updateReleaseExpiredSeats();
		if (released > 0) {
			System.out.println("[Scheduler] 만료 좌석 해제" + released + "개");
		}
	}
}
