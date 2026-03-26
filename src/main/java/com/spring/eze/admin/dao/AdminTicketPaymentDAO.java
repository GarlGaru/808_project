package com.spring.eze.admin.dao;

import java.util.List;

import com.spring.eze.admin.dto.AdminTicketPaymentDTO;

public interface  AdminTicketPaymentDAO {

	 List<AdminTicketPaymentDTO> selectTicketPaymentList();
	 
}
