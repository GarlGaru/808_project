package com.spring.eze.music.service;

import java.util.List;
import java.util.Map;

import com.spring.eze.music.dto.SongDTO;

public interface MusicService {

    // 메인 곡 리스트 (인기순)
    List<SongDTO> getSongList();

    // 곡 상세
    SongDTO getSongDetail(int songId);

    // 유사 곡 리스트 (같은 장르, 자기 자신 제외)
    List<SongDTO> getSimilarSongs(Map<String, Object> param);

    // 검색 (제목 + 아티스트)
    List<SongDTO> searchSongs(String keyword);

    // 재생 로그 기록
    void addPlayLog(int songId, int userId);

    // 좋아요 토글 (true → 좋아요, false → 취소)
    void addLike(int songId, int userId);

    void removeLike(int songId, int userId);

    boolean isLikedByUser(int songId, int userId);
}