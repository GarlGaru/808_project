package com.spring.eze.show.service.show;

import java.io.IOException;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.eze.show.dao.Show.ShowDAO;
import com.spring.eze.show.dto.Show.ShowDTO;

@Service
public class ShowServiceImpl implements ShowService{
	
	@Autowired
	private ShowDAO dao;
	
	// 공연 메인
	@Override
	public void getShowMain(HttpServletRequest request, HttpServletResponse resposne, Model model)
			throws ServletException, IOException {
		System.out.println("ShowServiceImpl - getShowMain()");
		
		String genre = request.getParameter("genre");
		
		// 1. 장르 목록
		List<String> gList = Arrays.asList("대중음악", "뮤지컬", "연극");
		
		// 2. 상단 메인 공연
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("genre", genre);
		List<ShowDTO> list = dao.selectShowMainList(map);
	

		// 3. 하단 오픈 예정 공연
		List<ShowDTO> upcomingList = dao.selectShowUpcoming();

		System.out.println("genre=" + genre);
		System.out.println("main list size=" + list.size());
		
		// 4. 화면 전달
		model.addAttribute("gList", gList);
		model.addAttribute("list", list);
		model.addAttribute("upcomingList", upcomingList);
		model.addAttribute("selectedGenre", genre);
	}
	
	//공연 장르별 상세페이지
	@Override
	public void prepareShowListPage(String category, String subCategory, Model model)
			throws ServletException, IOException {
		System.out.println("ShowServiceImpl - prepareShowListPage()");
		
		// 1. DB에서 리스트 가져오기 
		List<ShowDTO> list = dao.getShowListByCategory(category, subCategory);
		
		// 2. model에 필요한 값 담기
		model.addAttribute("list", list);
		System.out.println("조회된 공연수: " + list.size());
		
		model.addAttribute("currentCategory", category);
		model.addAttribute("subCategory", subCategory);
		
		// 3. 장르별 
		String displayTitle = "콘서트";
		if(category.equals("musical")) displayTitle = "뮤지컬";
		else if(category.equals("play")) displayTitle = "연극";
		
		// 4. 화면에 값 전달
		model.addAttribute("pageTitle", displayTitle);
	}

	// 공연 개별 상세페이지
	@Override
	public void getShowDetail(String showId, Model model)
			throws ServletException, IOException {
		System.out.println("ShowServiceImpl - getShowDetail()");
		
		//1. dto를 통해 값전달
		ShowDTO dto = dao.getShowDetail(showId);
		
		//2. 화면에 값전달
		model.addAttribute("dto", dto);
		
		//3. 제목 등 추가 정보 전달
		if(dto != null) {
			boolean oneDay = false;
			
			if(dto.getStartDate() != null && dto.getEndDate() != null) {
				oneDay = dto.getStartDate().equals(dto.getEndDate());
			}
			
			model.addAttribute("oneDay", oneDay);
			model.addAttribute("pageTitle", dto.getTitle() + "- 상세정보");
		}
	}

	// 공연 상세페이지 - 날짜, 회차
	@Override
	public void getScheduleByDate(String showId, String playDate, Model model)
			throws ServletException, IOException {
		System.out.println("ShowServiceImpl - getScheduleByDate()");
		
		List<ShowDTO> list = dao.getShowSchedule(showId, playDate);
		
		model.addAttribute("list", list);
	}

	// 공연 상세페이지 - 탭
	@Override
	public void getTabContent(String showId, String tabName, Model model) 
			throws ServletException, IOException {
		System.out.println("ShowServiceImpl - getTabContent()");
		
		//1. dto 통해 값 전달
		ShowDTO dto = dao.getShowDetail(showId);
		System.out.println("DTO 결과: " + dto.getCastInfo());
		
		//2. 화면값 전달
		model.addAttribute("dto", dto);
	}

	// 공연 랭킹
	@Override
	public void getShowRanking(HttpServletRequest request, HttpServletResponse resposne, Model model)
			throws ServletException, IOException {
		System.out.println("ShowServiceImpl - getTabContent()");
		
		String genre = request.getParameter("category");
		
		if(genre == null || genre.trim().equals("")) {
			genre = "concert";
		}
		
		List<ShowDTO> list = dao.getShowRanking(genre);
		
		model.addAttribute("list", list);
		model.addAttribute("currentCategory", genre);
	}

}
