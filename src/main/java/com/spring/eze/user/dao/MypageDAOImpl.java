package com.spring.eze.user.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.user.dto.UserDTO;
import com.spring.eze.user.dto.MypageBoardDTO;
import com.spring.eze.user.dto.MypageCommentDTO;
import com.spring.eze.user.dto.MypageReservationDTO;
import com.spring.eze.user.dto.MypagePaymentDTO;
import com.spring.eze.user.dto.MypageMonthlyStatDTO;
import com.spring.eze.user.dto.MypageDayStatDTO;
import com.spring.eze.user.dto.MypageGenreStatDTO;

@Repository
public class MypageDAOImpl implements MypageDAO {

    @Autowired
    private SqlSession sqlSession;

    // 유저 + 프로필
    @Override
    public UserDTO selectUserWithProfile(int userId) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.selectUserWithProfile(userId);
    }

    // 내가 쓴 글
    @Override
    public List<MypageBoardDTO> selectMyBoardList(Map<String, Object> map) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.selectMyBoardList(map);
    }

    // 내가 쓴 댓글
    @Override
    public List<MypageCommentDTO> selectMyCommentList(Map<String, Object> map) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.selectMyCommentList(map);
    }

    // 예매 내역
    @Override
    public List<MypageReservationDTO> selectMyReservationList(int userId) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.selectMyReservationList(userId);
    }

    // 결제 내역
    @Override
    public List<MypagePaymentDTO> selectMyPaymentList(int userId) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.selectMyPaymentList(userId);
    }

    // 월별 지출 합계
    @Override
    public List<MypageMonthlyStatDTO> selectMonthlyStats(int userId) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.selectMonthlyStats(userId);
    }

    // 총 재생 곡 수
    @Override
    public int selectTotalPlayCount(int userId) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.selectTotalPlayCount(userId);
    }

    // 요일별 재생수
    @Override
    public List<MypageDayStatDTO> selectPlayCountByDay(int userId) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.selectPlayCountByDay(userId);
    }

    // 탑 장르
    @Override
    public List<MypageGenreStatDTO> selectTopGenres(int userId) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.selectTopGenres(userId);
    }

    // 닉네임 수정
    @Override
    public int updateNickname(Map<String, Object> map) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.updateNickname(map);
    }

    // 생년월일, 소개 수정
    @Override
    public int updateProfile(Map<String, Object> map) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.updateProfile(map);
    }

    // 프로필 사진 수정
    @Override
    public int updatePhotoUrl(Map<String, Object> map) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.updatePhotoUrl(map);
    }

    // 계정 탈퇴
    @Override
    public int deleteUser(int userId) {
        MypageDAO dao = sqlSession.getMapper(MypageDAO.class);
        return dao.deleteUser(userId);
    }
}