package com.spring.eze.payment.service;

import java.util.HashMap;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
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
import com.spring.eze.user.dto.UserDTO;

@Service
public class kakaopayServiceImpl implements kakaopayService {

	//결제취소시 세션아이디필요함
	// 매 메서드마다 세션에서 loginUser 꺼내는 코드가 반복되므로 private 메서드로 분리해서 중복 제거
	@Autowired
	private HttpSession session;
	
	private UserDTO getLoginUser() {
	    UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
	    System.out.println("loginUser = " + loginUser);
	    System.out.println("loginUser.userId = " + (loginUser != null ? loginUser.getUserId() : null));
	    return loginUser;
	}
	
	
    // DB 접근용 DAO
    // payment_order 같은 결제 관련 테이블 insert / update / select 담당
    private final PaymentDAO paymentDAO;

    // 외부 REST API 호출용 객체
    // 여기서는 카카오페이 ready / approve / cancel 호출에 사용
    private final RestTemplate restTemplate = new RestTemplate();

    // 생성자 주입
    public kakaopayServiceImpl(PaymentDAO paymentDAO) {
        this.paymentDAO = paymentDAO;
    }

    // =========================
    // 카카오페이 Open API 엔드포인트
    // =========================

    // 결제 준비(ready) 요청 URL
    // 사용자가 결제하기 버튼 눌렀을 때 첫 번째로 호출됨
    private static final String READY_URL   = "https://open-api.kakaopay.com/online/v1/payment/ready";

    // 결제 승인(approve) 요청 URL
    // 사용자가 카카오 결제창에서 결제를 완료한 뒤,
    // 카카오가 pg_token을 가지고 우리 approval_url로 리다이렉트하면 호출됨
    private static final String APPROVE_URL = "https://open-api.kakaopay.com/online/v1/payment/approve";

    // 우리 서버 기준 기본 주소
    // 카카오 ready 요청 시 approval_url / cancel_url / fail_url 만들 때 사용
    // 주의: 지금 localhost라 실제 배포/외부 테스트 시엔 접근 불가할 수 있음
    private static final String BASE_URL = "http://localhost/eze";

    // 결제 취소(cancel) 요청 URL
    private static final String CANCEL_URL  = "https://open-api.kakaopay.com/online/v1/payment/cancel";

    /**
     * 카카오 API 요청용 공통 헤더 생성
     *
     * Authorization:
     *   JNDI에 등록된 secret key를 읽어서 카카오 인증 헤더로 사용
     *
     * Content-Type:
     *   카카오 Open API는 JSON 바디를 받으므로 application/json 설정
     */
    private HttpHeaders headers() {
        HttpHeaders h = new HttpHeaders();
        h.set("Authorization", "SECRET_KEY " + jndi("kakao/secretKey").trim());
        h.setContentType(MediaType.APPLICATION_JSON);
        return h;
    }

