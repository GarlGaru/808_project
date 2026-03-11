package com.spring.eze.show.controller;


import com.spring.eze.main.service.MainService;
import com.spring.eze.show.dao.Show.ShowDAO;
import com.spring.eze.show.dto.Seat.SeatDTO;
import com.spring.eze.show.dto.review.ReviewDTO;
import com.spring.eze.show.service.Seat.SeatService;

import com.spring.eze.show.service.review.ReviewService;

import com.spring.eze.show.service.show.ShowService;
import com.spring.eze.user.dto.UserDTO;

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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


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

////리 뷰 긔!!!!!!!!!!!!////////////////////////////////////////////////////////////
	
   //리뷰 목록 조회
//   @ResponseBody
//   @GetMapping("/reviewList")
//   public List<ReviewDTO> reviewList(
//		   @RequestParam String showId, 
//		   @RequestParam int page, 
//		   @RequestParam String sort) {
//	   return reviewService.getReviewPaging(showId, page, sort);
//     }
   
	// 1. 이 주소는 '화면(JSP)'을 띄워주는 용도야! (@ResponseBody 쓰면 안 돼!)
	@GetMapping("/review")
	public String reviewPage(Model model) {
	    log.info("리뷰 테스트 페이지 접속");
	    // 테스트용 공연 ID를 모델에 담아서 JSP로 보내줌
	    model.addAttribute("showId", "PF_test_001"); 
	    return "show/review"; // WEB-INF/views/show/review.jsp를 찾아가라!
	}
	
	@ResponseBody
	@GetMapping("/reviewList")
	public List<ReviewDTO> reviewList(
	    @RequestParam(value="showId", required=false, defaultValue="PF_test_001") String showId, 
	    @RequestParam(value="page", required=false, defaultValue="1") int page, 
	    @RequestParam(value="sort", required=false, defaultValue="latest") String sort) {
	    
	    log.info("리뷰 목록 요청 - showId: {}, page: {}, sort: {}", showId, page);
	    return reviewService.getReviewPaging(showId, page, sort);
	}
	
   //후기 작성 페이지
   @ResponseBody
   @PostMapping("/reviewInsert")
   public String reviewInsert(@RequestBody ReviewDTO dto, HttpSession session) {
	   
	   log.info("ShowController - reviewInsert");
	   
	   UserDTO loginUser = (UserDTO)session.getAttribute("loginUser");
	   
	   if(loginUser == null) {
		   return "login_required";
	   }
	   
	   dto.setUserNum(loginUser.getUserId());
	   dto.setNickname(loginUser.getNickname());
	   
	   reviewService.insertReview(dto);
       return "success"; 
   }

   //후기 수정
   @ResponseBody
   @PostMapping("/reviewUpdate")
   public String reviewUpdate(@RequestBody ReviewDTO dto, HttpSession session) {
	   
	   UserDTO loginUser = (UserDTO)session.getAttribute("loginUser");
	   
	   if(loginUser == null) {
		   return "login_required";
	   }
	   
	   dto.setUserNum(loginUser.getUserId());
	   
	   boolean result = reviewService.reviewUpdateAction(dto);
	   
	   if(result) {
		   return "success";
	   }else {
		   return "fail";
	   }
   }
   
   @ResponseBody
   @PostMapping("/reviewDelete")
   public String reviewDelete(@RequestParam int reviewId,  HttpSession session) {
	   
	   
	   UserDTO loginUser = (UserDTO)session.getAttribute("loginUser");
	   
	   if(loginUser == null) {
		   return "login_required";
	   }
	   
			   boolean result = reviewService.deleteReview(reviewId, loginUser.getUserId());
			   
			   if(result) {
				   return"success";
			   }else {
				   return "fail";
			   }
			   
   }
   
   @ResponseBody
   @GetMapping("/reviewAvg")
   public double reviewAvg(String showId) {
	   
	   return reviewService.getAvgRating(showId);
   }
   
   // 리 뷰 끝 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
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
	
//// 여기부터 좌석이긔긔긔!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   // 좌석맵 조회(회차별)

	@RequestMapping("/seat")
	public String seat(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("ShowController - 좌석 선택 화면");

		seatService.getSeatList(request, response, model);
		return "show/seat";
    }

	@GetMapping("/seatStatus")
	@ResponseBody
	public List<SeatDTO> getSeatStatus(@RequestParam String showId, @RequestParam int scheduleId) {
		
		return seatService.getSeatStatus(showId, scheduleId);
	}
	
    @RequestMapping("/seat-detail")
    public String seatDetail(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        log.info("seatDetail");

        return "show/show-detail";
    }
	

    @ResponseBody
    @PostMapping("/reserveCheck")
    public String reserveCheck(
            @RequestParam("show_id") String showId,
            @RequestParam("scheduleId") int scheduleId,
            @RequestParam("selectedSeats") List<String> seats) {

        boolean result = seatService.checkAndLockSeats(showId, scheduleId, seats);

        return result ? "success" : "fail";
    }
    
	@PostMapping("/reserve")
	public String reserveSeat(HttpServletRequest request, HttpServletResponse reponse, Model model)
			throws ServletException, IOException{
		log.info("ShowController - 좌석 선점 및 예약 확인 페이지 이동");
		
		try {
			//seatService.selectSeats(request, reponse, model);
		
		String[] selectedSeats = request.getParameterValues("selectedSeats");
		String showId = request.getParameter("showId");
		String scheduleId = request.getParameter("scheduleId");
		
		if (selectedSeats == null || selectedSeats.length == 0) {
            return "redirect:/show/seat"; 
        }
		
		model.addAttribute("selectedSeats",selectedSeats);
		model.addAttribute("showId", showId);
		model.addAttribute("scheduleId",scheduleId);
		
	    return "show/seatres"; 
	    
		}catch(Exception e) {
			model.addAttribute("errorMsg", "이미 선택된 좌석이 포함되어 있습니다.");
			return "show/seatres";
		}
	}
	
	//타이머 5분 후 좌석 해지 Ajax용
	@ResponseBody
	@PostMapping("/release")
	public String releaseSeats(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("Showcontroller - 타이머 종료로 인한 좌석해제(Ajax)");
		
		try {
			seatService.cancelSelectedSeats(request, response, model);
			return "success";
			
		}catch (Exception e) {
			return "fail";
		}
	}
	
	


	
 

}
