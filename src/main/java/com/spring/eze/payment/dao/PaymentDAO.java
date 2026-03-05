package com.spring.eze.payment.dao;

import com.spring.eze.payment.dto.PaymentOrderDTO;

public interface PaymentDAO {
	
	//결제
    int insertOrder(PaymentOrderDTO dto);
    int updateTid(PaymentOrderDTO dto);
    int updateStatus(PaymentOrderDTO dto);
    PaymentOrderDTO selectOrder(String orderId);
    void updateFail(PaymentOrderDTO dto);
    
    //결제취소
    int updateFailReason(PaymentOrderDTO dto);
}