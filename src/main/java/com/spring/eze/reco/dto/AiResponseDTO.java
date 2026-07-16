package com.spring.eze.reco.dto;

import java.util.List;

public class AiResponseDTO {
    String reply;
    List<SongDetailDTO> songs;

    public AiResponseDTO() {
    }

    public AiResponseDTO(String reply, List<SongDetailDTO> songs) {
        this.reply = reply;
        this.songs = songs;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public List<SongDetailDTO> getSongs() {
        return songs;
    }

    public void setSongs(List<SongDetailDTO> songs) {
        this.songs = songs;
    }

    @Override
    public String toString() {
        return "AiResponseDTO{" +
                "reply='" + reply + '\'' +
                ", songs=" + songs +
                '}';
    }
}
