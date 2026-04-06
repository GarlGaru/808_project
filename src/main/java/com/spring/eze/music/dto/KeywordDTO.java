package com.spring.eze.music.dto;

public class KeywordDTO {
	
	private int song_id;
	private int genre_id;
	private String keyword;
	
	public KeywordDTO() {
		super();
		
	}
	public KeywordDTO(int song_id, int genre_id, String keyword) {
		super();
		this.song_id = song_id;
		this.genre_id = genre_id;
		this.keyword = keyword;
	}
	public int getSong_id() {
		return song_id;
	}
	public void setSong_id(int song_id) {
		this.song_id = song_id;
	}
	public int getGenre_id() {
		return genre_id;
	}
	public void setGenre_id(int genre_id) {
		this.genre_id = genre_id;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	
	@Override
	public String toString() {
		return "KeywordDTO [song_id=" + song_id + ", genre_id=" + genre_id + ", keyword=" + keyword + "]";
	}
	
	
	
	

}
