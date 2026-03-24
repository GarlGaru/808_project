package com.spring.eze.admin.dto;

import java.util.Date;

public class AdminTicketPaymentDTO {

	private String orderId;
    private Long seatId;
    private String showId;
    private Long scheduleId;
    private Integer ticketPrice;
    private String ticketStatus;
    private Date createdAt;
    private Date canceledAt;
	public String getOrderId() {
		return orderId;
	}
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}
	public Long getSeatId() {
		return seatId;
	}
	public void setSeatId(Long seatId) {
		this.seatId = seatId;
	}
	public String getShowId() {
		return showId;
	}
	public void setShowId(String showId) {
		this.showId = showId;
	}
	public Long getScheduleId() {
		return scheduleId;
	}
	public void setScheduleId(Long scheduleId) {
		this.scheduleId = scheduleId;
	}
	public Integer getTicketPrice() {
		return ticketPrice;
	}
	public void setTicketPrice(Integer ticketPrice) {
		this.ticketPrice = ticketPrice;
	}
	public String getTicketStatus() {
		return ticketStatus;
	}
	public void setTicketStatus(String ticketStatus) {
		this.ticketStatus = ticketStatus;
	}
	public Date getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	public Date getCanceledAt() {
		return canceledAt;
	}
	public void setCanceledAt(Date canceledAt) {
		this.canceledAt = canceledAt;
	}
    
    
}
