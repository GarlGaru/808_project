package com.spring.eze.user.dto;

public class MypageGenreStatDTO {

	private String genreName;  // 장르명
	private int    playCount;  // 재생 횟수
	private int    percentage; // 비율(%)
	
	public MypageGenreStatDTO() {
		super();
	}

	public MypageGenreStatDTO(String genreName, int playCount, int percentage) {
		super();
		this.genreName = genreName;
		this.playCount = playCount;
		this.percentage = percentage;
	}

	public String getGenreName() {
		return genreName;
	}

	public void setGenreName(String genreName) {
		this.genreName = genreName;
	}

	public int getPlayCount() {
		return playCount;
	}

	public void setPlayCount(int playCount) {
		this.playCount = playCount;
	}

	public int getPercentage() {
		return percentage;
	}

	public void setPercentage(int percentage) {
		this.percentage = percentage;
	}

	@Override
	public String toString() {
		return "MypageGenreStatDTO [genreName=" + genreName + ", playCount=" + playCount + ", percentage=" + percentage
				+ "]";
	}
	
	
}
