package com.spring.eze.music.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.eze.common.GlobalVariableHolder;
import com.spring.eze.music.dao.MusicDAO;
import com.spring.eze.music.dto.SongDTO;

@Service
public class MusicServiceImpl implements MusicService {

    @Autowired
    private MusicDAO musicDAO;

    @Override
    public List<SongDTO> getweeklyRanking() {
        return musicDAO.getWeeklyRanking();
    }

    @Override
    public List<SongDTO> getTodayHitSongs() {
        return musicDAO.getTodayHitSongs();
    }

    @Override
    public List<SongDTO> getGenreRanking(int genreId) {
        return musicDAO.getGenreRanking(genreId);
    }

    @Override
    public void addPlayScore(int songId, int userId) {
        musicDAO.insertSongScore(songId, userId, GlobalVariableHolder.GLB_SCORE_PLAY);
    }

    @Override
    public void addIntervalScore(int songId, int userId) {
        musicDAO.insertSongScore(songId, userId, GlobalVariableHolder.GLB_SCORE_INTERVAL);
    }

    @Override
    public void addLikeScore(int songId, int userId) {
        musicDAO.insertSongScore(songId, userId, GlobalVariableHolder.GLB_SCORE_LIKE);
    }
    @Override
    public SongDTO getSongDetail(int songId) {
        return musicDAO.getSongDetail(songId);
    }

    @Override
    public List<SongDTO> getSimilarSongs(Map<String, Object> param) {
        return musicDAO.getSimilarSongs(param);
    }
    //노래연결
	@Override
	public String getSongPath(int songId) {
		return musicDAO.getSongPath(songId);
	}


  
}