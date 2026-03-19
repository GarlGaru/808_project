package com.spring.eze.board.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
	private BoardService boardservice;

	@RequestMapping("/list")
	public String BoardList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("BoardController - getList");

		// 2. 변경된 필드명 적용
		boardservice.BoardList(request, response, model);

		return "board/boardlist";
	}

	@RequestMapping("/board_detail")
	public String board_detail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("BoardController - board_detail ");
		// 2. 변경된 필드명 적용
		boardservice.BoardDetail(request, response, model);

		return "board/board_detail";
	}

	@RequestMapping("/board_update")
	public String board_update(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("BoardController - board_detail");
		HttpSession session = request.getSession();
		Object loginUser = session.getAttribute("loginUser");

		if ("POST".equalsIgnoreCase(request.getMethod())) {
			// 2. 변경된 필드명 적용
			boardservice.updateBoard(request, response, model);
			return "redirect:/board/board_detail?bno=" + request.getParameter("bno");
		}

		// 2. 변경된 필드명 적용
		boardservice.BoardDetail(request, response, model);
		return "board/board_update";
	}

	@RequestMapping("/board_delete")
	public String board_delete(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {

	    log.info("BoardController - board_delete");

	    // 1. 서비스에서 삭제 로직 수행
	    boardservice.deleteBoard(request, response, model);

	    // 2. 파라미터 가져오기
	    String pageNum = request.getParameter("pageNum");
	    String pageSize = request.getParameter("pageSize");
	    String target = request.getParameter("target"); // 어디로 돌아갈지 결정하는 파라미터 추가

	    if (pageNum == null || pageNum.isEmpty()) pageNum = "1";
	    if (pageSize == null || pageSize.isEmpty()) pageSize = "10";

	    // 3. 목적지 결정
	    String redirectPath = "/board/list"; // 기본값 (일반 게시판)
	    
	    // 관리자 페이지에서 요청했을 경우 관리자용 리스트 주소로 변경
	    if ("admin".equals(target)) {
	        redirectPath = "/board/admin/board"; 
	    }

	    // 4. 결정된 경로로 리다이렉트
	    return "redirect:" + redirectPath + "?pageNum=" + pageNum + "&pageSize=" + pageSize;
	}
	@RequestMapping("/plusReadCnt")
	public String plusReadCnt(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("BoardController - plusReadCnt");

		// 2. 변경된 필드명 적용
		boardservice.plusReadCnt(request, response, model);
		boardservice.BoardDetail(request, response, model);

		return "board/board_detail";
	}

	@RequestMapping("/wrter")
	public String plusReadCnts(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("BoardController - wrter");
		HttpSession session = request.getSession();

		if (session.getAttribute("loginUser") == null) {
			log.warn("비로그인 사용자의 글쓰기 시도 차단");

			response.setContentType("text/html; charset=UTF-8");
			java.io.PrintWriter out = response.getWriter();

			out.println("<script>");
			out.println("alert('로그인이 필요한 서비스입니다.');");
			out.println("location.href='" + request.getContextPath() + "user/authModal';");
			out.println("</script>");
			out.flush();
			out.close();

			return null;
		}
		return "board/plusReadCnt";
	}

	@RequestMapping("/insertBoard")
	public String insertBoard(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {

		log.info("BoardController - insertBoard ");

		// 2. 변경된 필드명 적용
		boardservice.boardInsert(request, response, model);

		return "redirect:/board/list";
	}

	@RequestMapping("/admin/board")
	public String adminBoardList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("BoardController - adminBoardList (관리자 페이지)");

		// 2. 변경된 필드명 적용
		boardservice.BoardList(request, response, model);
		return "/admin2/boardtables";
	}
}