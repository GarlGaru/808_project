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
//		List<ShowDTO> list = dao.selectShowMainList(map);
		List<ShowDTO> list = new ArrayList<ShowDTO>();

		// 3. 하단 오픈 예정 공연
//		List<ShowDTO> upcomingList = dao.selectShowUpcoming();
		List<ShowDTO> upcomingList = new ArrayList<ShowDTO>();

		System.out.println("genre=" + genre);
		System.out.println("main list size=" + list.size());
		
		// 4. 화면 전달
		model.addAttribute("gList", gList);
		model.addAttribute("list", list);
		model.addAttribute("upcomingList", upcomingList);
		model.addAttribute("selectedGenre", genre);
	}

}
