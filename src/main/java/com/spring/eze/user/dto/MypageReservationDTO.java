package com.spring.eze.user.dto;

public class MypageReservationDTO {

    // 1. 기본 식별 정보
    private int reservationId;   // 예매 번호
    
    // 2. 공연 정보 (show_tbl 기반)
    private String showTitle;    // 공연 제목 (title)
    private String startTime;    // 공연 기간 또는 관람일 (가공된 문자열)
    private String venue;        // 공연 장소 (venue_name)
    private String posterPath;   // 포스터 경로 (poster_url)

    // 3. 좌석 정보 (seat_tbl 기반 - 디자인 포인트를 위해 분리!)
    private String seatGrade;    // 좌석 등급 (VIP, R, S 등)
    private String seatLabel;    // 좌석 번호 (A-12 등)

    // 4. 결제 및 상태 (reservation_tbl 기반)
    private String amt;          // 가공된 결제 금액 (₩88,000)
    private String status;       // 예매 상태 (CONFIRMED, CANCELLED 등)

    // 5. 프론트엔드 전용 (필요 시 Service에서 세팅)
    private String gradient;     // 포스터 없을 때 깔아줄 배경색

	public MypageReservationDTO() {
		super();
	}

	public MypageReservationDTO(int reservationId, String showTitle, String startTime, String venue, String posterPath,
			String seatGrade, String seatLabel, String amt, String status, String gradient) {
		super();
		this.reservationId = reservationId;
		this.showTitle = showTitle;
		this.startTime = startTime;
		this.venue = venue;
		this.posterPath = posterPath;
		this.seatGrade = seatGrade;
		this.seatLabel = seatLabel;
		this.amt = amt;
		this.status = status;
		this.gradient = gradient;
	}

	public int getReservationId() {
		return reservationId;
	}

	public void setReservationId(int reservationId) {
		this.reservationId = reservationId;
	}

	public String getShowTitle() {
		return showTitle;
	}

	public void setShowTitle(String showTitle) {
		this.showTitle = showTitle;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getVenue() {
		return venue;
	}

	public void setVenue(String venue) {
		this.venue = venue;
	}

	public String getPosterPath() {
		return posterPath;
	}

	public void setPosterPath(String posterPath) {
		this.posterPath = posterPath;
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

	public String getAmt() {
		return amt;
	}

	public void setAmt(String amt) {
		this.amt = amt;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getGradient() {
		return gradient;
	}

	public void setGradient(String gradient) {
		this.gradient = gradient;
	}

	@Override
	public String toString() {
		return "MypageReservationDTO [reservationId=" + reservationId + ", showTitle=" + showTitle + ", startTime="
				+ startTime + ", venue=" + venue + ", posterPath=" + posterPath + ", seatGrade=" + seatGrade
				+ ", seatLabel=" + seatLabel + ", amt=" + amt + ", status=" + status + ", gradient=" + gradient + "]";
	}
	
	
	
	
}

