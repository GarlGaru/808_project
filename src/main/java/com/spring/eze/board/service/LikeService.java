package com.spring.eze.board.service;

import com.spring.eze.board.dto.LikeDTO;

public interface LikeService {
	public void insertLike(LikeDTO dto);
    public void deleteLike(LikeDTO dto);
    public int checkLike(LikeDTO dto);
    public int getLikeCount(int bno);

}
