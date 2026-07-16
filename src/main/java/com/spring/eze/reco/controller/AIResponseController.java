package com.spring.eze.reco.controller;

import com.spring.eze.common.LoginSessionHandler;
import com.spring.eze.reco.dto.AiResponseDTO;
import com.spring.eze.reco.dto.SongDetailDTO;
import com.spring.eze.reco.service.AiRecommendService;
import com.spring.eze.reco.service.RecommendService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

import static com.spring.eze.common.LoginSessionHandler.SESSION_ERROR;

@Controller
@RequestMapping("/api")
public class AIResponseController {
    private static final Logger log = LoggerFactory.getLogger(AIResponseController.class);

    @Autowired
    private LoginSessionHandler lsh;

    @Autowired
    private RecommendService recommendService;

    @Autowired
    private AiRecommendService aiRecommendService;

    @PostMapping("/songs/details")
    @ResponseBody
    public List<SongDetailDTO> songDetails(@RequestBody List<Integer> songIds) {
        System.out.println("AIResponseController - songDetails");
        return recommendService.getSongDetailListBySongId(songIds);
    }


    //RestTemplate 사용
    @PostMapping("/chat/ask")
    @ResponseBody
    public AiResponseDTO askToChatBot(@RequestBody String message, HttpServletRequest request) {
        log.info("AIResponseController askToChatBot");
        log.info("User Ask : {}", message);
        int userId = lsh.getUserIdFromSession(request);
        if (userId == SESSION_ERROR) {
            return new AiResponseDTO("로그인 한 뒤에 이용해주세요!", List.of());
        }

        return aiRecommendService.askToChatBot(userId, message);
    }
}
