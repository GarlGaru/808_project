
package com.spring.eze.board.controller;

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


import com.spring.eze.board.service.BoardService;

@Controller
@RequestMapping("/board")
public class BoardController {

	private static final Logger log = LoggerFactory.getLogger(BoardController.class);

	@Autowired
	private BoardService service;

		
	

	@RequestMapping("/list")
	public String BoardList(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {
	    log.info("BoardController - getList");
	    
	    // Service에서 페이징 처리 및 데이터 조회를 모두 수행합니다.
	    service.BoardList(request, response, model);
	    
	    return "board/boardlist";
	}

	@RequestMapping("/board_detail")	
	public String board_detail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("BoardController - board_detail ");
		service.BoardDetail(request, response, model);

		return "board/board_detail";
	}

	@RequestMapping("/board_update")
	public String board_update(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("BoardController - board_detail");
		// POST 방식일 때(수정 버튼 클릭 시)
		if ("POST".equalsIgnoreCase(request.getMethod())) {
			service.updateBoard(request, response, model);
			// 수정 완료 후 상세 페이지로 이동 (bno 유지)
			return "redirect:/board/board_detail?bno=" + request.getParameter("bno");
		}

		// GET 방식일 때(수정 폼으로 이동 시)
		service.BoardDetail(request, response, model);
		return "board/board_update";

	}

	@RequestMapping("/board_delete")
	public String board_delete(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {

		log.info("BoardController - board_delete");

		service.deleteBoard(request, response, model);

		String viewPage = request.getContextPath() + "/board/list";

		response.sendRedirect(viewPage);

		return null;
	}

	@RequestMapping("/plusReadCnt")
	public String plusReadCnt(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("BoardController - plusReadCnt");

		// 1. 조회수 1 증가 
		service.plusReadCnt(request, response, model);

		// 2. 게시글 상세 내용 가져오기
		service.BoardDetail(request, response, model);

		return "board/board_detail";
	}
	
	
	@RequestMapping("/wrter")
	public String plusReadCnts(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("BoardController - wrter");


		return "board/plusReadCnt";
	}
	
	@RequestMapping("/insertBoard")
	public String insertBoard(HttpServletRequest request, HttpServletResponse response, Model model) 
	        throws ServletException, IOException {
	    
	    log.info("BoardController - insertBoard ");

	    service.boardInsert(request, response, model);
	    
	    return "redirect:/board/list";
	}
}