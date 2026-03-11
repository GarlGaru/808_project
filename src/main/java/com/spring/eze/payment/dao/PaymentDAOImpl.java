package com.spring.eze.payment.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.payment.dto.PaymentOrderDTO;

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
	    sqlSession.update(NS + "updateMembershipType", param);
	}
	
	@Override
	public int updateTid(PaymentOrderDTO dto) {
		
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

	
}
