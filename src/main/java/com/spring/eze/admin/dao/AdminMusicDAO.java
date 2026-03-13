package com.spring.eze.admin.dao;

import java.util.List;
import com.spring.eze.admin.dto.AdminMusicDTO;

public interface AdminMusicDAO {
	
    List<AdminMusicDTO> selectMusicList();
    
    List<AdminMusicDTO> selectArtistList();
    void insertArtist(AdminMusicDTO dto);
    
    List<AdminMusicDTO> selectAlbumList();
    void insertAlbum(AdminMusicDTO dto);
        List<AdminMusicDTO> selectGenreList();
    void insertGenre(AdminMusicDTO dto);
}