    /**
     * JNDI 값 조회
     *
     * 예:
     *   java:comp/env/kakao/secretKey
     *
     * 보통 server.xml / context.xml 또는 톰캣 환경설정에 넣어둔 값을 읽어오는 용도
     * API 키를 코드에 직접 박지 않기 위해 사용
     */
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
    /**
     * 카카오 결제 준비 단계
     *
     * 역할:
     * 1. 우리 DB에 주문(order) 정보를 READY 상태로 먼저 저장
     * 2. 카카오페이에 ready 요청
     * 3. 카카오에서 받은 tid(거래번호)를 우리 DB에 저장
     * 4. 프론트는 응답으로 받은 next_redirect_pc_url 등으로 카카오 결제창 이동
     *
     * @param req           화면에서 받은 결제 요청 정보 (상품명, 수량, 금액, 결제타입 등)
     * @param orderId       우리 시스템 주문번호
     * @param userId        결제 사용자 번호
     * @param reservationId 예매번호 (티켓 결제인 경우 연결될 예약번호)
     */
    @Override
    public kakaopayreadyResponse ready(kakaopayorderRequest req,
                                       String orderId,
                                       long userId,
                                       long reservationId) {

        // 프론트에서 문자열로 넘어온 수량/총금액을 숫자로 변환
        int qty = Integer.parseInt(req.getQuantity());
        int total = Integer.parseInt(req.getTotalPrice());

        // 카카오 ready 요청 시 같이 넘겨줄 리다이렉트 주소들
        // approval_url : 결제 성공 후 카카오가 되돌아올 주소
        // cancel_url   : 사용자가 결제창에서 취소 눌렀을 때 돌아올 주소
        // fail_url     : 결제 실패 시 돌아올 주소
        String approvalUrl = BASE_URL + "/kakaopay/approve?orderId=" + orderId + "&userId=" + userId;
        String cancelUrl   = BASE_URL + "/kakaopay/cancel?orderId=" + orderId;
        String failUrl     = BASE_URL + "/kakaopay/fail?orderId=" + orderId;

        // -------------------------
        // 1) 우리 DB에 주문 정보 먼저 저장
        // -------------------------
        // 왜 먼저 저장하냐?
        // -> 카카오 결제창 갔다가 돌아왔을 때 orderId 기준으로 결제 흐름을 추적하기 위해
        PaymentOrderDTO order = new PaymentOrderDTO();
        order.setOrderId(orderId);               // 우리 주문번호
        order.setReservationId(reservationId);   // 연결된 예약번호
        order.setUserId(userId);                 // 결제한 사용자
        order.setItemName(req.getItemName());    // 상품명
        order.setQuantity(qty);                  // 수량
        order.setTotalAmount(total);             // 총 결제금액
        order.setStatus("READY");                // 아직 승인 전이므로 READY 상태

        // 결제 타입 검증
        // TICKET / SUBSCRIBE 둘 중 하나만 허용
        String type = req.getPaymentType();
        if (!"TICKET".equals(type) && !"SUBSCRIBE".equals(type)) {
            throw new IllegalArgumentException("paymentType must be TICKET or SUBSCRIBE");
        }

        // 주문에 결제 타입 저장
        // 이후 approve 단계에서 티켓인지, 구독인지 분기 처리할 때 사용
        order.setPaymentType(req.getPaymentType());

        // DB insert
        paymentDAO.insertOrder(order);

        // -------------------------
        // 2) 카카오 ready 요청용 JSON 바디 구성
        // -------------------------
        Map<String, Object> body = new HashMap<>();

        // 테스트 CID
        // 실서비스에서는 실제 가맹점 CID 사용
        body.put("cid", "TC0ONETIME");

        // 우리 주문번호 / 사용자번호
        body.put("partner_order_id", orderId);
        body.put("partner_user_id", String.valueOf(userId));

        // 상품 정보
        body.put("item_name", req.getItemName());
        body.put("quantity", qty);
        body.put("total_amount", total);
        body.put("tax_free_amount", 0); // 비과세 금액. 없으면 0

        // 결제 완료/취소/실패 후 돌아올 주소들
        body.put("approval_url", approvalUrl);
        body.put("cancel_url", cancelUrl);
        body.put("fail_url", failUrl);

        // 헤더 + 바디를 하나로 묶어서 전송 엔티티 생성
        HttpHeaders h = headers();
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, h);

