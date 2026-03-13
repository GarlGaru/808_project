package com.spring.eze.main.controller;
import com.spring.eze.main.service.MainService;
import java.io.IOException;
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
@RequestMapping("/main")
public class MainController {
	
	private static final Logger log = LoggerFactory.getLogger(MainController.class);

	@Autowired
    private MainService service;

	@RequestMapping("")
    public String main(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("Welecome");
        
		return "common/main";
    }

	@RequestMapping("/test")
    public String testDBConnection(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("testDBConnection");

        try {
            service.testDBconnection(request, response, model);
        }catch (Exception e){
            System.out.println("이 메세지를 보고 있다면 DB에 문제가 생긴겁니다");
            e.printStackTrace();
        }
		return "home";
    }

	@RequestMapping("/board")
    public String board(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("board");
        
		return "common/board";
    }
	

}
