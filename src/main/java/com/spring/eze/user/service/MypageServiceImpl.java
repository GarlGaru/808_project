package com.spring.eze.user.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.eze.user.dao.MypageDAO;
import com.spring.eze.user.dao.UserDAO;
import com.spring.eze.user.dto.EmailCodeDTO;
import com.spring.eze.user.dto.MypageBoardDTO;
import com.spring.eze.user.dto.MypageCommentDTO;
import com.spring.eze.user.dto.MypageDayStatDTO;
import com.spring.eze.user.dto.MypageMembershipDTO;
import com.spring.eze.user.dto.MypageMonthlyStatDTO;
import com.spring.eze.user.dto.MypagePaymentDTO;
import com.spring.eze.user.dto.MypagePlayReportDTO;
import com.spring.eze.user.dto.MypageReservationDTO;
import com.spring.eze.user.dto.UserDTO;

/**
 * MypageServiceImpl
 * 마이페이지 전용 Service 구현체
 *
 * 의존성:
 *   MypageDAO → 마이페이지 전용 쿼리
 *   UserDAO   → 비밀번호 확인/변경, 인증코드 확인 (인증팀 재사용)
 */
@Service
public class MypageServiceImpl implements MypageService {

	@Autowired
    private BCryptPasswordEncoder encoder; // SecurityConfig에서 빈(bean)으로 등록한 함호화 객체 주입
	
    // 더보기 방식 페이지 사이즈
    private static final int PAGE_SIZE = 10;

    // 요일 인덱스 → 요일명 변환 (Oracle TO_CHAR 'D': 1=일 ~ 7=토)
    private static final String[] DAY_NAMES = { "", "일", "월", "화", "수", "목", "금", "토" };

    @Autowired
    private MypageDAO mypageDAO;

    @Autowired
    private UserDAO userDAO; // 인증팀 DAO — 비밀번호/인증코드 처리


    /* ────────────────────────────────────────────
       유저 + 프로필
    ──────────────────────────────────────────── */

    // 유저 + 프로필 — 수정 후 세션 갱신용
    @Override
    public UserDTO getUserWithProfile(int userId) {
        return mypageDAO.selectUserWithProfile(userId);
    }


    /* ────────────────────────────────────────────
       활동 내역
    ──────────────────────────────────────────── */

    // 내가 쓴 글 — 더보기 방식 (page: 1부터 시작)
    @Override
    public List<MypageBoardDTO> getMyBoardList(int userId, int page) {
        // 더보기 페이징 계산
        // page=1 → startRow=1,  endRow=10
        // page=2 → startRow=11, endRow=20
        Map<String, Object> map = new HashMap<>();
        map.put("userId",   userId);
        map.put("startRow", (page - 1) * PAGE_SIZE + 1);
        map.put("endRow",   page * PAGE_SIZE);
        return mypageDAO.selectMyBoardList(map);
    }

    // 내가 쓴 댓글 — 더보기 방식 (page: 1부터 시작)
    @Override
    public List<MypageCommentDTO> getMyCommentList(int userId, int page) {
        Map<String, Object> map = new HashMap<>();
        map.put("userId",   userId);
        map.put("startRow", (page - 1) * PAGE_SIZE + 1);
        map.put("endRow",   page * PAGE_SIZE);
        return mypageDAO.selectMyCommentList(map);
    }

    
      // 예매 내역 — 최근 5건
//    @Override
//    public List<MypageReservationDTO> getMyReservationList(int userId) {
//        return mypageDAO.selectMyReservationList(userId);
//    }

    // 결제 내역 — 최신순 전체
    @Override
    public List<MypagePaymentDTO> getMyPaymentList(int userId) {
        return mypageDAO.selectMyPaymentList(userId);
    }
    
    
    // 월별 지출 합계 — Chart.js용
    @Override
    public List<MypageMonthlyStatDTO> getMonthlyStats(int userId) {
        return mypageDAO.selectMonthlyStats(userId);
    }

