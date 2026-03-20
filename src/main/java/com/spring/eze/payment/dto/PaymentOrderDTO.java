package com.spring.eze.payment.dto;

public class PaymentOrderDTO {
	
    private String orderId;
    
    private long  reservationId;
    private long  userId;
    
    private String itemName;
    private Integer  quantity;
    private Integer totalAmount;
    
    private String tid;
    private String status;
    private String createdAt; // DATE를 String으로 받아도 되고 Date로 받아도 됨(일단 간단히)
    private String approvedAt;  // 예약확정시간
    private String failReason;  // 실패시간
    private String paymentType; // 티켓인지 구독인지
	
    public String getPaymentType() {
		return paymentType;
	}
	public void setPaymentType(String paymentType) {
		this.paymentType = paymentType;
	}
	public String getApprovedAt() {
		return approvedAt;
	}
	public void setApprovedAt(String approvedAt) {
		this.approvedAt = approvedAt;
	}
	public String getFailReason() {
		return failReason;
	}
	public void setFailReason(String failReason) {
		this.failReason = failReason;
	}
	public String getOrderId() {
		return orderId;
	}
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}
	public long getReservationId() {
		return reservationId;
	}
	public void setReservationId(long reservationId) {
		this.reservationId = reservationId;
	}
	public long getUserId() {
		return userId;
	}
	public void setUserId(long userId) {
		this.userId = userId;
	}
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	public Integer getQuantity() {
		return quantity;
	}
	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}
	public Integer getTotalAmount() {
		return totalAmount;
	}
	public void setTotalAmount(Integer totalAmount) {
		this.totalAmount = totalAmount;
	}
	public String getTid() {
		return tid;
	}
	public void setTid(String tid) {
		this.tid = tid;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	
}