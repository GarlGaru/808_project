package com.spring.eze.music.dto;

public class SongDTO {

    private int songId;
    private String title;

    private String artistName;
    private String albumTitle;
    private String genreName;
    private String coverImageUrl;

    private int playCount;
    private int likeCount;
    private int genreId; 
    
    
    
    public SongDTO() {
    	super();
    	// TODO Auto-generated constructor stub
    }
    
    
    
    
    
    
    public SongDTO(int songId, String title, String artistName, String albumTitle, String genreName,
			String coverImageUrl, int playCount, int likeCount, int genreId) {
		
		this.songId = songId;
		this.title = title;
		this.artistName = artistName;
		this.albumTitle = albumTitle;
		this.genreName = genreName;
		this.coverImageUrl = coverImageUrl;
		this.playCount = playCount;
		this.likeCount = likeCount;
		this.genreId = genreId;
	}






	// ====== getter / setter ======
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