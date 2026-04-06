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
import com.spring.eze.user.dto.MypageReservationDTO;
import com.spring.eze.user.dto.UserDTO;

/**
 * MypageServiceImpl — 마이페이지 전용 Service 구현체
 *
 * [의존성] MypageDAO → 마이페이지 전용 쿼리 (내 데이터만 건드리는 쿼리들) UserDAO → 인증팀 DAO 재사용 (비밀번호
 * 변경, 인증코드 확인) ★ UserServiceImpl을 통째로 주입하면 레이어가 오염됨 DAO 단위로만 재사용하는 게 올바른 패턴
 */
@Service
public class MypageServiceImpl implements MypageService {

	private static final Logger logger = LoggerFactory.getLogger(MypageServiceImpl.class);
	private static final int PAGE_SIZE = 10;
	private static final String[] DAY_NAMES = { "", "일", "월", "화", "수", "목", "금", "토" };
	private static final String PHOTO_REAL_DIR = "D:\\DEV06\\808_workspace\\808_project\\src\\main\\webapp\\resources\\upload\\profile\\";
	private static final String PHOTO_WEB_PATH = "/resources/upload/profile/";

	@Autowired
	private MypageDAO mypageDAO;

	@Autowired
	private UserDAO userDAO; // 인증팀 DAO — 비밀번호 변경, 인증코드 확인에만 재사용

	@Autowired
	private BCryptPasswordEncoder encoder; // SecurityConfig에서 @Bean으로 등록한 암호화 객체

	// 공통
	// 유저 + 프로필 조회 — DB에서 최신 정보 한 번에 가져옴
	@Override
	public UserDTO getUserWithProfile(int userId) {
		return mypageDAO.selectUserWithProfile(userId);
	}

	private void refreshSession(HttpSession session, int userId) {
		// 1. DB에서 최신 정보 가져오기
		UserDTO updated = getUserWithProfile(userId);
		// 2. 세션에 비밀번호 제거 후 저장
		updated.setPassword(null);
		session.setAttribute("loginUser", updated);
	}

	// 마이페이지
	@Override
	public MypageMembershipDTO getMembershipInfo(int userId, HttpSession session) {

		// 1. DB에서 멤버십 정보 조회
		MypageMembershipDTO membership = mypageDAO.selectMembershipInfo(userId);
		logger.info("<<< selectMembershipInfo userId={}, result={} >>>", userId, membership);

		// 2. 세션 갱신 - DB 상태 기준 최신화
		refreshSession(session, userId);

		// 3. 멤버십 유효성 판단
		boolean isValid = (membership != null && "APPROVED".equals(membership.getStatus())
				&& membership.getDaysLeft() >= 0);

		// 4. 세션 등급(FREE/PRO) 동기화
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
		if (loginUser != null) {
			// 삼항연산자: isValid가 true면 "PRO", false면 "FREE"
			loginUser.getProfile().setMembershipType(isValid ? "PRO" : "FREE");
			session.setAttribute("loginUser", loginUser);
		}
		// 5. 반환
		return isValid ? membership : null;
	}

	// 808 플레이 리포트
	@Override
	public MypagePlayReportDTO getPlayReport(int userId, String periodType) {

		// 1. 점수 상수 세팅
		Map<String, Object> scoreMap = new HashMap<>();
		scoreMap.put("userId", userId);
		scoreMap.put("scoreInterval", GlobalVariableHolder.GLB_SCORE_INTERVAL);

		// 2. 청취 요약 조회 (총 청취시간, 재생곡수, 고유트랙수)
		MypagePlayReportDTO report = mypageDAO.selectPlaySummary(scoreMap);
		if (report == null)
			report = new MypagePlayReportDTO(); // 데이터 없어도 빈 DTO 반환

		if (periodType == null || periodType.trim().isEmpty())
			periodType = "THIS_MONTH";
		report.setPeriodType(periodType);

		// 3. 요일별 재생수
		List<MypageDayStatDTO> rawDayStats = mypageDAO.selectPlayCountByDay(scoreMap);
		List<MypageDayStatDTO> fullDayStats = buildFullDayStats(rawDayStats);
		report.setDayStats(fullDayStats);
		report.setBusiestDay(findBusiestDay(fullDayStats)); // 가장 활발한 요일

		// 4. TOP 장르
		report.setTopGenres(mypageDAO.selectTopGenres(scoreMap));

		// 5. TOP 곡 (기간 필터 적용)
		Map<String, Object> songMap = new HashMap<>(scoreMap); // scoreMap 복사
		songMap.put("periodType", periodType);
		report.setTopSongs(mypageDAO.selectTopSongs(songMap));

		// 6. TOP 아티스트
		report.setTopArtists(mypageDAO.selectTopArtists(scoreMap));

		return report;
	}

	// 활동 피드
	@Override
	public List<MypageActivityDTO> getMyActivityList(int userId, int page) {
		Map<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("startRow", (page - 1) * PAGE_SIZE + 1);
		map.put("endRow", page * PAGE_SIZE);
		return mypageDAO.selectMyActivityList(map);
	}

	// 예매 내역 — 최근 6건
	@Override
	public List<MypageReservationDTO> getMyReservationList(int userId) {
		return mypageDAO.selectMyReservationList(userId);
	}

