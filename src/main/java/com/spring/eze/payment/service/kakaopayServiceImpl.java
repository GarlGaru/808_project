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

@Service
public class kakaopayServiceImpl implements kakaopayService {

    @Autowired
    private HttpSession session;

    @Autowired
    private PaymentDAO paymentDAO;

    private final RestTemplate restTemplate = new RestTemplate();

    private static final String READY_URL   = "https://open-api.kakaopay.com/online/v1/payment/ready";
    private static final String APPROVE_URL = "https://open-api.kakaopay.com/online/v1/payment/approve";
    private static final String CANCEL_URL  = "https://open-api.kakaopay.com/online/v1/payment/cancel";

    private static final String BASE_URL = "http://localhost/eze";

    //홀드용
    //private static final String SESSION_HOLD_DONE = "seatHoldDone";
    //private static final String SESSION_HOLD_ORDER_ID = "seatHoldOrderId";

    private UserDTO getLoginUser() {
        return (UserDTO) session.getAttribute("loginUser");
    }

    private HttpHeaders headers() {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "SECRET_KEY " + jndi("kakao/secretKey").trim());
        headers.setContentType(MediaType.APPLICATION_JSON);
        return headers;
    }

    private String jndi(String name) {
        try {
            Context init = new InitialContext();
            Context env = (Context) init.lookup("java:comp/env");
            return (String) env.lookup(name);
        } catch (Exception e) {
            throw new RuntimeException("JNDI lookup 실패: " + name, e);
        }
    }

    //홀드체킹용
