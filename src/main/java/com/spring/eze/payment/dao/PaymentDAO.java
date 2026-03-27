package com.spring.eze.payment.dao;

import java.util.List;
import java.util.Map;

import com.spring.eze.payment.dto.PaymentOrderDTO;
import com.spring.eze.payment.dto.TicketPaymentDTO;

public interface PaymentDAO {
	
	//결제
    int insertOrder(PaymentOrderDTO dto);
    void updateMembershipType(Map<String, Object> param);
    
    int updateTid(PaymentOrderDTO dto);
    int updateStatus(PaymentOrderDTO dto);
    PaymentOrderDTO selectOrder(String orderId);
    void updateFail(PaymentOrderDTO dto);
    
    //결제취소
    int updateFailReason(PaymentOrderDTO dto);
    //구독
    int downgradeMembershipToFree(long userId);
    
    
    // -------------------------
    // 티켓 결제용 추가
    // -------------------------

    // ticket_payment_tbl insert
    int insertTicketPayment(TicketPaymentDTO dto);

    // 주문번호로 티켓 이력 취소 처리
    int updateTicketPaymentCancelByOrderId(String orderId);

    // 주문번호 기준 좌석 AVAILABLE 복구
    int updateSeatStatusAvailableByOrderId(String orderId);

    // 선택 좌석 SOLD 처리
    int updateSeatStatusSold(Map<String, Object> map);

    // 주문번호 기준 티켓 이력 조회
    List<TicketPaymentDTO> selectTicketPaymentsByOrderId(String orderId);
    
    Long selectSeatIdByLabel(Map<String, Object> map);
    
    //구매 상태값변경
    int updateSeatStatusHeld(Map<String, Object> map);
    
}