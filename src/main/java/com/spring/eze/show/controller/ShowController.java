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
   
   // [좌석] -------------
   // 좌석맵 조회(회차별)
	@RequestMapping("/seat")
	public String seat(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("ShowController - 좌석 선택 화면");

		seatService.getSeatList(request, response, model);
		return "show/seat";
    }

    @RequestMapping("/seat-detail")
    public String seatDetail(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        log.info("seatDetail");

        return "show/show-detail";
    }
	

	
 
}
