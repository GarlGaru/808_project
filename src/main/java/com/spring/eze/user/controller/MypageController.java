package com.spring.eze.user.controller;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.eze.user.dto.UserDTO;
import com.spring.eze.user.dto.MypageBoardDTO;
import com.spring.eze.user.dto.MypageCommentDTO;
import com.spring.eze.user.dto.MypageReservationDTO;
import com.spring.eze.user.dto.MypagePaymentDTO;
import com.spring.eze.user.dto.MypageMonthlyStatDTO;
import com.spring.eze.user.dto.MypagePlayReportDTO;
import com.spring.eze.user.service.MypageService;

@Controller
public class MypageController {

    private static final Logger logger = LoggerFactory.getLogger(MypageController.class);

    // MypageService 인터페이스 타입으로 주입
    // 실제 동작은 MypageServiceImpl이 하지만 인터페이스로 받는 게 올바른 방식
    @Autowired
    private MypageService mypageService;

    // ── 공통 헬퍼 ──────────────────────────────────
    // 매 메서드마다 세션에서 loginUser 꺼내는 코드가 반복되므로
    // private 메서드로 분리해서 중복 제거
    private UserDTO getLoginUser(HttpSession session) {
        return (UserDTO) session.getAttribute("loginUser");
    }

    // ── 내가 쓴 글 ─────────────────────────────────
    // @ResponseBody → return값을 JSP로 보내지 않고 JSON으로 직접 브라우저에 전송
    // HttpServletRequest → JS에서 넘긴 파라미터(page)를 꺼내기 위해 필요
    // HttpSession → 세션에서 로그인 유저 확인용
    @ResponseBody
    @RequestMapping(value = "/mypage/boards", method = RequestMethod.GET)
    public List<MypageBoardDTO> getMyBoards(HttpServletRequest request, HttpSession session) {
        logger.info("<<< url => /mypage/boards >>>");

        UserDTO loginUser = getLoginUser(session);
        // 세션 없으면 null 반환 → JS에서 null 체크 후 로그인 페이지로 이동
        if (loginUser == null) return null;

        // JS에서 넘긴 page 파라미터 꺼내기
        // ex) $.ajax({ data: { page: 2 } }) → "2" 라는 String으로 넘어옴
        // Integer.parseInt로 int 변환, null이면 기본값 1
        String pageStr = request.getParameter("page");
        int page = (pageStr != null) ? Integer.parseInt(pageStr) : 1;

        // userId와 page만 Service에 넘김
        // Service는 HttpServletRequest를 몰라도 됨 — 계층 분리
        return mypageService.getMyBoardList(loginUser.getUserId(), page);
    }

