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
public class MypageController {	

    private static final Logger logger = LoggerFactory.getLogger(MypageController.class);

 // 1. 마이페이지 모달
    @RequestMapping(value = "/mypageModal", method = RequestMethod.GET)
    public String mypage(HttpServletRequest request) 
            throws ServletException, IOException {
        logger.info("<<< url => /mypageModal >>>");
        
        // mypage.jsp (또는 mypage.html)로 이동
        return "user/mypageModal";
    }

}