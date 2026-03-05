package com.spring.eze.payment.service;

import java.util.HashMap;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;

import com.spring.eze.payment.dao.PaymentDAO;
import com.spring.eze.payment.dto.KakaoPayCancelResponse;
import com.spring.eze.payment.dto.PaymentOrderDTO;
import com.spring.eze.payment.dto.kakaopayapproveResponse;
import com.spring.eze.payment.dto.kakaopayorderRequest;
import com.spring.eze.payment.dto.kakaopayreadyResponse;

@Service
public class kakaopayServiceImpl implements kakaopayService {

    private final PaymentDAO paymentDAO;
    private final RestTemplate restTemplate = new RestTemplate();

    public kakaopayServiceImpl(PaymentDAO paymentDAO) {
        this.paymentDAO = paymentDAO;
    }

    // ====== KAKAO PAY (new open-api) ======
    private static final String READY_URL   = "https://open-api.kakaopay.com/online/v1/payment/ready";
    private static final String APPROVE_URL = "https://open-api.kakaopay.com/online/v1/payment/approve";
    // 되돌릴곳
    private static final String BASE_URL = "http://localhost/eze";

    // 취소 url
    private static final String CANCEL_URL  = "https://open-api.kakaopay.com/online/v1/payment/cancel";
    
    private HttpHeaders headers() {
        HttpHeaders h = new HttpHeaders();
        h.set("Authorization", "SECRET_KEY " + jndi("kakao/secretKey").trim());
        h.setContentType(MediaType.APPLICATION_JSON);
        return h;
    }

    private String jndi(String name) {
        try {
            Context ctx = new InitialContext();
            Object value = ctx.lookup("java:comp/env/" + name);
            return String.valueOf(value);
        } catch (Exception e) {
            throw new RuntimeException("JNDI lookup failed: " + name, e);
        }
    }

    // =========================
    // READY
    // =========================
    @Override
    public kakaopayreadyResponse ready(kakaopayorderRequest req,
                                       String orderId,
                                       long userId,
                                       long reservationId) {

        int qty = Integer.parseInt(req.getQuantity());
        int total = Integer.parseInt(req.getTotalPrice());

        String approvalUrl = BASE_URL + "/kakaopay/approve?orderId=" + orderId + "&userId=" + userId;
        String cancelUrl   = BASE_URL + "/kakaopay/cancel?orderId=" + orderId;
        String failUrl     = BASE_URL + "/kakaopay/fail?orderId=" + orderId;

        // 1) DB 저장 (READY)
        PaymentOrderDTO order = new PaymentOrderDTO();
        order.setOrderId(orderId);
        order.setReservationId(reservationId);
        order.setUserId(userId);
        order.setItemName(req.getItemName());
        order.setQuantity(qty);
        order.setTotalAmount(total);
        order.setStatus("READY");
        
        //확인작업
        String type = req.getPaymentType();
        if (!"TICKET".equals(type) && !"SUBSCRIBE".equals(type)) {
            throw new IllegalArgumentException("paymentType must be TICKET or SUBSCRIBE");
        }
        
        order.setPaymentType(req.getPaymentType()); // "TICKET" or "SUBSCRIBE"
       
        paymentDAO.insertOrder(order);

        // 2) 카카오 ready 호출 (JSON 바디)
        Map<String, Object> body = new HashMap<>();
        body.put("cid", "TC0ONETIME"); // 테스트 CID

        body.put("partner_order_id", orderId);
        body.put("partner_user_id", String.valueOf(userId));
        body.put("item_name", req.getItemName());
        body.put("quantity", qty);
        body.put("total_amount", total);
        body.put("tax_free_amount", 0);

        body.put("approval_url", approvalUrl);
        body.put("cancel_url", cancelUrl);
        body.put("fail_url", failUrl);

        HttpHeaders h = headers();
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, h);

