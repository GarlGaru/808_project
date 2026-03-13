package com.spring.eze.admin.dto;

import java.sql.Date;

public class AdminUserDTO {

	 	private int userId;
	    private String email;
	    private String password;
	    private String nickname;
	    private int emailVerified;
	    private Date createdAt;
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
		public Date getCreatedAt() {
			return createdAt;
		}
		public void setCreatedAt(Date createdAt) {
			this.createdAt = createdAt;
		}
	    
	    
	    
}
