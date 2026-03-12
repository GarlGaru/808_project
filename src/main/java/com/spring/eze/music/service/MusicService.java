package com.spring.eze.music.service;

import java.util.List;
import java.util.Map;

import com.spring.eze.music.dto.SongDTO;

public interface MusicService {

    // 메인 곡 리스트 (인기순)
    public List<SongDTO> getSongList();

    // 곡 상세
    public SongDTO getSongDetail(int songId);
    
    
    //==========================================
    //주간 랭킹
    public List<SongDTO> getweeklyRanking();
    
    //오늘의 히트송
    public List<SongDTO> getTodayHitSongs();
    
    //장르랭킹
    public List<SongDTO> getGenreRanking(int genreId);

    //==========================================
    
    // 유사 곡 리스트 (같은 장르, 자기 자신 제외)
    public List<SongDTO> getSimilarSongs(Map<String, Object> param);

    // 검색 (제목 + 아티스트)
    public List<SongDTO> searchSongs(String keyword);

    // 재생 로그 기록
    public void addPlayLog(int songId, int userId);

    // 좋아요 토글 (true → 좋아요, false → 취소)
    public void addLike(int songId, int userId);

    public void removeLike(int songId, int userId);

    public boolean isLikedByUser(int songId, int userId);
}