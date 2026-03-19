package com.spring.eze.user.dto;

public class MypageMonthlyStatDTO {

	private String yearMonth;   // 연월
	private int    totalAmount; // 월 합계
	
	public MypageMonthlyStatDTO() {
		super();
	}

	public MypageMonthlyStatDTO(String yearMonth, int totalAmount) {
		super();
		this.yearMonth = yearMonth;
		this.totalAmount = totalAmount;
	}

	public String getYearMonth() {
		return yearMonth;
	}

	public void setYearMonth(String yearMonth) {
		this.yearMonth = yearMonth;
	}

	public int getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(int totalAmount) {
		this.totalAmount = totalAmount;
	}

	@Override
	public String toString() {
		return "MypageMonthlyStatDTO [yearMonth=" + yearMonth + ", totalAmount=" + totalAmount + "]";
	}
	
}
