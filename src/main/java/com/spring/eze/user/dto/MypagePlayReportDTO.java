package com.spring.eze.user.dto;

import java.util.List;

public class MypagePlayReportDTO {

	private int    totalPlayCount;			    // 총 재생 곡 수
	private int    totlaPlayTimesec;			// 총 청취시간 (초) 뮤직팀 스코어 계산법 확인후 시간 추출
	private String busiestDay;					// 가장 활발한 요일
	private String periodType; 					// THIS_MONTH / LAST_MONTH / 3MONTH / 1YEAR
	private List<MypageDayStatDTO> dayStats;	// 요일별 재생수(차트용)
	private List<MypageGenreStatDTO> topGenres; // 탑 장르
	
	public MypagePlayReportDTO() {
		super();
	}

	public MypagePlayReportDTO(int totalPlayCount, int totlaPlayTimesec, String busiestDay, String periodType,
			List<MypageDayStatDTO> dayStats, List<MypageGenreStatDTO> topGenres) {
		super();
		this.totalPlayCount = totalPlayCount;
		this.totlaPlayTimesec = totlaPlayTimesec;
		this.busiestDay = busiestDay;
		this.periodType = periodType;
		this.dayStats = dayStats;
		this.topGenres = topGenres;
	}

	public int getTotalPlayCount() {
		return totalPlayCount;
	}

	public void setTotalPlayCount(int totalPlayCount) {
		this.totalPlayCount = totalPlayCount;
	}

	public int getTotlaPlayTimesec() {
		return totlaPlayTimesec;
	}

	public void setTotlaPlayTimesec(int totlaPlayTimesec) {
		this.totlaPlayTimesec = totlaPlayTimesec;
	}

	public String getBusiestDay() {
		return busiestDay;
	}

	public void setBusiestDay(String busiestDay) {
		this.busiestDay = busiestDay;
	}

	public String getPeriodType() {
		return periodType;
	}

	public void setPeriodType(String periodType) {
		this.periodType = periodType;
	}

	public List<MypageDayStatDTO> getDayStats() {
		return dayStats;
	}

	public void setDayStats(List<MypageDayStatDTO> dayStats) {
		this.dayStats = dayStats;
	}

	public List<MypageGenreStatDTO> getTopGenres() {
		return topGenres;
	}

	public void setTopGenres(List<MypageGenreStatDTO> topGenres) {
		this.topGenres = topGenres;
	}

	@Override
	public String toString() {
		return "MypagePlayReportDTO [totalPlayCount=" + totalPlayCount + ", totlaPlayTimesec=" + totlaPlayTimesec
				+ ", busiestDay=" + busiestDay + ", periodType=" + periodType + ", dayStats=" + dayStats
				+ ", topGenres=" + topGenres + "]";
	}
	
	
}
