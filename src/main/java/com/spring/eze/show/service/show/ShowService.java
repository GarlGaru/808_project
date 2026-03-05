package com.spring.eze.show.service.show;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface ShowService {

	public void getShowMain(HttpServletRequest request, HttpServletResponse resposne, Model model)
		throws ServletException, IOException;
	
	public void prepareShowListPage(String category, Model model)
		throws ServletException, IOException;
}
