package com.spring.eze.show.service.show;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	public void prepareShowListPage(String category, Model model)
			throws ServletException, IOException {
		System.out.println("ShowServiceImpl - prepareShowListPage()");
		
		// 1. DB에서 리스트 가져오기
		List<ShowDTO> list = dao.getShowListByCategory(category);
		
		// 2. model에 필요한 값 담기
		model.addAttribute("list", list);
		model.addAttribute("currentCategory", category);
		
		// 장르별 
		String displayTitle = "콘서트";
		if(category.equals("musical")) displayTitle = "뮤지컬";
		else if(category.equals("play")) displayTitle = "연극";
		
		// 4. 화면에 값 전달
		model.addAttribute("pageTitle", displayTitle);
		
	}

}
