package com.spring.eze.payment.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.spring.eze.payment.dto.kakaopayapproveResponse;
import com.spring.eze.payment.dto.kakaopayorderRequest;
import com.spring.eze.payment.dto.kakaopayreadyResponse;
import com.spring.eze.payment.service.kakaopayService;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.spring.eze.user.dto.UserDTO;
import com.spring.eze.user.service.MypageService;
import com.spring.eze.user.service.UserService;

@Controller
@RequestMapping("/kakaopay") // ★ 여기 고정: /eze/kakaopay/...
public class kakaoPayController {

    private final kakaopayService kakaopayService;
    
    @Autowired
    private MypageService mypageService;

    public kakaoPayController(kakaopayService kakaopayService) {
        this.kakaopayService = kakaopayService;
    }

    /**
     * 0) 테스트용 결제 폼
     * - 나중에 다른 페이지(공연/좌석/구독 등)에서 결제 버튼 누르면
     *   이 폼으로 "데이터 들고 들어오는 구조"로 바뀔 예정
     */
    @GetMapping("/form")
    public String form() {
        // /WEB-INF/views/payment/kakaoPayForm.jsp
        return "payment/kakaoPayForm";
    }

    /**
     * 1) READY: 결제 준비 요청
     * 사용자가 폼에서 itemName/quantity/totalPrice를 POST로 보냄
     * 우리는 주문번호(orderId) 만들고 DB에 READY 상태로 저장
     * 카카오 ready API 호출 -> 카카오 결제 페이지 URL 받아서 redirect
     */
    @PostMapping("/ready")
    public String ready(HttpServletRequest request, kakaopayorderRequest req) {

        HttpSession session = request.getSession();

        // 로그인 사용자
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            throw new IllegalArgumentException("로그인 정보가 없습니다.");
        }

        long userId = loginUser.getUserId();

        // 지금은 reservation 아직 안 붙였으니 임시값
        long reservationId = 0L;

        // 주문번호 생성
        String orderId = "TIC-" + System.currentTimeMillis();

        // 결제 타입
        String paymentType = req.getPaymentType();

        if ("TICKET".equals(paymentType)) {
            String showId = request.getParameter("showId");
            String scheduleId = request.getParameter("scheduleId");
            String[] selectedSeats = request.getParameterValues("selectedSeats");

            session.setAttribute("selectedSeats", selectedSeats);
            session.setAttribute("selectedShowId", showId);
            session.setAttribute("selectedScheduleId", scheduleId);

            System.out.println("=== TICKET READY REQUEST ===");
            System.out.println("showId=" + showId);
            System.out.println("scheduleId=" + scheduleId);
            System.out.println("selectedSeats=" + java.util.Arrays.toString(selectedSeats));

        } else if ("SUBSCRIBE".equals(paymentType)) {
            // 구독결제는 좌석정보 안 씀
            session.removeAttribute("selectedSeats");
            session.removeAttribute("selectedShowId");
            session.removeAttribute("selectedScheduleId");

            System.out.println("=== SUBSCRIBE READY REQUEST ===");
        }

        System.out.println("itemName=" + req.getItemName());
        System.out.println("quantity=" + req.getQuantity());
        System.out.println("totalPrice=" + req.getTotalPrice());
        System.out.println("userId=" + userId);

        kakaopayreadyResponse ready = kakaopayService.ready(req, orderId, userId, reservationId);

        return "redirect:" + ready.getNext_redirect_pc_url();
    }

    /**
     * 2) APPROVE: 결제 승인 요청(카카오가 redirect 해줌)
     * - 결제 성공하면 카카오가 approval_url로 GET redirect
     * - 이때 pg_token이 쿼리스트링으로 들어옴
     * - 세션 안 쓰는 구조면 orderId를 approval_url에 같이 붙여야 하고
     * - approve 호출할 때 DB에서 orderId로 tid 조회해서 사용
     */
    @GetMapping("/approve")
    public String approve(@RequestParam("pg_token") String pgToken,
                          @RequestParam("orderId") String orderId,
                          HttpSession session,
                          Model model) {
    	
    	 UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
    	    if (loginUser == null) {
    	        throw new IllegalArgumentException("로그인 정보가 없습니다.");
    	    }

    	    long userId = loginUser.getUserId();

        kakaopayapproveResponse approve = kakaopayService.approve(pgToken, orderId, userId);

        model.addAttribute("approve", approve);
        model.addAttribute("orderId", orderId);

        // /WEB-INF/views/payment/kakaoPayApprove.jsp
        // 테스트용
        //return "payment/kakaoPayApprove";
        // 승인 후 최신 회원정보 다시 조회
        
        // DB에서 최신 회원정보 다시 조회해서 세션 갱신
        
        UserDTO freshUser = mypageService.getUserWithProfile((int) userId);
        freshUser.setPassword(null);
        session.setAttribute("loginUser", freshUser);
       
        return "redirect:/main";
    }

    /**
     * 3) CANCEL: 사용자가 결제창에서 취소했을 때 카카오가 redirect
     * - cancel_url로 GET 호출됨
     */
    @GetMapping("/cancel")
    public String cancel(@RequestParam(value = "orderId", required = false) String orderId, Model model) {
        model.addAttribute("orderId", orderId);
        return "payment/kakaoPayCancel";
    }

    /**
     * 4) FAIL: 결제 실패(인증 실패 등)
     * - fail_url로 GET 호출됨
     */
    @GetMapping("/fail")
    public String fail(@RequestParam(value = "orderId", required = false) String orderId, Model model) {
        model.addAttribute("orderId", orderId);
        return "payment/kakaoPayFail";
    }
    
    
    //카카오 결제된거 취소(환불)
    @GetMapping("/request_cancel")
    @ResponseBody
    public String cancelRequest(@RequestParam("orderId") String orderId){
    	System.out.println("컨트롤러 orderId = [" + orderId + "]");
    	kakaopayService.cancel(orderId, null); // null = 전체취소
    	
    	return "OK";
    }
    
}