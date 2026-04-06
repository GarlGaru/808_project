package com.spring.eze.reco.controller;

import com.spring.eze.common.LoginSessionHandler;
import com.spring.eze.music.service.MusicService;
import com.spring.eze.reco.dto.SongCardDTO;
import com.spring.eze.reco.service.RecommendService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

import static com.spring.eze.common.LoginSessionHandler.SESSION_ERROR;

@Controller
public class RecommendController {
    
    private static final Logger log = LoggerFactory.getLogger(RecommendController.class);
    
    @Autowired
    private LoginSessionHandler lsh;

    @Autowired
    private RecommendService service;

    @Autowired
    private MusicService musicService;

    /**
     * 취향 기반 추천
     * */
    @ResponseBody
    @GetMapping("/music/personal-recommend")
    public List<SongCardDTO> recommendForUser(HttpServletRequest request) {
        log.info("Reco Controller : recommendForUser");
        int userId = lsh.getUserIdFromSession(request);
        if (userId == SESSION_ERROR) {  // 로그인 안했으면 빈 리스트
            return List.of();
        }

        return service.getUserRecommend(userId);
    }


    /**
     * 좋아할만한 인기 트랙
     * */
    @ResponseBody
    @GetMapping("/music/personal-recommend-popular")
    public List<SongCardDTO> recommendPopularForUser(HttpServletRequest request) {
        log.info("Reco Controller : recommendPopularForUser");
        int userId = lsh.getUserIdFromSession(request);
        if (userId == SESSION_ERROR) {  // 로그인 안했으면 주간 랭킹
            return service.convertToSongCardDTO(musicService.getweeklyRanking());
        }

        return service.recommendPopularForUser(userId);
    }


    /**
     * 좋아할만한 최신 곡
     * */
    @ResponseBody
    @GetMapping("/music/personal-recommend-latest")
    public List<SongCardDTO> recommendLatestForUser(HttpServletRequest request) {
        log.info("Reco Controller : recommendLatestForUser");
        int userId = lsh.getUserIdFromSession(request);
        if (userId == SESSION_ERROR) {  // 로그인 안했으면 그냥 최신곡
            return List.of();
        }

        return service.recommendLatestForUser(userId);
    }


    @GetMapping("/music/chat")
    public String chatPage(HttpServletRequest request) {
        log.info("Reco Controller : chatPage");

        return "music/chat";
    }
}
