package com.spring.eze.user.dto;

import java.sql.Timestamp;

public class UserDTO {
	
	private int userId;
	private String email;
	private String password;
	private String nickname;
	private int emailVerified;
	private Timestamp createdAt;
	
	public UserDTO() {
		super();
	}

	public UserDTO(int userId, String email, String password, String nickname, int emailVerified,
			Timestamp createdAt) {
		super();
		this.userId = userId;
		this.email = email;
		this.password = password;
		this.nickname = nickname;
		this.emailVerified = emailVerified;
		this.createdAt = createdAt;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public int getEmailVerified() {
		return emailVerified;
	}

	public void setEmailVerified(int emailVerified) {
		this.emailVerified = emailVerified;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	@Override
	public String toString() {
		return "UserDTO [userId=" + userId + ", email=" + email + ", password=" + password + ", nickname=" + nickname
				+ ", emailVerified=" + emailVerified + ", createdAt=" + createdAt + "]";
	}
	
}
