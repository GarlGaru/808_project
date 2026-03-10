package com.spring.eze.board.service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface BoardService {
	
	public void BoardList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	public void BoardDetail(HttpServletRequest request, HttpServletResponse response, Model model) 
	         throws ServletException, IOException;
	
	public void updateBoard(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	public void deleteBoard(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	
	public void plusReadCnt(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	public void boardInsert(HttpServletRequest request, HttpServletResponse response, Model model) 
	         throws ServletException, IOException;
	   

}
