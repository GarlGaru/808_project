package com.spring.eze.music.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.music.dto.ArtistDTO;
import com.spring.eze.music.dto.SongDTO;

@Repository
public class MusicDAOImpl implements MusicDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final String NS = "com.spring.eze.music.dao.MusicDAO.";

    @Override
    public List<SongDTO> getSongList() {
        return sqlSession.selectList(NS + "getSongList");
    }

    @Override
    public SongDTO getSongDetail(int songId) {
        return sqlSession.selectOne(NS + "getSongDetail", songId);
    }

    @Override
    public List<SongDTO> getSimilarSongs(Map<String, Object> param) {
        return sqlSession.selectList(NS + "getSimilarSongs", param);
    }

    @Override
    public List<SongDTO> searchSongs(String keyword) {
        return sqlSession.selectList(NS + "searchSongs", keyword);
    }

    @Override
    public void insertPlayLog(int songId, int userId) {
        Map<String, Object> param = new HashMap<>();
        param.put("songId", songId);
        param.put("userId", userId);
        sqlSession.insert(NS + "insertPlayLog", param);
    }

    @Override
    public void insertSongLike(int songId, int userId) {
        Map<String, Object> param = new HashMap<>();
        param.put("songId", songId);
        param.put("userId", userId);
        sqlSession.insert(NS + "insertSongLike", param);
    }

    @Override
    public void deleteSongLike(int songId, int userId) {
        Map<String, Object> param = new HashMap<>();
        param.put("songId", songId);
        param.put("userId", userId);
        sqlSession.delete(NS + "deleteSongLike", param);
    }

    @Override
    public int existsSongLike(int songId, int userId) {
        Map<String, Object> param = new HashMap<>();
        param.put("songId", songId);
        param.put("userId", userId);
        return sqlSession.selectOne(NS + "existsSongLike", param);
    }
 //주간랭킹
    @Override
    public List<SongDTO> getWeeklyRanking() {
        return sqlSession.selectList(NS + "getWeeklyRanking");
    }
//오늘의 최고 히트곡
    @Override
    public List<SongDTO> getTodayHitSongs() {
        return sqlSession.selectList(NS + "getTodayHitSongs");
    }
//장르랭킹
    @Override
    public List<SongDTO> getGenreRanking(int genreId) {
        return sqlSession.selectList(NS + "getGenreRanking", genreId);
    }
//점수 insert
    @Override
    public void insertSongScore(int songId, int userId, int score) {
        Map<String, Object> map = new HashMap<>();
        map.put("songId", songId);
        map.put("userId", userId);
        map.put("score", score);

        sqlSession.insert(NS + "insertSongScore", map);
    }
//노래 연결
	@Override
	public String getSongPath(int songId) {
		
		 return sqlSession.selectOne(NS + "getSongPath", songId);
	}
//아티스트 상세페이지
	@Override
	public ArtistDTO getArtistDetail(int artistId) {
		ArtistDTO dto = sqlSession.selectOne(NS + "getArtistDetail", artistId); 
		System.out.println(dto);
	    return  dto;
	}

	@Override
	public List<SongDTO> getSongsByArtist(int artistId) {
	    return sqlSession.selectList(NS + "getSongsByArtist", artistId);
	}
//좋아요
	@Override
	public int getLikeScoreSum(int songId, int userId) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("songId", songId);
	    param.put("userId", userId);

	    Integer result = sqlSession.selectOne(NS + "getLikeScoreSum", param);
	    return result == null ? 0 : result;
	}

	@Override
	public List<SongDTO> getLikedSongs(int userId) {
	    return sqlSession.selectList(NS + "getLikedSongs", userId);
	}
//검색
	@Override
	public List<SongDTO> getSearhSong(String keyword) {
		
		return sqlSession.selectList(NS +"getSearhSong",keyword);
	}

	@Override
	public List<ArtistDTO> getSearhArtist(String keyword) {
		
		return sqlSession.selectList(NS+"getSearhArtist",keyword);
	}
    
}