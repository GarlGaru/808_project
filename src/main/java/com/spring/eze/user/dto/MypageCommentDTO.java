package com.spring.eze.user.dto;

import java.sql.Date;

public class MypageCommentDTO {

	private int    cno;		   // 댓글 번호
	private int    bno;		   // 원글 번호
	private String boardTitle; // 원글 제목
	private String content;    // 댓글 내용
	private Date   regdate;    // 작성일
	
	public MypageCommentDTO() {
		super();
	}

	public MypageCommentDTO(int cno, int bno, String boardTitle, String content, Date regdate) {
		super();
		this.cno = cno;
		this.bno = bno;
		this.boardTitle = boardTitle;
		this.content = content;
		this.regdate = regdate;
	}

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

	public String getBoardTitle() {
		return boardTitle;
	}

	public void setBoardTitle(String boardTitle) {
		this.boardTitle = boardTitle;
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

	@Override
	public String toString() {
		return "MypageCommentDTO [cno=" + cno + ", bno=" + bno + ", boardTitle=" + boardTitle + ", content=" + content
				+ ", regdate=" + regdate + "]";
	}
	
}
