package com.spring.eze.board.dto;

import java.util.Date;


public class BoardDTO {
	
	// 기본 게시글 정보
    private int bno;
    private int userId;
    private String title;
    private String content;
    private Date regdate;
    private int viewcnt;
    
    private int likeCount;
    
    private String nickname;
    
    
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
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}
	public int getViewcnt() {
		return viewcnt;
	}
	public void setViewcnt(int viewcnt) {
		this.viewcnt = viewcnt;
	}
    public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	// 개시글 좋아요
	public int getLikeCount() {
        return likeCount;
    }
    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }
	@Override
	public String toString() {
		return "BoardDTO [bno=" + bno + ", userId=" + userId + ", title=" + title + ", content=" + content
				+ ", regdate=" + regdate + ", viewcnt=" + viewcnt + ", likeCount=" + likeCount + ", nickname="
				+ nickname + "]";
	}
	

    

}
