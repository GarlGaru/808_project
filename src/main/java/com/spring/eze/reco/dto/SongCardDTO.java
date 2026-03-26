package com.spring.eze.reco.dto;


public class SongCardDTO {

    private int songId;
    private String artistName;
    private String songTitle;
    private String coverImageUrl;

    public SongCardDTO() {
    }

    public SongCardDTO(int songId, String artistName, String songTitle, String coverImageUrl) {
        this.songId = songId;
        this.artistName = artistName;
        this.songTitle = songTitle;
        this.coverImageUrl = coverImageUrl;
    }

    public int getSongId() {
        return songId;
    }

    public void setSongId(int songId) {
        this.songId = songId;
    }

    public String getArtistName() {
        return artistName;
    }

    public void setArtistName(String artistName) {
        this.artistName = artistName;
    }

    public String getSongTitle() {
        return songTitle;
    }

    public void setSongTitle(String songTitle) {
        this.songTitle = songTitle;
    }

    public String getCoverImageUrl() {
        return coverImageUrl;
    }

    public void setCoverImageUrl(String coverImageUrl) {
        this.coverImageUrl = coverImageUrl;
    }

    @Override
    public String toString() {
        return "SongCardDTO{" +
                "songId=" + songId +
                ", artistName='" + artistName + '\'' +
                ", songTitle='" + songTitle + '\'' +
                ", coverImageUrl='" + coverImageUrl + '\'' +
                '}';
    }
}
