package com.spring.eze.user.dao;

import com.spring.eze.user.dto.ProfileDTO;

public interface MypageDAO {
	
	// 프로필 조회
	public ProfileDTO getProfile(int userId);

	// 닉네임, 소개, 생년월일 수정
	public int updateProfile(ProfileDTO DTO);
	
	// 비밀번호 변경
	public int updatePassword(ProfileDTO DTO);
	
	// 프로필 이미지 URL 저장
	public int updatePhotoUrl(ProfileDTO DTO);
	
	// 프로필 행 존재 여부
	public int countProfile(int userID);
	
	// 프로필 최초 생성
	public int insertProfile(int userId); 
	
}
