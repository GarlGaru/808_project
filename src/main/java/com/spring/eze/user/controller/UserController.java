package com.spring.eze.user.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

    // 1. 인증 모달창으로 이동 
    @RequestMapping("/authModal")
    public String loginPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        logger.info("<<< url => /authModal >>>");
        return "user/authModal";
    }

    // 2. 로그인 처리 (모달창에서 보낸 Ajax 요청을 처리함)
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    @ResponseBody // AJAX 응답을 위해 결과값만 리턴
    public int login(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        logger.info("<<< url => /login >>>");
        
        // 서비스에서 파라미터(email, password) 추출 및 세션 저장 로직 수행
        // getUserByEmail 로직을 서비스 내부에서 호출하여 처리함
        int result = service.loginAction(request, response);
        
        return result; 
    }

    // 3. 로그아웃
    @RequestMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        logger.info("<<< url => /logout >>>");
        
        // 세션 종료
        request.getSession().invalidate();
        return "redirect:/main";
    }

    // 4. 회원가입 처리
    @RequestMapping(value = "/signup", method = RequestMethod.POST)
    @ResponseBody
    public int signup(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        logger.info("<<< url => /signup >>>");
        
        // 서비스 내부에서 정규식 검증 및 DAO 호출
        return service.insertUser(request, response);
    }

    // 5. 이메일 중복확인
    @RequestMapping(value = "/checkEmail", method = RequestMethod.GET)
    @ResponseBody
    public int checkEmail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        logger.info("<<< url => /checkEmail >>>");
        
        return service.checkEmail(request, response);
    }

    // 6. 닉네임 중복확인
    @RequestMapping(value = "/checkNickname", method = RequestMethod.GET)
    @ResponseBody
    public int checkNickname(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        logger.info("<<< url => /checkNickname >>>");
        
        return service.checkNickname(request, response);
    }

    // 7. 이메일 인증 완료 처리
    @RequestMapping(value = "/verifyEmail", method = RequestMethod.POST)
    @ResponseBody
    public int verifyEmail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        logger.info("<<< url => /verifyEmail >>>");
        
        return service.updateEmailVerified(request, response);
    }

    // 8. 인증코드 저장 및 발송
    @RequestMapping(value = "/sendCode", method = RequestMethod.POST)
    @ResponseBody
    public String sendCode(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        logger.info("<<< url => /sendCode >>>");
        
        // 1. 서비스 실행 (DB 저장 및 세션에 코드 저장)
        service.insertEmailCode(request, response);
        
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
        return service.verifyCode(request, response);
    }

    // 9. 비밀번호 재설정 실행
    @RequestMapping(value = "/updatePw", method = RequestMethod.POST)
    @ResponseBody
    public int updatePw(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        logger.info("<<< url => /updatePw >>>");
        
        // 서비스에서 email과 password(나중에 해쉬처리)를 받아서 DB를 업데이트
        // 나중에 해쉬 암호화는 service.updatePw 내부에서 처리
        return service.updatePw(request, response); 
    }
    
    
    // 10. 회원탈퇴
    @RequestMapping(value = "/deleteUser", method = RequestMethod.POST)
    @ResponseBody
    public int deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        logger.info("<<< url => /deleteUser >>>");
        
        return service.deleteUser(request, response);
    }
    
 // 11. 마이페이지
    @RequestMapping(value = "/mypage", method = RequestMethod.GET)
    public String mypage(HttpServletRequest request) 
            throws ServletException, IOException {

        logger.info("<<< url => /mypage >>>");

        // mypage.jsp (또는 mypage.html)로 이동
        return "user/mypage";
    }


}