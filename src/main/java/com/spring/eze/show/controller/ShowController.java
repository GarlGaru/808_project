package com.spring.eze.show.controller;


import com.spring.eze.main.service.MainService;
import com.spring.eze.show.dto.Seat.SeatDTO;
import com.spring.eze.show.service.Seat.SeatSerivce;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/show")
public class ShowController {
	
	private static final Logger log = LoggerFactory.getLogger(ShowController.class);

	@Autowired
    private MainService service;
	@Autowired
	private SeatSerivce seatservice;
	
	@RequestMapping("")
    public String show(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("ShowController - main화면");

		return "show/show";
    }

	
	@RequestMapping("/seat")
    public String seat(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("ShowController - seat화면");

		String scheduleId = request.getParameter("schedule_id");
	    List<SeatDTO> list = seatservice.getSeatList(scheduleId);

	    model.addAttribute("list", list);
	    return "show/seat_select";
    }
}
