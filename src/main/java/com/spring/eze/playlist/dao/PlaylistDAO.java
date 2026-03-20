package com.spring.eze.playlist.dao;


import com.spring.eze.playlist.dto.PlaylistDTO;
import com.spring.eze.playlist.dto.PlaylistEleDTO;
import com.spring.eze.playlist.service.PlaylistType;

import java.util.List;
import java.util.Map;

public interface PlaylistDAO {

    List<PlaylistEleDTO> getPlaylist(int playListId);

    List<PlaylistDTO> getPlaylistAll(int userId);

    void createPlaylist(PlaylistDTO dto);

    int checkPlaylistExist(PlaylistDTO dto);

    PlaylistDTO getUniquePlaylist(Map<String, Object> map);
}
