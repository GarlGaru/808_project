package com.spring.eze.user.dto;

public class MypageDayStatDTO {
	
	private int    dayIndex;  // 요일 인덱스 1=일 ~ 7=토
	private String dayName;	  // 요일명 ex) "월"
	private int    playCount; // 재생수
	
	public MypageDayStatDTO() {
		super();
	}

	public MypageDayStatDTO(int dayIndex, String dayName, int playCount) {
		super();
		this.dayIndex = dayIndex;
		this.dayName = dayName;
		this.playCount = playCount;
	}

	public int getDayIndex() {
		return dayIndex;
	}

	public void setDayIndex(int dayIndex) {
		this.dayIndex = dayIndex;
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
		return "MypageDayStatDTO [dayIndex=" + dayIndex + ", dayName=" + dayName + ", playCount=" + playCount + "]";
	}

}
