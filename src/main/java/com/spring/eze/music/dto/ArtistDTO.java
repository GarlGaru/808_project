package com.spring.eze.music.dto;

public class ArtistDTO {

	private int artistId;
	private String name;
	private String profileImageUrl;
	
	
	public ArtistDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	public ArtistDTO(int artistId, String name, String profileImageUrl) {
		super();
		this.artistId = artistId;
		this.name = name;
		this.profileImageUrl = profileImageUrl;
	}
	
	
	public int getArtistId() {
		return artistId;
	}
	public void setArtistId(int artistId) {
		this.artistId = artistId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getProfileImageUrl() {
		return profileImageUrl;
	}
	public void setProfileImageUrl(String profileImageUrl) {
		this.profileImageUrl = profileImageUrl;
	}
	
	
	@Override
	public String toString() {
		return "ArtistDTO [artistId=" + artistId + ", name=" + name + ", profileImageUrl=" + profileImageUrl + "]";
	}
	
	
}
