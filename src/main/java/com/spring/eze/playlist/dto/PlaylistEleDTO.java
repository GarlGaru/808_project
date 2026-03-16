package com.spring.eze.playlist.dto;

public class PlaylistEleDTO {

    private int eleId;
    private int playlistId;
    private int songId;

    public PlaylistEleDTO() {
    }

    public PlaylistEleDTO(int eleId, int playlistId, int songId) {
        this.eleId = eleId;
        this.playlistId = playlistId;
        this.songId = songId;
    }

    public int getEleId() {
        return eleId;
    }

    public void setEleId(int eleId) {
        this.eleId = eleId;
    }

    public int getPlaylistId() {
        return playlistId;
    }

    public void setPlaylistId(int playlistId) {
        this.playlistId = playlistId;
    }

    public int getSongId() {
        return songId;
    }

    public void setSongId(int songId) {
        this.songId = songId;
    }

    @Override
    public String toString() {
        return "playlistEleDTO{" +
                "eleId=" + eleId +
                ", playlistId=" + playlistId +
                ", songId=" + songId +
                '}';
    }
}
