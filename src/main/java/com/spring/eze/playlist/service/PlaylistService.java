package com.spring.eze.playlist.service;

import com.spring.eze.playlist.dto.PlaylistDTO;
import com.spring.eze.playlist.dto.PlaylistEleDTO;

import java.util.List;


public interface PlaylistService {

    List<PlaylistEleDTO> getPlaylist(int playListId);

    PlaylistDTO getLikes(int playListId);

    PlaylistDTO getHistory(int playListId);

    List<PlaylistDTO> getPlaylistAll(int userId);
}
