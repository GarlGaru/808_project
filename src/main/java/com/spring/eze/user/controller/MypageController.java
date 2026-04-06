package com.spring.eze.user.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.eze.user.dto.MypageActivityDTO;
import com.spring.eze.user.dto.MypageMembershipDTO;
import com.spring.eze.user.dto.MypageMonthlyStatDTO;
import com.spring.eze.user.dto.MypagePaymentDTO;
import com.spring.eze.user.dto.MypagePlayReportDTO;
import com.spring.eze.user.dto.MypageReservationDTO;
import com.spring.eze.user.dto.UserDTO;
import com.spring.eze.user.service.MypageServiceImpl;

@Controller
public class MypageController {

    private static final Logger logger = LoggerFactory.getLogger(MypageController.class);
																						 
    @Autowired
    private MypageServiceImpl mypageService;
																																  
    // 세션에서 loginUser 꺼내는 공통 헬퍼
    private UserDTO getLoginUser(HttpSession session) {
        return (UserDTO) session.getAttribute("loginUser");
    }

    // 마이페이지 진입 — 멤버십 상태 동기화 후 페이지 이동
    @RequestMapping(value = "/mypage/", method = RequestMethod.GET)
    public String mypageMain(HttpSession session, Model model) {
        logger.info("<<< url => /mypage (Main) >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return "redirect:/login";

        // 초기 로딩 시 멤버십 정보를 Model에 담아 '깜빡임' 방지
        MypageMembershipDTO membership = mypageService.getMembershipInfo(loginUser.getUserId(), session);
        model.addAttribute("membership", membership);

        return "user/mypage";
    }

    // 멤버십 정보 조회 API (동적 갱신용)
    @RequestMapping(value = "/mypage/membershipInfo", method = RequestMethod.GET)
    @ResponseBody
    public MypageMembershipDTO membershipInfo(HttpSession session) {
        logger.info("<<< url => /mypage/membershipInfo (API) >>>");
        
        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return new MypageMembershipDTO(); // ← 빈 객체 반환
        
        MypageMembershipDTO dto = mypageService.getMembershipInfo(loginUser.getUserId(), session);
        if (dto == null) return new MypageMembershipDTO(); // ← 이것도 빈 객체로
        
        return dto;
    }
    
    // 808 플레이 리포트(기간요약: 이번달, 지난달, 최근 3개월)
    @ResponseBody
    @RequestMapping(value = "/mypage/playReport", method = RequestMethod.GET)
    public MypagePlayReportDTO getPlayReport(HttpServletRequest request, HttpSession session) {
        logger.info("<<< url => /mypage/playReport >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return null;

        String periodType = request.getParameter("periodType");
        if (periodType == null || periodType.trim().isEmpty()) periodType = "THIS_MONTH";

        return mypageService.getPlayReport(loginUser.getUserId(), periodType);
    }

    // 활동 피드 (게시글 / 댓글 / 리뷰) — 10개씩 더보기
    @ResponseBody
    @RequestMapping(value = "/mypage/activity", method = RequestMethod.GET)
    public List<MypageActivityDTO> getMyActivity(
            @RequestParam(defaultValue = "1") int page,
            HttpSession session) {
        logger.info("<<< url => /mypage/activity >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return null;

														 
        return mypageService.getMyActivityList(loginUser.getUserId(), page);
    }
    
    // 마이 티켓
    @ResponseBody
    @RequestMapping(value = "/mypage/reservations", method = RequestMethod.GET)
    public List<MypageReservationDTO> getMyReservations(HttpSession session) {
        logger.info("<<< url => /mypage/reservations >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return null;

        return mypageService.getMyReservationList(loginUser.getUserId());
    }

    // 구매 기록
    @ResponseBody
    @RequestMapping(value = "/mypage/payments", method = RequestMethod.GET)
    public List<MypagePaymentDTO> getMyPayments(HttpSession session,
                                                 @RequestParam(defaultValue = "1") int page) {
        logger.info("<<< url => /mypage/payments >>>");
        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return null;
        return mypageService.getMyPaymentList(loginUser.getUserId(), page);
    }

    // 구매기록 - 월별 지출 합계 — Chart.js용
    @ResponseBody
    @RequestMapping(value = "/mypage/monthlyStats", method = RequestMethod.GET)
    public List<MypageMonthlyStatDTO> getMonthlyStats(HttpSession session) {
        logger.info("<<< url => /mypage/monthlyStats >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return null;

        return mypageService.getMonthlyStats(loginUser.getUserId());
    }
	
    // 내 정보 수정 (닉네임, 생년월일, 소개)
    @ResponseBody
    @RequestMapping(value = "/mypage/updateInfo", method = RequestMethod.POST)
    public int updateUserInfo(HttpServletRequest request, HttpSession session) {
        logger.info("<<< url => /mypage/updateInfo >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return -999;

        String nickname  = request.getParameter("nickname");
        String birthDate = request.getParameter("birthDate");
        String bio       = request.getParameter("bio");

        return mypageService.updateUserInfo(loginUser.getUserId(), nickname, birthDate, bio, session);
    }

    // 프로필 사진 수정(multipart/form-data)
    @ResponseBody
    @RequestMapping(value = "/mypage/updatePhoto", method = RequestMethod.POST)
    public int updatePhoto(@RequestParam("photoFile") MultipartFile file, HttpSession session) {
        logger.info("<<< url => /mypage/updatePhoto >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return -999;
																															
        return mypageService.updateProfilePhoto(loginUser.getUserId(), file, session);
    }

    // 비밀번호 변경 (1:성공  -1:현재비번틀림  -2:인증코드오류  0:실패  -999:비로그인)
    @ResponseBody
    @RequestMapping(value = "/mypage/updatePw", method = RequestMethod.POST)
    public int updatePw(HttpServletRequest request, HttpSession session) {
        logger.info("<<< url => /mypage/updatePw >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return -999;

        String currentPw = request.getParameter("currentPw");
        String code      = request.getParameter("code");
        String newPw     = request.getParameter("newPw");

        return mypageService.updatePw(loginUser.getUserId(), currentPw, code, newPw);
    }

    // 계정 탈퇴 — 성공 시 세션 무효화(1:성공  0:실패  -999:비로그인)
    @ResponseBody
    @RequestMapping(value = "/mypage/withdraw", method = RequestMethod.POST)
    public int withdraw(HttpSession session) {
        logger.info("<<< url => /mypage/withdraw >>>");

        UserDTO loginUser = getLoginUser(session);
																   
        return mypageService.deleteUser(loginUser.getUserId(), session);
    }

}
