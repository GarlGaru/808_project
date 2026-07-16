package com.spring.eze.reco.dao;

import com.spring.eze.reco.dto.KeywordScoreDTO;
import com.spring.eze.reco.dto.SongCardDTO;
import com.spring.eze.reco.dto.SongDetailDTO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class RecommendDAOImpl implements RecommendDAO {

    @Autowired
    private SqlSession sqlSession;

    @Override
    public List<KeywordScoreDTO> selectTopKeywordsByUser(int userId) {
        RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
        return dao.selectTopKeywordsByUser(userId);
    }

    @Override
    public List<Integer> selectSongsByKeywords(
            List<KeywordScoreDTO> topKeywords, int amount) {
        RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
        return dao.selectSongsByKeywords(topKeywords, amount);
    }

    @Override
    public List<Integer> selectPopularSongsByKeywords(
            List<KeywordScoreDTO> topKeywords, int amount) {
        RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
        return dao.selectPopularSongsByKeywords(topKeywords, amount);
    }

    @Override
    public List<Integer> selectRecentSongsByTopKeywords(
            List<KeywordScoreDTO> topKeywords, int amount) {
        RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
        return dao.selectRecentSongsByTopKeywords(topKeywords, amount);
    }



    @Override
    public List<SongCardDTO> getResultSongs(List<Integer> songIds) {
        RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
        return dao.getResultSongs(songIds);
    }

    @Override
    public List<SongDetailDTO> selectSongDetailsBySongIds(List<Integer> songIds) {
        RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
        return dao.selectSongDetailsBySongIds(songIds);
    }
}
