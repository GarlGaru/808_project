package com.spring.eze.user.dao;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.user.dto.UserDTO;
import com.spring.eze.user.dto.EmailCodeDTO;

@Repository
public class UserDAOImpl implements UserDAO {

    @Autowired
    private SqlSession sqlSession;

    // 1. 회원가입
    @Override
    public int insertUser(UserDTO dto) {
        // [수업 방식] 매퍼 연결 후 변수에 담아서 리턴
        UserDAO dao = sqlSession.getMapper(UserDAO.class);
        int insertCnt = dao.insertUser(dto);
        return insertCnt;
    }

    // 2. 이메일 중복확인
    @Override
    public int checkEmail(String email) {
        UserDAO dao = sqlSession.getMapper(UserDAO.class);
        int selectCnt = dao.checkEmail(email);
        return selectCnt;
    }

    // 3. 닉네임 중복확인
    @Override
    public int checkNickname(String nickname) {
        UserDAO dao = sqlSession.getMapper(UserDAO.class);
        int selectCnt = dao.checkNickname(nickname);
        return selectCnt;
    }

    // 4. 로그인 시 유저 조회
    @Override
    public UserDTO getUserByEmail(String email) {
        UserDAO dao = sqlSession.getMapper(UserDAO.class);
        UserDTO dto = dao.getUserByEmail(email);
        return dto;
    }

    // 5. 이메일 인증 완료 처리
    @Override
    public int updateEmailVerified(String email) {
        UserDAO dao = sqlSession.getMapper(UserDAO.class);
        int updateCnt = dao.updateEmailVerified(email);
        return updateCnt;
    }

    // 6. 비밀번호 수정
    @Override
    public int updatePw(Map<String, Object> map) {
        UserDAO dao = sqlSession.getMapper(UserDAO.class);
        int updateCnt = dao.updatePw(map);
        return updateCnt;
    }
    
//    // 7. 회원탈퇴
//    @Override
//    public int deleteUser(String email) {
//        UserDAO dao = sqlSession.getMapper(UserDAO.class);
//        int deleteCnt = dao.deleteUser(email);
//        return deleteCnt;
//    }

    // 8. 인증코드 저장
    @Override
    public int insertEmailCode(EmailCodeDTO dto) {
        UserDAO dao = sqlSession.getMapper(UserDAO.class);
        int insertCnt = dao.insertEmailCode(dto);
        return insertCnt;
    }

    // 9. 인증코드 조회
    @Override
    public EmailCodeDTO getEmailCode(String email) {
        UserDAO dao = sqlSession.getMapper(UserDAO.class);
        EmailCodeDTO dto = dao.getEmailCode(email);
        return dto;
    }

}