        try {
            // 카카오 ready API 호출
            ResponseEntity<kakaopayreadyResponse> res =
                    restTemplate.postForEntity(READY_URL, entity, kakaopayreadyResponse.class);

            // 응답 본문 꺼냄
            kakaopayreadyResponse resp = res.getBody();

            // -------------------------
            // 3) 카카오가 발급한 tid 저장
            // -------------------------
            // tid = 카카오 거래번호
            // approve / cancel 때 꼭 필요하므로 DB에 저장해야 함
            if (resp != null && resp.getTid() != null) {
                PaymentOrderDTO upd = new PaymentOrderDTO();
                upd.setOrderId(orderId);
                upd.setTid(resp.getTid());
                paymentDAO.updateTid(upd);
            }

            // 프론트에서는 이 응답 안의 redirect URL로 카카오 결제창 이동
            return resp;

        } catch (HttpStatusCodeException e) {
            // 카카오 ready 실패 시
            // 우리 주문도 FAIL로 갱신해서 나중에 상태 추적 가능하게 함
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
    /**
     * 카카오 결제 승인 단계
     *
     * 흐름:
     * 1. ready 때 저장한 order 조회
     * 2. DB에 저장된 tid + 카카오가 넘겨준 pg_token으로 approve 호출
     * 3. 성공 시 payment_order 상태를 APPROVED로 변경
     * 4. 결제타입에 따라 후처리
     *    - TICKET    : 좌석/예약 확정 처리
     *    - SUBSCRIBE : 회원권/구독권 시작 처리
     */
    @Override
    public kakaopayapproveResponse approve(String pgToken,
                                           String orderId,
                                           long userId) {

        // DB에서 기존 주문 조회
        // 여기 안에 tid, paymentType, amount 같은 정보가 들어있음
        PaymentOrderDTO order = paymentDAO.selectOrder(orderId);

        // 카카오 approve 요청 바디 구성
        Map<String, Object> body = new HashMap<>();
        body.put("cid", "TC0ONETIME");
        body.put("tid", order.getTid());                    // ready 때 받은 카카오 거래번호
        body.put("partner_order_id", orderId);              // 우리 주문번호
        body.put("partner_user_id", String.valueOf(userId));// 우리 사용자번호
        body.put("pg_token", pgToken);                      // 카카오가 성공 후 넘겨준 승인토큰

        HttpHeaders h = headers();
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, h);

        try {
            // 카카오 approve 호출
            ResponseEntity<kakaopayapproveResponse> res =
                    restTemplate.postForEntity(APPROVE_URL, entity, kakaopayapproveResponse.class);

            // -------------------------
            // 승인 성공 → 우리 주문 상태 APPROVED
            // -------------------------
            PaymentOrderDTO upd = new PaymentOrderDTO();
            upd.setOrderId(orderId);
            upd.setStatus("APPROVED");
            paymentDAO.updateStatus(upd);

            // -------------------------
            // 결제 타입별 후처리
            // -------------------------
            // 현재 네 코드에서는 TICKET은 주석만 있고,
            // SUBSCRIBE는 membershipType을 PRO로 바꾸는 처리만 들어있음
            if ("TICKET".equals(order.getPaymentType())) {
                // 티켓 결제인 경우 해야 할 것 예시:
                // - reservation_tbl 상태 확정
                // - seat_tbl 상태 BOOKED 확정
                // - 결제 완료 시간 저장
                // 지금은 비어있음
            } else if ("SUBSCRIBE".equals(order.getPaymentType())) {
                // 구독 결제인 경우
                // 사용자 멤버십을 PRO로 변경
            	Map<String, Object> param = new HashMap<>();
            	
            	//세션에서 아이디받아서 넣을거임
            	UserDTO loginUser = getLoginUser();
            	long payuserid = loginUser.getUserId();
            	System.out.println("payuserid" + payuserid);
            	
            	param.put("userId", payuserid);
                param.put("membershipType", "PRO");

                paymentDAO.updateMembershipType(param);
            }

            return res.getBody();

        } catch (HttpStatusCodeException e) {
            // 승인 실패 → 주문 FAIL 처리
            PaymentOrderDTO fail = new PaymentOrderDTO();
            fail.setOrderId(orderId);
            fail.setStatus("FAIL");
            fail.setFailReason(e.getStatusCode() + " " + e.getResponseBodyAsString());
            paymentDAO.updateFail(fail);

            throw e;
        }
    }

