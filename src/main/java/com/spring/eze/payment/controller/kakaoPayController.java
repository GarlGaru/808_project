package com.spring.eze.payment.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.spring.eze.payment.dto.kakaopayapproveResponse;
import com.spring.eze.payment.dto.kakaopayorderRequest;
import com.spring.eze.payment.dto.kakaopayreadyResponse;
import com.spring.eze.payment.service.kakaopayService;

@Controller
@RequestMapping("/kakaopay") // ★ 여기 고정: /eze/kakaopay/...
public class kakaoPayController {

    private final kakaopayService kakaopayService;

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
    public String ready(kakaopayorderRequest req) {

        // 지금은 로그인 안 붙였으니까 임시 userId
        // 나중에 로그인 붙이면 여기서 user_tbl.user_id 가져와서 long으로 넘기면 됨
        long userId = 1L;

        // 지금은 예약도 아직 안 붙였으니까 임시 reservationId
        // 예약 붙이면 reservation_tbl에 먼저 insert하고 그 reservation_id를 넘겨야 함
        long reservationId = 0L;

        // 주문번호(문자열 PK) - 중복만 안 나면 됨
        String orderId = "TIC-" + System.currentTimeMillis();

        // (디버깅) 바인딩 확인용 - quantity가 null로 들어오면 여기서 바로 보임
        System.out.println("=== READY REQUEST ===");
        System.out.println("itemName=" + req.getItemName());
        System.out.println("quantity=" + req.getQuantity());
        System.out.println("totalPrice=" + req.getTotalPrice());

        // 서비스에서:
        // 1) DB 저장(READY)
        // 2) 카카오 ready 호출
        // 3) tid 업데이트
        kakaopayreadyResponse ready = kakaopayService.ready(req, orderId, userId, reservationId);

        // 카카오가 준 결제페이지로 이동
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
                          @RequestParam("userId") long userId,
                          Model model) {

        kakaopayapproveResponse approve = kakaopayService.approve(pgToken, orderId, userId);

        model.addAttribute("approve", approve);
        model.addAttribute("orderId", orderId);

        // /WEB-INF/views/payment/kakaoPayApprove.jsp
        // 테스트용
        //return "payment/kakaoPayApprove";
        // 실제로 쓸거(현재 메인으로보냄)
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
    	
    	kakaopayService.cancel(orderId, null); // null = 전체취소
    	
    	return "OK";
    }
    
}