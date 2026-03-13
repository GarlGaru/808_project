package com.spring.eze.admin.controller;

import java.io.File;
import java.util.List;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

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
import com.spring.eze.admin.service.AdminMusicService;
import com.spring.eze.admin.service.AdminStatsService;

@Controller
@RequestMapping("/admin")
public class AdminController {

	private final AdminStatsService service;
	private final AdminMusicService musicService;
	
	public AdminController(AdminStatsService service, AdminMusicService musicService) {
	        this.service = service;
	        this.musicService = musicService;
	}

    // 대시보드
    @GetMapping({"", "/"})
    public String index() {
    	//System.out.println(service.selectPayList().size());
    	System.out.println("admin index 들어옴");
    	
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
        
        List<AdminMusicDTO> list = musicService.selectMusicList();
        
        System.out.println("adminmusic size = " + list.size());
        
        model.addAttribute("musicList", list);
        
        return "/admin2/musictables";
    }
    
    //어드민 음악 인서트
    @GetMapping("/music/write")
    public String musicWriteForm(Model model) {

        model.addAttribute("artistList", musicService.selectArtistList());
        model.addAttribute("albumList", musicService.selectAlbumList());
        model.addAttribute("genreList", musicService.selectGenreList());

        return "/admin2/musicwrite";
    }
    
    @PostMapping("/music/write")
    public String insertSong(AdminMusicDTO dto,
            @RequestParam(value = "songFile", required = false) MultipartFile songFile,
            HttpServletRequest request,
            Model model) throws Exception {

        System.out.println("노래 등록 컨트롤러 들어옴");
        System.out.println("songFile name = " + (songFile == null ? "null" : songFile.getOriginalFilename()));
        System.out.println("songFile empty = " + (songFile == null ? "null" : songFile.isEmpty()));

        String uploadPath =
                request.getSession()
                       .getServletContext()
                       .getRealPath("/resources/music/");

        System.out.println("uploadPath = " + uploadPath);

        long time = System.currentTimeMillis();

        if (songFile != null && !songFile.isEmpty()) {

            String originalName = songFile.getOriginalFilename();
            originalName = originalName.replaceAll(" ", "_");

            if (!isMp3File(originalName)) {
                model.addAttribute("msg", "mp3 파일만 업로드 가능합니다.");
                model.addAttribute("artistList", musicService.selectArtistList());
                model.addAttribute("albumList", musicService.selectAlbumList());
                model.addAttribute("genreList", musicService.selectGenreList());
                return "/admin2/musicwrite";
            }

            File dir = new File(uploadPath + "mp3/");
            if (!dir.exists()) {
                dir.mkdirs();
            }

            System.out.println("dir = " + dir.getAbsolutePath());
            System.out.println("dir exists = " + dir.exists());

            String fileName = time + "_" + originalName;
            File saveFile = new File(dir, fileName);

            System.out.println("saveFile = " + saveFile.getAbsolutePath());

            songFile.transferTo(saveFile);

            System.out.println("save done = " + saveFile.exists());

            dto.setSongPath("/resources/music/mp3/" + fileName);
        }

        musicService.insertSong(dto);

        return "redirect:/admin/music";
    }
    
//    //어드민 아티스트 조회
    @GetMapping("/music/admin_artist")
    public String adminartist(Model model) {

        List<AdminMusicDTO> artistList = musicService.selectArtistList();
        model.addAttribute("artistList", artistList);

        return "/admin2/admin_artist";
    }
    // 어드민 저장
    @PostMapping("/music/admin_artist")
    public String insertArtist(AdminMusicDTO dto,
            @RequestParam(value = "artistImageFile", required = false) MultipartFile artistImageFile,
            HttpServletRequest request,
            Model model) throws Exception {

        System.out.println("아티스트 등록 컨트롤러 들어옴");
        System.out.println("artistImageFile = " + (artistImageFile == null ? "null" : artistImageFile.getOriginalFilename()));

        String uploadPath =
                request.getSession()
                       .getServletContext()
                       .getRealPath("/resources/music/");

        System.out.println("uploadPath : " + uploadPath);

        long time = System.currentTimeMillis();

        if (artistImageFile != null && !artistImageFile.isEmpty()) {

            String originalName = artistImageFile.getOriginalFilename();
            originalName = originalName.replaceAll(" ", "_");

            if (!isImageFile(originalName)) {
                model.addAttribute("msg", "아티스트 이미지는 jpg, jpeg, png, gif, webp 파일만 가능합니다.");
                model.addAttribute("artistList", musicService.selectArtistList());
                return "/admin2/admin_artist";
            }

            File dir = new File(uploadPath + "img/");
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String fileName = time + "_" + originalName;

            File saveFile = new File(dir, fileName);
            artistImageFile.transferTo(saveFile);

            dto.setProfileImageUrl("/resources/music/img/" + fileName);
        }

        musicService.insertArtist(dto);

        model.addAttribute("msg", "아티스트 등록 완료");
        model.addAttribute("artistList", musicService.selectArtistList());

        return "/admin2/admin_artist";
    }
    