    // =========================
    // CANCEL
    // =========================
    /**
     * 결제 취소
     *
     * 흐름:
     * 1. orderId로 기존 주문 조회
     * 2. 취소 가능한 상태인지 검증
     * 3. 카카오 cancel API 호출
     * 4. 성공 시 우리 주문 상태를 CANCEL로 변경
     * 5. 실패 시 failReason만 기록
     *
     * @param orderId      취소할 주문번호
     * @param cancelAmount 취소 금액(null이면 전체취소)
     */
    @Override
    public KakaoPayCancelResponse cancel(String orderId, Integer cancelAmount) {

        System.out.println("서비스 진입 orderId = [" + orderId + "]");

        // 주문 조회
        PaymentOrderDTO order = paymentDAO.selectOrder(orderId);

        // 주문 자체가 없으면 취소 불가
        if (order == null) {
            throw new IllegalArgumentException("결제내역이 없습니다" + orderId);
        }

        // 이미 취소된 주문이면 중복 취소 방지
        if ("CANCEL".equals(order.getStatus())) {
            throw new IllegalArgumentException("이미 취소된 건입니다" + orderId);
        }

        // 승인된 결제만 취소 가능
        // READY / FAIL / CANCEL 상태는 취소 대상 아님
        if (!"APPROVED".equals(order.getStatus())) {
            throw new IllegalArgumentException("APPROVED만 취소 current = " + order.getStatus());
        }

        // tid가 없으면 카카오 취소 요청 자체를 만들 수 없음
        if (order.getTid() == null || order.getTid().isBlank()) {
            throw new IllegalArgumentException("tid가 null입니다");
        }

        // 취소금액이 없으면 전체금액 취소로 처리
        int amount = (cancelAmount == null) ? order.getTotalAmount() : cancelAmount;

        // 취소 금액 검증
        if (amount <= 0) throw new IllegalArgumentException("amount > 0");

        // -------------------------
        // 카카오 cancel 요청 바디
        // -------------------------
        Map<String, Object> body = new HashMap<>();
        body.put("cid", "TC0ONETIME");         // 테스트 가맹점 CID
        body.put("tid", order.getTid());       // 카카오 거래번호
        body.put("cancel_amount", amount);     // 취소금액
        body.put("cancel_tax_free_amount", 0); // 비과세 취소금액. 없으면 0

        // 디버깅 로그
        System.out.println("조회된 orderId = [" + order.getOrderId() + "]");
        System.out.println("조회된 tid = [" + order.getTid() + "]");
        System.out.println("조회된 status = [" + order.getStatus() + "]");

        HttpHeaders h = headers();
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, h);

        try {
            // 카카오 취소 API 호출
            ResponseEntity<KakaoPayCancelResponse> res =
                    restTemplate.postForEntity(CANCEL_URL, entity, KakaoPayCancelResponse.class);

            // -------------------------
            // 취소 성공 → 우리 주문 상태 CANCEL
            // -------------------------
            PaymentOrderDTO upd = new PaymentOrderDTO();
            upd.setOrderId(orderId);
            upd.setStatus("CANCEL");
            paymentDAO.updateStatus(upd);
            
          //세션에서 아이디받아서 넣을거임
        	UserDTO loginUser = getLoginUser();
        	long payuserid = loginUser.getUserId();
        	System.out.println("payuserid" + payuserid);

            // 결제 타입별 취소 후처리
            if ("SUBSCRIBE".equals(order.getPaymentType())) {
            	
                // 구독 취소 -> membership_type FREE로 복구
                paymentDAO.downgradeMembershipToFree(payuserid);

            } else if ("TICKET".equals(order.getPaymentType())) {
                // 티켓 취소 -> 좌석/예약 복구
                // paymentDAO.cancelReservation(...);
                // paymentDAO.releaseSeats(...);
            }

            return res.getBody();

        } catch (HttpStatusCodeException e) {
            // 취소 실패 시 failReason만 기록
            PaymentOrderDTO fail = new PaymentOrderDTO();
            
            
        	
            fail.setOrderId(orderId);
            fail.setFailReason("CANCEL_FAIL:" + e.getStatusCode() + " " + e.getResponseBodyAsString());
            paymentDAO.updateFailReason(fail);

            throw e;
        }
    }
}