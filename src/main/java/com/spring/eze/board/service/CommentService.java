package com.spring.eze.board.service;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import com.spring.eze.board.dto.CommentDTO;

public interface CommentService {
	
	public void CommentList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	public void updateComment(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	public void deleteComment(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	public void CommentInsert(HttpServletRequest request, HttpServletResponse response, Model model) 
	         throws ServletException, IOException;
	List<CommentDTO> getCommentList(int bno);
    void insertComment(CommentDTO dto);
}
