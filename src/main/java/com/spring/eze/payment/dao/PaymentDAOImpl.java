package com.spring.eze.payment.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.payment.dto.PaymentOrderDTO;
import com.spring.eze.payment.dto.TicketPaymentDTO;

@Repository
public class PaymentDAOImpl implements PaymentDAO{
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	 private static final String NS = "com.spring.eze.payment.dao.PaymentDAO.";

	@Override
	public int insertOrder(PaymentOrderDTO dto) {
		
		return sqlSession.insert(NS + "insertOrder", dto);		
	}
	
	//유저프로필에도 구독상태값 같이 저장
	@Override
	public void updateMembershipType(Map<String, Object> param) {
		System.out.println("updateMembershipType");
		System.out.println("param"+ param);
		
	    sqlSession.update(NS + "updateMembershipType", param);
	}
	
	@Override
	public int updateTid(PaymentOrderDTO dto) {
		System.out.println("PaymentOrderDTO");
		
		 return sqlSession.update(NS + "updateTid", dto);	
	
	}

	@Override
	public int updateStatus(PaymentOrderDTO dto) {

		return sqlSession.update(NS + "updateStatus", dto);
	}

	@Override
	public PaymentOrderDTO selectOrder(String orderId) {
		return sqlSession.selectOne(NS + "selectOrder", orderId);
	}

	@Override
	public void updateFail(PaymentOrderDTO dto) {
		 sqlSession.update(NS + "updateFail", dto);
		
	}

	@Override
	public int updateFailReason(PaymentOrderDTO dto) {
		return sqlSession.update(NS + "updateFailReason", dto);
	}

	@Override
	public int downgradeMembershipToFree(long userId) {
	    return sqlSession.update(NS + "downgradeMembershipToFree", userId);
	}

	
	//이밑으론 모두다 공연파트

	@Override
    public int insertTicketPayment(TicketPaymentDTO dto) {
        return sqlSession.insert(NS + "insertTicketPayment", dto);
    }

    @Override
    public int updateTicketPaymentCancelByOrderId(String orderId) {
        return sqlSession.update(NS + "updateTicketPaymentCancelByOrderId", orderId);
    }

    @Override
    public int updateSeatStatusAvailableByOrderId(String orderId) {
        return sqlSession.update(NS + "updateSeatStatusAvailableByOrderId", orderId);
    }

    @Override
    public int updateSeatStatusSold(Map<String, Object> map) {
        return sqlSession.update(NS + "updateSeatStatusSold", map);
    }

    @Override
    public List<TicketPaymentDTO> selectTicketPaymentsByOrderId(String orderId) {
        return sqlSession.selectList(NS + "selectTicketPaymentsByOrderId", orderId);
    }

    @Override
    public Long selectSeatIdByLabel(Map<String, Object> map) {
        return sqlSession.selectOne(NS + "selectSeatIdByLabel", map);
    }

    @Override
    public int updateSeatStatusHeld(Map<String, Object> map) {
        return sqlSession.update(NS + "updateSeatStatusHeld", map);
    }
	
}
