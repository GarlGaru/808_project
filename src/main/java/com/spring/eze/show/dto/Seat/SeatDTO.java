package com.spring.eze.show.dto.Seat;

import java.util.Date;

public class SeatDTO {

    private Integer seatId;
    private String showId;		//API Id
    private Integer scheduleId;	//공연 날짜 및 시간
    private String userId;

    private String seatLabel;	  // 예 A-10
    private String resSeatLabel;  // 좌석 라벨 (예: A열 15번) -> 예약된
    private String seatGrade;     // 좌석 등급 (VIP, R석 등)
    private String seatStatus;    // 예약 상태 (예약중, 완료, 취소 등)
   
    private Date holdAt;        // 선점 시작 시간
	
    public SeatDTO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public SeatDTO(int seatId, String showId, int scheduleId, String userId, String seatLabel, String resSeatLabel,
			String seatGrade, String seatStatus, Date holdAt) {
		super();
		this.seatId = seatId;
		this.showId = showId;
		this.scheduleId = scheduleId;
		this.userId = userId;
		this.seatLabel = seatLabel;
		this.resSeatLabel = resSeatLabel;
		this.seatGrade = seatGrade;
		this.seatStatus = seatStatus;
		this.holdAt = holdAt;
	}

	public int getSeatId() {
		return seatId;
	}

	public void setSeatId(int seatId) {
		this.seatId = seatId;
	}

	public String getShowId() {
		return showId;
	}

	public void setShowId(String showId) {
		this.showId = showId;
	}

	public int getScheduleId() {
		return scheduleId;
	}

	public void setScheduleId(int scheduleId) {
		this.scheduleId = scheduleId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getSeatLabel() {
		return seatLabel;
	}

	public void setSeatLabel(String seatLabel) {
		this.seatLabel = seatLabel;
	}

	public String getResSeatLabel() {
		return resSeatLabel;
	}

	public void setResSeatLabel(String resSeatLabel) {
		this.resSeatLabel = resSeatLabel;
	}

	public String getSeatGrade() {
		return seatGrade;
	}

	public void setSeatGrade(String seatGrade) {
		this.seatGrade = seatGrade;
	}

	public String getSeatStatus() {
		return seatStatus;
	}

	public void setSeatStatus(String seatStatus) {
		this.seatStatus = seatStatus;
	}

	public Date getHoldAt() {
		return holdAt;
	}

	public void setHoldAt(Date holdAt) {
		this.holdAt = holdAt;
	}

	@Override
	public String toString() {
		return "SeatDTO [seatId=" + seatId + ", showId=" + showId + ", scheduleId=" + scheduleId + ", userId=" + userId
				+ ", seatLabel=" + seatLabel + ", resSeatLabel=" + resSeatLabel + ", seatGrade=" + seatGrade
				+ ", seatStatus=" + seatStatus + ", holdAt=" + holdAt + "]";
	}
}
