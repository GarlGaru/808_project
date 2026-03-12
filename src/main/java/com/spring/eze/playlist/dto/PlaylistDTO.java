package com.spring.eze.playlist.dto;

public class PlaylistDTO {

    private int playlistId;
    private int userId;
    private String title;

    public int getPlaylistId() {
        return playlistId;
    }

    public void setPlaylistId(int playlistId) {
        this.playlistId = playlistId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    @Override
    public String toString() {
        return "PlaylistDTO{" +
                "playlistId=" + playlistId +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                '}';
    }
}
