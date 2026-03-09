package com.spring.eze.user.dao;

import org.springframework.stereotype.Repository;

import com.spring.eze.user.dto.ProfileDTO;

@Repository
public class MypageDAOImpl implements MypageDAO{

	// 프로필 조회
	@Override
	public ProfileDTO getProfile(int userId) {
		return null;
	}

	// 닉네임, 소개, 생년월일 수정
	@Override
	public int updateProfile(ProfileDTO DTO) {
		return 0;
	}
	// 비밀번호 변경
	@Override
	public int updatePassword(ProfileDTO DTO) {
		return 0;
	}
	// 프로필 이미지 URL 저장
	@Override
	public int updatePhotoUrl(ProfileDTO DTO) {
		return 0;
	}
	// 프로필 행 존재 여부
	@Override
	public int countProfile(int userID) {
		return 0;
	}
	// 프로필 최초 생성
	@Override
	public int insertProfile(int userId) {
		return 0;
	}

}
