package com.spring.eze.show.service.Seat;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.eze.show.dao.Seat.SeatDAO;
import com.spring.eze.show.dto.Seat.SeatDTO;

@Service
public class SeatServiceImpl implements SeatService {

	@Autowired
	private SeatDAO dao;
	
	// 좌석맵 조회(회차별) //좌석화면 띄우는 용도 (null,trim, try-catch 등의 예외처리 X)
	@Override
	public void getSeatList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("SeatServiceImpl - getSeatList()");
		
		
		 System.out.println("===== 파라미터 확인 =====");
		    System.out.println("show_id: " + request.getParameter("show_id"));
		    System.out.println("schedule_id: " + request.getParameter("schedule_id"));
		    System.out.println("========================");
		
		String showId = request.getParameter("show_id");
		int scheduleId = Integer.parseInt(request.getParameter("schedule_id"));
		
		System.out.println("getSeatLiest() - show_id" + showId);
		System.out.println("getSeatList() - schedule_id" + scheduleId);
		//DAO에 넘길 map 생성
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("showId", showId);
		map.put("scheduleId", scheduleId);
		
		// DB 조회
		List<SeatDTO> list = dao.selectSeatList(map);
		
		// 화면 전달
		model.addAttribute("seatList", list);
		
	}

	// 좌석 상태 조회(실시간/새로고침)
	@Override
	public void getSeatStatus(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

	// 좌석 선택 저장 (결제 직전까지 유치: 세션 or 임시테이블)
	@Override
	public void selectSeats(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

	// 좌석 선택 취소
	@Override
	public void cancelSelectedSeats(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

}
