package com.spring.eze.admin.service;

import java.util.List;
import com.spring.eze.admin.dto.AdminMusicDTO;

public interface AdminMusicService {

    List<AdminMusicDTO> selectMusicList();
    List<AdminMusicDTO> selectArtistList();
    List<AdminMusicDTO> selectAlbumList();
    List<AdminMusicDTO> selectGenreList();

    void insertArtist(AdminMusicDTO dto);
    void insertAlbum(AdminMusicDTO dto);
    void insertGenre(AdminMusicDTO dto);
    void insertSong(AdminMusicDTO dto);
}