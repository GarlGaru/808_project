package com.spring.eze.music.dto;

public class SongDTO {

	

	private int songId;
	private int albumId;
	private int artistId;
	private int genreId;
	private int totalScore;
	
	private String title;
	private String artistName;
	private String albumTitle;
	private String genreName;

	private String coverImageUrl;
	private String songPath;

	
    public SongDTO() {
    	super();
    	// TODO Auto-generated constructor stub
    }

	public SongDTO( int songId, int albumId, int artistId, int genreId, int totalScore, String title,
			String artistName, String albumTitle, String genreName, String coverImageUrl, String songPath) {
		super();
		
		this.songId = songId;
		this.albumId = albumId;
		this.artistId = artistId;
		this.genreId = genreId;
		this.totalScore = totalScore;
		this.title = title;
		this.artistName = artistName;
		this.albumTitle = albumTitle;
		this.genreName = genreName;
		this.coverImageUrl = coverImageUrl;
		this.songPath = songPath;
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
	

	public int getGenreId() {
		return genreId;
	}




	public void setGenreId(int genreId) {
		this.genreId = genreId;
	}

	public int getTotalScore() {
		return totalScore;
	}

	public void setTotalScore(int totalScore) {
		this.totalScore = totalScore;
	}



    
}
    
   