package com.spring.eze.board.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.eze.board.dao.BoardDAO;
import com.spring.eze.board.dto.BoardDTO;
import com.spring.eze.board.pageing.Pageing;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardDAO dao;

	// 1. 목록 조회 (페이징)
	@Override
	public void BoardList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		String pageNum = request.getParameter("pageNum");
		Pageing paging = new Pageing(pageNum);

		int totalCount = dao.boardCnt();
		paging.setTotalCount(totalCount);

		Map<String, Object> map = new HashMap<>();
		map.put("startRow", paging.getStartRow());
		map.put("endRow", paging.getEndRow());

		List<BoardDTO> list = dao.boardList(map);
		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		for(BoardDTO u : list) {
			System.out.println("list = " + u);
		}
	}

	// 2. 상세 정보 조회
	@Override
	public void BoardDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		String bnoStr = request.getParameter("bno");
		String ninkStr = request.getParameter("nickname");
		System.out.println("nickname +> "+ ninkStr);
		if (bnoStr != null && !bnoStr.isEmpty()) {
			int bno = Integer.parseInt(bnoStr); // bno도 int로 즉시 변환
			BoardDTO dto = dao.getBoardDetail(bno);
			if (dto != null) {
	            System.out.println("DB에서 재활용하기 위해 가져온 닉네임 => " + dto.getNickname());
	        }
			
			model.addAttribute("dto", dto);
		}
	}

	// 3. 게시글 수정 (userId를 처음부터 int로 처리)
	@Override
	public void updateBoard(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("BoardServiceImpl - updateBoard");

		// 받자마자 int로 변환 (userId는 int형)
		int bno = Integer.parseInt(request.getParameter("bno"));
		int userId = Integer.parseInt(request.getParameter("user_id"));
		String title = request.getParameter("title");
		String content = request.getParameter("content");

		BoardDTO dto = new BoardDTO();
		dto.setBno(bno);
		dto.setUserId(userId); // int형 userId 세팅
		dto.setTitle(title);
		dto.setContent(content);

		dao.updateBoard(dto);
	}

	// 4. 게시글 삭제 (userId를 처음부터 int로 처리)
	@Override
	public void deleteBoard(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("BoardServiceImpl - deleteBoard");

		// 받자마자 int로 변환
		int bno = Integer.parseInt(request.getParameter("bno"));
		int userId = Integer.parseInt(request.getParameter("user_id"));

		BoardDTO dto = new BoardDTO();
		dto.setBno(bno);
		dto.setUserId(userId); // int형 userId 세팅

		dao.deleteBoard(dto);
	}

	// 5. 조회수 증가
	@Override
	public void plusReadCnt(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		String bnoParam = request.getParameter("bno");
		if (bnoParam != null && !bnoParam.isEmpty()) {
			int bno = Integer.parseInt(bnoParam); // int 변환
			dao.plusReadCnt(bno);
		}
	}

	// 6. 게시글 등록 (userId를 처음부터 int로 처리)
	@Override
	public void boardInsert(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("BoardServiceImpl - boardInsert");

		HttpSession session = request.getSession();
		com.spring.eze.user.dto.UserDTO loginUser = (com.spring.eze.user.dto.UserDTO) session.getAttribute("loginUser");

		int userId = 0;
		if (loginUser != null) {
			// 2. 객체에서 직접 숫자로 된 ID를 꺼냅니다.
			userId = loginUser.getUserId();
		} else {
			// 로그인이 안 된 경우에 대한 예외 처리 (로그인 페이지 리다이렉트 등)
			response.sendRedirect(request.getContextPath() + "/authModal");
			return;
		}
		String title = request.getParameter("title");
		String content = request.getParameter("content");

		BoardDTO dto = new BoardDTO();
		dto.setUserId(userId); // 이미 int인 userId를 DTO에 전달
		dto.setTitle(title);
		dto.setContent(content);

		dao.insertBoard(dto);
	}
}