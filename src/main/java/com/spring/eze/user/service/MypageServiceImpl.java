package com.spring.eze.user.service;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.spring.eze.common.GlobalVariableHolder;
import com.spring.eze.user.dao.MypageDAO;
import com.spring.eze.user.dao.UserDAO;
import com.spring.eze.user.dto.EmailCodeDTO;
import com.spring.eze.user.dto.MypageActivityDTO;
import com.spring.eze.user.dto.MypageDayStatDTO;
import com.spring.eze.user.dto.MypageMembershipDTO;
import com.spring.eze.user.dto.MypageMonthlyStatDTO;
import com.spring.eze.user.dto.MypagePaymentDTO;
import com.spring.eze.user.dto.MypagePlayReportDTO;
import com.spring.eze.user.dto.UserDTO;

/**
 * MypageServiceImpl — 마이페이지 전용 Service 구현체
 *
 * [의존성]
 *   MypageDAO → 마이페이지 전용 쿼리 (내 데이터만 건드리는 쿼리들)
 *   UserDAO   → 인증팀 DAO 재사용 (비밀번호 변경, 인증코드 확인)
 *              ★ UserServiceImpl을 통째로 주입하면 레이어가 오염됨
 *                 DAO 단위로만 재사용하는 게 올바른 패턴
 */
@Service
public class MypageServiceImpl implements MypageService {

    // SLF4J 로거 — 서비스 레이어에서 예외/비즈니스 로직 추적용
    // LoggerFactory.getLogger(클래스.class) 패턴으로 클래스명이 로그에 찍힘
    private static final Logger logger = LoggerFactory.getLogger(MypageServiceImpl.class);

    // 더보기 페이지 사이즈 — 한 번에 10개씩 가져옴
    private static final int PAGE_SIZE = 10;

    // Oracle TO_CHAR('D') 반환값: 1=일요일 ~ 7=토요일
    // 배열 인덱스 0은 빈값(""), 1~7만 실제로 사용
    private static final String[] DAY_NAMES = { "", "일", "월", "화", "수", "목", "금", "토" };

    // 프로필 사진 저장 경로 상수 분리
    // PHOTO_REAL_DIR: 실제 파일이 저장될 물리 경로 (Tomcat 재시작해도 파일 유지)
    // PHOTO_WEB_PATH: DB에 저장되는 웹 접근 경로 (브라우저에서 /resources/... 로 접근)
    private static final String PHOTO_REAL_DIR = "D:\\DEV06\\808_workspace\\808_project\\src\\main\\webapp\\resources\\upload\\profile\\";
    private static final String PHOTO_WEB_PATH = "/resources/upload/profile/";

    @Autowired
    private MypageDAO mypageDAO;

    @Autowired
    private UserDAO userDAO; // 인증팀 DAO — 비밀번호 변경, 인증코드 확인에만 재사용

    @Autowired
    private BCryptPasswordEncoder encoder; // SecurityConfig에서 @Bean으로 등록한 암호화 객체


    /* ════════════════════════════════════════════
       공통 헬퍼
       ════════════════════════════════════════════ */

    /**
     * 유저 + 프로필 조회 — DB에서 최신 정보 한 번에 가져옴
     * selectUserWithProfile: USER_TBL LEFT JOIN PROFILE_TBL 쿼리
     * 세션 갱신이 필요한 모든 곳에서 이 메서드를 거치도록 함 (중복 제거)
     */
    @Override
    public UserDTO getUserWithProfile(int userId) {
        return mypageDAO.selectUserWithProfile(userId);
    }

    /**
     * 세션 갱신 공통 헬퍼 — 수정 후 항상 이 메서드로 세션을 최신화
     *
     * 왜 setPassword(null) 하냐?
     *   로그인 시 세션에 비번을 null로 저장했는데,
     *   DB에서 다시 조회하면 BCrypt 해시가 딸려옴
     *   세션에 해시라도 남기면 안 되므로 여기서 항상 제거
     *
     * private인 이유 — 외부(Controller)에서 직접 호출할 필요 없음
     *   수정 → 세션 갱신은 항상 Service 안에서 한 세트로 처리해야 일관성 유지
     */
    private void refreshSession(HttpSession session, int userId) {
        UserDTO updated = getUserWithProfile(userId); //DB에서 최신 정보 가져오기
        updated.setPassword(null); 					  // 보안: BCrypt 해시를 세션에 남기지 않음
        session.setAttribute("loginUser", updated);	  // 세션에 덮어쓰기
    }


    /* ════════════════════════════════════════════
       페이지 진입
       ════════════════════════════════════════════ */

