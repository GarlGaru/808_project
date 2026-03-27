package com.spring.eze.board.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import com.spring.eze.board.dto.BoardDTO;

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

	public List<BoardDTO> getList();

	public int getTotalCnt(Map<String, Object> map);
	
	
	public int getTodayCount();

	List<BoardDTO> getTodayBoardList();
	   

}