        try {
            ResponseEntity<kakaopayreadyResponse> res =
                    restTemplate.postForEntity(READY_URL, entity, kakaopayreadyResponse.class);

            kakaopayreadyResponse resp = res.getBody();

            // 3) tid 저장
            if (resp != null && resp.getTid() != null) {
                PaymentOrderDTO upd = new PaymentOrderDTO();
                upd.setOrderId(orderId);
                upd.setTid(resp.getTid());
                paymentDAO.updateTid(upd);
            }

            return resp;

        } catch (HttpStatusCodeException e) {
            // ready 실패 → FAIL 업데이트
            PaymentOrderDTO fail = new PaymentOrderDTO();
            fail.setOrderId(orderId);
            fail.setStatus("FAIL");
            fail.setFailReason(e.getStatusCode() + " " + e.getResponseBodyAsString());
            paymentDAO.updateFail(fail);

            throw e;
        }
    }

    // =========================
    // APPROVE
    // =========================
    @Override
    public kakaopayapproveResponse approve(String pgToken,
                                          String orderId,
                                          long userId) {

        PaymentOrderDTO order = paymentDAO.selectOrder(orderId);

        Map<String, Object> body = new HashMap<>();
        body.put("cid", "TC0ONETIME");
        body.put("tid", order.getTid());
        body.put("partner_order_id", orderId);
        body.put("partner_user_id", String.valueOf(userId));
        body.put("pg_token", pgToken);

        HttpHeaders h = headers();
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, h);

        try {
            ResponseEntity<kakaopayapproveResponse> res =
                    restTemplate.postForEntity(APPROVE_URL, entity, kakaopayapproveResponse.class);

            // 승인 성공 → APPROVED
            PaymentOrderDTO upd = new PaymentOrderDTO();
            upd.setOrderId(orderId);
            upd.setStatus("APPROVED");
            paymentDAO.updateStatus(upd);
            
            // order 안에 paymentType 있다고 치면
            if ("TICKET".equals(order.getPaymentType())) {
                // 티켓 확정 처리
            } else if ("SUBSCRIBE".equals(order.getPaymentType())) {
                // 구독 시작 처리
            }

            return res.getBody();

        } catch (HttpStatusCodeException e) {
            // 승인 실패 → FAIL
            PaymentOrderDTO fail = new PaymentOrderDTO();
            fail.setOrderId(orderId);
            fail.setStatus("FAIL");
            fail.setFailReason(e.getStatusCode() + " " + e.getResponseBodyAsString());
            paymentDAO.updateFail(fail);
            

            throw e;
        }
    }

	@Override
	public KakaoPayCancelResponse cancel(String orderId, Integer cancelAmount) {
		
		PaymentOrderDTO order = paymentDAO.selectOrder(orderId);
		if(order == null) {
			//IllegalArgumentException orderId가 있는지없는지만 체크하는 내장함수
			throw new IllegalArgumentException("결제내역이 없습니다" + orderId);
		}
		
		//이미 취소상태면
		if("CANCEL".equals(order.getStatus())) {
			throw new IllegalArgumentException("이미 취소된 건입니다" + orderId);
		}
		
		//승인된 결제만 취소처리
		if(!"APPROVED".equals(order.getStatus())) {
			throw new IllegalArgumentException("APPROVED만 취소 current = " + order.getStatus());
		}
		
		if(order.getTid() == null || order.getTid().isBlank()) {
			throw new IllegalArgumentException("tid가 null입니다");
		}
		
		int amount = (cancelAmount == null) ? order.getTotalAmount() : cancelAmount;
		if(amount <= 0 ) throw new IllegalArgumentException("amount > 0");
		
		//카카오취소 cancel 요청바디
		Map<String, Object> body = new HashMap<>();
		body.put("cid", "TC0ONETIME"); //카카오 가맹점
		body.put("tid", order.getTid());
		body.put("cancel_amount", amount);
		body.put("cancel_tax_free_amount", 0); 	//카카오가요청하는 수수료? 무조건넣어야받음
		
		HttpHeaders h = headers();
		HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, h);
		
		try {
			ResponseEntity<KakaoPayCancelResponse> res = 
					restTemplate.postForEntity(CANCEL_URL, entity, KakaoPayCancelResponse.class);
			
			//취소성공시
			PaymentOrderDTO upd = new PaymentOrderDTO();
			upd.setOrderId(orderId);
			upd.setStatus("CANCEL");
			paymentDAO.updateStatus(upd);
			
			return res.getBody();
		} catch(HttpStatusCodeException e) {
			// 취소실패
			PaymentOrderDTO fail = new PaymentOrderDTO();
			fail.setOrderId(orderId);
			fail.setFailReason("CANCEL_FAIL:" + e.getStatusCode() + " " + e.getResponseBodyAsString());
			paymentDAO.updateFailReason(fail);
			
			throw e;
		}
		
	}
}