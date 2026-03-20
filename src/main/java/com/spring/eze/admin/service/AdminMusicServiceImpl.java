package com.spring.eze.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.spring.eze.admin.dao.AdminMetaMapper;
import com.spring.eze.admin.dao.AdminMusicDAO;
import com.spring.eze.admin.dto.AdminMusicDTO;

@Service
public class AdminMusicServiceImpl implements AdminMusicService {

    private final AdminMetaMapper metaMapper;
    private final AdminMusicDAO musicDAO;

    public AdminMusicServiceImpl(AdminMetaMapper metaMapper, AdminMusicDAO musicDAO) {
        this.metaMapper = metaMapper;
        this.musicDAO = musicDAO;
    }

    @Override
    public List<AdminMusicDTO> selectMusicList() {
        return musicDAO.selectMusicList();
    }

    @Override
    public List<AdminMusicDTO> selectArtistList() {
        return metaMapper.selectArtistList();
    }

    @Override
    public void insertArtist(AdminMusicDTO dto) {
        metaMapper.insertArtist(dto);
    }

    @Override
    public List<AdminMusicDTO> selectAlbumList() {
        return metaMapper.selectAlbumList();
    }

    @Override
    public void insertAlbum(AdminMusicDTO dto) {
        metaMapper.insertAlbum(dto);
    }

    @Override
    public List<AdminMusicDTO> selectGenreList() {
        return metaMapper.selectGenreList();
    }

    @Override
    public void insertGenre(AdminMusicDTO dto) {
        metaMapper.insertGenre(dto);
    }

    @Override
    public void insertSong(AdminMusicDTO dto) {
        musicDAO.insertSong(dto);

        int songId = musicDAO.selectLastSongId();
        dto.setSongId(songId);

        if (dto.getGenreIds() != null) {
            for (int genreId : dto.getGenreIds()) {
                AdminMusicDTO temp = new AdminMusicDTO();
                temp.setSongId(songId);
                temp.setGenreId(genreId);
                musicDAO.insertSongGenre(temp);
            }
        }
    }
}