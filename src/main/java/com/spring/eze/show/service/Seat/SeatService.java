package com.spring.eze.show.service.Seat;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import com.spring.eze.show.dto.Seat.SeatDTO;

public interface SeatService {
	
    // 좌석맵 조회(회차별)
    public void getSeatList(HttpServletRequest request, HttpServletResponse response, Model model)
        throws ServletException, IOException;

    // 좌석 상태 조회(실시간/새로고침)
    public void getSeatStatus(HttpServletRequest request, HttpServletResponse response, Model model)
        throws ServletException, IOException;

    // 좌석 선택 저장(결제 직전까지 유지: 세션 or 임시테이블)
    public void selectSeats(HttpServletRequest request, HttpServletResponse response, Model model)
        throws ServletException, IOException;

    // 좌석 선택 취소
    public void cancelSelectedSeats(HttpServletRequest request, HttpServletResponse response, Model model)
        throws ServletException, IOException;

    
    public List<SeatDTO> getSeatStatus(String showId, int scheduleId);
    
    public boolean checkAndLockSeats(String showId, int scheduleId, List<String> seats);
}

