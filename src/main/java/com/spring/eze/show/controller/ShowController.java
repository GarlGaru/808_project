package com.spring.eze.show.controller;


import com.spring.eze.main.service.MainService;
import com.spring.eze.show.dto.review.ReviewDTO;
import com.spring.eze.show.service.review.ReviewService;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/show")
public class ShowController {
   
   private static final Logger log = LoggerFactory.getLogger(ShowController.class);

   @Autowired
    private MainService service;
   
   @Autowired
    private ReviewService rservice;
   
   @RequestMapping("")
    public String show(HttpServletRequest request, HttpServletResponse response, Model model)
         throws ServletException, IOException {
      log.info("ShowController - main화면");

      return "show/show";
    }
   
   @RequestMapping("/reviewList")
   public String reviewList(HttpServletRequest request, HttpServletResponse response, Model model)
	         throws ServletException, IOException {
       
       List<ReviewDTO> reviews = rservice.getReviewList(request, response, model);
       int totalCount = rservice.getTotalReviewCount(request, response, model);
       String[] concertList = {"지킬앤하이드", "레미제라블", "데스노트", "오페라의유령", "위키드", 
               "맘마미아", "시카고", "캣츠", "킹키부츠", "노트르담드파리"};
       
       model.addAttribute("concertList", concertList);
       model.addAttribute("reviews", reviews);
       model.addAttribute("totalCount", totalCount);
       return "show/review";
   }
	 
}
