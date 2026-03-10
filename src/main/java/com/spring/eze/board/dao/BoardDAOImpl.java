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

	private String NS = "com.spring.eze.board.dao.BoardDAO";

	@Override
	public List<BoardDTO> boardList(Map<String, Object> map) {
		System.out.println("DAOImpl -boardList");
		return sqlSession.selectList(NS + ".boardList", map);
	}

	@Override
	public int boardCnt() {
		return sqlSession.selectOne(NS + ".boardCnt");
	}

	@Override
	public void plusReadCnt(int bno) {
	    System.out.println("DAO- plusReadCnt");
	    // 조회수 증가는 보통 UPDATE 쿼리이므로 sqlSession.update()를 사용합니다.
	    sqlSession.update(NS + ".plusReadCnt", bno); 
	    // return 문 삭제
	}	

	@Override
	public BoardDTO getBoardDetail(int bno) {
		System.out.println("BoardDAOImpl - getBoardDetail");
		BoardDTO dto = sqlSession.selectOne(NS + ".getBoardDetail", bno);
		return dto;
	}

	@Override
	public void updateBoard(BoardDTO dto) {
		System.out.println("BoardDAOImpl - updateBoard");

		sqlSession.update(NS + ".updateBoard", dto);

	}

	@Override
	public void deleteBoard(BoardDTO bno) {
		System.out.println("BoardDAOImpl-deleteBoard");

		sqlSession.delete(NS + ".deleteBoard", bno);

	}
	@Override
	public void insertBoard(BoardDTO dto) {
		System.out.println("BoardDAOImpl-insertBoard");

		sqlSession.insert(NS + ".insertBoard", dto);
	}

}