    // 멤버십 정보 조회 및 검증
    @Override
    public MypageMembershipDTO getMembershipInfo(int userId) {
        
        // 1. DB에서 가장 최근의 PRO 결제 정보를 조회
        MypageMembershipDTO membership = mypageDAO.selectMembershipInfo(userId);
        
        // 2. 정보가 존재할 경우에만 유효성 검증
        if (membership != null) {
            
             // 결제 상태가 'APPROVED'(승인)가 아니라면 유효한 멤버십이 아님
             // D-Day(daysLeft)가 0보다 작으면 이미 한 달이 지나 만료된 상태
            boolean isApproved = "APPROVED".equals(membership.getStatus());
            boolean isExpired = membership.getDaysLeft() < 0;

            // 승인이 안났거나 이미 만료되었다면 사용자에게 정보를 보여주지 않음 (null 반환)
            if (!isApproved || isExpired) {
                return null;
            }
        }
        
        // 3. 위 검증을 모두 통과한 정상적인 정보(PRO 유지 중)만 반환
        return membership;
    }
    

    /* ────────────────────────────────────────────
       808 플레이 리포트
    ──────────────────────────────────────────── */

    // 808 플레이 리포트 — Lazy Loading (탭 클릭 시 최초 1회)
    @Override
    public MypagePlayReportDTO getPlayReport(int userId, String periodType) {

        // 1. 숫자 요약 — CASE WHEN으로 4개 한번에 조회
        MypagePlayReportDTO report = mypageDAO.selectPlaySummary(userId);
        if (report == null) report = new MypagePlayReportDTO();

        // 2. 기간 필터 기본값
        if (periodType == null || periodType.trim().isEmpty()) {
            periodType = "THIS_MONTH";
        }
        report.setPeriodType(periodType);

        // 3. 요일별 재생수 — 0채움 + dayName 변환
        List<MypageDayStatDTO> rawDayStats  = mypageDAO.selectPlayCountByDay(userId);
        List<MypageDayStatDTO> fullDayStats = buildFullDayStats(rawDayStats);
        report.setDayStats(fullDayStats);

        // 4. 가장 활발한 요일 — dayStats MAX playCount 추출
        report.setBusiestDay(findBusiestDay(fullDayStats));

        // 5. 탑 장르 Top4
        report.setTopGenres(mypageDAO.selectTopGenres(userId));

        // 6. 탑 곡 Top10 — 기간 필터 적용
        Map<String, Object> songMap = new HashMap<>();
        songMap.put("userId",     userId);
        songMap.put("periodType", periodType);
        report.setTopSongs(mypageDAO.selectTopSongs(songMap));

        // 7. 탑 아티스트 Top10
        report.setTopArtists(mypageDAO.selectTopArtists(userId));

        return report;
    }

    /**
     * 요일별 재생수 0채움 + dayName 변환
     * DB: 데이터 있는 요일만 반환
     * 반환: 1~7 전체 7개 고정 (없는 요일 playCount=0)
     */
    private List<MypageDayStatDTO> buildFullDayStats(List<MypageDayStatDTO> rawList) {
        // dayIndex → playCount 매핑
        int[] counts = new int[8]; // 인덱스 1~7 사용
        for (MypageDayStatDTO d : rawList) {
            counts[d.getDayIndex()] = d.getPlayCount();
        }
        // 1~7 전체 채움
        List<MypageDayStatDTO> result = new ArrayList<>();
        for (int i = 1; i <= 7; i++) {
            MypageDayStatDTO dto = new MypageDayStatDTO();
            dto.setDayIndex(i);
            dto.setDayName(DAY_NAMES[i]);
            dto.setPlayCount(counts[i]);
            // avgPlayTimeSec: 해당 요일 재생수 * 10초 (SCORE=5 기준 단순 추정)
            dto.setAvgPlayTimeSec(counts[i] * 10);
            result.add(dto);
        }
        return result;
    }

