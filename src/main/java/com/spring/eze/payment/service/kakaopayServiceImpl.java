package com.spring.eze.payment.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;

import com.spring.eze.payment.dao.PaymentDAO;
import com.spring.eze.payment.dto.KakaoPayCancelResponse;
import com.spring.eze.payment.dto.PaymentOrderDTO;
import com.spring.eze.payment.dto.TicketPaymentDTO;
import com.spring.eze.payment.dto.kakaopayapproveResponse;
import com.spring.eze.payment.dto.kakaopayorderRequest;
import com.spring.eze.payment.dto.kakaopayreadyResponse;
import com.spring.eze.user.dto.UserDTO;

@Service // 스프링 서비스 빈 등록
public class kakaopayServiceImpl implements kakaopayService {

    @Autowired
    private HttpSession session; // 현재 로그인 세션 접근용

    @Autowired
    private PaymentDAO paymentDAO; // 결제 관련 DB 처리 DAO

    private final RestTemplate restTemplate = new RestTemplate(); // 카카오페이 API 호출용

    // 카카오페이 단건결제 API 주소
    private static final String READY_URL   = "https://open-api.kakaopay.com/online/v1/payment/ready";
    private static final String APPROVE_URL = "https://open-api.kakaopay.com/online/v1/payment/approve";
    private static final String CANCEL_URL  = "https://open-api.kakaopay.com/online/v1/payment/cancel";

    // 로컬 프로젝트 기준 콜백 URL 베이스
    private static final String BASE_URL = "http://localhost/eze";

    // 홀드 처리 세션키로 쓰려던 값들
    // 지금은 주석 처리되어 사용 안 함
    //private static final String SESSION_HOLD_DONE = "seatHoldDone";
    //private static final String SESSION_HOLD_ORDER_ID = "seatHoldOrderId";

    // 세션에서 로그인 사용자 꺼내는 공통 메서드
    private UserDTO getLoginUser() {
        return (UserDTO) session.getAttribute("loginUser");
    }

    // 카카오페이 API 호출용 공통 헤더 생성
    private HttpHeaders headers() {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "SECRET_KEY " + jndi("kakao/secretKey").trim());
        headers.setContentType(MediaType.APPLICATION_JSON);
        return headers;
    }

    // 톰캣 JNDI에서 시크릿키 조회
    private String jndi(String name) {
        try {
            Context init = new InitialContext();
            Context env = (Context) init.lookup("java:comp/env");
            return (String) env.lookup(name);
        } catch (Exception e) {
            throw new RuntimeException("JNDI lookup 실패: " + name, e);
        }
    }

    // 홀드 관련 세션 제거용이었음
    // 현재는 사용 안 함
