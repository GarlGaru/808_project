package com.spring.eze.board.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.board.dto.LikeDTO;
@Repository
public class LikeDAOImpl implements LikeDAO {
    
    @Autowired
    private SqlSession sqlSession;
    
    private static final String Like = "com.spring.eze.mapper.LikeMapper";

    @Override
    public void insertLike(LikeDTO dto) {
        sqlSession.insert(Like + ".insertLike", dto);
    }

    @Override
    public void deleteLike(LikeDTO dto) {
        //  좋아요 취소 기능
        sqlSession.delete(Like + ".deleteLike", dto);
    }

    @Override
    public int checkLike(LikeDTO dto) {
        // 이미 좋아요를 눌렀는지(0/1) 
        return sqlSession.selectOne(Like + ".checkLike", dto);
    }

    @Override
    public int getLikeCount(int bno) {
        // 게시글의 전체 좋아요 개수 반환
        return sqlSession.selectOne(Like + ".getLikeCount", bno);
    }
}