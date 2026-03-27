package com.spring.eze.user.service;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.web.multipart.MultipartFile;

import com.spring.eze.user.dto.MypageActivityDTO;
import com.spring.eze.user.dto.MypageMembershipDTO;
import com.spring.eze.user.dto.MypageMonthlyStatDTO;
import com.spring.eze.user.dto.MypagePaymentDTO;
import com.spring.eze.user.dto.MypagePlayReportDTO;
import com.spring.eze.user.dto.UserDTO;

public interface MypageService {

    // 유저 + 프로필 — 수정 후 세션 갱신용
    public UserDTO getUserWithProfile(int userId);
    
    // 내 정보 수정 — 수정 후 세션 갱신 필요해서 HttpSession 받음
    // @return 1: 성공, -1: 닉네임 없음, 0: 실패
    public int updateUserInfo(int userId, String nickname, String birthDate, String bio, HttpSession session);

    // 프로필 사진 수정 — 수정 후 세션 갱신 필요해서 HttpSession 받음
    // @return 1: 성공, 0: 실패
    public int updateProfilePhoto(int userId, MultipartFile file, HttpSession session);

    // 비밀번호 변경 — 현재 비번 확인 → 인증코드 확인 → 새 비번 UPDATE
    // @return 1: 성공, -1: 현재 비번 틀림, -2: 인증코드 만료/불일치, 0: 실패
    public int updatePw(int userId, String currentPw, String code, String newPw);

    // 멤버십 정보 조회 + 세션 등급 동기화
    public MypageMembershipDTO getMembershipInfo(int userId, HttpSession session);

    // 계정 탈퇴 — 탈퇴 후 session.invalidate() 필요해서 HttpSession 받음
    // @return 1: 성공, 0: 실패
    public int deleteUser(int userId, HttpSession session);

    // 808 플레이 리포트 — Lazy Loading (탭 클릭 시 최초 1회)
    // periodType: THIS_MONTH / LAST_MONTH / 3MONTH
    public MypagePlayReportDTO getPlayReport(int userId, String periodType);
    
    // 통합 활동 내역 조회 
    public List<MypageActivityDTO> getMyActivityList(int userId, int page);

    // 결제 내역 — 최신순 전체
    public List<MypagePaymentDTO> getMyPaymentList(int userId);

    // 월별 지출 합계 — Chart.js용
    public List<MypageMonthlyStatDTO> getMonthlyStats(int userId);
    


}