    // 앨범 조회
    @GetMapping("/music/admin_album")
    public String adminalbum(Model model) {

        List<AdminMusicDTO> artistList = musicService.selectArtistList();
        List<AdminMusicDTO> albumList = musicService.selectAlbumList();

        model.addAttribute("artistList", artistList);
        model.addAttribute("albumList", albumList);

        return "/admin2/admin_album";
    }

    // 앨범 저장
    @PostMapping("/music/admin_album")
    public String insertAlbum(AdminMusicDTO dto,
            @RequestParam(value = "albumImageFile", required = false) MultipartFile albumImageFile,
            HttpServletRequest request,
            Model model) throws Exception {

        System.out.println("앨범 등록 컨트롤러 들어옴");
        System.out.println("albumImageFile = " + (albumImageFile == null ? "null" : albumImageFile.getOriginalFilename()));

        String uploadPath =
                request.getSession()
                       .getServletContext()
                       .getRealPath("/resources/music/");

        System.out.println("uploadPath : " + uploadPath);

        long time = System.currentTimeMillis();

        if (albumImageFile != null && !albumImageFile.isEmpty()) {

            String originalName = albumImageFile.getOriginalFilename();
            originalName = originalName.replaceAll(" ", "_");

            if (!isImageFile(originalName)) {
                model.addAttribute("msg", "앨범 이미지는 jpg, jpeg, png, gif, webp 파일만 가능합니다.");
                model.addAttribute("artistList", musicService.selectArtistList());
                model.addAttribute("albumList", musicService.selectAlbumList());
                return "/admin2/admin_album";
            }

            File dir = new File(uploadPath + "img/");
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String fileName = time + "_" + originalName;

            File saveFile = new File(dir, fileName);
            albumImageFile.transferTo(saveFile);

            dto.setCoverImageUrl("/resources/music/img/" + fileName);
        }

        musicService.insertAlbum(dto);

        model.addAttribute("msg", "앨범 등록 완료");
        model.addAttribute("artistList", musicService.selectArtistList());
        model.addAttribute("albumList", musicService.selectAlbumList());

        return "/admin2/admin_album";
    }
    
    // 장르 조회
    @GetMapping("/music/admin_genre")
    public String admingenre(Model model) {

        List<AdminMusicDTO> genreList = musicService.selectGenreList();
        model.addAttribute("genreList", genreList);

        return "/admin2/admin_genre";
    }

    // 장르 저장
    @PostMapping("/music/admin_genre")
    public String insertGenre(AdminMusicDTO dto, Model model) {

        musicService.insertGenre(dto);

        model.addAttribute("msg", "장르 등록 완료");
        model.addAttribute("genreList", musicService.selectGenreList());

        return "/admin2/admin_genre";
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