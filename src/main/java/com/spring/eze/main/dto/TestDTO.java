package com.spring.eze.main.dto;

public class TestDTO {
	private int id;
	private String showMe;
	
	public TestDTO() {
	}

	public TestDTO(int id, String showMe) {
		this.id = id;
		this.showMe = showMe;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getShowMe() {
		return showMe;
	}

	public void setShowMe(String showMe) {
		this.showMe = showMe;
	}

	@Override
	public String toString() {
		return showMe;
	}
	
	
	
	
}
