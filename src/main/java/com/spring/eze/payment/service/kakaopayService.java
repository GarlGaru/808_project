package com.spring.eze.payment.service;

import com.spring.eze.payment.dto.KakaoPayCancelResponse;
import com.spring.eze.payment.dto.kakaopayapproveResponse;
import com.spring.eze.payment.dto.kakaopayorderRequest;
import com.spring.eze.payment.dto.kakaopayreadyResponse;

public interface kakaopayService {

    // READY
    kakaopayreadyResponse ready(
            kakaopayorderRequest req,
            String orderId,
            long userId,
            long reservationId
    );

    // APPROVE
    kakaopayapproveResponse approve(
            String pgToken,
            String orderId,
            long userId
    );
    
    //결제취소
    KakaoPayCancelResponse cancel(
    		String orderId, Integer cancelAmount);
}