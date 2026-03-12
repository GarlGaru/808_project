package com.spring.eze.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.spring.eze.admin.dao.AdminArtistMapper;
import com.spring.eze.admin.dto.AdminMusicDTO;

@Service
public class AdminMusicServiceImpl implements AdminMusicService {

    private final AdminArtistMapper mapper;

    public AdminMusicServiceImpl(AdminArtistMapper mapper) {
        this.mapper = mapper;
    }

    @Override
    public List<AdminMusicDTO> selectArtistList() {
        return mapper.selectArtistList();
    }

    @Override
    public void insertArtist(AdminMusicDTO dto) {
        mapper.insertArtist(dto);
    }
}