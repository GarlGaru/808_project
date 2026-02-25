package com.spring.eze.show.service.Seat;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.eze.show.dao.Seat.SeatDAO;
import com.spring.eze.show.dto.Seat.SeatDTO;

@Service
public class SeatServiceImpl implements SeatSerivce {

	@Autowired
	private SeatDAO dao;
	
	@Override
	public void getSeatList(HttpServletRequest request, HttpServletResponse reponse, Model model)
			throws ServletException, IOException {
		System.out.println("SeatServiceImpl - getSeatList()");
		
		String schedule_id = request.getParameter("schedule_id");
		List<SeatDTO> list = dao.getSeatList(schedule_id);
		
		model.addAttribute("list",list);
	}

}
