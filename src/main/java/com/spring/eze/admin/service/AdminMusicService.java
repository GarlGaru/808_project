package com.spring.eze.admin.service;

import java.util.List;
import com.spring.eze.admin.dto.AdminMusicDTO;

public interface AdminMusicService {

    List<AdminMusicDTO> selectArtistList();

    void insertArtist(AdminMusicDTO dto);
}