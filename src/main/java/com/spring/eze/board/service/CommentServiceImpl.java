package com.spring.eze.board.service;


import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;


import com.spring.eze.board.dao.CommentDAO;
import com.spring.eze.board.dto.BoardDTO;
import com.spring.eze.board.dto.CommentDTO;


@Service
public class CommentServiceImpl implements CommentService {
    
    @Autowired
    private CommentDAO commentdao;

    // 1. 댓글 목록 조회
    @Override
    public void CommentList(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        // 방어 로직 없이 바로 파싱하여 DAO 호출
        int bno = Integer.parseInt(request.getParameter("bno"));
        model.addAttribute("list", commentdao.CommentList(bno));
    }
    
    // 2. 댓글 등록
    @Override
    public void CommentInsert(HttpServletRequest request, HttpServletResponse response, Model model) 
            throws ServletException, IOException {
        
        // 파라미터를 즉시 int로 변환하여 DTO에 세팅
        CommentDTO dto = new CommentDTO();
        dto.setBno(Integer.parseInt(request.getParameter("bno")));
        dto.setUserId(Integer.parseInt(request.getParameter("userId")));
        dto.setContent(request.getParameter("content"));
        dto.setNickname(request.getParameter("nickname"));
        
        commentdao.insertComment(dto);        
        
        // 등록 직후 목록 갱신을 위해 데이터 다시 담기
        model.addAttribute("list", commentdao.CommentList(dto.getBno()));
    }

    // 3. 댓글 삭제
    @Override
    public void deleteComment(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        
        int cno = Integer.parseInt(request.getParameter("cno"));
        int bno = Integer.parseInt(request.getParameter("bno"));

        CommentDTO dto = new CommentDTO();
        dto.setCno(cno);
        
        commentdao.deleteComment(dto);	
        
        // 삭제 후 목록 갱신
        model.addAttribute("list", commentdao.CommentList(bno));
    }

    // 4. 댓글 수정
	@Override
	public void updateComment(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
        
        int cno = Integer.parseInt(request.getParameter("cno"));
        String content = request.getParameter("content");

        CommentDTO dto = new CommentDTO();
        dto.setCno(cno);
        dto.setContent(content);
        
        commentdao.updateComment(dto);
	}

	@Override
	public List<CommentDTO> getCommentList(int bno) {
		// DAO의 id인 CommentList를 호출
        return commentdao.CommentList(bno);
	}

	@Override
	public void insertComment(CommentDTO dto) {
		   // DAO의 id인 insertComment를 호출
        commentdao.insertComment(dto);		
	}
}