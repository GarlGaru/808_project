package com.spring.eze.reco.dao;

import com.spring.eze.reco.dto.KeywordScoreDTO;
import com.spring.eze.reco.dto.SongCardDTO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class RecommendDAOImpl implements RecommendDAO {

    @Autowired
    private SqlSession sqlSession;

    @Override
    public List<KeywordScoreDTO> selectTopKeywords(int userId) {
        RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
        return dao.selectTopKeywords(userId);
    }

    @Override
    public List<Integer> selectRecommendedSongs(int userId, List<KeywordScoreDTO> topKeywords, int amount) {
        RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
        return dao.selectRecommendedSongs(userId, topKeywords, amount);
    }

    @Override
    public List<SongCardDTO> getResultSongs(List<Integer> songIds) {
        RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
        return dao.getResultSongs(songIds);
    }
}
