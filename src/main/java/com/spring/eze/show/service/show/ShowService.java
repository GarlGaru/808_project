package com.spring.eze.show.service.show;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface ShowService {

	public void getShowMain(HttpServletRequest request, HttpServletResponse resposne, Model model)
		throws ServletException, IOException;
	
	public void prepareShowListPage(String category, String subCategory, Model model)
		throws ServletException, IOException;
	
	public void getShowDetail(String showId, Model model)
		throws ServletException, IOException;
	
	public void getScheduleByDate(String showId, String playDate, Model model)
		throws ServletException, IOException;
	
	public void getTabContent(String showId, String tabName, Model model)
		throws ServletException, IOException;
	
	public void getShowRanking(HttpServletRequest request, HttpServletResponse resposne, Model model)
			throws ServletException, IOException;
	
	//seat 좌석용 추가
	public String getVenueName(String showId);
	
	//좌석 선택 및 예매확인시 공연 회차정보따라오게
	public void getScheduleInfo(String scheduleId, Model model);
}
