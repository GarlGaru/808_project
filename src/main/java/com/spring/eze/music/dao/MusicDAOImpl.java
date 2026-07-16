package com.spring.eze.music.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.music.dto.ArtistDTO;
import com.spring.eze.music.dto.KeywordDTO;
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
	//좋아요 확인용  있으면 1 없으면 0 으로 확인
	@Override
	public int existsLikeScoreRow(int songId, int userId) {
	 	Map<String, Object> param = new HashMap<>();
	    param.put("songId", songId);
	    param.put("userId", userId);

	    Integer result = sqlSession.selectOne(NS + "existsLikeScoreRow", param);
	    return result == null ? 0 : result;
	}
	//좋아요 insert
	@Override
	public void insertLikeScore(int songId, int userId) {
		Map<String, Object> param = new HashMap<>();
		param.put("songId", songId);
		param.put("userId", userId);
		
		sqlSession.insert(NS + "insertLikeScore" , param);
		
	}
	//좋아요 delete
	@Override
	public void deleteLikeScore(int songId, int userId) {
		Map<String, Object> param = new HashMap<>();
	    param.put("songId", songId);
	    param.put("userId", userId);

	    sqlSession.delete(NS + "deleteLikeScore", param);
		
	}
	/**
	 * 현재 로그인한 사용자의 LIKE 타입 플레이리스트 ID를 조회한다.
	 * 없으면 null 이 반환된다.
	 */
	@Override
	public Integer getLikePlaylistId(int userId) {
	    return sqlSession.selectOne(NS + "getLikePlaylistId", userId);
	}

	/**
	 * 현재 로그인한 사용자의 LIKE 타입 플레이리스트를 생성한다.
	 * playlists_tbl 에 title='좋아요', list_type='LIKE' 로 insert 된다.
	 */
	@Override
	public void createLikePlaylist(int userId) {
	    sqlSession.insert(NS + "createLikePlaylist", userId);
	}

	/**
	 * 특정 플레이리스트에 특정 곡이 이미 들어있는지 확인한다.
	 * 중복 insert 방지용이다.
	 */
	@Override
	public int existsPlaylistElement(int playlistId, int songId) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("playlistId", playlistId);
	    param.put("songId", songId);

	    Integer result = sqlSession.selectOne(NS + "existsPlaylistElement", param);
	    return result == null ? 0 : result;
	}

	/**
	 * 특정 플레이리스트에 특정 곡을 추가한다.
	 * playlist_ele_tbl 에 playlist_id, song_id 를 insert 한다.
	 */
	@Override
	public void insertPlaylistElement(int playlistId, int songId) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("playlistId", playlistId);
	    param.put("songId", songId);

	    sqlSession.insert(NS + "insertPlaylistElement", param);
	}

	/**
	 * 특정 플레이리스트에서 특정 곡을 삭제한다.
	 * 좋아요 취소 시 playlist_ele_tbl 에서 해당 곡을 제거할 때 사용한다.
	 */
	@Override
	public void deletePlaylistElement(int playlistId, int songId) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("playlistId", playlistId);
	    param.put("songId", songId);

	    sqlSession.delete(NS + "deletePlaylistElement", param);
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
//키워드 리스트
	@Override
	public List<KeywordDTO> getKeywordList(int songId) {
		
		return sqlSession.selectList(NS +"getKeywordList",songId);
	}




    
}