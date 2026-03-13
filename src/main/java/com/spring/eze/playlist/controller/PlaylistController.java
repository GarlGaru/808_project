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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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

    @Autowired
    private PlaylistServiceImpl service;

    @GetMapping({"", "/"})
    public String test(HttpServletRequest request, HttpServletResponse response, Model model) {
        log.info("PlaylistController - test");
        return "";
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

        UserDTO userDTO = (UserDTO) request.getSession().getAttribute("loginUser");
        if (userDTO == null) {
            return new ArrayList<>();
        }
        int userId = userDTO.getUserId();
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
    public @ResponseBody PlaylistDTO getLikes(@RequestParam int playListId){
        log.info("PlaylistController - getLikes");
        PlaylistDTO dto = service.getLikes(playListId);

        return dto;
    }

    /**
     * 히스토리 리스트 가져오기
     * */
    @GetMapping("/history")
    public @ResponseBody PlaylistDTO getHistory(@RequestParam int playListId){
        log.info("PlaylistController - getHistory");
        PlaylistDTO dto = service.getHistory(playListId);

        return dto;
    }

}
