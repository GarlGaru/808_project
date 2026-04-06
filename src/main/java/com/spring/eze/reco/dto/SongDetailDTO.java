package com.spring.eze.reco.dto;

import java.util.List;

public class SongDetailDTO {
    private int song_id;
    private String song_title;
    private String album_title;
    private String artist_name;
    private List<String> genres;

    public SongDetailDTO() {
    }

    public SongDetailDTO(int song_id, String song_title, String album_title, String artist_name, List<String> genres) {
        this.song_id = song_id;
        this.song_title = song_title;
        this.album_title = album_title;
        this.artist_name = artist_name;
        this.genres = genres;
    }

    public int getSong_id() {
        return song_id;
    }

    public void setSong_id(int song_id) {
        this.song_id = song_id;
    }

    public String getSong_title() {
        return song_title;
    }

    public void setSong_title(String song_title) {
        this.song_title = song_title;
    }

    public String getAlbum_title() {
        return album_title;
    }

    public void setAlbum_title(String album_title) {
        this.album_title = album_title;
    }

    public String getArtist_name() {
        return artist_name;
    }

    public void setArtist_name(String artist_name) {
        this.artist_name = artist_name;
    }

    public List<String> getGenres() {
        return genres;
    }

    public void setGenres(List<String> genres) {
        this.genres = genres;
    }

    @Override
    public String toString() {
        return "SongDetail{" +
                "song_id=" + song_id +
                ", song_title='" + song_title + '\'' +
                ", album_title='" + album_title + '\'' +
                ", artist_name='" + artist_name + '\'' +
                ", genres=" + genres +
                '}';
    }
}
