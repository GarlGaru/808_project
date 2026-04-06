package com.spring.eze.show.dto.Myticket;

import java.sql.Date;

public class MyticketDTO {

	// user_tbl
	private String email;

	// paymentOrder_tbl
	private long reservationId;
	private long userId;
	private String orderId;
	private String approvedAt;
	private Integer quantity;
	private String status;
	
	// show_tbl
	private String title;
	private String posterUrl;
	private String venueName;
	private Date startDate;
	private Date endDate;
	private String showId;
	
	// schedule_tbl
	private Date playDate;
	
	// reservation_tbl
	private Integer totalPrice;
	private String paymentStatus;
	private String paymentMethod;
	
	//계산용
	private String cancelAvailable;

	public MyticketDTO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public MyticketDTO(String email, long reservationId, long userId, String orderId, String approvedAt,
			Integer quantity, String status, String title, String posterUrl, String venueName, Date startDate,
			Date endDate, Date playDate, Integer totalPrice, String paymentStatus, String paymentMethod,
			String cancelAvailable, String showId) {
		super();
		this.email = email;
		this.reservationId = reservationId;
		this.userId = userId;
		this.orderId = orderId;
		this.approvedAt = approvedAt;
		this.quantity = quantity;
		this.status = status;
		this.title = title;
		this.posterUrl = posterUrl;
		this.venueName = venueName;
		this.startDate = startDate;
		this.endDate = endDate;
		this.playDate = playDate;
		this.totalPrice = totalPrice;
		this.paymentStatus = paymentStatus;
		this.paymentMethod = paymentMethod;
		this.cancelAvailable = cancelAvailable;
		this.showId = showId;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
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

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getApprovedAt() {
		return approvedAt;
	}

	public void setApprovedAt(String approvedAt) {
		this.approvedAt = approvedAt;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getPosterUrl() {
		return posterUrl;
	}

	public void setPosterUrl(String posterUrl) {
		this.posterUrl = posterUrl;
	}

	public String getVenueName() {
		return venueName;
	}

	public void setVenueName(String venueName) {
		this.venueName = venueName;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public Date getPlayDate() {
		return playDate;
	}

	public void setPlayDate(Date playDate) {
		this.playDate = playDate;
	}

	public Integer getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(Integer totalPrice) {
		this.totalPrice = totalPrice;
	}

	public String getPaymentStatus() {
		return paymentStatus;
	}

	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}

	public String getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	public String getCancelAvailable() {
		return cancelAvailable;
	}

	public void setCancelAvailable(String cancelAvailable) {
		this.cancelAvailable = cancelAvailable;
	}

	public String getShowId() {
		return showId;
	}

	public void setShowId(String showId) {
		this.showId = showId;
	}

	@Override
	public String toString() {
		return "MyticketDTO [email=" + email + ", reservationId=" + reservationId + ", userId=" + userId + ", orderId="
				+ orderId + ", approvedAt=" + approvedAt + ", quantity=" + quantity + ", status=" + status + ", title="
				+ title + ", posterUrl=" + posterUrl + ", venueName=" + venueName + ", startDate=" + startDate
				+ ", endDate=" + endDate + ", showId=" + showId + ", playDate=" + playDate + ", totalPrice="
				+ totalPrice + ", paymentStatus=" + paymentStatus + ", paymentMethod=" + paymentMethod
				+ ", cancelAvailable=" + cancelAvailable + "]";
	}

}
