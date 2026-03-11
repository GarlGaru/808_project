package com.spring.eze.user.dto;

import java.sql.Date;

public class MypageBoardDTO {
	
	private int    bno;     // 게시글 번호
	private String title;   // 제목
	private String content; // 내용
	private Date   regdate;	// 작성일
	private int    viewcnt; // 조회수
	
	public MypageBoardDTO() {
		super();
	}

	public MypageBoardDTO(int bno, String title, String content, Date regdate, int viewcnt) {
		super();
		this.bno = bno;
		this.title = title;
		this.content = content;
		this.regdate = regdate;
		this.viewcnt = viewcnt;
	}

	public int getBno() {
		return bno;
	}

	public void setBno(int bno) {
		this.bno = bno;
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

	@Override
	public String toString() {
		return "MypageBoardDTO [bno=" + bno + ", title=" + title + ", content=" + content + ", regdate=" + regdate
				+ ", viewcnt=" + viewcnt + "]";
	}
	
}
