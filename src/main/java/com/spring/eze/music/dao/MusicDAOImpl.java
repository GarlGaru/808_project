package com.spring.eze.music.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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
}