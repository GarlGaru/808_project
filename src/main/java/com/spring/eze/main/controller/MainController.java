package com.spring.eze.main.controller;
import com.spring.eze.main.service.MainService;

import java.io.IOException;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {
	
	private static final Logger log = LoggerFactory.getLogger(MainController.class);

	@Autowired
    private MainService service;

	@RequestMapping("/main")
    public String main(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("Welecome");

        
		return "common/main";
    }

	@RequestMapping({"/main/test","/test", "", "*.java"})
    public String testDBConnection(
    		Locale locale, HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("testDBConnection");
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );

        try {
            service.testDBconnection(request, response, model);
        }catch (Exception e){
            e.printStackTrace();
            System.out.println("이 메세지를 보고 있다면 DB에 문제가 생긴겁니다");
            System.out.println("Message : \n" + e.getMessage());
        }
		return "home";
    }


}
