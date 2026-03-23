package com.spring.eze.playlist.controller;

import com.spring.eze.common.LoginSessionHandler;
import com.spring.eze.playlist.dto.PlaylistDTO;
import com.spring.eze.playlist.dto.PlaylistEleDTO;
import com.spring.eze.playlist.service.PlaylistServiceImpl;
import com.spring.eze.user.dto.UserDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

import static com.spring.eze.common.LoginSessionHandler.SESSION_ERROR;

/**
 * Playlist는 하나의 단어로 취급합니다.
 * 그러므로 카멜케이스(대문자)에 주의 해주세요.
 * Play + List 면 PlayList 로 쓰겠지만 하나의 단어이므로 Playlist 입니다.
 * */
@Controller
public class PlaylistController {

    private static final Logger log = LoggerFactory.getLogger(PlaylistController.class);
    @Autowired
    private LoginSessionHandler lsh;

    @Autowired
    private PlaylistServiceImpl service;



    /**
     * url = /playlist/all <br>
     * 유저의 플레이리스트 전부 가져오기 <br>
     * 좋아요, 히스토리 포함<br>
     * 플레이리스트 내용은 '/playlist' 사용
     * @return id, title
     * */
    @GetMapping("/playlist/all")
    public @ResponseBody List<PlaylistDTO> getPlaylistAll(HttpServletRequest request){
        log.info("PlaylistController - getPlaylistAll");

        int userId = lsh.getUserIdFromSession(request);
        if (userId == SESSION_ERROR) {
            return new ArrayList<>();
        }
        List<PlaylistDTO> list = service.getPlaylistAll(userId);
        return list;
    }

    /**
     * url = /playlist?playListId=
     * 플레이리스트 하나 가져오기
     * @param playlistId 유저의 플레이리스트 ID
     * */
    @GetMapping("/playlist")
    public @ResponseBody List<PlaylistEleDTO> getPlaylist(@RequestParam int playlistId){
        log.info("PlaylistController - getPlaylist");
        log.info("Requested Playlist ID : {}", playlistId);
        List<PlaylistEleDTO> dto = service.getPlaylist(playlistId);
        log.info("Response Size : {}", dto.size());

        return dto;
    }

    /**
     * 좋아요 리스트 가져오기
     * */
    @GetMapping("/like")
    public @ResponseBody PlaylistDTO getLikes(HttpServletRequest request){
        log.info("PlaylistController - getLikes");

        int userId = lsh.getUserIdFromSession(request);
        if (userId == SESSION_ERROR) {
            return null;
        }

        return service.getLikes(userId);
    }

    /**
     * 히스토리 리스트 가져오기
     * */
    @GetMapping("/history")
    public @ResponseBody PlaylistDTO getHistory(HttpServletRequest request){
        log.info("PlaylistController - getHistory");

        int userId = lsh.getUserIdFromSession(request);
        if (userId == SESSION_ERROR) {
            return null;
        }

        return service.getHistory(userId);
    }

    @PostMapping("/playlist/create")
    public @ResponseBody int createPlaylist(
            HttpServletRequest request , @RequestBody String title){
        log.info("PlaylistController - createPlaylist");

        int userId = lsh.getUserIdFromSession(request);
        if (userId == SESSION_ERROR) {
            return 0;
        }

        return service.createPlaylist(userId, title);
    }

}
