package com.spring.eze.user.dto;

import java.sql.Date;

public class MypagePaymentDTO {
	
	private String orderId;		// 주문 번호
	private String itemName; 	// 결제명
	private int    totalAmount;	// 결제 금액
	private Date   approvedAt;	// 결제 승인일
	private Date   createdAt;	// 결제 생성일
	private String status; 		// 결제 상태
	private String paymentType; // 결제 유형
	
	public MypagePaymentDTO() {
		super();
	}

	public MypagePaymentDTO(String orderId, String itemName, int totalAmount, Date approvedAt, Date createdAt,
			String status, String paymentType) {
		super();
		this.orderId = orderId;
		this.itemName = itemName;
		this.totalAmount = totalAmount;
		this.approvedAt = approvedAt;
		this.createdAt = createdAt;
		this.status = status;
		this.paymentType = paymentType;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public int getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(int totalAmount) {
		this.totalAmount = totalAmount;
	}

	public Date getApprovedAt() {
		return approvedAt;
	}

	public void setApprovedAt(Date approvedAt) {
		this.approvedAt = approvedAt;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPaymentType() {
		return paymentType;
	}

	public void setPaymentType(String paymentType) {
		this.paymentType = paymentType;
	}

	@Override
	public String toString() {
		return "MypagePaymentDTO [orderId=" + orderId + ", itemName=" + itemName + ", totalAmount=" + totalAmount
				+ ", approvedAt=" + approvedAt + ", createdAt=" + createdAt + ", status=" + status + ", paymentType="
				+ paymentType + "]";
	}
	

}
