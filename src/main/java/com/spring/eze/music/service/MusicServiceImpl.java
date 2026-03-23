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
	//아티스트 상세페이지
	public ArtistDTO getArtistDetail(int artistId) {
		
		return musicDAO.getArtistDetail(artistId);
	}

	@Override
	public List<SongDTO> getSongsByArtist(int artistId) {
		
		return musicDAO.getSongsByArtist(artistId);
	}
	//좋아요
	@Override
	public String toggleLike(int songId, int userId) {
	    int likeSum = musicDAO.getLikeScoreSum(songId, userId);

	    if (likeSum > 0) {
	        musicDAO.insertSongScore(songId, userId, -GlobalVariableHolder.GLB_SCORE_LIKE);
	        return "unliked";
	    } else {
	        musicDAO.insertSongScore(songId, userId, GlobalVariableHolder.GLB_SCORE_LIKE);
	        return "liked";
	    }
	}

	@Override
	public int getLikeStatus(int songId, int userId) {
	    return musicDAO.getLikeScoreSum(songId, userId);
	}

	@Override
	public List<SongDTO> getLikedSongs(int userId) {
	    return musicDAO.getLikedSongs(userId);
	}

	@Override
	public void searchList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		
		System.out.println("ServiceImpl - searchList");
		
		String keyword = request.getParameter("keyword");
		System.out.println("keyword"+ keyword);
		
		
		
	}

  
}