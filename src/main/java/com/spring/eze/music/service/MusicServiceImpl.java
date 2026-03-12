package com.spring.eze.music.service;

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

	// 전체 곡 리스트 조회 (메인 페이지 / 랭킹 페이지에서 사용)
	@Override
	public List<SongDTO> getSongList() {
		// DAO에게 DB 조회를 요청
		return musicDAO.getSongList();
	}

	// 곡 상세 정보 조회(상세 페이지 진입 시 사용)
	@Override
	public SongDTO getSongDetail(int songId) {
		return musicDAO.getSongDetail(songId);
	}

	// 유사곡 추천 조회 / 같은 장르의 곡을 가져오는 기능
	@Override
	public List<SongDTO> getSimilarSongs(Map<String, Object> param) {

		// param에는 songId (현재 곡)genreId (현재 곡 장르)가 들어 있음
		return musicDAO.getSimilarSongs(param);
	}

	// 곡 검색 제목 또는 아티스트 기준 검색
	@Override
	public List<SongDTO> searchSongs(String keyword) {
		return musicDAO.searchSongs(keyword);
	}

	// 곡 재생 로그 기록 / 플레이 버튼 눌렀을 때 실행

	@Override
	public void addPlayLog(int songId, int userId) {

		// play_log_tbl에 재생 기록 저장
		musicDAO.insertPlayLog(songId, userId);
	}

	// 좋아요 추가

	@Override
	public void addLike(int songId, int userId) {

		// song_likes_tbl에 좋아요 저장
		musicDAO.insertSongLike(songId, userId);
	}

	// 좋아요 취소

	@Override
	public void removeLike(int songId, int userId) {

		// 좋아요 삭제
		musicDAO.deleteSongLike(songId, userId);
	}

	// 해당 유저가 이 곡을 좋아요 했는지 확인

	@Override
	public boolean isLikedByUser(int songId, int userId) {

		// DB에서 count 조회
		int count = musicDAO.existsSongLike(songId, userId);

		// 1 이상이면 true
		return count > 0;
	}
	
	//============================================================
	//주간 랭킹
	@Override
	public List<SongDTO> getweeklyRanking() {
		List<SongDTO> list = musicDAO.getWeeklyRanking();
		return list;
	}
	//오늘의 최고 히트송
	@Override
	public List<SongDTO> getTodayHitSongs() {
		List<SongDTO> list = musicDAO.getTodayHitSongs();
		return list;
	}
	//장르랭킹
	@Override
	public List<SongDTO> getGenreRanking(int genreId) {
		
		return null;
	}
}