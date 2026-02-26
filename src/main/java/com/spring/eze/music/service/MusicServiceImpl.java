package com.spring.eze.music.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.eze.music.dao.MusicDAO;
import com.spring.eze.music.dto.SongDTO;

@Service
public class MusicServiceImpl implements MusicService {

    @Autowired
    private MusicDAO musicDAO;

    @Override
    public List<SongDTO> getSongList() {
        return musicDAO.getSongList();
    }

    @Override
    public SongDTO getSongDetail(int songId) {
        return musicDAO.getSongDetail(songId);
    }

    @Override
    public List<SongDTO> getSimilarSongs(Map<String, Object> param) {
       
        return musicDAO.getSimilarSongs(param);
    }

    @Override
    public List<SongDTO> searchSongs(String keyword) {
        return musicDAO.searchSongs(keyword);
    }

    @Override
    public void addPlayLog(int songId, int userId) {
        musicDAO.insertPlayLog(songId, userId);
    }

    @Override
    public void addLike(int songId, int userId) {
        musicDAO.insertSongLike(songId, userId);
    }

    @Override
    public void removeLike(int songId, int userId) {
        musicDAO.deleteSongLike(songId, userId);
    }

    @Override
    public boolean isLikedByUser(int songId, int userId) {
        int count = musicDAO.existsSongLike(songId, userId);
        return count > 0;
    }
}