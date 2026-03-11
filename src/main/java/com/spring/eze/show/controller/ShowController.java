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
	
	@Autowired
	private ShowService showservice;


   
   // [공연메인] -------------
	@RequestMapping("")
    public String show(HttpServletRequest request, HttpServletResponse response, Model model)
         throws ServletException, IOException {
      log.info("ShowController - main화면");

      	showservice.getShowMain(request, response, model);
		return "show/show";
    }
	
	// [공연장르상세페이지] <방법A> 장르 탭  -------------
	@RequestMapping("/showList")
	public String showList(@RequestParam(value="category", defaultValue="concert")String category, 
			   			   @RequestParam(value="subCategory", defaultValue="all")String subCategory,
			   			   Model model)
		 throws ServletException, IOException {
      log.info("ShowController - 각 장르별 상세페이지 화면 ");
     
      showservice.prepareShowListPage(category, subCategory, model);
      return "show/showList";
	}
		
	// [공연장르상세페이지] <방법B> 공연 장르 탭 ajax 데이터 요청 -------
	@RequestMapping("/showListAjax")
	public String showListAjax(@RequestParam(value="category", defaultValue="concert")String category, 
							   @RequestParam(value="subCategory", defaultValue="all")String subCategory,
							   Model model)
		 throws ServletException, IOException {
	  log.info("ShowController - Ajax 데이터 요청 화면 (카테고리, 세부장르)");	
		
	  showservice.prepareShowListPage(category, subCategory, model);
	  return "show/showListContent";
	}
	
	// [공연상세페이지] 공연개별페이지 -----
	@RequestMapping("/showDetail")
	public String showDetail(@RequestParam("showId") String showId, Model model)
		throws ServletException, IOException {
		log.info("ShowController - 공연 상세페이지 화면 요청화면" + showId);	
		
		showservice.getShowDetail(showId, model);
		return "show/showDetail";
	}
	
	// [공연상세페이지] 공연개별상세페이지 탭 -----
	@RequestMapping("/getTabContentAjax")
	public String showDetailAjax(@RequestParam("showId") String showId, 
								 @RequestParam("tabName") String tabName, Model model)
		 throws ServletException, IOException {
	  log.info("ShowController - Ajax 데이터 요청 화면");	
		
	  showservice.getTabContent(showId, tabName, model);
	  return "show/tabs/" + tabName;
	}
	
	// [공연상세페이지] 날짜 선택 시 해당 날짜의 '시간 목록'만 가져오는 Ajax -----
	@RequestMapping("/getScheduleAjax")
	public String getScheduleAjax(@RequestParam("showId") String showId, 
	                              @RequestParam("playDate") String playDate, Model model)
		throws ServletException, IOException {
    log.info("ShowController - 날짜별 시간 목록 Ajax 요청: " + showId + ", " + playDate); 
    
    // 1. 서비스에서 해당 날짜의 시간 리스트만 가져오도록 별도 메서드 호출
    showservice.getScheduleByDate(showId, playDate, model);
    
    // 2. 전체 페이지가 아닌, 시간 버튼들만 있는 '조각 JSP'를 리턴
    return "show/scheduleTimeList"; 
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

	
   // [좌석] -------------
   // 좌석맵 조회(회차별)

	@RequestMapping("/seat")
	public String seat(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("ShowController - 좌석 선택 화면");

		seatService.getSeatList(request, response, model);
		return "show/seat";
    }

    @RequestMapping("/seat-detail")
    public String seatDetail(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        log.info("seatDetail");

        return "show/show-detail";
    }
	

	@PostMapping("/reserve")
	public String reserveSeat(HttpServletRequest request) {
	
	    return "show/seatres"; 
	}
	
	


	
 

}
