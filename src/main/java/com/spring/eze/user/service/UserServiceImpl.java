package com.spring.eze.user.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.eze.user.dto.UserDTO;
import com.spring.eze.user.dao.UserDAO;
import com.spring.eze.user.dto.EmailCodeDTO;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDAO dao;

    // 백엔드 검증용 정규식 — JS와 동일한 기준 유지
    private static final String EMAIL_PATTERN    = "^[A-Za-z0-9+_.-]+@(.+)$";
    private static final String NICKNAME_PATTERN = "^[가-힣a-zA-Z0-9]{2,10}$";

    // ── 공통: 파라미터 null 체크 + trim ──
    // null이면 null 반환, 아니면 trim한 값 반환 (빈문자열은 그대로 통과 — 각 메서드에서 처리)
    private String getParam(HttpServletRequest request, String key) {
        String val = request.getParameter(key);
        return val == null ? null : val.trim();
    }

    // 1. 회원가입
    @Override
    public int insertUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email    = getParam(request, "email");
            String password = getParam(request, "password");
            String nickname = getParam(request, "nickname");

            // 빈값/공백 체크 (getParam이 null 반환)
            if (email == null || password == null || nickname == null) {
                System.out.println(">>> [회원가입 실패] 필수 파라미터 누락 또는 공백");
                return -100;
            }

            if (!Pattern.matches(EMAIL_PATTERN, email))    return -1; // 이메일 형식 오류
            if (!Pattern.matches(NICKNAME_PATTERN, nickname)) return -2; // 닉네임 형식 오류
            if (password.length() < 8)                     return -3; // 비밀번호 길이 부족

            UserDTO dto = new UserDTO();
            dto.setEmail(email);
            dto.setPassword(password);
            dto.setNickname(nickname);

            int insertCnt = dao.insertUser(dto);
            System.out.println(">>> [회원가입 완료] 이메일: " + email);
            return insertCnt;

        } catch (Exception e) {
            System.err.println(">>> [회원가입 에러 발생]");
            e.printStackTrace();
            return -999;
        }
    }

    // 2. 이메일 중복확인
    @Override
    public int checkEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = getParam(request, "email");
        if (email == null) return 0; // 빈값은 중복 없음(사용 가능)으로 처리 — 실제 발송 단계에서 차단됨
        return dao.checkEmail(email);
    }

    // 3. 닉네임 중복확인
    @Override
    public int checkNickname(HttpServletRequest request, HttpServletResponse response) {
        try {
            String nickname = getParam(request, "nickname");

            // null 또는 빈값·공백만 입력 시 → 사용 불가로 응답
            if (nickname == null || nickname.isEmpty()) {
                System.out.println(">>> [닉네임 체크] 빈값 또는 공백 입력");
                return 1;
            }

            // 형식 검증 (2~10자 한글/영문/숫자) — 공백 포함 시 패턴 불일치로 차단
            if (!Pattern.matches(NICKNAME_PATTERN, nickname)) {
                System.out.println(">>> [닉네임 체크] 형식 오류: " + nickname);
                return 1;
            }

            System.out.println(">>> [닉네임 체크] 조회: " + nickname);
            return dao.checkNickname(nickname);

        } catch (Exception e) {
            System.err.println(">>> 닉네임 체크 중 오류 발생: " + e.getMessage());
            return 1; // 에러 시 안전하게 사용 불가 응답
        }
    }

    // 4. 로그인
    @Override
    public int loginAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email    = getParam(request, "email");
            String password = request.getParameter("password"); // 비밀번호는 trim 하지 않음 (공백 포함 가능)

            if (email == null || password == null || password.isEmpty()) return 0;

            UserDTO loginUser = dao.getUserByEmail(email);
            if (loginUser == null)                              return 0; // 이메일 없음
            
            String dbPw = loginUser.getPassword();
            if (dbPw == null || !dbPw.equals(password))        return 0; // 비밀번호 불일치
            if (loginUser.getEmailVerified() != 1)             return 2; // 이메일 미인증

            HttpSession session = request.getSession();
            session.setAttribute("loginUser", loginUser);
            session.setAttribute("userEmail", email);

            System.out.println(">>> [로그인 성공] " + email);
            return 1;

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // 5. 이메일 인증 완료 처리
    @Override
    public int updateEmailVerified(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = getParam(request, "email");
        if (email == null) return 0;
        return dao.updateEmailVerified(email);
    }

    // 6. 비밀번호 수정
    @Override
    public int updatePw(HttpServletRequest request, HttpServletResponse response) {
        String email    = getParam(request, "email");
        String password = request.getParameter("password"); // 비밀번호는 trim 하지 않음

        if (email == null || password == null || password.isEmpty()) {
            System.out.println(">>> [비밀번호 수정 실패] 빈값 입력");
            return 0;
        }

        System.out.println(">>> 비밀번호 수정 대상: " + email);

        Map<String, Object> map = new HashMap<>();
        map.put("email", email);
        map.put("password", password);
        return dao.updatePw(map);
    }

    // 7. 회원탈퇴
    @Override
    public int deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = (String) request.getSession().getAttribute("userEmail");
        int deleteCnt = dao.deleteUser(email);
        if (deleteCnt == 1) request.getSession().invalidate();
        return deleteCnt;
    }

    // 8. 인증코드 생성 및 DB 저장
    @Override
    public int insertEmailCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = getParam(request, "email");
        if (email == null) return 0; // 빈값·공백 차단

        // 형식 검증 — 공백 포함 이메일이 넘어오는 경우 차단
        if (!Pattern.matches(EMAIL_PATTERN, email)) {
            System.out.println(">>> [인증코드 발송 실패] 이메일 형식 오류: " + email);
            return 0;
        }

        int randomCode = (int)(Math.random() * 899999) + 100000;
        String codeStr = String.valueOf(randomCode);

        EmailCodeDTO dto = new EmailCodeDTO();
        dto.setEmail(email);
        dto.setCode(codeStr);

        int result = dao.insertEmailCode(dto);
        if (result == 1) {
            request.getSession().setAttribute("sentCode", codeStr);
            System.out.println(">>> [발급완료] 이메일: " + email + " / 인증코드: " + codeStr);
        }
        return result;
    }

    // 9. 인증코드 조회
    @Override
    public EmailCodeDTO getEmailCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = getParam(request, "email");
        if (email == null) return null;
        return dao.getEmailCode(email);
    }

    // 10. 인증코드 검증
    @Override
    public int verifyCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email     = getParam(request, "email");
        String inputCode = getParam(request, "code");

        if (email == null || inputCode == null) return 0;

        EmailCodeDTO dbRecord = dao.getEmailCode(email);

        if (dbRecord == null)                        return 0;  // 없거나 만료
        if (dbRecord.getCode().equals(inputCode))    return 1;  // 일치
        return -1;                                              // 불일치
    }
}
