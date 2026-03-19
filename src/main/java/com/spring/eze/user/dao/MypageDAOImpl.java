package com.spring.eze.user.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.user.dto.MypageBoardDTO;
import com.spring.eze.user.dto.MypageCommentDTO;
import com.spring.eze.user.dto.MypageDayStatDTO;
import com.spring.eze.user.dto.MypageGenreStatDTO;
import com.spring.eze.user.dto.MypageMonthlyStatDTO;
import com.spring.eze.user.dto.MypagePaymentDTO;
import com.spring.eze.user.dto.MypagePlayReportDTO;
import com.spring.eze.user.dto.MypageReservationDTO;
import com.spring.eze.user.dto.MypageTopArtistDTO;
import com.spring.eze.user.dto.MypageTopSongDTO;
import com.spring.eze.user.dto.UserDTO;

@Repository
public class MypageDAOImpl implements MypageDAO {

    @Autowired
    private SqlSession sqlSession;

    // MypageDAO mapper 반환 매 메서드마다 getMapper 중복 제거
    private MypageDAO mapper() {
        return sqlSession.getMapper(MypageDAO.class);
    }

    /* ────────────────────────────────────────────
       유저 + 프로필
    ──────────────────────────────────────────── */

    // 유저 + 프로필 - 내정보 수정 후 세션 갱신용
    @Override
    public UserDTO selectUserWithProfile(int userId) {
        return mapper().selectUserWithProfile(userId);
    }

    /* ────────────────────────────────────────────
       활동 내역
    ──────────────────────────────────────────── */

    // 내가 쓴 글 - 더보기 방식
    @Override
    public List<MypageBoardDTO> selectMyBoardList(Map<String, Object> map) {
        return mapper().selectMyBoardList(map);
    }

    // 내가 쓴 댓글 - 더보기 방식
    @Override
    public List<MypageCommentDTO> selectMyCommentList(Map<String, Object> map) {
        return mapper().selectMyCommentList(map);
    }

    /* ────────────────────────────────────────────
       예매 내역
 	   ──────────────────────────────────────────── */
    // 예매 내역 - 최근 5건
//    @Override
//    public List<MypageReservationDTO> selectMyReservationList(int userId) {
//        return mapper().selectMyReservationList(userId);
//    }
    
    /* ────────────────────────────────────────────
       결제 내역
	   ──────────────────────────────────────────── */
    // 결제 내역 - 최신순 전체
    @Override
    public List<MypagePaymentDTO> selectMyPaymentList(int userId) {
        return mapper().selectMyPaymentList(userId);
    }
    
    // 월별 지출 합계(최근 12개월)
    @Override
    public List<MypageMonthlyStatDTO> selectMonthlyStats(int userId) {
        return mapper().selectMonthlyStats(userId);
    }

    /* ────────────────────────────────────────────
       808 플레이 리포트
    ──────────────────────────────────────────── */

    @Override
    public MypagePlayReportDTO selectPlaySummary(int userId) {
        return mapper().selectPlaySummary(userId);
    }

    // 플레이 리포트 - 요일별 재생수
    @Override
    public List<MypageDayStatDTO> selectPlayCountByDay(int userId) {
        return mapper().selectPlayCountByDay(userId);
    }
    
    // 플레이 리포트 - 탑 장르
    @Override
    public List<MypageGenreStatDTO> selectTopGenres(int userId) {
        return mapper().selectTopGenres(userId);
    }

    // 탑 곡 - Top10
    @Override
    public List<MypageTopSongDTO> selectTopSongs(Map<String, Object> map) {
        return mapper().selectTopSongs(map);
    }

    // 탑 아티스트 - Top10
    @Override
    public List<MypageTopArtistDTO> selectTopArtists(int userId) {
        return mapper().selectTopArtists(userId);
    }

    /* ────────────────────────────────────────────
       내 정보 수정
    ──────────────────────────────────────────── */

    // 내 정보 수정 - 닉네임
    @Override
    public int updateNickname(Map<String, Object> map) {
        return mapper().updateNickname(map);
    }

    // 내 정보 수정 - 생년월일, 소개
    @Override
    public int updateProfile(Map<String, Object> map) {
        return mapper().updateProfile(map);
    }

    // 내 정보 수정 - 프로필 사진
    @Override
    public int updatePhotoUrl(Map<String, Object> map) {
        return mapper().updatePhotoUrl(map);
    }

    // 계정 탈퇴
    @Override
    public int deleteUser(int userId) {
        return mapper().deleteUser(userId);
    }

}
