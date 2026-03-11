package com.spring.eze.music.controller;

import com.spring.eze.music.service.MusicService;
import com.spring.eze.music.dto.SongDTO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/music")
public class MusicController {
    
    private static final Logger log = LoggerFactory.getLogger(MusicController.class);

    @Autowired
    private MusicService musicService;   // 🔹 MainService 대신 MusicService 사용

    /**
     * /music 또는 /music/ 로 들어왔을 때
     * 메인 음악 리스트 페이지로 이동
     */
    @GetMapping({"", "/"})
    public String musicMain(HttpServletRequest request,
                            HttpServletResponse response,
                            Model model) {

        log.info("MusicController - musicMain() 호출");

        // 1) DB에서 곡 리스트 가져오기
        List<SongDTO> songList = musicService.getSongList();

        // 2) JSP에서 사용할 모델에 담기
        model.addAttribute("songList", songList);

        // 3) /WEB-INF/.../music/music.jsp 로 이동 (뷰리졸버 규칙에 따라)
        return "music/music";   // 기존과 동일한 뷰 이름 유지
    }

    /**
     * (옵션) /music/list 로도 접근 가능하게 하고 싶으면 이 메소드 추가해도 됨
     */
    @GetMapping("/list")
    public String musicList(Model model) {

        log.info("MusicController - musicList() 호출");

        List<SongDTO> songList = musicService.getSongList();
        model.addAttribute("songList", songList);

        return "music/music";
    }
    @GetMapping("/detail")
    public String songDetail(@RequestParam("songId") int songId, Model model) {

        // 1) 현재 곡 정보 가져오기
        SongDTO song = musicService.getSongDetail(songId);
        model.addAttribute("song", song);

        // 2) 유사곡 조회를 위한 파라미터(장르 + 현재 곡 id)
        //    SongDTO 안에 genreId 필드가 있다고 가정
        Map<String, Object> param = new HashMap<>();
        param.put("songId", songId);
        param.put("genreId", song.getGenreId());

        // 3) 같은 장르 + 자기 자신 제외한 유사곡 리스트
        List<SongDTO> similarList = musicService.getSimilarSongs(param);
        model.addAttribute("similarList", similarList);
        
        System.out.println("songId = " + songId);
        System.out.println("genreId = " + song.getGenreId());
        System.out.println("similarList size = " + similarList.size());
        // 4) 상세 페이지로 이동
        return "music/detail";
    }
	 @RequestMapping("/recommend")
	 public String recommend(HttpServletRequest request,
	                            HttpServletResponse response,
	                            Model model) {
		
		 log.info("<<< url => /recommend >>>");
		 return "/music/recommend";
	 }
	 
	 @RequestMapping("/ranking")
	 public String ranking(HttpServletRequest request,
	                            HttpServletResponse response,
	                            Model model) {
		 log.info("<<< url => /ranking >>>");
		 return "/music/ranking";
	 }
	 
 
}