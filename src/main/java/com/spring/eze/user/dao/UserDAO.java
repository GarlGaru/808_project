package com.spring.eze.user.dao;

import java.util.Map;

import com.spring.eze.user.dto.EmailCodeDTO;
import com.spring.eze.user.dto.UserDTO;

public interface UserDAO {

    // 회원가입
    public int insertUser(UserDTO dto);

    // 이메일 중복확인
    public int checkEmail(String email);

    // 닉네임 중복확인
    public int checkNickname(String nickname);

    // 로그인 시 유저 조회
    public UserDTO getUserByEmail(String email);

    // 이메일 인증 완료 처리
    public int updateEmailVerified(String email);
    
    // 비밀번호 수정
    public int updatePw(Map<String, Object> map);

//    // 회원탈퇴
//    public int deleteUser(String email);

    // 인증코드 저장
    public int insertEmailCode(EmailCodeDTO dto);

    // 인증코드 조회
    public EmailCodeDTO getEmailCode(String email);

}
