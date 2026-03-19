package com.spring.eze.board.service;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.eze.board.dao.BoardDAO;
import com.spring.eze.board.dto.BoardDTO;
import com.spring.eze.board.pageing.Pageing;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardDAO dao;

	// 1. 목록 조회 (페이징)
	// [BoardServiceImpl.java]
	@Override
	public void BoardList(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {
	    String pageNum = request.getParameter("pageNum");
	    if (pageNum == null || pageNum.isEmpty()) {
	        pageNum = "1";
	    }
	    String sort = request.getParameter("sort"); // 1. sort 파라미터 읽기 [cite: 20, 21]
	    String searchType = request.getParameter("searchType");
	    String keyword = request.getParameter("keyword");
	    
	    
	    Pageing paging = new Pageing(pageNum);
	    
	    Map<String, Object> map = new HashMap<>();
	    map.put("searchType", searchType);
	    map.put("keyword", keyword);
	    
	    
	    int totalCount = dao.boardCnt(map);
	    paging.setTotalCount(totalCount);

	    //Map<String, Object> map = new HashMap<>();
	    map.put("startRow", paging.getStartRow());
	    map.put("endRow", paging.getEndRow());
	    map.put("sort", sort); // 2. MyBatis로 넘길 맵에 sort 추가
	    
	    List<BoardDTO> bestList = dao.getBestList();

	    List<BoardDTO> list = dao.boardList(map);
	    System.out.println("DEBUG: list size = " + (list != null ? list.size() : "null"));
	    
	
	    model.addAttribute("bestList", bestList);
	    model.addAttribute("list", list);
	    model.addAttribute("paging", paging);
	    model.addAttribute("sort", sort); // 3. JSP에서 'checked' 상태 유지를 위해 다시 전달 [cite: 21, 22]
	    model.addAttribute("searchType", searchType); // 3. JSP에서 'checked' 상태 유지를 위해 다시 전달 [cite: 21, 22]
	    model.addAttribute("keyword", keyword); // 3. JSP에서 'checked' 상태 유지를 위해 다시 전달 [cite: 21, 22]
	    
	    System.out.println("검색 타입: " + searchType);
	    System.out.println("검색어: " + keyword);
	    System.out.println("결과 개수: " + totalCount);
	    
	}

	// 2. 상세 정보 조회
	@Override
	public void BoardDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		String bnoStr = request.getParameter("bno");
		
		if (bnoStr != null && !bnoStr.isEmpty()) {
			int bno = Integer.parseInt(bnoStr);
			BoardDTO dto = dao.getBoardDetail(bno);
			
			// JSP에서 ${dto.youtubeUrl}로 사용하므로 이름을 "dto"로 유지
			model.addAttribute("dto", dto);
			
			if (dto != null) {
				System.out.println("조회된 유튜브 URL: " + dto.getYoutubeUrl());
			}
		}
	}

	// 3. 게시글 수정 (유튜브 URL 추가)
	@Override
	public void updateBoard(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {
	    
	    // 1. Multipart 요청으로 캐스팅
	    MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
	    
	    // 2. 파라미터 읽기
	    int bno = Integer.parseInt(multipartRequest.getParameter("bno"));
	    int userId = Integer.parseInt(multipartRequest.getParameter("user_id"));
	    String title = multipartRequest.getParameter("title");
	    String content = multipartRequest.getParameter("content");
	    String youtubeUrl = multipartRequest.getParameter("youtubeUrl");
	    String oldFileName = multipartRequest.getParameter("board_image"); // 기존 파일명(hidden)

	    // 3. 새 파일 처리
	    MultipartFile file = multipartRequest.getFile("file"); 
	    String fileName = oldFileName; // 기본값은 기존 파일명

	    if (file != null && !file.isEmpty()) {
	        String uploadPath = request.getSession().getServletContext().getRealPath("/resources/images/board-image");
	        
	        // 기존 파일 삭제 (선택 사항: 서버 용량 관리를 위해 새 파일 업로드 시 기존 파일 삭제)
	        if (oldFileName != null && !oldFileName.isEmpty()) {
	            File oldFile = new File(uploadPath, oldFileName);
	            if (oldFile.exists()) oldFile.delete();
	        }

	        // 새 파일 저장
	        String originalName = file.getOriginalFilename();
	        fileName = UUID.randomUUID().toString() + "_" + originalName;

	        try {
	            file.transferTo(new File(uploadPath, fileName));
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    // 4. DTO 구성 및 DB 업데이트
	    BoardDTO dto = new BoardDTO();
	    dto.setBno(bno);
	    dto.setUserId(userId);
	    dto.setTitle(title);
	    dto.setContent(content);
	    dto.setYoutubeUrl(youtubeUrl);
	    dto.setBoard_image(fileName); 

	    dao.updateBoard(dto);
	}

	// 4. 게시글 삭제
	@Override
	public void deleteBoard(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		int bno = Integer.parseInt(request.getParameter("bno"));
		int userId = Integer.parseInt(request.getParameter("user_id"));

		BoardDTO dto = new BoardDTO();
		dto.setBno(bno);
		dto.setUserId(userId);

		dao.deleteBoard(dto);
	}

	// 5. 조회수 증가
	@Override
	public void plusReadCnt(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		String bnoParam = request.getParameter("bno");
		if (bnoParam != null && !bnoParam.isEmpty()) {
			int bno = Integer.parseInt(bnoParam);
			dao.plusReadCnt(bno);
		}
	}

	// 6. 게시글 등록 (유튜브 URL 추가)
	@Override
	public void boardInsert(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {

	    // 1. 세션 체크 (기존 유지)
	    HttpSession session = request.getSession();
	    com.spring.eze.user.dto.UserDTO loginUser = (com.spring.eze.user.dto.UserDTO) session.getAttribute("loginUser");

	    if (loginUser == null) {
	        response.sendRedirect(request.getContextPath() + "/authModal");
	        return;
	    }

	    // 2. MultipartHttpServletRequest로 캐스팅
	    // enctype="multipart/form-data" 환경에서는 이 객체를 통해 파라미터를 읽어야 합니다.
	    MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;

	    // 3. 파라미터 읽기 (multipartRequest 사용)
	    int userId = loginUser.getUserId();
	    String title = multipartRequest.getParameter("title");
	    String content = multipartRequest.getParameter("content");
	    String youtubeUrl = multipartRequest.getParameter("youtubeUrl");

	    // 4. 파일 처리 및 저장
	    MultipartFile file = multipartRequest.getFile("board-image"); // JSP의 input name과 일치해야 함
	    String fileName = ""; 

	    if (file != null && !file.isEmpty()) {
	        // 저장 경로: src/main/webapp/resources/images/board-image 
	        String uploadPath = request.getSession().getServletContext().getRealPath("/resources/images/board-image");
	        
	        // 디렉토리가 없으면 생성
	        File uploadDir = new File(uploadPath);
	        if (!uploadDir.exists()) {
	            uploadDir.mkdirs();
	        }

	        // 파일명 중복 방지를 위해 UUID 결합
	        String originalName = file.getOriginalFilename();
	        fileName = UUID.randomUUID().toString() + "_" + originalName;

	        try {
	            // 실제 서버 폴더에 파일 저장
	            file.transferTo(new File(uploadPath, fileName));
	        } catch (Exception e) {
	            e.printStackTrace();
	            // 에러 발생 시 로그 출력 등을 추가할 수 있습니다.
	        }
	    }

	    // 5. DTO 구성 및 DB 저장
	    BoardDTO dto = new BoardDTO();
	    dto.setUserId(userId);
	    dto.setTitle(title != null ? title : "제목 없음");
	    dto.setContent(content != null ? content : "");
	    dto.setYoutubeUrl(youtubeUrl);
	    dto.setBoard_image(fileName); // DB에 저장될 파일명 세팅 

	    dao.insertBoard(dto);
	}

	@Override
	public List<BoardDTO> getList() {
		// TODO Auto-generated method stub
		return null;
	}
}