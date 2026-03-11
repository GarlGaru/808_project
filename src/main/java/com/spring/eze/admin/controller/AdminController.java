package com.spring.eze.admin.controller;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.eze.admin.dto.AdminMusicDTO;
import com.spring.eze.admin.dto.AdminPaymentOrderDTO;
import com.spring.eze.admin.dto.AdminUserDTO;
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
    	System.out.println(service.selectPayList().size());
    	
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
    public String usertables(Model model) {
    	List<AdminUserDTO> list = service.selectUserList();
    	
    	model.addAttribute("userList", list);
    	System.out.println("userList size = " + list.size());
    	
        return "/admin2/usertables";
    }
    
    @GetMapping("/pay")
    public String paytables(Model model) {
        model.addAttribute("payList", service.selectPayList());
        return "/admin2/paytables";
    }
    
    @GetMapping("/board")
    public String boardtables() {
        return "/admin2/boardtables";
    }
    
    //어드민 음악 셀렉트
    @GetMapping("/music")
    public String musicttables(Model model) {
    	
    	List<AdminMusicDTO> list = service.selectMusicList();
    	
    	System.out.println("adminmusic size = " +list.size());
    	
    	model.addAttribute("musicList", list);
    	
        return "/admin2/musictables";
    }
    
    //어드민 음악 인서트
    @GetMapping("/music/write")
    public String musicWriteForm() {
    	
    	return "admin2/musicwrite";
    }
    
    //어드민 음악 및 mp3 추가
    @PostMapping("/music/write")
    public String iunsertMusicAll(AdminMusicDTO dto,
    		@RequestParam(value = "artistImageFile", required = false) MultipartFile artistImageFile,
    		@RequestParam(value = "albumImageFile", required = false) MultipartFile albumImageFile,
    		@RequestParam(value = "songFile", required = false) MultipartFile songFile,
    		HttpServletRequest request,
    		Model model
    	)throws Exception {
    	
    	//데이터 확인용
    	 System.out.println("컨트롤러 들어옴");
    	 System.out.println("artistImageFile = " + (artistImageFile == null ? "null" : artistImageFile.getOriginalFilename()));
    	 System.out.println("albumImageFile = " + (albumImageFile == null ? "null" : albumImageFile.getOriginalFilename()));
    	 System.out.println("songFile = " + (songFile == null ? "null" : songFile.getOriginalFilename()));
    	    
    	
    	//이미지 절대경로
    	String uploadPath =
    	        request.getSession()
    	               .getServletContext()
    	               .getRealPath("/resources/music/");
    	System.out.println("uploadPath : " + uploadPath);
    	
    	// System.currentTimeMillis()
    	// 1970년 1월 1일 이후 현재까지 흐른 시간을 "밀리초(ms)" 단위 숫자로 반환
    	// 파일명 앞에 붙여서 업로드 파일 이름 중복을 방지
    	long time = System.currentTimeMillis();
    	
    	
    	// 아티스트 이미지 저장
    	if(!artistImageFile.isEmpty()) {
    		
    		 // 사용자가 업로드한 파일의 원래 파일명을 가져옴
    		 String originalName = artistImageFile.getOriginalFilename();
    		 
    		 // 파일명에 공백이 있으면 URL 문제 방지를 위해 "_" 로 치환
    		 originalName = originalName.replaceAll(" ", "_");

    	        if (!isImageFile(originalName)) {
    	        	model.addAttribute
    	        	("msg","아티스트 이미지는 jpg, jpeg, png, gif, webp 파일만 가능합니다.");
    	        	return "admin2/musicwrite";
    	        }
    	        
    		//참고사이트
    		//https://developer-talk.tistory.com/811
    		//파일가져오기 
    		String fileName = time + "_" + originalName;
    		
    		 
    		File saveFile = new File(uploadPath + "img/" + fileName);
    		artistImageFile.transferTo(saveFile);
    		
    		dto.setProfileImageUrl("/resources/music/img/" + fileName);
    	}
    	
    	// 앨범 이미지 저장
    	if(!albumImageFile.isEmpty()) {
    		
    		String originalName = albumImageFile.getOriginalFilename();
    		
    		originalName = originalName.replaceAll(" ", "_");
    		
    		if (!isImageFile(originalName)) {
                model.addAttribute
                ("msg","이미지 파일(jpg,png,gif)만 업로드 가능합니다.");
                return "admin2/musicwrite";
            }
    		
    		// 중복 방지를 위해 시간 + 원본파일명으로 새 파일명 생성
    		String fileName = time + "_" + originalName;
    		
    		
    		
    		File saveFile = new File(uploadPath + "img/" + fileName);
    		albumImageFile.transferTo(saveFile);
    		
    		dto.setCoverImageUrl("/resources/music/img/" + fileName);
    	}
    	
    	// mp3 파일 저장
    	if(!songFile.isEmpty()) {
    		
    		 String originalName = songFile.getOriginalFilename();
    		
    		 originalName = originalName.replaceAll(" ", "_");
    		 
    		 if (!isMp3File(originalName)) {
    	            model.addAttribute
    	            ("msg","mp3 파일만 업로드 가능합니다.");
    	            return "admin2/musicwrite";
    	        }
    		 
    		//mp3 파일 저장
    		String fileName = time + "_" + originalName;
    		
    		
    		File saveFile = new File(uploadPath + "mp3/" + fileName);
    		songFile.transferTo(saveFile);
    		
    		dto.setSongPath("/resources/music/mp3/" + fileName);
    	}
    	
    	service.insertMusicAll(dto);
    	
    	model.addAttribute("msg","...");
    	return "redirect:/admin/music";
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
    
    //========= 앨범, mp3 체크용코드=========
    private boolean isImageFile(String fileName){
    	if(fileName == null ) return false;
    		
    	String lower = fileName.toLowerCase();
    	return lower.endsWith(".jpg")
    		|| lower.endsWith(".jpeg")
    		|| lower.endsWith(".png")
    		|| lower.endsWith(".gif")
    		|| lower.endsWith(".webp");
    }
    
    private boolean isMp3File(String fileName) {
    	if(fileName == null) return false;
    	
    	String lower = fileName.toLowerCase();
    	return lower.endsWith(".mp3");
    }
    
}