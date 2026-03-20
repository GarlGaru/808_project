package com.spring.eze.board.dao;

import java.util.List;
import java.util.Map;

import com.spring.eze.board.dto.BoardDTO;
import com.spring.eze.board.dto.CommentDTO;

public interface CommentDAO {
	
	// 댓글 목록
	public List<CommentDTO> CommentList(int bno);
	
	
	 // 댓글 총 개수
    public int commentCnt();
    
	// 댓글 수정
    public void updateComment(CommentDTO dto);
   
    
    // 댓글 삭제
    public void deleteComment(CommentDTO dto);

    
    //게시글 추가
    public void insertComment(CommentDTO dto);



}


