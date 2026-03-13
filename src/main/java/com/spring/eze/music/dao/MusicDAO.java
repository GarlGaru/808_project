package com.spring.eze.music.dao;

import java.util.List;
import java.util.Map;

import com.spring.eze.music.dto.SongDTO;

public interface MusicDAO {

	public List<SongDTO> getSongList();

    public SongDTO getSongDetail(int songId);

    public List<SongDTO> getSimilarSongs(Map<String, Object> param);

    public List<SongDTO> searchSongs(String keyword);

    public void insertPlayLog(int songId, int userId);

    public void insertSongLike(int songId, int userId);

    public void deleteSongLike(int songId, int userId);

    public int existsSongLike(int songId, int userId);
    
    // 랭킹
    //주간랭킹
    public List<SongDTO> getWeeklyRanking();
    
    
    //오늘의 최고 히트곡
    public List<SongDTO> getTodayHitSongs();
    
    //장르랭킹
    public List<SongDTO> getGenreRanking(int genreId);
    
    //점수 insert
    public void insertSongScore(int songId, int userId, int score);
    
    //노래 연결
    public String getSongPath(int songId);
 
}