 package com.spring.eze.board.dao;

import java.util.List;
import java.util.Map;

import com.spring.eze.board.dto.BoardDTO;


public interface BoardDAO {
    // 게시글 목록
    public List<BoardDTO> boardList(Map<String, Object> map);

    // 게시글 총 개수
    public int boardCnt();
    
    // 조회수 증가 (bno로 이름 통일)
    public void plusReadCnt(int bno);
    
    // 게시글 상세 조회
    public BoardDTO getBoardDetail(int bno);
    
    // 게시글 수정 (오타 수정)
    public void updateBoard(BoardDTO dto);
    
    // 게시글 삭제
    public void deleteBoard(BoardDTO dto);
    //게시글 추가
    public void insertBoard(BoardDTO dto);


}
