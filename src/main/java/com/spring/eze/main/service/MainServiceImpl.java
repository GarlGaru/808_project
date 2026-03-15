package com.spring.eze.main.service;

import com.spring.eze.main.dao.MainDAO;
import com.spring.eze.main.dto.TestDTO;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

@Service
public class MainServiceImpl implements MainService {

	@Autowired
	private MainDAO dao;

	@Override
	public void testDBconnection(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		TestDTO dto = dao.testDBConnection();
		System.out.println(dto);

		model.addAttribute("showMe", dto.getShowMe() );
	}
}
