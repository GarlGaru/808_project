package com.spring.eze.payment.dao;

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
		 sqlSession.update("kakaopay.updateFail", dto);
		
	}

	
}
