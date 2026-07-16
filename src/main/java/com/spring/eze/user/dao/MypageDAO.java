package com.spring.eze.user.dao;

import java.util.List;
import java.util.Map;

import com.spring.eze.user.dto.MypageActivityDTO;
import com.spring.eze.user.dto.MypagePaymentDTO;
import com.spring.eze.user.dto.MypagePlayReportDTO;
import com.spring.eze.user.dto.MypageReservationDTO;
import com.spring.eze.user.dto.MypageTopArtistDTO;
import com.spring.eze.user.dto.MypageTopSongDTO;
import com.spring.eze.user.dto.MypageMonthlyStatDTO;
import com.spring.eze.user.dto.MypageDayStatDTO;
import com.spring.eze.user.dto.MypageGenreStatDTO;
import com.spring.eze.user.dto.MypageMembershipDTO;
import com.spring.eze.user.dto.UserDTO;

public interface MypageDAO {

    // 유저 + 프로필 - 내정보 수정 후 세션 갱신용
    public UserDTO selectUserWithProfile(int userId);

    // 통합 활동 내역 조회 (userId, startRow, endRow 포함된 Map)
    public List<MypageActivityDTO> selectMyActivityList(Map<String, Object> map);
    
    // 예매 내역 - 최근 5건
    public List<MypageReservationDTO> selectMyReservationList(int userId);

    // 결제 내역 - 최신순 전체
    public List<MypagePaymentDTO> selectMyPaymentList(Map<String, Object> map);

    // 월별 지출 합계(최근 12개월) - Chart.js용
    public List<MypageMonthlyStatDTO> selectMonthlyStats(int userId);
    
    // 멤버쉽 정보
    public MypageMembershipDTO selectMembershipInfo(int userId);
    
    // 808 플레리 리포트 요약
	// SCORE = 1   → 재생 시작 (GLB_SCORE_PLAY)
	// SCORE = 5   → 10초 청취 (GLB_SCORE_INTERVAL)
	// SCORE = 300 → 좋아요 (집계 제외)
    public MypagePlayReportDTO selectPlaySummary(Map<String, Object> map);
 
    // 플레이 리포트 - 요일별 재생수
    public List<MypageDayStatDTO> selectPlayCountByDay(Map<String, Object> map);

    // 플레이 리포트 - 탑 장르
    public List<MypageGenreStatDTO> selectTopGenres(Map<String, Object> map);

    // 탑 곡 - Top10
    public List<MypageTopSongDTO> selectTopSongs(Map<String, Object> map);
    
    // 탑 아티스트 - Top10
    public List<MypageTopArtistDTO> selectTopArtists(Map<String, Object> map);
   
    // 내 정보 수정 - 닉네임
    public int updateNickname(Map<String, Object> map);

    // 내 정보 수정 - 생년월일, 소개
    public int updateProfile(Map<String, Object> map);

    // 내 정보 수정 - 프로필 사진
    public int updatePhotoUrl(Map<String, Object> map);

    // 계정 탈퇴
    public int deleteUser(int userId);
}