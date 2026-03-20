package com.spring.eze.user.dto;

import java.sql.Date;

public class EmailCodeDTO {

	private int emailCodeId;
	private String email;
	private String code;
	private Date expiresAt;
	private Date createdAt;
	
	public EmailCodeDTO() {
		super();
	}

	public EmailCodeDTO(int emailCodeId, String email, String code, Date expiresAt, Date createdAt) {
		super();
		this.emailCodeId = emailCodeId;
		this.email = email;
		this.code = code;
		this.expiresAt = expiresAt;
		this.createdAt = createdAt;
	}

	public int getEmailCodeId() {
		return emailCodeId;
	}

	public void setEmailCodeId(int emailCodeId) {
		this.emailCodeId = emailCodeId;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public Date getExpiresAt() {
		return expiresAt;
	}

	public void setExpiresAt(Date expiresAt) {
		this.expiresAt = expiresAt;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	@Override
	public String toString() {
		return "EmailCodeDTO [emailCodeId=" + emailCodeId + ", email=" + email + ", code=" + code + ", expiresAt="
				+ expiresAt + ", createdAt=" + createdAt + "]";
	}
	
	
	
}
