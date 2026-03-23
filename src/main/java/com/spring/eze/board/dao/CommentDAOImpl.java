package com.spring.eze.board.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.board.dto.CommentDTO;

@Repository
public class CommentDAOImpl implements CommentDAO {

	@Autowired
	private SqlSession sqlSession;

	private String CT = "com.spring.eze.board.dao.CommentDAO";

	public List<CommentDTO> CommentList(int bno) {
		System.out.println("CommentDAOImpl - CommentList");
		return sqlSession.selectList(CT + ".CommentList", bno);
	
	}
	
	@Override
	public int commentCnt() {
		return sqlSession.selectOne(CT + ".commentCnt");
	}


	@Override
	public void updateComment(CommentDTO dto) {
		System.out.println("CommentDAOImpl - updateComment");

		sqlSession.update(CT + ".updateComment", dto);

	}

	@Override
	public void insertComment(CommentDTO dto) {
		System.out.println("CommentDAOImpl-insertComment"+ dto);

		sqlSession.insert(CT + ".insertComment", dto);

	}

	@Override
	public void deleteComment(CommentDTO dto) {
		System.out.println("CommentDAOImpl-deleteComment");
		
		sqlSession.delete(CT+ ".deleteComment", dto);
		
	}



}
