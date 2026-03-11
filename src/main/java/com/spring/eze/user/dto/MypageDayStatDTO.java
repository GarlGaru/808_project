package com.spring.eze.user.dto;

public class MypageDayStatDTO {
	
	private String dayName;	  // 요일명 ex) "월"
	private int    playCount; // 재생수
	
	public MypageDayStatDTO() {
		super();
	}

	public MypageDayStatDTO(String dayName, int playCount) {
		super();
		this.dayName = dayName;
		this.playCount = playCount;
	}

	public String getDayName() {
		return dayName;
	}

	public void setDayName(String dayName) {
		this.dayName = dayName;
	}

	public int getPlayCount() {
		return playCount;
	}

	public void setPlayCount(int playCount) {
		this.playCount = playCount;
	}

	@Override
	public String toString() {
		return "MypageDayStatDTO [dayName=" + dayName + ", playCount=" + playCount + "]";
	}
	

}
