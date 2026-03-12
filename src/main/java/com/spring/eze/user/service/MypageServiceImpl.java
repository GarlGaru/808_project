package com.spring.eze.user.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.eze.user.dao.MypageDAO;
import com.spring.eze.user.dto.UserDTO;
import com.spring.eze.user.dto.MypageBoardDTO;
import com.spring.eze.user.dto.MypageCommentDTO;
import com.spring.eze.user.dto.MypageReservationDTO;
import com.spring.eze.user.dto.MypagePaymentDTO;
import com.spring.eze.user.dto.MypageMonthlyStatDTO;
import com.spring.eze.user.dto.MypagePlayReportDTO;
import com.spring.eze.user.dto.MypageDayStatDTO;
import com.spring.eze.user.dto.MypageGenreStatDTO;

@Service
public class MypageServiceImpl implements MypageService {

    @Autowired
    private MypageDAO mypageDAO;

    // 더보기 방식 — 한 번에 보여줄 게시글/댓글 수
    private static final int PAGE_SIZE = 10;

    // ── 유저 + 프로필 ──────────────────────────────
    // Controller나 다른 메서드에서 세션 갱신할 때 호출
    @Override
    public UserDTO getUserWithProfile(int userId) {
        return mypageDAO.selectUserWithProfile(userId);
    }

    // ── 내가 쓴 글 ─────────────────────────────────
    // page 1 → startRow:1, endRow:10
    // page 2 → startRow:11, endRow:20
    // Oracle ROWNUM 페이징 방식에 맞게 계산
    @Override
    public List<MypageBoardDTO> getMyBoardList(int userId, int page) {
        int startRow = (page - 1) * PAGE_SIZE + 1;
        int endRow   = page * PAGE_SIZE;

        // MyBatis에 여러 파라미터 넘길 때 Map 사용
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId",   userId);
        map.put("startRow", startRow);
        map.put("endRow",   endRow);

        return mypageDAO.selectMyBoardList(map);
    }

    // ── 내가 쓴 댓글 ───────────────────────────────
    @Override
    public List<MypageCommentDTO> getMyCommentList(int userId, int page) {
        int startRow = (page - 1) * PAGE_SIZE + 1;
        int endRow   = page * PAGE_SIZE;

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId",   userId);
        map.put("startRow", startRow);
        map.put("endRow",   endRow);

        return mypageDAO.selectMyCommentList(map);
    }

//    // ── 예매 내역 ──────────────────────────────────
//    @Override
//    public List<MypageReservationDTO> getMyReservationList(int userId) {
//        return mypageDAO.selectMyReservationList(userId);
//    }

    // ── 결제 내역 ──────────────────────────────────
    @Override
    public List<MypagePaymentDTO> getMyPaymentList(int userId) {
        return mypageDAO.selectMyPaymentList(userId);
    }

    // ── 월별 지출 합계 ─────────────────────────────
    @Override
    public List<MypageMonthlyStatDTO> getMonthlyStats(int userId) {
        return mypageDAO.selectMonthlyStats(userId);
    }

    // ── 808 플레이 리포트 ──────────────────────────
    // DAO 조회 결과 3개를 조합해서 PlayReportDTO 하나로 조립
    @Override
    public MypagePlayReportDTO getPlayReport(int userId) {
        MypagePlayReportDTO report = new MypagePlayReportDTO();

        // 1. 총 재생 곡 수
        report.setTotalPlayCount(mypageDAO.selectTotalPlayCount(userId));

        // 2. 요일별 재생수
        // DB에서 재생 기록 있는 요일만 나오므로 Service에서 0~6 전체 채워줌
        List<MypageDayStatDTO> rawDays = mypageDAO.selectPlayCountByDay(userId);
        String[] dayNames = {"일","월","화","수","목","금","토"};
        int[] counts = new int[7]; // 기본값 0으로 초기화

        // dayIndex는 Oracle TO_CHAR(date,'D') 기준 1=일 ~ 7=토
        for (MypageDayStatDTO d : rawDays) {
            counts[d.getDayIndex() - 1] = d.getPlayCount();
        }

        // 가장 재생 많은 요일 찾기
        int maxIdx = 0;
        for (int i = 1; i < 7; i++) {
            if (counts[i] > counts[maxIdx]) maxIdx = i;
        }
        report.setBusiestDay(dayNames[maxIdx]);

        // 요일별 전체 리스트 조립 — Chart.js에 넘길 용도
        List<MypageDayStatDTO> fullDays = new ArrayList<MypageDayStatDTO>();
        for (int i = 0; i < 7; i++) {
            MypageDayStatDTO d = new MypageDayStatDTO();
            d.setDayIndex(i + 1);
            d.setDayName(dayNames[i]);
            d.setPlayCount(counts[i]);
            fullDays.add(d);
        }
        report.setDayStats(fullDays);

        // 3. 탑 장르
        report.setTopGenres(mypageDAO.selectTopGenres(userId));

        return report;
    }

    // ── 내 정보 수정 ───────────────────────────────
    // 닉네임은 USER_TBL, 생년월일/소개는 PROFILE_TBL — 테이블이 달라서 DAO 두 번 호출
    // 수정 완료 후 세션의 loginUser를 DB에서 재조회해서 갱신
    @Override
    public int updateUserInfo(int userId, String nickname, String birthDate, String bio, HttpSession session) {

        // 닉네임 빈값 체크 — Mapper의 null체크와 별개로 Service에서도 검증
        if (nickname == null || nickname.trim().isEmpty()) return -1;

        // 닉네임 수정 — USER_TBL
        Map<String, Object> nickMap = new HashMap<String, Object>();
        nickMap.put("userId",   userId);
        nickMap.put("nickname", nickname.trim());
        mypageDAO.updateNickname(nickMap);

        // 생년월일, 소개 수정 — PROFILE_TBL
        // null이면 Mapper의 <if> 태그에서 UPDATE 제외 → 기존값 유지
        Map<String, Object> profileMap = new HashMap<String, Object>();
        profileMap.put("userId",    userId);
        profileMap.put("birthDate", birthDate);
        profileMap.put("bio",       bio);
        mypageDAO.updateProfile(profileMap);

        // 수정 후 DB에서 최신 정보 재조회해서 세션 갱신
        // 세션 갱신 안 하면 헤더/사이드바에 예전 닉네임이 그대로 보임
        UserDTO updated = mypageDAO.selectUserWithProfile(userId);
        session.setAttribute("loginUser", updated);

        return 1;
    }

    // ── 프로필 사진 수정 ───────────────────────────
    // 파일 저장은 Controller에서 처리 후 URL만 넘어옴
    // DB에 URL 저장 후 세션 갱신
    @Override
    public int updatePhotoUrl(int userId, String photoUrl, HttpSession session) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId",   userId);
        map.put("photoUrl", photoUrl);

        int result = mypageDAO.updatePhotoUrl(map);

        // 사진 수정 성공 시 세션 갱신
        if (result == 1) {
            UserDTO updated = mypageDAO.selectUserWithProfile(userId);
            session.setAttribute("loginUser", updated);
        }
        return result;
    }

    // ── 계정 탈퇴 ──────────────────────────────────
    // user_tbl CASCADE → profile_tbl 자동 삭제
    // 탈퇴 성공 시 세션 무효화 — JS에서 메인으로 redirect 처리
    @Override
    public int deleteUser(int userId, HttpSession session) {
        int result = mypageDAO.deleteUser(userId);
        if (result == 1) {
            session.invalidate();
        }
        return result;
    }
}