package com.spring.eze.show.controller;


import com.spring.eze.main.service.MainService;
import com.spring.eze.show.dao.Show.ShowDAO;
import com.spring.eze.show.dto.review.ReviewDTO;
import com.spring.eze.show.service.Seat.SeatService;

import com.spring.eze.show.service.review.ReviewService;

import com.spring.eze.show.service.show.ShowService;


import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.springframework.web.bind.annotation.RequestParam;


@Controller
@RequestMapping("/show")
public class ShowController {
   
   private static final Logger log = LoggerFactory.getLogger(ShowController.class);

    @Autowired
    private MainService service;
	@Autowired
	private SeatService seatService;
	@Autowired

	private ReviewService reviewService;

	private ShowService showservice;


   
   // [공연메인] -------------
	@RequestMapping("")
    public String show(HttpServletRequest request, HttpServletResponse response, Model model)
         throws ServletException, IOException {
      log.info("ShowController - main화면");

      	showservice.getShowMain(request, response, model);
		return "show/show";
    }


   //후기 목록 조회
   @RequestMapping("/reviewList")
   public String reviewList(HttpServletRequest request, HttpServletResponse response, Model model)
     throws ServletException, IOException {
         
         log.info("ShowController - reviewList");
         
         reviewService.reviewListAction(request, response, model);
         
          return "show/review";
     }
   
   //후기 작성 페이지
   @GetMapping("/writeReview")
   public String writeReviewForm(HttpServletRequest request, HttpServletResponse response, Model model)
		     throws ServletException, IOException {
   
	   log.info("ShowController - writeReview");
	   
	   reviewService.getConcertListAction(request, response, model);
	 
       return "show/writeReview"; // 위에서 만든 jsp 이름
   }

 //2. 작성한 후기 실제로 DB에 저장하기 (POST)
   @PostMapping("/insertReview")
   public String insertReview(HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes rttr)
		     throws ServletException, IOException {
	   
	   reviewService.reviewInsertAction(request, response, model);
	   rttr.addFlashAttribute("msg", "insertSuccess");
	   
      // 후기목록 페이지로 리턴
     return "redirect:/show/reviewList";
  }
   
	// 좌석맵 조회(회차별)

	
   // [공연장르상세페이지] -------------
	@RequestMapping("/showList")
	public String showList(@RequestParam(value="category", defaultValue="concert")String category, Model model)
         throws ServletException, IOException {
      log.info("ShowController - 각 장르별 상세페이지 화면");
     
      showservice.prepareShowListPage(category, model);
      return "show/show";
	}
	
//   // 콘서트 
//	@RequestMapping("/show/musicalList")
//	public String musicalList(HttpServletRequest request, HttpServletResponse response, Model model)
//	     throws ServletException, IOException {
//	  log.info("ShowController - 뮤지컬 상세페이지 화면");
//	 
//	  return "show/musicalList";
//	}
//	
//   // 콘서트 
//	@RequestMapping("/show/playList")
//	public String playList(HttpServletRequest request, HttpServletResponse response, Model model)
//	     throws ServletException, IOException {
//	  log.info("ShowController - 연극 상세페이지 화면");
//	 
//	  return "show/playList";
//	}
//	
   // [좌석] -------------
   // 좌석맵 조회(회차별)

	@RequestMapping("/seat")
	public String seat(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("ShowController - 좌석 선택 화면");

		seatService.getSeatList(request, response, model);
		return "show/seat";
    }
	

	@PostMapping("/seat")
	public String reserveSeat(HttpServletRequest request) {
	
	    return "show/seatres"; 
	}
	
	


	
 

}
