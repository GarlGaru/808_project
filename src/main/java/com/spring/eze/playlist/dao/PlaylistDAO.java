package com.spring.eze.playlist.dao;


import com.spring.eze.playlist.dto.PlaylistDTO;
import com.spring.eze.playlist.dto.PlaylistEleDTO;

import java.util.List;

public interface PlaylistDAO {

    List<PlaylistEleDTO> getPlaylist(int playListId);

    List<PlaylistDTO> getPlaylistAll(int userId);
}
