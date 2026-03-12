package com.spring.eze.music.service;

import java.util.List;
import java.util.Map;

import com.spring.eze.music.dto.SongDTO;

public interface MusicService {


    
    //==========================================
    //주간 랭킹
    public List<SongDTO> getweeklyRanking();
    
    //오늘의 히트송
    public List<SongDTO> getTodayHitSongs();
    
    //장르랭킹
    public List<SongDTO> getGenreRanking(int genreId);

    //==========================================


    // 재생 시작 점수
    public void addPlayScore(int songId, int userId);

    // 일정 시간 이상 재생 점수
    public void addIntervalScore(int songId, int userId);

    // 좋아요 점수
    public void addLikeScore(int songId, int userId);
    
    
    //==========================================
    public SongDTO getSongDetail(int songId);

    public List<SongDTO> getSimilarSongs(Map<String, Object> param);
    
    //노래연결
    public String getSongPath(int songId);
   
}