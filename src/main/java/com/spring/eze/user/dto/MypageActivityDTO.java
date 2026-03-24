package com.spring.eze.user.dto;

import java.util.Date;

/**
 * 마이페이지 통합 활동 내역 DTO
 * (게시글, 댓글, 리뷰를 하나의 리스트로 관리하기 위함)
 */
public class MypageActivityDTO {
    private String type;        // 활동 구분 (게시글, 댓글, 리뷰)
    private int targetNo;       // 고유 번호 (bno, rno, reviewId)
    private String parentId;    // 이동 대상 ID (bno 혹은 showId)
    private String targetTitle; // 원문 제목 혹은 공연 제목
    private String content;     // 작성 내용
    private Date regdate;       // 작성일

    // 기본 생성자
    public MypageActivityDTO() {}

    // Getter & Setter (정파의 정석)
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public int getTargetNo() { return targetNo; }
    public void setTargetNo(int targetNo) { this.targetNo = targetNo; }

    public String getParentId() { return parentId; }
    public void setParentId(String parentId) { this.parentId = parentId; }

    public String getTargetTitle() { return targetTitle; }
    public void setTargetTitle(String targetTitle) { this.targetTitle = targetTitle; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Date getRegdate() { return regdate; }
    public void setRegdate(Date regdate) { this.regdate = regdate; }

    // 디버깅을 위한 toString
    @Override
    public String toString() {
        return "MypageActivityDTO [type=" + type + ", targetNo=" + targetNo + 
               ", targetTitle=" + targetTitle + ", regdate=" + regdate + "]";
    }
}