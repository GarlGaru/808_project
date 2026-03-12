package com.spring.eze.user.service;

import java.util.List;

import javax.servlet.http.HttpSession;

import com.spring.eze.user.dto.UserDTO;
import com.spring.eze.user.dto.MypageBoardDTO;
import com.spring.eze.user.dto.MypageCommentDTO;
import com.spring.eze.user.dto.MypageReservationDTO;
import com.spring.eze.user.dto.MypagePaymentDTO;
import com.spring.eze.user.dto.MypageMonthlyStatDTO;
import com.spring.eze.user.dto.MypagePlayReportDTO;

public interface MypageService {

    // 유저 + 프로필 — 수정 후 세션 갱신용
    public UserDTO getUserWithProfile(int userId);

    // 내가 쓴 글 — 더보기 방식 (page: 1부터 시작)
    public List<MypageBoardDTO> getMyBoardList(int userId, int page);

    // 내가 쓴 댓글 — 더보기 방식
    public List<MypageCommentDTO> getMyCommentList(int userId, int page);

    // 예매 내역 — 최근 5건
    public List<MypageReservationDTO> getMyReservationList(int userId);

    // 결제 내역
    public List<MypagePaymentDTO> getMyPaymentList(int userId);

    // 월별 지출 합계 — Chart.js용
    public List<MypageMonthlyStatDTO> getMonthlyStats(int userId);

    // 808 플레이 리포트
    public MypagePlayReportDTO getPlayReport(int userId);

    // 내 정보 수정 — 수정 후 세션 갱신 필요해서 HttpSession 받음
    public int updateUserInfo(int userId, String nickname, String birthDate, String bio, HttpSession session);

    // 프로필 사진 수정 — 수정 후 세션 갱신 필요해서 HttpSession 받음
    public int updatePhotoUrl(int userId, String photoUrl, HttpSession session);

    // 계정 탈퇴 — 탈퇴 후 session.invalidate() 필요해서 HttpSession 받음
    public int deleteUser(int userId, HttpSession session);
}