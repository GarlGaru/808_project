package com.spring.eze.show.service.Seat;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.management.RuntimeErrorException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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
		    System.out.println("show_id: " + request.getParameter("showId"));
		    System.out.println("schedule_id: " + request.getParameter("scheduleId"));
		    System.out.println("========================");
		
		String showId = request.getParameter("show_id");
		//int scheduleId = Integer.parseInt(request.getParameter("schedule_id"));
		String scheduleIdStr = request.getParameter("scheduleId"); 

	    int scheduleId = 0; 
	    
	    // 2. 숫자로 바꾸기 전 체크 (안전장치)
	    if (scheduleIdStr != null && !scheduleIdStr.isEmpty()) {
	        scheduleId = Integer.parseInt(scheduleIdStr);
	    } else {
	        // 데이터가 없으면 일단 로그를 찍고 0이나 기본값을 부여해
	        System.out.println("⚠️ 파라미터 scheduleId가 전달되지 않았습니다.");
	    }
		
		
		System.out.println("getSeatLiest() - show_id" + showId);
		System.out.println("getSeatList() - schedule_id" + scheduleId);
		//DAO에 넘길 map 생성
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("showId", showId);
		map.put("scheduleId", scheduleId);
		
		// DB 조회
		List<SeatDTO> list = dao.selectSeatList(map);
		//List<SeatDTO> list = new ArrayList<SeatDTO>();
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
		String showId = request.getParameter("showId");
		int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
		String[] selectedSeats = request.getParameterValues("selectedSeats");
		
		
		//로그인한 유저 아이디 가져오기
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("userId");
		if(userId == null) userId="GUEST_USER"; //미로그인 시 임시값
		
		Map<String, Object> map = new HashMap<>();
		map.put("showId", showId);
		map.put("scheduleId", scheduleId);
		map.put("userId", userId);
		map.put("seatLabels", Arrays.asList(selectedSeats));
		
		//DB업데이트 시도
		int result = dao.updateHoldSeats(map);
		
		if(result < selectedSeats.length) {
			throw new RuntimeException("이미 선택 된 좌석입니다.");
		}
		
		
	}

	// 좌석 선택 취소
	@Override
	public void cancelSelectedSeats(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		//ajax에서 보낸 데이터들 꺼냄
		String showId = request.getParameter("showId");
		String scheduleId = request.getParameter("scheduleId");
		String[] seatLabels = request.getParameterValues("seatLabels[]"); //ajax배열 명칭 주의
		
		if(seatLabels != null && seatLabels.length > 0) {
			Map<String, Object> map = new HashMap<>();
			map.put("showId", showId);
			map.put("scheduleId", Integer.parseInt(scheduleId));
			map.put("seatLabels", Arrays.asList(seatLabels));
			
			dao.updateReleaseSeats(map);
		}
		
	}

	@Override
	public List<SeatDTO> getSeatStatus(String showId, int scheduleId) {
		Map<String, Object> map = new HashMap<>();
		map.put("showId", showId);
		map.put("scheduleId", scheduleId);
		
		return dao.selectSeatStatus(map);
		
	}
	@Override
	@Transactional
	public boolean checkAndLockSeats(String showId, int scheduleId, List<String> seats){
		
//	    boolean isAvailable = dao.checkAndLockSeats(showId, scheduleId, seats);
//	    
//	    if (!isAvailable) return false;

	    Map<String, Object> map = new HashMap<>();
	    map.put("showId", showId);
	    map.put("scheduleId", scheduleId);
	    map.put("userId", "TEMP_USER"); // 실제로는 세션의 loginUserId 사용
	    map.put("seatLabels", seats);

//	    int result = dao.updateHoldSeats(map);
//	    
//	    return result == seats.size();
	    
	    return true; //발표용 return
	}

}
