package com.spring.eze.admin.dto;

public class DailyCountDTO {
	private String label; // "03/01" 같은 문자열
    private int cnt;

    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }

    public int getCnt() { return cnt; }
    public void setCnt(int cnt) { this.cnt = cnt; }
}