    /**
     * 멤버십 상태 조회 + 세션 등급 동기화
     *
     * 마이페이지 진입(/mypage GET) 시 매번 호출됨
     * → DB 최신 상태로 세션 등급을 실시간 보정하는 역할
     *
     * isValid 조건:
     *   1. membership이 null이 아닐 것 (데이터 존재)
     *   2. status가 "APPROVED"일 것 (결제 승인 상태)
     *   3. daysLeft >= 0일 것 (만료 안 됨)
     *   셋 중 하나라도 false면 FREE로 강등
     *
     * 반환값:
     *   유효한 멤버십 → MypageMembershipDTO (JSP에서 만료일 표시용)
     *   유효하지 않음 → null (JSP c:if ${not empty membership} 으로 분기)
     */
    @Override
    public MypageMembershipDTO getMembershipInfo(int userId, HttpSession session) {
        MypageMembershipDTO membership = mypageDAO.selectMembershipInfo(userId);
        logger.info("<<< selectMembershipInfo userId={}, result={} >>>", userId, membership);
        
        // 유효성 판단(세션 등급용)
        boolean isValid = (membership != null
                && "APPROVED".equals(membership.getStatus())
                && membership.getDaysLeft() >= 0);

        // 세션 등급 동기화 — DB 상태와 세션 상태를 항상 일치시킴
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        if (loginUser != null) {
            // 삼항연산자: isValid가 true면 "PRO", false면 "FREE"
            loginUser.getProfile().setMembershipType(isValid ? "PRO" : "FREE");
            session.setAttribute("loginUser", loginUser);
        }
        
        return isValid ? membership : null;
    }


    /* ════════════════════════════════════════════
       조회
       ════════════════════════════════════════════ */

    /**
     * 808 플레이 리포트
     * 여러 쿼리 결과를 MypagePlayReportDTO 하나에 조립해서 반환
     * JS Lazy Load — 플레이리포트 탭 클릭 시 최초 1회만 호출
     *
     * periodType: THIS_MONTH(기본) / LAST_MONTH / 3MONTH
     * TOP10 곡은 기간 필터 적용, 나머지는 전체 기간
     */
    @Override
    public MypagePlayReportDTO getPlayReport(int userId, String periodType) {
    	
        // 뮤직팀 SCORE 상수를 map으로 담아서 매퍼에 전달
        // GLB_SCORE_* 값이 바뀌어도 여기만 자동 반영됨
        Map<String, Object> scoreMap = new HashMap<>();
        scoreMap.put("userId",        userId);
		/* scoreMap.put("scorePlay", GlobalVariableHolder.GLB_SCORE_PLAY); */
        scoreMap.put("scoreInterval", GlobalVariableHolder.GLB_SCORE_INTERVAL);
    	
        // 1. 청취 요약 숫자 (총 청취시간, 재생곡수, 고유트랙수)
        MypagePlayReportDTO report = mypageDAO.selectPlaySummary(scoreMap);
        if (report == null) report = new MypagePlayReportDTO(); // 데이터 없어도 빈 DTO 반환

        if (periodType == null || periodType.trim().isEmpty()) periodType = "THIS_MONTH";
        report.setPeriodType(periodType);

        // 요일별 재생수 — 같은 scoreMap 재사용
        List<MypageDayStatDTO> rawDayStats  = mypageDAO.selectPlayCountByDay(scoreMap);
        List<MypageDayStatDTO> fullDayStats = buildFullDayStats(rawDayStats);
        report.setDayStats(fullDayStats);
        report.setBusiestDay(findBusiestDay(fullDayStats)); // 가장 활발한 요일

        // TOP 장르 — 같은 scoreMap 재사용
        report.setTopGenres(mypageDAO.selectTopGenres(scoreMap));

        // TOP 곡 — periodType 추가
        Map<String, Object> songMap = new HashMap<>(scoreMap); // scoreMap 복사
        songMap.put("periodType", periodType);
        report.setTopSongs(mypageDAO.selectTopSongs(songMap));

        // TOP 아티스트 — scoreMap 재사용
        report.setTopArtists(mypageDAO.selectTopArtists(scoreMap));

        return report;
    }

    /**
     * 통합 활동 내역 — 게시글/댓글/리뷰 한 번에 조회
     * 더보기 방식 페이징:
     *   page=1 → startRow=1,  endRow=10
     *   page=2 → startRow=11, endRow=20
     * MyBatis 쿼리에서 ROWNUM으로 Oracle 페이징 처리
     */
    @Override
    public List<MypageActivityDTO> getMyActivityList(int userId, int page) {
        Map<String, Object> map = new HashMap<>();
        map.put("userId",   userId);
        map.put("startRow", (page - 1) * PAGE_SIZE + 1);
        map.put("endRow",   page * PAGE_SIZE);
        return mypageDAO.selectMyActivityList(map);
    }

