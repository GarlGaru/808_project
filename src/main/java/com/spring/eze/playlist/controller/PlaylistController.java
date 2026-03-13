package com.spring.eze.playlist.controller;

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

/**
 * Playlist는 하나의 단어로 취급합니다.
 * 그러므로 카멜케이스(대문자)에 주의 해주세요.
 * Play + List 면 PlayList 로 쓰겠지만 하나의 단어이므로 Playlist 입니다.
 * */
@Controller
public class PlaylistController {

    private static final Logger log = LoggerFactory.getLogger(PlaylistController.class);

    private static final int SESSION_ERROR = -1;

    @Autowired
    private PlaylistServiceImpl service;


//    @GetMapping({"", "/"})
//    public String test(HttpServletRequest request, HttpServletResponse response, Model model) {
//        log.info("PlaylistController - test");
//        return "";
//    }

    /**
     * 로그인이 되어있는지 판정
     * @return 성공시 : userId, 실패시 : SESSION_ERROR
     * */
    private int getUserIdFromSession(HttpServletRequest request){
        UserDTO userDTO = null;
        try{
            userDTO = (UserDTO) request.getSession().getAttribute("loginUser");
        }catch (Exception e){
            log.error(e.toString());
            return SESSION_ERROR;
        }
        if (userDTO == null) {
            return SESSION_ERROR;
        }

        return userDTO.getUserId();
    }

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

        int userId = this.getUserIdFromSession(request);
        if (userId == SESSION_ERROR) {
            return new ArrayList<>();
        }
        List<PlaylistDTO> list = service.getPlaylistAll(userId);
        return list;
    }

    /**
     * url = /playlist?playListId=
     * 플레이리스트 하나 가져오기
     * @param playListId 유저의 플레이리스트 ID
     * */
    @GetMapping("/playlist")
    public @ResponseBody List<PlaylistEleDTO> getPlaylist(@RequestParam int playListId){
        log.info("PlaylistController - getPlaylist");
        log.info("Requested Playlist ID : {}", playListId);
        List<PlaylistEleDTO> dto = service.getPlaylist(playListId);
        log.info("Response Size : {}", dto.size());

        return dto;
    }

    /**
     * 좋아요 리스트 가져오기
     * */
    @GetMapping("/like")
    public @ResponseBody PlaylistDTO getLikes(HttpServletRequest request){
        log.info("PlaylistController - getLikes");

        int userId = this.getUserIdFromSession(request);
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

        int userId = this.getUserIdFromSession(request);
        if (userId == SESSION_ERROR) {
            return null;
        }

        return service.getHistory(userId);
    }

    @PostMapping("/playlist/create")
    public @ResponseBody int createPlaylist(
            HttpServletRequest request , @RequestBody String title){
        log.info("PlaylistController - createPlaylist");

        int userId = this.getUserIdFromSession(request);
        if (userId == SESSION_ERROR) {
            return 0;
        }

        return service.createPlaylist(userId, title);
    }

}
