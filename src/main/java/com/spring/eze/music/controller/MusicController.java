package com.spring.eze.music.controller;

import com.spring.eze.music.service.MusicService;
import com.spring.eze.user.dto.UserDTO;
import com.spring.eze.music.dto.SongDTO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/music")
public class MusicController {

    private static final Logger log = LoggerFactory.getLogger(MusicController.class);

    @Autowired
    private MusicService musicService;

    // 음악 메인
    @GetMapping({ "", "/" })
    public String musicMain(HttpServletRequest request, HttpServletResponse response, Model model) {

        log.info("MusicController - musicMain() 호출");

        List<SongDTO> weeklyRanking = musicService.getweeklyRanking();
        List<SongDTO> todayHitSongs = musicService.getTodayHitSongs();
        List<SongDTO> genreRanking = musicService.getGenreRanking(1); // 기본 장르 1

        model.addAttribute("weeklyRanking", weeklyRanking);
        model.addAttribute("todayHitSongs", todayHitSongs);
        model.addAttribute("genreRanking", genreRanking);

        // 필요하면 유지
        model.addAttribute("songList", weeklyRanking);

        return "music/music";
    }

    @RequestMapping("/recommend")
    public String recommend(HttpServletRequest request, HttpServletResponse response, Model model) {
        log.info("<<< url => /recommend >>>");
        return "/music/recommend";
    }

    // 랭킹 페이지 통합
    @RequestMapping("/ranking")
    public String ranking(HttpServletRequest request, HttpServletResponse response, Model model) {

        List<SongDTO> weeklyRanking = musicService.getweeklyRanking();
        List<SongDTO> todayHitSongs = musicService.getTodayHitSongs();
        List<SongDTO> genreRanking = musicService.getGenreRanking(1); // 기본 장르 1

        model.addAttribute("weeklyRanking", weeklyRanking);
        model.addAttribute("todayHitSongs", todayHitSongs);
        model.addAttribute("genreRanking", genreRanking);

        // 기존 JSP가 songList만 보고 있다면 호환용으로 같이 넣기
        model.addAttribute("songList", todayHitSongs);

        log.info("<<< url => /ranking >>>");
        return "/music/ranking";
    }

    // 재생 시작 점수
    @GetMapping("/playScore")
    @ResponseBody
    public String recordPlayScore(@RequestParam int songId, HttpSession session) {

        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        
        log.info("playScore 호출됨 - songId={}", songId);
        log.info("session loginUser={}", loginUser);
        
        if (loginUser == null) {
        	log.info("로그인 안 된 상태라 점수 저장 안 함");
            return "noLogin";
        }

        int userId = loginUser.getUserId();
        log.info("점수 저장 시작 - userId={}, songId={}", userId, songId);
        
        musicService.addPlayScore(songId, userId);
        log.info("점수 저장 완료");
        return "success";
    }

    // 일정 시간 이상 재생 점수
    @GetMapping("/intervalScore")
    @ResponseBody
    public String recordIntervalScore(@RequestParam int songId, HttpSession session) {

        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            return "noLogin";
        }

        int userId = loginUser.getUserId();
        musicService.addIntervalScore(songId, userId);

        return "success";
    }

    // 좋아요 점수
    @GetMapping("/likeScore")
    @ResponseBody
    public String recordLikeScore(@RequestParam int songId, HttpSession session) {

        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            return "noLogin";
        }

        int userId = loginUser.getUserId();
        musicService.addLikeScore(songId, userId);

        return "success";
    }
    //곡상세 페이지
    @GetMapping("/detail")
    public String songDetail(@RequestParam("songId") int songId, Model model) {

        SongDTO song = musicService.getSongDetail(songId);
        model.addAttribute("song", song);

        Map<String, Object> param = new HashMap<>();
        param.put("songId", songId);
        param.put("genreId", song.getGenreId());

        List<SongDTO> similarList = musicService.getSimilarSongs(param);
        model.addAttribute("similarList", similarList);

        return "music/detail";
    }
    //노래연결
    @ResponseBody
    @GetMapping("/songPath")
    public String getSongPath(@RequestParam("songId") int songId) {
        return musicService.getSongPath(songId);
    }
}