    // 결제 내역 — 최신순 전체 조회
    @Override
    public List<MypagePaymentDTO> getMyPaymentList(int userId) {
        return mypageDAO.selectMyPaymentList(userId);
    }

    // 월별 지출 합계 — Chart.js 바 차트용 (yearMonth, totalAmount)
    @Override
    public List<MypageMonthlyStatDTO> getMonthlyStats(int userId) {
        return mypageDAO.selectMonthlyStats(userId);
    }


    /* ════════════════════════════════════════════
       수정
       ════════════════════════════════════════════ */

    /**
     * 내 정보 수정 (닉네임 / 생년월일 / 소개)
     *
     * USER_TBL(닉네임)과 PROFILE_TBL(생년월일, 소개)이 분리되어 있어서
     * 두 번의 UPDATE가 필요함
     *
     * birthDate가 null이면 기존값 유지 (<set> 태그로 null 필드 제외)
     * bio는 빈문자열 허용 — 소개글을 지우는 기능도 있어야 하므로
     *
     * @return 1:성공, -1:닉네임 없음, 0:DB 실패
     */
    @Override
    public int updateUserInfo(int userId, String nickname, String birthDate, String bio, HttpSession session) {
        if (nickname == null || nickname.trim().isEmpty()) return -1;

        Map<String, Object> nickMap = new HashMap<>();
        nickMap.put("userId",   userId);
        nickMap.put("nickname", nickname.trim());
        if (mypageDAO.updateNickname(nickMap) < 1) return 0; // 닉네임 UPDATE 실패

        Map<String, Object> profileMap = new HashMap<>();
        profileMap.put("userId",    userId);
        profileMap.put("birthDate", (birthDate != null && !birthDate.isEmpty()) ? birthDate : null);
        profileMap.put("bio",       bio);
        mypageDAO.updateProfile(profileMap);

        // 수정 후 세션을 최신 DB 데이터로 갱신 — 화면에 바로 반영되도록
        refreshSession(session, userId);
        return 1;
    }

    /**
     * 프로필 사진 수정
     *
     * @Transactional: 파일 저장 + DB UPDATE를 한 묶음으로 처리
     *   → DB UPDATE 실패 시 파일도 롤백 (단, 파일 시스템은 실제로 롤백 안 됨 — 주의)
     *
     * 파일명을 "user_{userId}.{ext}"로 고정하는 이유:
     *   → 같은 유저가 다시 올리면 덮어쓰기 → 파일이 쌓이지 않음
     *
     * PHOTO_REAL_DIR: 실제 저장 경로 (상수로 분리 → 경로 변경 시 한 곳만 수정)
     * PHOTO_WEB_PATH: DB에 저장할 웹 경로
     *
     * @return 1:성공, 0:파일 없음/확장자 오류/DB 실패, -1:예외
     */
    @Transactional
    @Override
    public int updateProfilePhoto(int userId, MultipartFile file, HttpSession session) {
        try {
            if (file == null || file.isEmpty()) return 0;

            // 확장자 검사 — 허용된 이미지 형식만 통과
            String originalName = file.getOriginalFilename();
            String ext = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase();
            if (!ext.matches("jpg|jpeg|png|gif")) return 0;

            // 물리 파일 저장
            String fileName   = "user_" + userId + "." + ext;
            File   targetFile = new File(PHOTO_REAL_DIR + fileName);
            if (!targetFile.getParentFile().exists()) targetFile.getParentFile().mkdirs();
            file.transferTo(targetFile); // MultipartFile → 실제 파일로 저장

            // DB에 웹 접근 경로 저장 + 세션 갱신
            Map<String, Object> map = new HashMap<>();
            map.put("userId",   userId);
            map.put("photoUrl", PHOTO_WEB_PATH + fileName);

            if (mypageDAO.updatePhotoUrl(map) > 0) {
                refreshSession(session, userId);
                return 1;
            }
            return 0;

        } catch (Exception e) {
            // userId를 함께 찍어야 어떤 유저에서 발생했는지 추적 가능
            logger.error("프로필 사진 수정 중 예외 발생 — userId={}", userId, e);
            return -1;
        }
    }