//    private void clearSeatHoldSession() {
//        session.removeAttribute(SESSION_HOLD_DONE);
//        session.removeAttribute(SESSION_HOLD_ORDER_ID);
//    }

    @Override
    @Transactional
    public kakaopayreadyResponse ready(kakaopayorderRequest req,
                                       String orderId,
                                       long userId,
                                       long reservationId) {

        UserDTO loginUser = getLoginUser();
        if (loginUser == null) {
            throw new IllegalStateException("로그인 세션이 없습니다.");
        }

        if (req == null) {
            throw new IllegalArgumentException("결제 요청값이 없습니다.");
        }

        int qty;
        int total;

        try {
            qty = Integer.parseInt(req.getQuantity());
            total = Integer.parseInt(req.getTotalPrice());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("수량 또는 금액이 숫자가 아닙니다.");
        }

        String type = req.getPaymentType();

        if (qty <= 0) {
            throw new IllegalArgumentException("수량은 1 이상이어야 합니다.");
        }

        if (total <= 0) {
            throw new IllegalArgumentException("금액은 0보다 커야 합니다.");
        }

        if (!"TICKET".equals(type) && !"SUBSCRIBE".equals(type)) {
            throw new IllegalArgumentException("paymentType은 TICKET 또는 SUBSCRIBE만 가능합니다.");
        }

        //jsp에서 이미홀드를하고있음 2번중복홀드라 에러남
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

        String approvalUrl = BASE_URL + "/kakaopay/approve?orderId=" + orderId;
        String cancelUrl   = BASE_URL + "/kakaopay/cancel?orderId=" + orderId;
        String failUrl     = BASE_URL + "/kakaopay/fail?orderId=" + orderId;

        PaymentOrderDTO order = new PaymentOrderDTO();
        order.setOrderId(orderId);
        order.setReservationId(reservationId);
        order.setUserId(loginUser.getUserId());
        order.setItemName(req.getItemName());
        order.setQuantity(qty);
        order.setTotalAmount(total);
        order.setStatus("READY");
        order.setPaymentType(type);

        paymentDAO.insertOrder(order);

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
            ResponseEntity<kakaopayreadyResponse> response =
                    restTemplate.postForEntity(READY_URL, entity, kakaopayreadyResponse.class);

            kakaopayreadyResponse readyResponse = response.getBody();

            if (readyResponse != null && readyResponse.getTid() != null) {
                PaymentOrderDTO tidDto = new PaymentOrderDTO();
                tidDto.setOrderId(orderId);
                tidDto.setTid(readyResponse.getTid());
                paymentDAO.updateTid(tidDto);
            }

            return readyResponse;

        } catch (HttpStatusCodeException e) {
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

        PaymentOrderDTO order = paymentDAO.selectOrder(orderId);
        if (order == null) {
            throw new IllegalStateException("주문정보가 없습니다. orderId=" + orderId);
        }

        if (order.getTid() == null || order.getTid().trim().isEmpty()) {
            throw new IllegalStateException("tid가 없습니다. orderId=" + orderId);
        }

        UserDTO loginUser = getLoginUser();
        if (loginUser == null) {
            throw new IllegalStateException("로그인 세션이 없습니다.");
        }

        Map<String, Object> body = new HashMap<>();
        body.put("cid", "TC0ONETIME");
        body.put("tid", order.getTid());
        body.put("partner_order_id", orderId);
        body.put("partner_user_id", String.valueOf(loginUser.getUserId()));
        body.put("pg_token", pgToken);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers());

        try {
            ResponseEntity<kakaopayapproveResponse> response =
                    restTemplate.postForEntity(APPROVE_URL, entity, kakaopayapproveResponse.class);

            PaymentOrderDTO statusDto = new PaymentOrderDTO();
            statusDto.setOrderId(orderId);
            statusDto.setStatus("APPROVED");
            paymentDAO.updateStatus(statusDto);

            if ("TICKET".equals(order.getPaymentType())) {

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

                int eachPrice = order.getTotalAmount() / selectedSeats.length;
                List<Long> seatIds = new ArrayList<>();

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

                if (!seatIds.isEmpty()) {
                    Map<String, Object> seatMap = new HashMap<>();
                    seatMap.put("seatIds", seatIds);
                    paymentDAO.updateSeatStatusSold(seatMap);
                }

                //clearSeatHoldSession();
                session.removeAttribute("selectedSeats");
                session.removeAttribute("selectedShowId");
                session.removeAttribute("selectedScheduleId");

            } else if ("SUBSCRIBE".equals(order.getPaymentType())) {

                Map<String, Object> param = new HashMap<>();
                param.put("userId", order.getUserId());
                param.put("membershipType", "PRO");
                paymentDAO.updateMembershipType(param);

            } else {
                throw new IllegalArgumentException("지원하지 않는 결제 타입입니다: " + order.getPaymentType());
            }

            return response.getBody();

        } catch (HttpStatusCodeException e) {
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

        PaymentOrderDTO order = paymentDAO.selectOrder(orderId);
        if (order == null) {
            throw new IllegalArgumentException("결제내역이 없습니다. orderId=" + orderId);
        }

        if ("CANCEL".equals(order.getStatus())) {
            throw new IllegalArgumentException("이미 취소된 건입니다. orderId=" + orderId);
        }

        if (!"APPROVED".equals(order.getStatus())) {
            throw new IllegalArgumentException("취소 가능한 상태가 아닙니다. status=" + order.getStatus());
        }

        if (order.getTid() == null || order.getTid().trim().isEmpty()) {
            throw new IllegalStateException("취소할 tid가 없습니다. orderId=" + orderId);
        }

        int amount = (cancelAmount == null) ? order.getTotalAmount() : cancelAmount;

        Map<String, Object> body = new HashMap<>();
        body.put("cid", "TC0ONETIME");
        body.put("tid", order.getTid());
        body.put("cancel_amount", amount);
        body.put("cancel_tax_free_amount", 0);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers());

        try {
            ResponseEntity<KakaoPayCancelResponse> response =
                    restTemplate.postForEntity(CANCEL_URL, entity, KakaoPayCancelResponse.class);

            PaymentOrderDTO cancelDto = new PaymentOrderDTO();
            cancelDto.setOrderId(orderId);
            cancelDto.setStatus("CANCEL");
            paymentDAO.updateStatus(cancelDto);

            if ("SUBSCRIBE".equals(order.getPaymentType())) {
                paymentDAO.downgradeMembershipToFree(order.getUserId());

            } else if ("TICKET".equals(order.getPaymentType())) {
                paymentDAO.updateTicketPaymentCancelByOrderId(orderId);
                paymentDAO.updateSeatStatusAvailableByOrderId(orderId);
                //clearSeatHoldSession();
            }

            return response.getBody();

        } catch (HttpStatusCodeException e) {
            PaymentOrderDTO failDto = new PaymentOrderDTO();
            failDto.setOrderId(orderId);
            failDto.setFailReason(e.getStatusCode() + " " + e.getResponseBodyAsString());
            paymentDAO.updateFailReason(failDto);
            throw e;
        }
    }
}