	// 결제 내역 — 최신순 전체 조회
	@Override
	public List<MypagePaymentDTO> getMyPaymentList(int userId, int page) {
		Map<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("startRow", (page - 1) * PAGE_SIZE + 1);
		map.put("endRow", page * PAGE_SIZE);
		return mypageDAO.selectMyPaymentList(map);
	}

	// 월별 지출 합계
	@Override
	public List<MypageMonthlyStatDTO> getMonthlyStats(int userId) {
		return mypageDAO.selectMonthlyStats(userId);
	}

	// 내 정보 수정
	@Override
	public int updateUserInfo(int userId, String nickname, String birthDate, String bio, HttpSession session) {
		// 1. 닉네임 검증
		if (nickname == null || nickname.trim().isEmpty())
			return -1;
		
		// 2. 닉네임 업데이트
		Map<String, Object> nickMap = new HashMap<>();
		nickMap.put("userId", userId);
		nickMap.put("nickname", nickname.trim());
		if (mypageDAO.updateNickname(nickMap) < 1)
			return 0; // 닉네임 UPDATE 실패
		
		// 3. 프로필 업데이트
		Map<String, Object> profileMap = new HashMap<>();
		profileMap.put("userId", userId);
		profileMap.put("birthDate", (birthDate != null && !birthDate.isEmpty()) ? birthDate : null);
		profileMap.put("bio", bio);
		mypageDAO.updateProfile(profileMap);

		// 4. 세션 갱신(수정 후 세션을 최신 DB 데이터로 갱신)
		refreshSession(session, userId);
		return 1;
	}

	// 프로필 사진 업로드
	@Transactional
	@Override
	public int updateProfilePhoto(int userId, MultipartFile file, HttpSession session) {
		try {
			// 1. 파일 유효성 검사
			if (file == null || file.isEmpty())
				return 0;

			// 2. 확장자 검사 — jpg, jpeg, png, gif만 허용
			String originalName = file.getOriginalFilename();
			String ext = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase();
			if (!ext.matches("jpg|jpeg|png|gif"))
				return 0;

			// 3. 고정된 파일명으로 덮어쓰기
			String fileName = "user_" + userId + "." + ext;
			File targetFile = new File(PHOTO_REAL_DIR + fileName);
			if (!targetFile.getParentFile().exists())
				targetFile.getParentFile().mkdirs();
			file.transferTo(targetFile); // MultipartFile → 실제 파일로 저장

			// 4. DB 업데이트 + 세션 갱신
			Map<String, Object> map = new HashMap<>();
			map.put("userId", userId);
			map.put("photoUrl", PHOTO_WEB_PATH + fileName);
			
			// 5. DB 업데이트 성공 시 세션 갱신
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

	// 비밀번호 변경
	@Override
	public int updatePw(int userId, String currentPw, String code, String newPw) {
		// 1. 현재 비밀번호 확인
		UserDTO user = getUserWithProfile(userId);
		if (user == null || !encoder.matches(currentPw, user.getPassword()))
			return -1;

		// 2. 인증코드 확인 (불일치 또는 만료 모두 -2 반환)
		EmailCodeDTO emailCode = userDAO.getEmailCode(user.getEmail());
		if (emailCode == null || !emailCode.getCode().equals(code))
			return -2;
		if (emailCode.getExpiresAt().before(new Date()))
			return -2; // 현재시간보다 이전이면 만료

		// 3. 새 비밀번호 BCrypt encode 후 저장
		Map<String, Object> map = new HashMap<>();
		map.put("email", user.getEmail());
		map.put("password", encoder.encode(newPw)); // 새 비번도 반드시 암호화
		return userDAO.updatePw(map);
	}

	// 회원탈퇴
	@Override
	public int deleteUser(int userId, HttpSession session) {
		int result = mypageDAO.deleteUser(userId);
		if (result < 1)
			return 0;
		session.invalidate(); // 탈퇴 후 세션 완전 파기
		return 1;
	}

	// 공통 헬퍼 - 요일별 통계 처리
	private List<MypageDayStatDTO> buildFullDayStats(List<MypageDayStatDTO> rawList) {
		int[] counts = new int[8]; // 0~7, 인덱스 1~7만 사용
		for (MypageDayStatDTO d : rawList) {
			counts[d.getDayIndex()] = d.getPlayCount();
		}

		List<MypageDayStatDTO> result = new ArrayList<>();
		for (int i = 1; i <= 7; i++) {
			MypageDayStatDTO dto = new MypageDayStatDTO();
			dto.setDayIndex(i);
			dto.setDayName(DAY_NAMES[i]); // 숫자 인덱스 → "월", "화" 등으로 변환
			dto.setPlayCount(counts[i]);
			// dto.setAvgPlayTimeSec(counts[i] * 10); // 요일별 차트 구현시 활성화
			result.add(dto);
		}
		return result;
	}

	// 가장 활발한 요일
	private String findBusiestDay(List<MypageDayStatDTO> dayStats) {
		if (dayStats == null || dayStats.isEmpty())
			return "-";
		MypageDayStatDTO busiest = dayStats.get(0);
		for (MypageDayStatDTO d : dayStats) {
			if (d.getPlayCount() > busiest.getPlayCount())
				busiest = d;
		}
		return busiest.getPlayCount() == 0 ? "-" : busiest.getDayName();
	}

}
