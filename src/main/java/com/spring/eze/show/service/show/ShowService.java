package com.spring.eze.show.service.show;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface ShowService {

	// 공연메인
	public void getShowMain(HttpServletRequest request, HttpServletResponse resposne, Model model)
		throws ServletException, IOException;
	
	// 상단탭 장르별 상세페이지
	public void prepareShowListPage(String category, String subCategory, Model model)
		throws ServletException, IOException;
	
	// 상세페이지
	public void getShowDetail(String showId, Model model)
		throws ServletException, IOException;
	
	// 날짜 회차
	public void getScheduleByDate(String showId, String playDate, Model model)
		throws ServletException, IOException;
	
	// 상세페이지 내 탭
	public void getTabContent(String showId, String tabName, Model model)
		throws ServletException, IOException;
	
	// 랭킹
	public void getShowRanking(HttpServletRequest request, HttpServletResponse resposne, Model model)
			throws ServletException, IOException;

	//seat 좌석용 추가
	public String getVenueName(String showId);

	// 마이티켓
	public void getMyTicketList(Long userId, Model model)
			throws ServletException, IOException;
	
	//좌석 선택 및 예매확인시 공연 회차정보따라오게
	public void getScheduleInfo(String scheduleId, Model model);
}
