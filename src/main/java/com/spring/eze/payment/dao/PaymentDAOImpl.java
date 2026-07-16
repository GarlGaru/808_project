package com.spring.eze.payment.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.payment.dto.PaymentOrderDTO;
import com.spring.eze.payment.dto.TicketPaymentDTO;

@Repository // DAO 계층 스프링 빈 등록
public class PaymentDAOImpl implements PaymentDAO{
	
	@Autowired
	private SqlSessionTemplate sqlSession; // MyBatis SQL 실행 객체
	
	// MyBatis mapper namespace
	private static final String NS = "com.spring.eze.payment.dao.PaymentDAO.";

	@Override
	public int insertOrder(PaymentOrderDTO dto) {
		// payment_order 테이블에 결제 주문 1건 등록
		return sqlSession.insert(NS + "insertOrder", dto);		
	}
	
	// 구독 결제 승인 시 user/profile 쪽 membership 상태도 같이 변경
	@Override
	public void updateMembershipType(Map<String, Object> param) {
		System.out.println("updateMembershipType");
		System.out.println("param" + param);
		
		// membership_type 값을 FREE / PRO 같은 형태로 변경
	    sqlSession.update(NS + "updateMembershipType", param);
	}
	
	@Override
	public int updateTid(PaymentOrderDTO dto) {
		System.out.println("PaymentOrderDTO");
		
		// 카카오페이 ready 요청 후 받은 tid를 payment_order에 저장
		return sqlSession.update(NS + "updateTid", dto);	
	}

	@Override
	public int updateStatus(PaymentOrderDTO dto) {
		// 결제 상태 변경
		// 예: READY -> APPROVED / CANCEL / FAIL
		return sqlSession.update(NS + "updateStatus", dto);
	}

	@Override
	public PaymentOrderDTO selectOrder(String orderId) {
		// orderId로 결제 주문 1건 조회
		return sqlSession.selectOne(NS + "selectOrder", orderId);
	}

	@Override
	public void updateFail(PaymentOrderDTO dto) {
		// 결제 실패 처리
		// 보통 status를 FAIL로 바꾸거나 실패 관련 값 저장
		sqlSession.update(NS + "updateFail", dto);
	}

	@Override
	public int updateFailReason(PaymentOrderDTO dto) {
		// 실패 사유(fail_reason) 컬럼 업데이트
		return sqlSession.update(NS + "updateFailReason", dto);
	}

	@Override
	public int downgradeMembershipToFree(long userId) {
		// 구독 취소 시 해당 유저 멤버십을 FREE로 변경
	    return sqlSession.update(NS + "downgradeMembershipToFree", userId);
	}

	
	// ==============================
	// 아래부터는 공연/티켓 결제 관련
	// ==============================

	@Override
    public int insertTicketPayment(TicketPaymentDTO dto) {
		// 티켓 결제 상세 내역 1건 등록
		// 한 주문(orderId)에 좌석 수만큼 여러 건 들어갈 수 있음
        return sqlSession.insert(NS + "insertTicketPayment", dto);
    }

    @Override
    public int updateTicketPaymentCancelByOrderId(String orderId) {
    	// 주문번호 기준으로 ticket_payment 상태를 취소 처리
        return sqlSession.update(NS + "updateTicketPaymentCancelByOrderId", orderId);
    }

    @Override
    public int updateSeatStatusAvailableByOrderId(String orderId) {
    	// 주문번호 기준으로 연결된 좌석들을 다시 AVAILABLE 상태로 복구
        return sqlSession.update(NS + "updateSeatStatusAvailableByOrderId", orderId);
    }

    @Override
    public int updateSeatStatusSold(Map<String, Object> map) {
    	// 결제 완료 후 특정 좌석 상태를 SOLD로 변경
        return sqlSession.update(NS + "updateSeatStatusSold", map);
    }

    @Override
    public List<TicketPaymentDTO> selectTicketPaymentsByOrderId(String orderId) {
    	// 주문번호로 티켓 결제 상세 목록 조회
    	// 주문 1건에 좌석이 여러 개면 리스트로 조회됨
        return sqlSession.selectList(NS + "selectTicketPaymentsByOrderId", orderId);
    }

    @Override
    public Long selectSeatIdByLabel(Map<String, Object> map) {
    	// show_id, schedule_id, seat_label 같은 조건으로 seat_id 조회
        return sqlSession.selectOne(NS + "selectSeatIdByLabel", map);
    }

    @Override
    public int updateSeatStatusHeld(Map<String, Object> map) {
    	// 좌석 선점 시 상태를 HELD로 변경
        return sqlSession.update(NS + "updateSeatStatusHeld", map);
    }
	
}