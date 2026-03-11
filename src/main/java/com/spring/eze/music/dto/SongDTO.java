package com.spring.eze.music.dto;

public class SongDTO {

	private int ranking;

	private int songId;
	private int albumId;
	private int artistId;
	private int genreId;
	
	private String title;
	private String artistName;
	private String albumTitle;
	private String genreName;

	
	private String coverImageUrl;
	private String songPath;

	private int playCount;
	private int likeCount;
    
    
    public SongDTO() {
    	super();
    	// TODO Auto-generated constructor stub
    }


	

	public SongDTO(int ranking, int songId, int albumId, int artistId, int genreId, String title, String artistName,
			String albumTitle, String genreName, String coverImageUrl, String songPath, int playCount, int likeCount) {
		super();
		this.ranking = ranking;
		this.songId = songId;
		this.albumId = albumId;
		this.artistId = artistId;
		this.genreId = genreId;
		this.title = title;
		this.artistName = artistName;
		this.albumTitle = albumTitle;
		this.genreName = genreName;
		this.coverImageUrl = coverImageUrl;
		this.songPath = songPath;
		this.playCount = playCount;
		this.likeCount = likeCount;
	}




	public int getRanking() {
		return ranking;
	}


	public void setRanking(int ranking) {
		this.ranking = ranking;
	}


	public int getSongId() {
		return songId;
	}


	public void setSongId(int songId) {
		this.songId = songId;
	}


	public int getAlbumId() {
		return albumId;
	}


	public void setAlbumId(int albumId) {
		this.albumId = albumId;
	}


	public int getArtistId() {
		return artistId;
	}


	public void setArtistId(int artistId) {
		this.artistId = artistId;
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


	public String getAlbumTitle() {
		return albumTitle;
	}


	public void setAlbumTitle(String albumTitle) {
		this.albumTitle = albumTitle;
	}


	public String getGenreName() {
		return genreName;
	}


	public void setGenreName(String genreName) {
		this.genreName = genreName;
	}


	public String getCoverImageUrl() {
		return coverImageUrl;
	}


	public void setCoverImageUrl(String coverImageUrl) {
		this.coverImageUrl = coverImageUrl;
	}


	public String getSongPath() {
		return songPath;
	}


	public void setSongPath(String songPath) {
		this.songPath = songPath;
	}


	public int getPlayCount() {
		return playCount;
	}


	public void setPlayCount(int playCount) {
		this.playCount = playCount;
	}


	public int getLikeCount() {
		return likeCount;
	}


	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}
	

	public int getGenreId() {
		return genreId;
	}




	public void setGenreId(int genreId) {
		this.genreId = genreId;
	}



    
}
    
   