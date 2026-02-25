package com.spring.eze.show.dto.Seat;

import java.time.LocalDateTime;
import java.util.Date;

public class SeatDTO {

	
   
    private int seat_id;
	private String user_id;
    private String schedule_id;	//공연 날짜 및 시간

    private String res_seat_label;  // 좌석 라벨 (예: A열 15번)
    private String seat_grade;     // 좌석 등급 (VIP, R석 등)
    private String seat_status;    // 예약 상태 (예약중, 완료, 취소 등)
    
    private Date hold_At;        // 선점 시작 시간
    private Date hold_Expires;	  // 선점 만료 시간	 
    
    
    public SeatDTO(int seat_id, String user_id, String schedule_id, String res_seat_label, String seat_grade,
			String seat_status, Date hold_At, Date hold_Expires) {
		super();
		this.seat_id = seat_id;
		this.user_id = user_id;
		this.schedule_id = schedule_id;
		this.res_seat_label = res_seat_label;
		this.seat_grade = seat_grade;
		this.seat_status = seat_status;
		this.hold_At = hold_At;
		this.hold_Expires = hold_Expires;
	}

    
	public SeatDTO() {
		super();
	}



	public int getSeat_id() {
		return seat_id;
	}



	public void setSeat_id(int seat_id) {
		this.seat_id = seat_id;
	}



	public String getUser_id() {
		return user_id;
	}


	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}


	public String getSchedule_id() {
		return schedule_id;
	}


	public void setSchedule_id(String schedule_id) {
		this.schedule_id = schedule_id;
	}


	public String getRes_seat_label() {
		return res_seat_label;
	}


	public void setRes_seat_label(String res_seat_label) {
		this.res_seat_label = res_seat_label;
	}


	public String getSeat_grade() {
		return seat_grade;
	}


	public void setSeat_grade(String seat_grade) {
		this.seat_grade = seat_grade;
	}


	public String getSeat_status() {
		return seat_status;
	}


	public void setSeat_status(String seat_status) {
		this.seat_status = seat_status;
	}


	public Date getHold_At() {
		return hold_At;
	}


	public void setHold_At(Date hold_At) {
		this.hold_At = hold_At;
	}


	public Date getHold_Expires() {
		return hold_Expires;
	}


	public void setHold_Expires(Date hold_Expires) {
		this.hold_Expires = hold_Expires;
	}


	@Override
	public String toString() {
		return "SeatDTO [seat_id=" + seat_id + ", user_id=" + user_id + ", schedule_id=" + schedule_id
				+ ", res_seat_label=" + res_seat_label + ", seat_grade=" + seat_grade + ", seat_status=" + seat_status
				+ ", hold_At=" + hold_At + ", hold_Expires=" + hold_Expires + "]";
	}
    
    
    
}
