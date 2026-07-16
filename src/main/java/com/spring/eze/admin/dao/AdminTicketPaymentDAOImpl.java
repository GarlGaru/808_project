package com.spring.eze.admin.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.admin.dto.AdminTicketPaymentDTO;

@Repository
public class AdminTicketPaymentDAOImpl implements AdminTicketPaymentDAO {

	 @Autowired
	    private SqlSessionTemplate sqlSession;

	    private static final String NS = "com.spring.eze.admin.dao.AdminTicketPaymentDAO.";

	    @Override
	    public List<AdminTicketPaymentDTO> selectTicketPaymentList() {
	        return sqlSession.selectList(NS + "selectTicketPaymentList");
	    }

}
