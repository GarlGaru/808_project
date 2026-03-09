package com.spring.eze.show.dto.Show;

import java.sql.Date;

public class ShowDTO {

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
	
	public ShowDTO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public ShowDTO(String showId, String title, Date startDate, Date endDate, String venueName, String posterUrl,
			String area, String genre, String openrunYn, String state) {
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

	@Override
	public String toString() {
		return "ShowDTO [showId=" + showId + ", title=" + title + ", startDate=" + startDate + ", endDate=" + endDate
				+ ", venueName=" + venueName + ", posterUrl=" + posterUrl + ", area=" + area + ", genre=" + genre
				+ ", openrunYn=" + openrunYn + ", state=" + state + "]";
	}
	
}
