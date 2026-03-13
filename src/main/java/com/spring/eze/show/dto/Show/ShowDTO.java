package com.spring.eze.show.dto.Show;

import java.sql.Date;

public class ShowDTO {

//	show_tbl
    private String showId; //Kopis Api id
	private String title;
	private Date startDate;
	private Date endDate;
	private String venueName;
	private String posterUrl;
	private String area;
	private String genre;
	private String openrunYn;
	private String state;
	
//  showDetail_tbl
	private String runtime;
	private String ageLimit;
	private String ticketPrice;
	private String castInfo;
	private String styurl;
	
//	schedule_tbl
	private int scheduleId;
	private String startTime;
	private String endTime;
	private Date playDate;
	
	public ShowDTO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public ShowDTO(String showId, String title, Date startDate, Date endDate, String venueName, String posterUrl,
			String area, String genre, String openrunYn, String state, String runtime, String ageLimit,
			String ticketPrice, String castInfo, String styurl, int scheduleId, String startTime, String endTime, Date playDate) {
		super();
		this.showId = showId;
		this.title = title;
		this.startDate = startDate;
		this.endDate = endDate;
		this.venueName = venueName;
		this.posterUrl = posterUrl;
		this.area = area;
		this.genre = genre;
		this.openrunYn = openrunYn;
		this.state = state;
		this.runtime = runtime;
		this.ageLimit = ageLimit;
		this.ticketPrice = ticketPrice;
		this.castInfo = castInfo;
		this.styurl = styurl;
		this.scheduleId = scheduleId;
		this.startTime = startTime;
		this.endTime = endTime;
		this.playDate = playDate;
	}

	public String getShowId() {
		return showId;
	}

	public void setShowId(String showId) {
		this.showId = showId;
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

	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}

	public String getGenre() {
		return genre;
	}

	public void setGenre(String genre) {
		this.genre = genre;
	}

	public String getOpenrunYn() {
		return openrunYn;
	}

	public void setOpenrunYn(String openrunYn) {
		this.openrunYn = openrunYn;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getRuntime() {
		return runtime;
	}

	public void setRuntime(String runtime) {
		this.runtime = runtime;
	}

	public String getAgeLimit() {
		return ageLimit;
	}

	public void setAgeLimit(String ageLimit) {
		this.ageLimit = ageLimit;
	}

	public String getTicketPrice() {
		return ticketPrice;
	}

	public void setTicketPrice(String ticketPrice) {
		this.ticketPrice = ticketPrice;
	}

	public String getCastInfo() {
		return castInfo;
	}

	public void setCastInfo(String castInfo) {
		this.castInfo = castInfo;
	}

	public String getStyurl() {
		return styurl;
	}

	public void setStyurl(String styurl) {
		this.styurl = styurl;
	}

	public int getScheduleId() {
		return scheduleId;
	}

	public void setScheduleId(int scheduleId) {
		this.scheduleId = scheduleId;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	
	public Date getPlayDate() {
		return playDate;
	}

	public void setPlayDate(Date playDate) {
		this.playDate = playDate;
	}

	@Override
	public String toString() {
		return "ShowDTO [showId=" + showId + ", title=" + title + ", startDate=" + startDate + ", endDate=" + endDate
				+ ", venueName=" + venueName + ", posterUrl=" + posterUrl + ", area=" + area + ", genre=" + genre
				+ ", openrunYn=" + openrunYn + ", state=" + state + ", runtime=" + runtime + ", ageLimit=" + ageLimit
				+ ", ticketPrice=" + ticketPrice + ", castInfo=" + castInfo + ", styurl=" + styurl + ", scheduleId="
				+ scheduleId + ", startTime=" + startTime + ", endTime=" + endTime + ", playDate=" + playDate + "]";
	}

}