    // ── 내가 쓴 댓글 ───────────────────────────────
    @ResponseBody
    @RequestMapping(value = "/mypage/comments", method = RequestMethod.GET)
    public List<MypageCommentDTO> getMyComments(HttpServletRequest request, HttpSession session) {
        logger.info("<<< url => /mypage/comments >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return null;

        String pageStr = request.getParameter("page");
        int page = (pageStr != null) ? Integer.parseInt(pageStr) : 1;

        return mypageService.getMyCommentList(loginUser.getUserId(), page);
    }

    // ── 예매 내역 ──────────────────────────────────
    // page 파라미터 없으므로 HttpServletRequest 불필요
    // HttpSession만 받아서 loginUser 꺼내면 됨
    @ResponseBody
    @RequestMapping(value = "/mypage/reservations", method = RequestMethod.GET)
    public List<MypageReservationDTO> getMyReservations(HttpSession session) {
        logger.info("<<< url => /mypage/reservations >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return null;

        return mypageService.getMyReservationList(loginUser.getUserId());
    }

    // ── 결제 내역 ──────────────────────────────────
    @ResponseBody
    @RequestMapping(value = "/mypage/payments", method = RequestMethod.GET)
    public List<MypagePaymentDTO> getMyPayments(HttpSession session) {
        logger.info("<<< url => /mypage/payments >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return null;

        return mypageService.getMyPaymentList(loginUser.getUserId());
    }

    // ── 월별 지출 합계 ─────────────────────────────
    @ResponseBody
    @RequestMapping(value = "/mypage/monthlyStats", method = RequestMethod.GET)
    public List<MypageMonthlyStatDTO> getMonthlyStats(HttpSession session) {
        logger.info("<<< url => /mypage/monthlyStats >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return null;

        return mypageService.getMonthlyStats(loginUser.getUserId());
    }

    // ── 808 플레이 리포트 ──────────────────────────
    @ResponseBody
    @RequestMapping(value = "/mypage/playReport", method = RequestMethod.GET)
    public MypagePlayReportDTO getPlayReport(HttpSession session) {
        logger.info("<<< url => /mypage/playReport >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return null;

        return mypageService.getPlayReport(loginUser.getUserId());
    }

    // ── 내 정보 수정 ───────────────────────────────
    // JS에서 nickname, birthDate, bio 3개 파라미터를 POST로 넘김
    // HttpServletRequest로 파라미터 꺼내서 각각 Service에 전달
    // HttpSession은 수정 후 세션 갱신용으로 Service에 넘김
    @ResponseBody
    @RequestMapping(value = "/mypage/updateInfo", method = RequestMethod.POST)
    public int updateUserInfo(HttpServletRequest request, HttpSession session) {
        logger.info("<<< url => /mypage/updateInfo >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return -999;

        // JS FormData or data:{} 로 넘어온 파라미터 꺼내기
        String nickname  = request.getParameter("nickname");
        String birthDate = request.getParameter("birthDate");
        String bio       = request.getParameter("bio");

        // Service에 userId + 각 파라미터 + 세션 넘김
        // 세션을 넘기는 이유 — 수정 후 loginUser 세션 갱신을 Service에서 처리
        return mypageService.updateUserInfo(loginUser.getUserId(), nickname, birthDate, bio, session);
    }

    // ── 프로필 사진 수정 ───────────────────────────
    // multipart/form-data 방식 — 파일 업로드
    // @RequestParam("photoFile") → JS FormData.append("photoFile", file)과 키 이름 일치해야 함
    // MultipartFile → Spring이 업로드된 파일을 객체로 변환해서 넘겨줌
    @ResponseBody
    @RequestMapping(value = "/mypage/updatePhoto", method = RequestMethod.POST)
    public int updatePhoto(
            @RequestParam("photoFile") MultipartFile file,
            HttpSession session) {
        logger.info("<<< url => /mypage/updatePhoto >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return -999;

        try {
            // 저장 경로 — 로컬 서버 고정 경로
            String uploadPath = "C:/808_upload/profile/";
            File dir = new File(uploadPath);
            // 폴더 없으면 자동 생성
            if (!dir.exists()) dir.mkdirs();

            // 파일명 — userId 기반으로 고정 (같은 유저가 재업로드하면 덮어쓰기)
            // ex) user_1.jpg
            String originalName = file.getOriginalFilename();
            String ext      = originalName.substring(originalName.lastIndexOf("."));
            String fileName = "user_" + loginUser.getUserId() + ext;

            // 실제 파일 저장
            file.transferTo(new File(uploadPath + fileName));

            // DB에 저장할 URL 경로 — 웹에서 접근 가능한 경로
            String photoUrl = "/upload/profile/" + fileName;

            // Service에 userId + photoUrl + 세션 넘김
            // 파일 저장은 Controller에서, DB저장+세션갱신은 Service에서
            return mypageService.updatePhotoUrl(loginUser.getUserId(), photoUrl, session);

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    // ── 계정 탈퇴 ──────────────────────────────────
    // 탈퇴 후 세션 무효화는 Service에서 처리
    // JS에서 result === 1 확인 후 메인으로 redirect
    @ResponseBody
    @RequestMapping(value = "/mypage/withdraw", method = RequestMethod.POST)
    public int withdraw(HttpSession session) {
        logger.info("<<< url => /mypage/withdraw >>>");

        UserDTO loginUser = getLoginUser(session);
        if (loginUser == null) return -999;

        // 세션을 넘기는 이유 — 탈퇴 성공 시 Service에서 session.invalidate() 처리
        return mypageService.deleteUser(loginUser.getUserId(), session);
    }
}