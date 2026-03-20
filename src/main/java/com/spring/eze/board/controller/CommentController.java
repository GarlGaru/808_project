package com.spring.eze.board.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.eze.board.service.CommentService;


@Controller
@RequestMapping("/reply") // 1. 다시 /reply로 기준을 잡습니다.
public class CommentController {

	@Autowired
	private CommentService commentservice;


	@RequestMapping("/list")
	public String CommentList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("CommentController - CommentList");
		commentservice.CommentList(request, response, model);
		return "board/reply_list";
	}

	@RequestMapping("/insert")
	public String CommentInsert(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("CommentController - CommentInsert");
		commentservice.CommentInsert(request, response, model);
		return "board/reply_list";
	}
	
	@RequestMapping("/delete")
	public String deleteComment(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("CommentController - deleteComment");
		commentservice.deleteComment(request, response, model);
		
		return "board/reply_list";
	
	}
}
