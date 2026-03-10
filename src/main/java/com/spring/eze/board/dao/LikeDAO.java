package com.spring.eze.board.dao;

import com.spring.eze.board.dto.LikeDTO;

public interface LikeDAO {
	
	// 1. 좋아요 누르기
    public void insertLike(LikeDTO dto);

    // 2. 좋아요 취소 
    public void deleteLike(LikeDTO dto);

    // 3. 좋아요 중복 체크 
    public int checkLike(LikeDTO dto);

    // 4. 해당 게시글의 총 좋아요 개수 가져오기
    public int getLikeCount(int bno);
}