    /**
     * 비밀번호 변경 — 현재비번 확인 → 인증코드 확인 → 새비번 저장
     *
     * 마이페이지 비번변경은 분실비번 재설정과 다름:
     *   분실비번(/updatePw): 현재비번 확인 없음, 이메일 인증만으로 변경
     *   마이페이지(/mypage/updatePw): 현재비번 + 이메일 인증코드 둘 다 필요
     *
     * encoder.matches(입력값, DB해시):
     *   BCrypt는 복호화 불가 → equals() 절대 못 씀
     *   matches()가 내부에서 솔트 꺼내서 비교해줌
     *
     * userDAO 재사용:
     *   getEmailCode — 인증팀이 만든 코드 조회 로직 그대로 활용
     *   updatePw     — 인증팀이 만든 비번 변경 쿼리 그대로 활용
     *   DAO만 재사용, UserServiceImpl은 주입하지 않음 (레이어 오염 방지)
     *
     * @return 1:성공, -1:현재비번 틀림, -2:인증코드 오류/만료, 0:실패
     */
    @Override
    public int updatePw(int userId, String currentPw, String code, String newPw) {
        // 1. 현재 비밀번호 확인
        UserDTO user = getUserWithProfile(userId);
        if (user == null || !encoder.matches(currentPw, user.getPassword())) return -1;

        // 2. 인증코드 확인 (불일치 또는 만료 모두 -2 반환)
        EmailCodeDTO emailCode = userDAO.getEmailCode(user.getEmail());
        if (emailCode == null || !emailCode.getCode().equals(code)) return -2;
        if (emailCode.getExpiresAt().before(new Date())) return -2; // 현재시간보다 이전이면 만료

        // 3. 새 비밀번호 BCrypt encode 후 저장
        Map<String, Object> map = new HashMap<>();
        map.put("email",    user.getEmail());
        map.put("password", encoder.encode(newPw)); // 새 비번도 반드시 암호화
        return userDAO.updatePw(map);
    }


    /* ════════════════════════════════════════════
       탈퇴
       ════════════════════════════════════════════ */

    /**
     * 계정 탈퇴
     * USER_TBL DELETE → CASCADE로 PROFILE_TBL 자동 삭제 (DB 제약조건)
     * 삭제 성공 후 session.invalidate() — 세션 완전 초기화 (로그아웃 효과)
     *
     * @return 1:성공, 0:실패
     */
    @Override
    public int deleteUser(int userId, HttpSession session) {
        int result = mypageDAO.deleteUser(userId);
        if (result < 1) return 0;
        session.invalidate(); // 탈퇴 후 세션 완전 파기
        return 1;
    }


    /* ════════════════════════════════════════════
       private 헬퍼 — 외부 노출 불필요한 내부 로직
       ════════════════════════════════════════════ */

    /**
     * 요일별 재생수 0채움
     * DB는 재생 기록이 있는 요일만 반환 (예: 월/수/금만 데이터 있을 수 있음)
     * Chart.js는 7개 고정 데이터가 필요 → 없는 요일은 0으로 채워서 반환
     *
     * int[] counts: 인덱스 1~7 사용 (0은 빈값, Oracle 'D' 기준)
     */
    private List<MypageDayStatDTO> buildFullDayStats(List<MypageDayStatDTO> rawList) {
        int[] counts = new int[8]; // 0~7, 인덱스 1~7만 사용
        for (MypageDayStatDTO d : rawList) {
            counts[d.getDayIndex()] = d.getPlayCount();
        }

        List<MypageDayStatDTO> result = new ArrayList<>();
        for (int i = 1; i <= 7; i++) {
            MypageDayStatDTO dto = new MypageDayStatDTO();
            dto.setDayIndex(i);
            dto.setDayName(DAY_NAMES[i]);    // 숫자 인덱스 → "월", "화" 등으로 변환
            dto.setPlayCount(counts[i]);
            // dto.setAvgPlayTimeSec(counts[i] * 10); // 요일별 차트 구현시 활성화
            result.add(dto);
        }
        return result;
    }

    /**
     * 가장 활발한 요일 추출
     * playCount가 가장 높은 요일의 dayName 반환
     * 모든 요일 playCount가 0이면 "-" 반환 (데이터 없음)
     */
    private String findBusiestDay(List<MypageDayStatDTO> dayStats) {
        if (dayStats == null || dayStats.isEmpty()) return "-";
        MypageDayStatDTO busiest = dayStats.get(0);
        for (MypageDayStatDTO d : dayStats) {
            if (d.getPlayCount() > busiest.getPlayCount()) busiest = d;
        }
        return busiest.getPlayCount() == 0 ? "-" : busiest.getDayName();
    }

}