//    private void clearSeatHoldSession() {
//        session.removeAttribute(SESSION_HOLD_DONE);
//        session.removeAttribute(SESSION_HOLD_ORDER_ID);
//    }

    @Override
    @Transactional // DB 저장 + API 호출 흐름을 하나의 트랜잭션으로 처리
    public kakaopayreadyResponse ready(kakaopayorderRequest req,
                                       String orderId,
                                       long userId,
                                       long reservationId) {

        // 세션 로그인 체크
        UserDTO loginUser = getLoginUser();
        if (loginUser == null) {
            throw new IllegalStateException("로그인 세션이 없습니다.");
        }

        // 요청값 자체 null 체크
        if (req == null) {
            throw new IllegalArgumentException("결제 요청값이 없습니다.");
        }

        int qty;
        int total;

        // 문자열로 들어온 수량/금액을 숫자로 변환
        try {
            qty = Integer.parseInt(req.getQuantity());
            total = Integer.parseInt(req.getTotalPrice());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("수량 또는 금액이 숫자가 아닙니다.");
        }

        String type = req.getPaymentType(); // 결제 타입(TICKET / SUBSCRIBE)

        // 수량 검증
        if (qty <= 0) {
            throw new IllegalArgumentException("수량은 1 이상이어야 합니다.");
        }

        // 금액 검증
        if (total <= 0) {
            throw new IllegalArgumentException("금액은 0보다 커야 합니다.");
        }

        // 결제 타입 검증
        if (!"TICKET".equals(type) && !"SUBSCRIBE".equals(type)) {
            throw new IllegalArgumentException("paymentType은 TICKET 또는 SUBSCRIBE만 가능합니다.");
        }

        // 원래 티켓 결제 시 좌석 HOLD를 여기서 또 하려던 코드
        // 그런데 JSP 쪽에서 이미 HOLD를 하고 있어서 중복 HOLD 에러 발생 가능
        // 그래서 현재는 전체 주석 처리 상태
//        if ("TICKET".equals(type)) {
//            Boolean seatHoldDone = (Boolean) session.getAttribute(SESSION_HOLD_DONE);
//            String seatHoldOrderId = (String) session.getAttribute(SESSION_HOLD_ORDER_ID);
//
//            boolean alreadyHeldForThisOrder =
//                    Boolean.TRUE.equals(seatHoldDone) && orderId != null && orderId.equals(seatHoldOrderId);
//
//            if (!alreadyHeldForThisOrder) {
//
//                String[] selectedSeats = (String[]) session.getAttribute("selectedSeats");
//                String showId = (String) session.getAttribute("selectedShowId");
//                Object scheduleObj = session.getAttribute("selectedScheduleId");
//
//                if (selectedSeats == null || selectedSeats.length == 0) {
//                    throw new IllegalArgumentException("선택된 좌석 정보가 없습니다.");
//                }
//
//                if (showId == null || scheduleObj == null) {
//                    throw new IllegalArgumentException("공연 정보가 없습니다.");
//                }
//
//                long scheduleId;
//                if (scheduleObj instanceof Long) {
//                    scheduleId = (Long) scheduleObj;
//                } else {
//                    scheduleId = Long.parseLong(String.valueOf(scheduleObj));
//                }
//
//                List<Long> seatIds = new ArrayList<>();
//
//                for (String rawSeatLabel : selectedSeats) {
//                    String seatLabel = rawSeatLabel == null ? null : rawSeatLabel.trim();
//
//                    if (seatLabel == null || seatLabel.isEmpty()) {
//                        throw new IllegalArgumentException("좌석 라벨이 비어 있습니다.");
//                    }
//
//                    Map<String, Object> seatParam = new HashMap<>();
//                    seatParam.put("showId", showId);
//                    seatParam.put("scheduleId", scheduleId);
//                    seatParam.put("seatLabel", seatLabel);
//
//                    Long seatId = paymentDAO.selectSeatIdByLabel(seatParam);
//
//                    if (seatId == null) {
//                        throw new IllegalArgumentException("seat_id 조회 실패: " + seatLabel);
//                    }
//
//                    seatIds.add(seatId);
//                }
//
//                if (!seatIds.isEmpty()) {
//                    Map<String, Object> holdMap = new HashMap<>();
//                    holdMap.put("seatIds", seatIds);
//
//                    int heldCount = paymentDAO.updateSeatStatusHeld(holdMap);
//
//                    if (heldCount != seatIds.size()) {
//                        throw new IllegalStateException("선택 좌석 중 이미 HELD 또는 SOLD 상태인 좌석이 있습니다.");
//                    }
//
//                    session.setAttribute(SESSION_HOLD_DONE, true);
//                    session.setAttribute(SESSION_HOLD_ORDER_ID, orderId);
//                }
//            }
//        }

        // 카카오페이 결제 성공/취소/실패 후 돌아올 콜백 URL 생성
        String approvalUrl = BASE_URL + "/kakaopay/approve?orderId=" + orderId;
        String cancelUrl   = BASE_URL + "/kakaopay/cancel?orderId=" + orderId;
        String failUrl     = BASE_URL + "/kakaopay/fail?orderId=" + orderId;

        // payment_order 테이블에 먼저 READY 상태 주문 저장
        PaymentOrderDTO order = new PaymentOrderDTO();
        order.setOrderId(orderId);
        order.setReservationId(reservationId);
        order.setUserId(loginUser.getUserId()); // 실제 로그인 유저 기준 저장
        order.setItemName(req.getItemName());
        order.setQuantity(qty);
        order.setTotalAmount(total);
        order.setStatus("READY");
        order.setPaymentType(type);

        paymentDAO.insertOrder(order);

        // 카카오페이 ready 요청 바디 구성
        Map<String, Object> body = new HashMap<>();
        body.put("cid", "TC0ONETIME");
        body.put("partner_order_id", orderId);
        body.put("partner_user_id", String.valueOf(loginUser.getUserId()));
        body.put("item_name", req.getItemName());
        body.put("quantity", qty);
        body.put("total_amount", total);
        body.put("tax_free_amount", 0);
        body.put("approval_url", approvalUrl);
        body.put("cancel_url", cancelUrl);
        body.put("fail_url", failUrl);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers());

        try {
            // 카카오페이 ready API 호출
            ResponseEntity<kakaopayreadyResponse> response =
                    restTemplate.postForEntity(READY_URL, entity, kakaopayreadyResponse.class);

            kakaopayreadyResponse readyResponse = response.getBody();

            // 응답으로 받은 tid를 DB에 저장
            if (readyResponse != null && readyResponse.getTid() != null) {
                PaymentOrderDTO tidDto = new PaymentOrderDTO();
                tidDto.setOrderId(orderId);
                tidDto.setTid(readyResponse.getTid());
                paymentDAO.updateTid(tidDto);
            }

            return readyResponse;

        } catch (HttpStatusCodeException e) {
            // ready 실패 시 payment_order를 FAIL 처리
            //clearSeatHoldSession();

            PaymentOrderDTO failDto = new PaymentOrderDTO();
            failDto.setOrderId(orderId);
            failDto.setStatus("FAIL");
            failDto.setFailReason(e.getStatusCode() + " " + e.getResponseBodyAsString());
            paymentDAO.updateFail(failDto);
            throw e;
        }
    }

    @Override
    @Transactional
    public kakaopayapproveResponse approve(String pgToken, String orderId, long userId) {

        // 주문번호로 기존 결제주문 조회
        PaymentOrderDTO order = paymentDAO.selectOrder(orderId);
        if (order == null) {
            throw new IllegalStateException("주문정보가 없습니다. orderId=" + orderId);
        }

        // ready 때 저장된 tid가 있어야 승인 가능
        if (order.getTid() == null || order.getTid().trim().isEmpty()) {
            throw new IllegalStateException("tid가 없습니다. orderId=" + orderId);
        }

        // 승인 시점에도 로그인 세션 확인
        UserDTO loginUser = getLoginUser();
        if (loginUser == null) {
            throw new IllegalStateException("로그인 세션이 없습니다.");
        }

        // 카카오페이 approve 요청 바디 구성
        Map<String, Object> body = new HashMap<>();
        body.put("cid", "TC0ONETIME");
        body.put("tid", order.getTid());
        body.put("partner_order_id", orderId);
        body.put("partner_user_id", String.valueOf(loginUser.getUserId()));
        body.put("pg_token", pgToken);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers());

        try {
            // 카카오페이 approve API 호출
            ResponseEntity<kakaopayapproveResponse> response =
                    restTemplate.postForEntity(APPROVE_URL, entity, kakaopayapproveResponse.class);

            // payment_order 상태를 APPROVED 로 변경
            PaymentOrderDTO statusDto = new PaymentOrderDTO();
            statusDto.setOrderId(orderId);
            statusDto.setStatus("APPROVED");
            paymentDAO.updateStatus(statusDto);

            // 티켓 결제인 경우
            if ("TICKET".equals(order.getPaymentType())) {

                // 세션에 저장된 좌석/공연 정보 꺼내기
                String[] selectedSeats = (String[]) session.getAttribute("selectedSeats");
                String showId = (String) session.getAttribute("selectedShowId");
                Object scheduleObj = session.getAttribute("selectedScheduleId");

                if (selectedSeats == null || selectedSeats.length == 0) {
                    throw new IllegalArgumentException("선택된 좌석 정보가 없습니다.");
                }

                if (showId == null || scheduleObj == null) {
                    throw new IllegalArgumentException("공연 정보가 없습니다.");
                }

                long scheduleId;
                if (scheduleObj instanceof Long) {
                    scheduleId = (Long) scheduleObj;
                } else {
                    scheduleId = Long.parseLong(String.valueOf(scheduleObj));
                }

                // 좌석 수로 나눠서 1좌석당 가격 계산
                int eachPrice = order.getTotalAmount() / selectedSeats.length;
                List<Long> seatIds = new ArrayList<>();

                // 선택한 좌석마다 seat_id 조회 후 ticket_payment 저장
                for (String rawSeatLabel : selectedSeats) {
                    String seatLabel = rawSeatLabel == null ? null : rawSeatLabel.trim();

                    if (seatLabel == null || seatLabel.isEmpty()) {
                        throw new IllegalArgumentException("좌석 라벨이 비어 있습니다.");
                    }

                    Map<String, Object> seatParam = new HashMap<>();
                    seatParam.put("showId", showId);
                    seatParam.put("scheduleId", scheduleId);
                    seatParam.put("seatLabel", seatLabel);

                    Long seatId = paymentDAO.selectSeatIdByLabel(seatParam);

                    if (seatId == null) {
                        throw new IllegalArgumentException("seat_id 조회 실패: " + seatLabel);
                    }

                    TicketPaymentDTO tp = new TicketPaymentDTO();
                    tp.setOrderId(orderId);
                    tp.setSeatId(seatId);
                    tp.setShowId(showId);
                    tp.setScheduleId(scheduleId);
                    tp.setTicketPrice(eachPrice);
                    tp.setTicketStatus("APPROVED");

                    paymentDAO.insertTicketPayment(tp);
                    seatIds.add(seatId);
                }

                // 승인 완료된 좌석들을 SOLD 상태로 변경
                if (!seatIds.isEmpty()) {
                    Map<String, Object> seatMap = new HashMap<>();
                    seatMap.put("seatIds", seatIds);
                    paymentDAO.updateSeatStatusSold(seatMap);
                }

                // 결제 완료 후 세션에 남아있는 좌석 선택 정보 제거
                //clearSeatHoldSession();
                session.removeAttribute("selectedSeats");
                session.removeAttribute("selectedShowId");
                session.removeAttribute("selectedScheduleId");

            // 구독 결제인 경우
            } else if ("SUBSCRIBE".equals(order.getPaymentType())) {

                // 유저 멤버십을 PRO로 변경
                Map<String, Object> param = new HashMap<>();
                param.put("userId", order.getUserId());
                param.put("membershipType", "PRO");
                paymentDAO.updateMembershipType(param);

            } else {
                throw new IllegalArgumentException("지원하지 않는 결제 타입입니다: " + order.getPaymentType());
            }

            return response.getBody();

        } catch (HttpStatusCodeException e) {
            // 승인 실패 시 주문 상태 FAIL 처리
            PaymentOrderDTO failDto = new PaymentOrderDTO();
            failDto.setOrderId(orderId);
            failDto.setStatus("FAIL");
            failDto.setFailReason(e.getStatusCode() + " " + e.getResponseBodyAsString());
            paymentDAO.updateFail(failDto);
            throw e;
        }
    }

    @Override
    @Transactional
    public KakaoPayCancelResponse cancel(String orderId, Integer cancelAmount) {

        // 취소할 주문 조회
        PaymentOrderDTO order = paymentDAO.selectOrder(orderId);
        if (order == null) {
            throw new IllegalArgumentException("결제내역이 없습니다. orderId=" + orderId);
        }

        // 이미 취소된 건이면 막음
        if ("CANCEL".equals(order.getStatus())) {
            throw new IllegalArgumentException("이미 취소된 건입니다. orderId=" + orderId);
        }

        // APPROVED 상태만 취소 가능
        if (!"APPROVED".equals(order.getStatus())) {
            throw new IllegalArgumentException("취소 가능한 상태가 아닙니다. status=" + order.getStatus());
        }

        // tid 없으면 카카오 취소 API 호출 불가
        if (order.getTid() == null || order.getTid().trim().isEmpty()) {
            throw new IllegalStateException("취소할 tid가 없습니다. orderId=" + orderId);
        }

        // 부분취소 금액이 없으면 전체취소로 처리
        int amount = (cancelAmount == null) ? order.getTotalAmount() : cancelAmount;

        // 카카오페이 cancel 요청 바디 구성
        Map<String, Object> body = new HashMap<>();
        body.put("cid", "TC0ONETIME");
        body.put("tid", order.getTid());
        body.put("cancel_amount", amount);
        body.put("cancel_tax_free_amount", 0);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers());

        try {
            // 카카오페이 cancel API 호출
            ResponseEntity<KakaoPayCancelResponse> response =
                    restTemplate.postForEntity(CANCEL_URL, entity, KakaoPayCancelResponse.class);

            // payment_order 상태를 CANCEL 로 변경
            PaymentOrderDTO cancelDto = new PaymentOrderDTO();
            cancelDto.setOrderId(orderId);
            cancelDto.setStatus("CANCEL");
            paymentDAO.updateStatus(cancelDto);

            // 구독 취소면 FREE로 다운그레이드
            if ("SUBSCRIBE".equals(order.getPaymentType())) {
                paymentDAO.downgradeMembershipToFree(order.getUserId());

            // 티켓 취소면 ticket_payment 취소 + 좌석 AVAILABLE 복구
            } else if ("TICKET".equals(order.getPaymentType())) {
                paymentDAO.updateTicketPaymentCancelByOrderId(orderId);
                paymentDAO.updateSeatStatusAvailableByOrderId(orderId);
                //clearSeatHoldSession();
            }

            return response.getBody();

        } catch (HttpStatusCodeException e) {
            // 취소 API 실패 사유만 fail_reason 컬럼에 기록
            PaymentOrderDTO failDto = new PaymentOrderDTO();
            failDto.setOrderId(orderId);
            failDto.setFailReason(e.getStatusCode() + " " + e.getResponseBodyAsString());
            paymentDAO.updateFailReason(failDto);
            throw e;
        }
    }
}