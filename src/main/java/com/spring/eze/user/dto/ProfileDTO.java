package com.spring.eze.user.dto;

import java.sql.Date;

public class ProfileDTO {

	private int userId;				 
	private String membershipType;	// 멤버쉽 타입
	private Date birthDate;			// 생년월일
	private String bio;				// 자기 소개
	private String photoUrl;		// 프로필 사진
	private Date updateAt;			// 프로필 수정일
	
	public ProfileDTO() {
		super();
	}

	public ProfileDTO(int userId, String membershipType, Date birthDate, String bio, String photoUrl, Date updateAt) {
		super();
		this.userId = userId;
		this.membershipType = membershipType;
		this.birthDate = birthDate;
		this.bio = bio;
		this.photoUrl = photoUrl;
		this.updateAt = updateAt;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getMembershipType() {
		return membershipType;
	}

	public void setMembershipType(String membershipType) {
		this.membershipType = membershipType;
	}

	public Date getBirthDate() {
		return birthDate;
	}

	public void setBirthDate(Date birthDate) {
		this.birthDate = birthDate;
	}

	public String getBio() {
		return bio;
	}

	public void setBio(String bio) {
		this.bio = bio;
	}

	public String getPhotoUrl() {
		return photoUrl;
	}

	public void setPhotoUrl(String photoUrl) {
		this.photoUrl = photoUrl;
	}

	public Date getUpdateAt() {
		return updateAt;
	}

	public void setUpdateAt(Date updateAt) {
		this.updateAt = updateAt;
	}

	@Override
	public String toString() {
		return "ProfileDTO [userId=" + userId + ", membershipType=" + membershipType + ", birthDate=" + birthDate
				+ ", bio=" + bio + ", photoUrl=" + photoUrl + ", updateAt=" + updateAt + "]";
	}

	
}
