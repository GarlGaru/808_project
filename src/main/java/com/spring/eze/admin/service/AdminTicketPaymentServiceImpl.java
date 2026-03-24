package com.spring.eze.admin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.eze.admin.dao.AdminTicketPaymentDAO;
import com.spring.eze.admin.dto.AdminTicketPaymentDTO;

@Service
public class AdminTicketPaymentServiceImpl implements AdminTicketPaymentService {

	 @Autowired
	 private AdminTicketPaymentDAO adminTicketPaymentDAO;

	 @Override
	 public List<AdminTicketPaymentDTO> getTicketPaymentList() {
		 return adminTicketPaymentDAO.selectTicketPaymentList();
	 }

}
