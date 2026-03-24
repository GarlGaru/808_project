package com.spring.eze.payment.dto;

import java.util.Date;

public class TicketPaymentDTO {
	


    // 결제 주문번호
    private String orderId;

    // 좌석번호
    private long seatId;

    // 공연 ID
    private String showId;

    // 회차 ID
    private long scheduleId;

    // 좌석 1건 가격
    private int ticketPrice;

    // APPROVED / CANCEL
    private String ticketStatus;

    // 생성일
    private Date createdAt;

    // 취소일
    private Date canceledAt;


	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public long getSeatId() {
		return seatId;
	}

	public void setSeatId(long seatId) {
		this.seatId = seatId;
	}

	public String getShowId() {
		return showId;
	}

	public void setShowId(String showId) {
		this.showId = showId;
	}

	public long getScheduleId() {
		return scheduleId;
	}

	public void setScheduleId(long scheduleId) {
		this.scheduleId = scheduleId;
	}

	public int getTicketPrice() {
		return ticketPrice;
	}

	public void setTicketPrice(int ticketPrice) {
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

	@Override
	public String toString() {
		return "TicketPaymentDTO [orderId=" + orderId + ", seatId=" + seatId + ", showId=" + showId + ", scheduleId="
				+ scheduleId + ", ticketPrice=" + ticketPrice + ", ticketStatus=" + ticketStatus + ", createdAt="
				+ createdAt + ", canceledAt=" + canceledAt + "]";
	}

	
    
    

}
