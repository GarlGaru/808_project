package com.spring.eze.playlist.service;

import com.spring.eze.playlist.dto.PlaylistDTO;
import com.spring.eze.playlist.dto.PlaylistEleDTO;

import java.util.List;


public interface PlaylistService {

    int createPlaylist(int userId, String title);

    List<PlaylistEleDTO> getPlaylist(int playListId);

    PlaylistDTO getLikes(int userId);

    PlaylistDTO getHistory(int userId);

    List<PlaylistDTO> getPlaylistAll(int userId);
}
