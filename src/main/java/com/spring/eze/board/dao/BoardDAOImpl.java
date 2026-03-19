package com.spring.eze.board.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.board.dto.BoardDTO;

@Repository
public class BoardDAOImpl implements BoardDAO {

    @Autowired
    private SqlSession sqlSession;

    // Mapper XML의 namespace와 일치해야 합니다.
    private String NS = "com.spring.eze.board.dao.BoardDAO";

    @Override
    public List<BoardDTO> boardList(Map<String, Object> map) {
        System.out.println("DAOImpl - boardList 호출");
        return sqlSession.selectList(NS + ".boardList", map); //
    }

    @Override
    public int boardCnt(Map<String, Object> map) {
        // 검색 조건(keyword 등)이 포함된 전체 개수를 반환합니다.
        return sqlSession.selectOne(NS + ".boardCnt", map); 
    }

    @Override
    public void plusReadCnt(int bno) {
        System.out.println("DAOImpl - plusReadCnt: " + bno);
        sqlSession.update(NS + ".plusReadCnt", bno); //
    }

    @Override
    public BoardDTO getBoardDetail(int bno) {
        System.out.println("BoardDAOImpl - getBoardDetail: " + bno);
        return sqlSession.selectOne(NS + ".getBoardDetail", bno); //
    }

    @Override
    public void updateBoard(BoardDTO dto) {
        System.out.println("BoardDAOImpl - updateBoard");
        sqlSession.update(NS + ".updateBoard", dto); //
    }

    @Override
    public void deleteBoard(BoardDTO dto) {
        System.out.println("BoardDAOImpl - deleteBoard");
        sqlSession.delete(NS + ".deleteBoard", dto); //
    }

    @Override
    public void insertBoard(BoardDTO dto) {
        System.out.println("BoardDAOImpl - insertBoard");
        sqlSession.insert(NS + ".insertBoard", dto); //
    }

    @Override
    public List<BoardDTO> getBestList() {
        return sqlSession.selectList(NS + ".getBestList"); //
    }
}