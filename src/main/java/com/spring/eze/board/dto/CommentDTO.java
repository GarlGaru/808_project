package com.spring.eze.board.dto;

import java.util.Date;

public class CommentDTO {
    
	private int cno;           // 댓글 번호 (PK)
    private int bno;           // 게시글 번호 (FK)
    private Integer pCno;      // 부모 댓글 번호 (null 허용을 위해 Integer 사용)
    private int userId;        // 작성자 (FK)
    private String content;    // 댓글 내용
    private Date regdate;      // 작성일
    private String nickname;   // 닉네임

    public int getCno() {
		return cno;
	}
	public void setCno(int cno) {
		this.cno = cno;
	}
	public int getBno() {
		return bno;
	}
	public void setBno(int bno) {
		this.bno = bno;
	}
	public Integer getpCno() {
		return pCno;
	}
	public void setpCno(Integer pCno) {
		this.pCno = pCno;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
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
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	
	@Override
	public String toString() {
		return "CommentDTO [cno=" + cno + ", bno=" + bno + ", pCno=" + pCno + ", userId=" + userId + ", content="
				+ content + ", regdate=" + regdate + ", nickname=" + nickname + "]";
	}
	
	

    	
}