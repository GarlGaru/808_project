package com.spring.eze.user.dao;

import java.util.List;
import java.util.Map;

import com.spring.eze.user.dto.MypageBoardDTO;
import com.spring.eze.user.dto.MypageCommentDTO;
import com.spring.eze.user.dto.MypageReservationDTO;
import com.spring.eze.user.dto.MypagePaymentDTO;
import com.spring.eze.user.dto.MypageMonthlyStatDTO;
import com.spring.eze.user.dto.MypageDayStatDTO;
import com.spring.eze.user.dto.MypageGenreStatDTO;
import com.spring.eze.user.dto.UserDTO;

public interface MypageDAO {

    // 유저 + 프로필 — 내정보 수정 후 세션 갱신용
    public UserDTO selectUserWithProfile(int userId);

    // 내가 쓴 글 — 더보기 방식 (map: userId, startRow, endRow)
    public List<MypageBoardDTO> selectMyBoardList(Map<String, Object> map);

    // 내가 쓴 댓글 — 더보기 방식 (map: userId, startRow, endRow)
    public List<MypageCommentDTO> selectMyCommentList(Map<String, Object> map);

    // 예매 내역 — 최근 5건
    public List<MypageReservationDTO> selectMyReservationList(int userId);

    // 결제 내역 — 최신순 전체
    public List<MypagePaymentDTO> selectMyPaymentList(int userId);

    // 월별 지출 합계 — Chart.js용
    public List<MypageMonthlyStatDTO> selectMonthlyStats(int userId);

    // 플레이 리포트 — 총 재생 곡 수
    public int selectTotalPlayCount(int userId);

    // 플레이 리포트 — 요일별 재생수
    public List<MypageDayStatDTO> selectPlayCountByDay(int userId);

    // 플레이 리포트 — 탑 장르
    public List<MypageGenreStatDTO> selectTopGenres(int userId);

    // 내 정보 수정 — 닉네임
    public int updateNickname(Map<String, Object> map);

    // 내 정보 수정 — 생년월일, 소개
    public int updateProfile(Map<String, Object> map);

    // 내 정보 수정 — 프로필 사진
    public int updatePhotoUrl(Map<String, Object> map);

    // 계정 탈퇴
    public int deleteUser(int userId);
}