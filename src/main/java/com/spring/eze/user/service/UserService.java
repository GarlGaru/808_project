package com.spring.eze.user.service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.spring.eze.user.dto.EmailCodeDTO;

public interface UserService {

    // 회원가입
    public int insertUser(HttpServletRequest request)
			throws ServletException, IOException;

    // 이메일 중복확인
    public int checkEmail(HttpServletRequest request)
			throws ServletException, IOException;

    // 닉네임 중복확인
    public int checkNickname(HttpServletRequest request)
			throws ServletException, IOException;

    // 로그인 처리
    public int loginAction(HttpServletRequest request)
            throws ServletException, IOException;
    
    // 이메일 인증 완료 처리
    public int updateEmailVerified(HttpServletRequest request)
			throws ServletException, IOException;

    // 비밀번호 수정
    public int updatePw(HttpServletRequest request)
			throws ServletException, IOException;
    
    // 회원탈퇴
    public int deleteUser(HttpServletRequest request)
			throws ServletException, IOException;

    // 인증코드 저장
    public int insertEmailCode(HttpServletRequest request)
			throws ServletException, IOException;

    // 인증코드 조회
    public EmailCodeDTO getEmailCode(HttpServletRequest request)
			throws ServletException, IOException;

    // 이메일 인증코드 대조 검증 (추가)
    public int verifyCode(HttpServletRequest request)
            throws ServletException, IOException;
}
