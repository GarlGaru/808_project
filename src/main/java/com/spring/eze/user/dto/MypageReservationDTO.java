package com.spring.eze.user.dto;

import java.util.Date;

public class MypageReservationDTO {

    private String reservationId;   // 결제번호
    private String showTitle;       // 공연 제목
    private Date startDate;         // 공연 기간 시작
    private Date endDate;           // 공연 기간 종료
    // private String showTime;     // 공연 시간 HH:MM~HH:MM
    private String venue;           // 공연장
    private String seatGrade;       // 좌석 등급
    private String seatLabel;       // 좌석 번호
    private String ticketPrice;     // 문자열로 들어오는 금액 ("VIP 150,000원")
    private int quantity;           // 매수
    private String status;          // 예매 상태
    private String posterImg;       // 포스터 경로
    private Date playDate;			// 관람일자
    
	public MypageReservationDTO() {
		super();
	}

	public MypageReservationDTO(String reservationId, String showTitle, Date startDate, Date endDate, String venue,
			String seatGrade, String seatLabel, String ticketPrice, int quantity, String status, String posterImg,
			Date playDate) {
		super();
		this.reservationId = reservationId;
		this.showTitle = showTitle;
		this.startDate = startDate;
		this.endDate = endDate;
		this.venue = venue;
		this.seatGrade = seatGrade;
		this.seatLabel = seatLabel;
		this.ticketPrice = ticketPrice;
		this.quantity = quantity;
		this.status = status;
		this.posterImg = posterImg;
		this.playDate = playDate;
	}

	public String getReservationId() {
		return reservationId;
	}

	public void setReservationId(String reservationId) {
		this.reservationId = reservationId;
	}

	public String getShowTitle() {
		return showTitle;
	}

	public void setShowTitle(String showTitle) {
		this.showTitle = showTitle;
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

	public String getVenue() {
		return venue;
	}

	public void setVenue(String venue) {
		this.venue = venue;
	}

	public String getSeatGrade() {
		return seatGrade;
	}

	public void setSeatGrade(String seatGrade) {
		this.seatGrade = seatGrade;
	}

	public String getSeatLabel() {
		return seatLabel;
	}

	public void setSeatLabel(String seatLabel) {
		this.seatLabel = seatLabel;
	}

	public String getTicketPrice() {
		return ticketPrice;
	}

	public void setTicketPrice(String ticketPrice) {
		this.ticketPrice = ticketPrice;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPosterImg() {
		return posterImg;
	}

	public void setPosterImg(String posterImg) {
		this.posterImg = posterImg;
	}

	public Date getPlayDate() {
		return playDate;
	}

	public void setPlayDate(Date playDate) {
		this.playDate = playDate;
	}

	@Override
	public String toString() {
		return "MypageReservationDTO [reservationId=" + reservationId + ", showTitle=" + showTitle + ", startDate="
				+ startDate + ", endDate=" + endDate + ", venue=" + venue + ", seatGrade=" + seatGrade + ", seatLabel="
				+ seatLabel + ", ticketPrice=" + ticketPrice + ", quantity=" + quantity + ", status=" + status
				+ ", posterImg=" + posterImg + ", playDate=" + playDate + "]";
	}

	

}