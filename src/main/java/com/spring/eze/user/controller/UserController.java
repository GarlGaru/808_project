package com.spring.eze.user.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.eze.user.service.UserServiceImpl;

@Controller
public class UserController {	

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserServiceImpl service;

    // 1. 로그인/회원가입 통합 모달창 호출
    @RequestMapping("/authModal")
    public String authModal() {
        logger.info("<<< url => /user/authModal >>>");
        // /WEB-INF/views/user/authModal.jsp 파일을 찾아감
        return "user/authModal";
    }

    // 2. 로그인 처리 (AJAX)
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    @ResponseBody // 페이지 이동 없이 결과값(int)만 브라우저로 전송
    public int login(HttpServletRequest request) throws ServletException, IOException {
        logger.info("<<< url => /user/login >>>");
        
        // 서비스에서 아이디/비번 확인 후 성공 시 세션에 유저 정보 저장
        return service.loginAction(request); 
    }

    // 3. 로그아웃 처리
    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        logger.info("<<< url => /user/logout >>>");
        
        // 세션에 저장된 모든 정보 삭제 (로그아웃 처리)
        session.invalidate();
        // 로그아웃 후 메인 페이지로 이동
        return "redirect:/main";
    }

    // 4. 회원가입 처리
    @RequestMapping(value = "/signup", method = RequestMethod.POST)
    @ResponseBody
    public int signup(HttpServletRequest request) throws ServletException, IOException {
        logger.info("<<< url => /user/signup >>>");
        
        // 사용자가 입력한 정보를 DB에 저장
        return service.insertUser(request);
    }

    // 5. 이메일 중복확인
    @RequestMapping(value = "/checkEmail", method = RequestMethod.GET)
    @ResponseBody
    public int checkEmail(HttpServletRequest request) throws ServletException, IOException {
        logger.info("<<< url => /user/checkEmail >>>");
        // 이메일 존재 여부를 숫자로 반환 (0: 없음, 1: 중복)
        return service.checkEmail(request);
    }

    // 6. 닉네임 중복확인
    @RequestMapping(value = "/checkNickname", method = RequestMethod.GET)
    @ResponseBody
    public int checkNickname(HttpServletRequest request) throws ServletException, IOException {
        logger.info("<<< url => /user/checkNickname >>>");
        // 닉네임 중복 여부 반환
        return service.checkNickname(request);
    }

    // 7. 이메일 인증 완료 처리
    @RequestMapping(value = "/verifyEmail", method = RequestMethod.POST)
    @ResponseBody
    public int verifyEmail(HttpServletRequest request) throws ServletException, IOException {
        logger.info("<<< url => /user/verifyEmail >>>");
        return service.updateEmailVerified(request);
    }

    // 8. 인증코드 저장 및 발송
    @RequestMapping(value = "/sendCode", method = RequestMethod.POST)
    @ResponseBody
    public String sendCode(HttpServletRequest request) throws ServletException, IOException {
        logger.info("<<< url => /user/sendCode >>>");  
        
        // 1. 서비스 실행 (DB 저장 및 세션에 코드 저장)
        service.insertEmailCode(request);
        
        // 2. 서비스 내부에서 저장한 세션 값을 꺼냄
        String generatedCode = (String) request.getSession().getAttribute("sentCode");
        
        // 3. 확인용 로그
        System.out.println(">>> 브라우저로 전송할 코드: " + generatedCode);
        
        // 4. 알럿창용으로 String으로 반환, 성공(1)이 아니라 실제 코드 리턴!
        return generatedCode; 
    }
    
    // 8-1. 인증코드 검증 처리 추가 혹은 기존 검증 대체
    @RequestMapping(value = "/checkCode", method = RequestMethod.POST)
    @ResponseBody
    public int checkCode(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        logger.info("<<< url => /checkCode >>>");
        
        // 서비스에서 DB의 코드와 사용자의 입력값을 비교함
        // 결과: 1(일치), 0(만료), -1(불일치)
        return service.verifyCode(request);
    }

    // 9. 비밀번호 재설정 실행
    @RequestMapping(value = "/updatePw", method = RequestMethod.POST)
    @ResponseBody
    public int updatePw(HttpServletRequest request) throws ServletException, IOException {
        logger.info("<<< url => /user/updatePw >>>");
        
        // 서비스에서 email과 password(나중에 해쉬처리)를 받아서 DB를 업데이트
        // 나중에 해쉬 암호화는 service.updatePw 내부에서 처리
        return service.updatePw(request);
    }
    
    
    // 10. 회원탈퇴
    @RequestMapping(value = "/deleteUser", method = RequestMethod.POST)
    @ResponseBody
    public int deleteUser(HttpServletRequest request) throws ServletException, IOException {
        logger.info("<<< url => /user/deleteUser >>>");
        return service.deleteUser(request);
    }
    

}