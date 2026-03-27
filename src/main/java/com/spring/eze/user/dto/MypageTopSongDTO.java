package com.spring.eze.user.dto;

/**
 * MypageTopSongDTO
 * 808 플레이 리포트 — 탑 곡 Top10
 * 기간 필터: THIS_MONTH / LAST_MONTH / 3MONTH
 */
public class MypageTopSongDTO {

    private int    songId;        // 곡 번호 
    private String title;         // 곡 제목 
    private String artistName;    // 아티스트명 
    private int    playCount;  	  // 재생횟수
    private String coverImageUrl; // 앨범커버
    
	public MypageTopSongDTO() {
		super();
	}

	public MypageTopSongDTO(int songId, String title, String artistName, int playCount, String coverImageUrl) {
		super();
		this.songId = songId;
		this.title = title;
		this.artistName = artistName;
		this.playCount = playCount;
		this.coverImageUrl = coverImageUrl;
	}

	public int getSongId() {
		return songId;
	}

	public void setSongId(int songId) {
		this.songId = songId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getArtistName() {
		return artistName;
	}

	public void setArtistName(String artistName) {
		this.artistName = artistName;
	}

	public int getPlayCount() {
		return playCount;
	}

	public void setPlayCount(int playCount) {
		this.playCount = playCount;
	}

	public String getCoverImageUrl() {
		return coverImageUrl;
	}

	public void setCoverImageUrl(String coverImageUrl) {
		this.coverImageUrl = coverImageUrl;
	}

	@Override
	public String toString() {
		return "MypageTopSongDTO [songId=" + songId + ", title=" + title + ", artistName=" + artistName + ", playCount="
				+ playCount + ", coverImageUrl=" + coverImageUrl + "]";
	}


}
