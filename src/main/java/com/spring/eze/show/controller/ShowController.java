package com.spring.eze.show.controller;


import com.spring.eze.main.service.MainService;
import com.spring.eze.payment.service.kakaopayService;
import com.spring.eze.show.dao.Show.ShowDAO;
import com.spring.eze.show.dto.Seat.SeatDTO;
import com.spring.eze.show.dto.Show.ShowDTO;
import com.spring.eze.show.dto.ranking.RankingDTO;
import com.spring.eze.show.dto.review.ReviewDTO;
import com.spring.eze.show.service.Seat.SeatService;
import com.spring.eze.show.service.ranking.RankingService;
import com.spring.eze.show.service.review.ReviewService;

import com.spring.eze.show.service.show.ShowService;
import com.spring.eze.user.dto.UserDTO;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.bind.annotation.RequestMethod;
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

	@Autowired
	private RankingService rankingService;
	
	@Autowired
	private kakaopayService kakaoService;
   
   // [공연메인] -------------
	@RequestMapping("")
    public String show(HttpServletRequest request, HttpServletResponse response, Model model)
         throws ServletException, IOException {
      log.info("ShowController - main화면");

      	model.addAttribute("menu", "default");
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
     
      model.addAttribute("menu", category);
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
	
	  model.addAttribute("menu", category);
	  showservice.prepareShowListPage(category, subCategory, model);
	  return "show/showListContent";
	}
	
	// [공연메인페이지] - 마이티켓연결
	@RequestMapping("/mypage/myTicket")
	public String myTicketPage(HttpSession session, Model model, HttpServletResponse response)
		 throws Exception {
		log.info("ShowController - 공연메인=>마이티켓연결");
		
		model.addAttribute("menu", "myticket");
		
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
		
		if(loginUser == null) {
		    // 모델에 경고창에 띄울 텍스트를 담음
		    model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
		    
		    return "show/mypage/message"; 
		}
		
		long userId = loginUser.getUserId();
		
		showservice.getMyTicketList(userId, model);
		
		return "show/mypage/myTicket";
	}
		
	// [결제] 마이티켓 예매취소------
	@PostMapping("/mypage/cancelTicket")
	@ResponseBody
	public Map<String, Object> processCancelTicket(@RequestParam("orderId") String orderId, HttpSession session) {
		log.info("ShowController - 마이티켓 예매취소");
		
		Map<String, Object> map = new HashMap<>();
		
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
		
		if(loginUser == null) {
			map.put("status", "fail");
			map.put("message", "로그인이 만료되었거나 로그인이 필요합니다.");
			return map;
		}
		
		try {
			System.out.println("예매취소요청 - userId: " + loginUser.getUserId() + "orderId: " + orderId);
			
			kakaoService.cancel(orderId, null);
			
			map.put("status", "success");
			map.put("message", "예매가 정상적으로 취소 및 환불되었습니다.");
		} catch(IllegalArgumentException | IllegalStateException e) {
			map.put("status", "fail");
			map.put("message", e.getMessage());
		} catch(Exception e) {
			e.printStackTrace();
			map.put("status", "error");
			map.put("message", "취소 처리 중 오류가 발생했습니다. 관리자에게 문의해주세요.");
		}
		
		return map;
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
	
	  model.addAttribute("showId", showId);
	  showservice.getTabContent(showId, tabName, model);
	  return "show/tabs/" + tabName;
	}
	
	
	// [공연상세페이지] 날짜 선택 시 해당 날짜의 '시간 목록'만 가져오는 Ajax -----
	@RequestMapping("/getScheduleAjax")
	public String getScheduleAjax(@RequestParam("showId") String showId, 
	                              @RequestParam("playDate") String playDate, Model model)
		throws ServletException, IOException {
    log.info("ShowController - 날짜별 시간 목록 Ajax 요청: " + showId + ", " + playDate); 
    log.info("showId= " + showId);
    log.info("playDate= " + playDate);
    
    // 1. 서비스에서 해당 날짜의 시간 리스트만 가져오도록 별도 메서드 호출
    showservice.getScheduleByDate(showId, playDate, model);
    
    // 2. 전체 페이지가 아닌, 시간 버튼들만 있는 '조각 JSP'를 리턴
    return "show/scheduleTimeList"; 
	}
	
   //[리뷰] -------------------
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
	    @RequestParam(value="showId") String showId, 
	    @RequestParam(value="page", required=false, defaultValue="1") int page, 
	    @RequestParam(value="sort", required=false, defaultValue="latest") String sort) {
	    
		log.info("리뷰 목록 요청 - showId=" + showId + ", page=" + page + ", sort=" + sort);
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
   
   // [랭킹 시작] ----------------
   // [랭킹 페이지] --------------
   @RequestMapping(value = "/ranking", method=RequestMethod.GET)
   public String showRanking(String category, Model model) {
	  
	  log.info("showController - 랭킹 화면");
	   
	  List<RankingDTO> rankingList = rankingService.getTicketRanking(category);
	  
	  System.out.println("가져온 랭킹 데이터: " + rankingList);
	  model.addAttribute("rankingList", rankingList);
	  model.addAttribute("currentCategory", category);
	  
	  return "show/ranking";
   }
   
   // [랭킹 ajax] -----------------
   @RequestMapping(value="/rankingAjax", method=RequestMethod.GET)
   public String rankingAjax(@RequestParam(defaultValue = "all") String category, Model model) {
	   log.info("showController - 랭킹 화면 ajax");
	   System.out.println(">>> 넘어온 카테고리: " + category);
	   
	   List<RankingDTO> rankingList = rankingService.getTicketRanking(category);
	   
	   // 데이터가 몇 건이나 나오는지 확인!
	   System.out.println(">>> 조회된 데이터 개수: " + (rankingList != null ? rankingList.size() : 0));
	    
	   model.addAttribute("rankingList", rankingList);
	   model.addAttribute("currentCategory", category);
	   
	   return "show/rankingContent";
   }
	
   // [좌석] -------------
   // 좌석맵 조회(회차별)
	@RequestMapping("/seat")
	public String seat(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("ShowController - 좌석 선택 화면");
		
		String showId = request.getParameter("showId");
		String scheduleId = request.getParameter("scheduleId");
		
		System.out.println("showId = " + showId);
		System.out.println("scheduleId = " + scheduleId);
		
		model.addAttribute("scheduleId",scheduleId);
		model.addAttribute("showId",showId);
		
		showservice.getShowDetail(showId, model);
		seatService.getSeatList(request, response, model);
		
		//공연장 레이아웃뜨
		String venueName = showservice.getVenueName(showId);
		System.out.println("=== venueName 확인: " + venueName);
		
		List<SeatDTO> layoutList = seatService.getSeatLayout(venueName);
		System.out.println("=== layoutList 사이즈: " + (layoutList != null ? layoutList.size() : "null"));
		    
		
		model.addAttribute("layoutList", layoutList);
		
		return "show/seat";
    }

	@GetMapping("/seatStatus")
	@ResponseBody
	public List<SeatDTO> getSeatStatus(@RequestParam String showId, @RequestParam int scheduleId) {
		
		return seatService.getSeatStatus(showId, scheduleId);
	}

    @ResponseBody
    @PostMapping("/reserveCheck")
    public String reserveCheck(
            @RequestParam("showId") String showId,
            @RequestParam("scheduleId") int scheduleId,
            @RequestParam("selectedSeats") List<String> seats, HttpSession session) {

    	UserDTO loginUser = (UserDTO)session.getAttribute("loginUser");
    	if(loginUser == null) {
    		return "login_required";
    	}
    	
    	String userId = String.valueOf(loginUser.getUserId());
    	
        boolean result = seatService.checkAndLockSeats(showId, scheduleId, seats, userId);
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
		

		seatService.getScheduleInfo(scheduleId, model);

		showservice.getScheduleInfo(scheduleId, model);
		

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
