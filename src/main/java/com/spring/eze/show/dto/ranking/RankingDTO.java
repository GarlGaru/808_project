package com.spring.eze.show.dto.ranking;

import java.util.Date;

public class RankingDTO {
	
	private String showId;	// 공연 ID
	private int reserveCount; // 총 예매 건수
	
	// show_tbl
	private String title;
	private Date startDate;
	private Date endDate;
	private String venueName;
	private String posterUrl;
	
	public RankingDTO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public RankingDTO(String showId, int reserveCount, String title, Date startDate, Date endDate, String venueName,
			String posterUrl) {
		super();
		this.showId = showId;
		this.reserveCount = reserveCount;
		this.title = title;
		this.startDate = startDate;
		this.endDate = endDate;
		this.venueName = venueName;
		this.posterUrl = posterUrl;
	}

	public String getShowId() {
		return showId;
	}

	public void setShowId(String showId) {
		this.showId = showId;
	}

	public int getReserveCount() {
		return reserveCount;
	}

	public void setReserveCount(int reserveCount) {
		this.reserveCount = reserveCount;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
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

	public String getVenueName() {
		return venueName;
	}

	public void setVenueName(String venueName) {
		this.venueName = venueName;
	}

	public String getPosterUrl() {
		return posterUrl;
	}

	public void setPosterUrl(String posterUrl) {
		this.posterUrl = posterUrl;
	}

	@Override
	public String toString() {
		return "RankingDTO [showId=" + showId + ", reserveCount=" + reserveCount + ", title=" + title + ", startDate="
				+ startDate + ", endDate=" + endDate + ", venueName=" + venueName + ", posterUrl=" + posterUrl + "]";
	}
	
	
}