    /**
     * 가장 활발한 요일 추출
     * playCount MAX 요일명 반환, 데이터 없으면 "-"
     */
    private String findBusiestDay(List<MypageDayStatDTO> dayStats) {
        if (dayStats == null || dayStats.isEmpty()) return "-";
        MypageDayStatDTO busiest = dayStats.get(0);
        for (MypageDayStatDTO d : dayStats) {
            if (d.getPlayCount() > busiest.getPlayCount()) busiest = d;
        }
        return busiest.getPlayCount() == 0 ? "-" : busiest.getDayName();
    }


    /* ────────────────────────────────────────────
       내 정보 수정
    ──────────────────────────────────────────── */

    // 내 정보 수정
    @Override
    public int updateUserInfo(int userId, String nickname,
                              String birthDate, String bio,
                              HttpSession session) {
        // 닉네임 필수 체크
        if (nickname == null || nickname.trim().isEmpty()) return -1;

        // USER_TBL 닉네임 업데이트
        Map<String, Object> nickMap = new HashMap<>();
        nickMap.put("userId",   userId);
        nickMap.put("nickname", nickname.trim());
        int result = mypageDAO.updateNickname(nickMap);
        if (result < 1) return 0;

        // PROFILE_TBL 생년월일/소개 업데이트
        // <set> 태그로 null 필드 제외 → 기존값 유지
        Map<String, Object> profileMap = new HashMap<>();
        profileMap.put("userId",    userId);
        profileMap.put("birthDate", (birthDate != null && !birthDate.isEmpty()) ? birthDate : null);
        profileMap.put("bio",       bio); // 빈문자열 허용 (소개 지우기 가능)
        mypageDAO.updateProfile(profileMap);

        // 세션 갱신
        UserDTO updated = mypageDAO.selectUserWithProfile(userId);
        session.setAttribute("loginUser", updated);

        return 1;
    }

    // 프로필 사진 수정
    @Transactional
    @Override
    public int updatePhotoUrl(int userId, String photoUrl, HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        map.put("userId",   userId);
        map.put("photoUrl", photoUrl);
        
        // DB 업데이트
        int result = mypageDAO.updatePhotoUrl(map);
        if (result < 1) return 0;

        // 세션 갱신
        UserDTO updated = mypageDAO.selectUserWithProfile(userId);
        if (updated != null) {
            // 3. [본인 규칙 적용] 세션에는 비밀번호를 들고 다니지 않으므로 null 처리
            updated.setPassword(null); 
            
            // 4. 최신 프로필 정보가 포함된 객체로 세션 덮어쓰기
            session.setAttribute("loginUser", updated);
            return 1;
        }
        
        return 0;
    }

 // 비밀번호 변경
    @Override
    public int updatePw(int userId, String currentPw, String code, String newPw) {

        // 1. 현재 비밀번호 확인 — userId로 유저 조회 후 BCrypt matches() 비교
        UserDTO user = mypageDAO.selectUserWithProfile(userId);
        if (user == null || !encoder.matches(currentPw, user.getPassword())) return -1;

        // 2. 인증코드 확인 — 인증팀 getEmailCode 재사용
        EmailCodeDTO emailCode = userDAO.getEmailCode(user.getEmail());
        if (emailCode == null) return -2;

        // 인증코드 불일치 체크
        if (!emailCode.getCode().equals(code)) return -2;

        // 인증코드 만료 체크 — expires_at 이 현재시간보다 이전이면 만료
        if (emailCode.getExpiresAt().before(new Date())) return -2;

        // 3. 새 비밀번호 BCrypt encode 후 저장 — 인증팀 userDAO.updatePw 재사용
        Map<String, Object> map = new HashMap<>();
        map.put("email",    user.getEmail());
        map.put("password", encoder.encode(newPw));
        return userDAO.updatePw(map);
    }

    // 계정 탈퇴 
    @Override
    public int deleteUser(int userId, HttpSession session) {
        // USER_TBL DELETE → CASCADE로 PROFILE_TBL 자동 삭제
        int result = mypageDAO.deleteUser(userId);
        if (result < 1) return 0;

        // 세션 완전 초기화
        session.invalidate();
        return 1;
    }


}
