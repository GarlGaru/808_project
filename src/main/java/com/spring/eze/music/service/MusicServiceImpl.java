package com.spring.eze.music.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.eze.common.GlobalVariableHolder;
import com.spring.eze.music.dao.MusicDAO;
import com.spring.eze.music.dto.ArtistDTO;
import com.spring.eze.music.dto.KeywordDTO;
import com.spring.eze.music.dto.SongDTO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.transaction.annotation.Transactional;

@Service
public class MusicServiceImpl implements MusicService {
	
	private static final Logger log = LoggerFactory.getLogger(MusicServiceImpl.class);
	
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
	//아티스트 상세페이지
	public ArtistDTO getArtistDetail(int artistId) {
		
		return musicDAO.getArtistDetail(artistId);
	}

	@Override
	public List<SongDTO> getSongsByArtist(int artistId) {
		
		return musicDAO.getSongsByArtist(artistId);
	}
	//좋아요
	/**
	 * 좋아요 버튼 토글을 처리한다.
	 * 
	 * 1. 현재 사용자가 해당 곡을 좋아요 했는지 먼저 확인한다.
	 * 2. 이미 좋아요 상태면 song_score_tbl 의 300점 row 를 삭제한다.
	 * 3. 좋아요 상태가 아니면 song_score_tbl 에 300점 row 를 추가한다.
	 * 4. 동시에 LIKE 타입 플레이리스트를 조회하여 playlist_ele_tbl 도 함께 동기화한다.
	 * 5. 최종 결과로 liked 또는 unliked 문자열을 반환한다.
	 */
	@Transactional
	@Override
	public String toggleLike(int songId, int userId) {
	    int existsLike = musicDAO.existsLikeScoreRow(songId, userId);

	    if (existsLike > 0) {
	        // 1. score 테이블에서 좋아요 row 삭제
	        musicDAO.deleteLikeScore(songId, userId);

	        // 2. LIKE 플레이리스트 조회
	        Integer likePlaylistId = musicDAO.getLikePlaylistId(userId);

	        // 3. 좋아요 플레이리스트가 있으면 그 안의 곡도 삭제
	        if (likePlaylistId != null) {
	            musicDAO.deletePlaylistElement(likePlaylistId, songId);
	        }

	        return "unliked";

	    } else {
	        // 1. score 테이블에 좋아요 row 추가
	        musicDAO.insertLikeScore(songId, userId);

	        // 2. LIKE 플레이리스트 조회
	        Integer likePlaylistId = musicDAO.getLikePlaylistId(userId);

	        // 3. 없으면 새로 생성
	        if (likePlaylistId == null) {
	            musicDAO.createLikePlaylist(userId);
	            likePlaylistId = musicDAO.getLikePlaylistId(userId);
	        }

	        // 4. playlist 안에 같은 곡이 없을 때만 추가
	        if (likePlaylistId != null) {
	            int existsPlaylistSong = musicDAO.existsPlaylistElement(likePlaylistId, songId);

	            if (existsPlaylistSong == 0) {
	                musicDAO.insertPlaylistElement(likePlaylistId, songId);
	            }
	        }

	        return "liked";
	    }
	}
	
	@Override
	public int getLikeStatus(int songId, int userId) {
	    return musicDAO.existsLikeScoreRow(songId, userId);
	}



	@Override
	public List<SongDTO> getLikedSongs(int userId) {
	    return musicDAO.getLikedSongs(userId);
	}

	@Override
	public List<SongDTO> searchSongs(String keyword) {
	
		return musicDAO.getSearhSong(keyword);
	}

	@Override
	public List<KeywordDTO> getKeyword(int songId) {
		
		return musicDAO.getKeywordList(songId);
	}

  
}