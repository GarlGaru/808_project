package com.spring.eze.playlist.dto;

import com.spring.eze.playlist.service.PlaylistType;

public class PlaylistDTO {

    private int playlistId;
    private int userId;
    private String title;
    private PlaylistType listType;

    public PlaylistDTO(int playlistId, int userId, String title, PlaylistType listType) {
        this.playlistId = playlistId;
        this.userId = userId;
        this.title = title;
        this.listType = listType;
    }

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

    public PlaylistType getListType() {
        return listType;
    }

    public void setListType(PlaylistType listType) {
        this.listType = listType;
    }

    @Override
    public String toString() {
        return "PlaylistDTO{" +
                "playlistId=" + playlistId +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                ", listType=" + listType +
                '}';
    }
}
