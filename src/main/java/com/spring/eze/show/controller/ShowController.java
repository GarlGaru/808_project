package com.spring.eze.show.controller;


import com.spring.eze.main.service.MainService;
import com.spring.eze.show.service.Seat.SeatService;
import com.spring.eze.show.service.show.ShowService;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/show")
public class ShowController {
   
   private static final Logger log = LoggerFactory.getLogger(ShowController.class);

    @Autowired
    private MainService service;
	@Autowired
	private SeatService seatService;
	@Autowired
	private ShowService showservice;

   
   // [공연메인] -------------
	@RequestMapping("")
    public String show(HttpServletRequest request, HttpServletResponse response, Model model)
         throws ServletException, IOException {
      log.info("ShowController - main화면");

      	showservice.getShowMain(request, response, model);
		return "show/show";
    }
	
   // [공연장르상세페이지] -------------
	@RequestMapping("/showList")
	public String showList(@RequestParam(value="category", defaultValue="concert")String category, Model model)
         throws ServletException, IOException {
      log.info("ShowController - 각 장르별 상세페이지 화면");
     
      showservice.prepareShowListPage(category, model);
      return "show/show";
	}
	
//   // 콘서트 
//	@RequestMapping("/show/musicalList")
//	public String musicalList(HttpServletRequest request, HttpServletResponse response, Model model)
//	     throws ServletException, IOException {
//	  log.info("ShowController - 뮤지컬 상세페이지 화면");
//	 
//	  return "show/musicalList";
//	}
//	
//   // 콘서트 
//	@RequestMapping("/show/playList")
//	public String playList(HttpServletRequest request, HttpServletResponse response, Model model)
//	     throws ServletException, IOException {
//	  log.info("ShowController - 연극 상세페이지 화면");
//	 
//	  return "show/playList";
//	}
//	
   // [좌석] -------------
   // 좌석맵 조회(회차별)
	@RequestMapping("/seat")
	public String seat(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("ShowController - 좌석 선택 화면");

		seatService.getSeatList(request, response, model);
		return "show/seat";
    }
	

	
 
}
