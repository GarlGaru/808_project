package com.spring.eze.reco.controller;

import com.spring.eze.common.LoginSessionHandler;
import com.spring.eze.music.dto.SongDTO;
import com.spring.eze.music.service.MusicService;
import com.spring.eze.playlist.dto.PlaylistDTO;
import com.spring.eze.reco.service.RecommendService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
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


    @GetMapping("/music/weekly-ranking")
    public @ResponseBody List<SongDTO> weekly(){

        List<SongDTO> list = musicService.getweeklyRanking();

        return list;
    }

    @GetMapping("/music/today-hits")
    public @ResponseBody List<SongDTO> today(){

        List<SongDTO> list = musicService.getTodayHitSongs();

        return list;
    }

    @GetMapping("/music/genre-ranking")
    public @ResponseBody List<SongDTO> genre(){

        List<SongDTO> list = musicService.getGenreRanking(1); // 기본 장르 1

        return list;
    }

    @GetMapping("/music/test")
    public @ResponseBody List<SongDTO> test(){

        List<SongDTO> list = new ArrayList<>();

        return list;
    }



}
