package com.spring.eze.user.service;


import com.spring.eze.user.dto.ProfileDTO;

public interface MypageService {
	
	// 프로필 조회
	public ProfileDTO getProfie(int userId);
	
	// 닉네임, 자기소개, 생년월일 수정
	public int updateProfile(ProfileDTO dto);
	
	// 비밀번호 변경
	

}
