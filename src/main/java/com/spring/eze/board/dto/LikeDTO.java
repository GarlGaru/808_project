package com.spring.eze.board.dto;

import java.util.Date;

public class LikeDTO {
	
	private int likeNo;      // 좋아요 번호
    private int bno;         // 게시글 번호
    private int userId;      // 누른 사람의 회원 번호
    private Date likeDate;   // 누른 시간    
	
    public int getLikeNo() {
		return likeNo;
	}
	public void setLikeNo(int likeNo) {
		this.likeNo = likeNo;
	}
	public int getBno() {
		return bno;
	}
	public void setBno(int bno) {
		this.bno = bno;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public Date getLikeDate() {
		return likeDate;
	}
	public void setLikeDate(Date likeDate) {
		this.likeDate = likeDate;
	}

    
    
    
}
