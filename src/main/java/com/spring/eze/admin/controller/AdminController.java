package com.spring.eze.admin.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.eze.admin.dto.DailyCountDTO;
import com.spring.eze.admin.service.AdminStatsService;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	private final AdminStatsService service;

	public AdminController(AdminStatsService service) {
	        this.service = service;
	}

    // 대시보드
    @GetMapping({"", "/"})
    public String index() {
        return "/admin2/index";
    }

    // 컴포넌트
    @GetMapping("/buttons")
    public String buttons() {
        return "/admin2/buttons";
    }

    @GetMapping("/cards")
    public String cards() {
        return "/admin2/cards";
    }

    // 유틸
    @GetMapping("/utilities-color")
    public String utilitiesColor() {
        return "/admin2/utilities-color";
    }

    @GetMapping("/utilities-border")
    public String utilitiesBorder() {
        return "/admin2/utilities-border";
    }

    @GetMapping("/utilities-animation")
    public String utilitiesAnimation() {
        return "/admin2/utilities-animation";
    }

    @GetMapping("/utilities-other")
    public String utilitiesOther() {
        return "/admin2/utilities-other";
    }

    // 페이지
    @GetMapping("/login")
    public String login() {
        return "/admin2/login";
    }

    @GetMapping("/register")
    public String register() {
        return "/admin2/register";
    }

    @GetMapping("/forgot-password")
    public String forgotPassword() {
        return "/admin2/forgot-password";
    }

    @GetMapping("/404")
    public String page404() {
        return "/admin2/404";
    }

    @GetMapping("/blank")
    public String blank() {
        return "/admin2/blank";
    }

    // 애드온
    @GetMapping("/charts")
    public String charts() {
        return "/admin2/charts";
    }

    @GetMapping("/user")
    public String usertables() {
        return "/admin2/usertables";
    }
    
    @GetMapping("/pay")
    public String paytables() {
        return "/admin2/paytables";
    }
    
    @GetMapping("/board")
    public String boardtables() {
        return "/admin2/boardtables";
    }
    
    @GetMapping("/music")
    public String musicttables() {
        return "/admin2/musictables";
    }
    
    //디비연결해서 데이터리스트로가져올거임
    
    // 최근 5일 가입
    @GetMapping("/api/stats/signupLast5")
    @ResponseBody
    public List<DailyCountDTO> signupLast5() {
        return service.signupLast5();
    }

    // 최근 5일 결제 승인
    @GetMapping("/api/stats/payLast5")
    @ResponseBody
    public List<DailyCountDTO> payLast5() {
        return service.payLast5();
    }

    // 결제 상태별 건수 (파이차트용)
    @GetMapping("/api/stats/payStatus")
    @ResponseBody
    public List<DailyCountDTO> payStatus() {
        return service.payStatus();
    }
    
    
}