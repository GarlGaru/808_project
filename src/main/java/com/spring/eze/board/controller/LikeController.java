package com.spring.eze.board.controller;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.eze.board.dto.LikeDTO;
import com.spring.eze.board.service.LikeService;

@Controller
@RequestMapping("/like")
public class LikeController {

    private static final Logger log = LoggerFactory.getLogger(LikeController.class);

    @Autowired
    private LikeService likeService;
    

    @PostMapping("/selest")
    @ResponseBody
    public String insertLike(LikeDTO dto) {
        log.info("LikeController - 좋아요 토글 요청: bno={}, userId={}", dto.getBno(), dto.getUserId());
        
        try {
            // 1. 이미 좋아요를 눌렀는지 확인
            int likeCheck = likeService.checkLike(dto);
            
            if (likeCheck == 0) {
                // 2-1. 안 눌렀다면 좋아요 데이터 추가
                log.info("좋아요 추가 실행");
                likeService.insertLike(dto);
                return "inserted";
            } else {
                // 2-2. 이미 눌렀다면 좋아요 데이터 삭제
                log.info("좋아요 취소 실행");
                likeService.deleteLike(dto);
                return "deleted";
            }
        } catch (Exception e) {
            log.error("좋아요 처리 중 서버 오류 발생", e);
            return "error";
        }
    }

    /**
     * 좋아요 정보 조회
     * - 특정 게시글의 전체 좋아요 수와 현재 사용자의 좋아요 여부 반환
     */
    @RequestMapping("/getLikeInfo")
    @ResponseBody
    public Map<String, Object> getLikeInfo(LikeDTO dto) {
        log.info("LikeController - 좋아요 정보 조회: bno={}, userId={}", dto.getBno(), dto.getUserId());
        
        Map<String, Object> map = new HashMap<>();
        
        try {
            // 게시글 전체 좋아요 개수
            int count = likeService.getLikeCount(dto.getBno());
            // 현재 로그인 유저의 좋아요 여부 (1: 누름, 0: 안누름)
            int isLiked = likeService.checkLike(dto);
            
            map.put("count", count);
            map.put("isLiked", isLiked);
            map.put("status", "success");
            
        } catch (Exception e) {
            log.error("좋아요 정보 조회 중 오류 발생", e);
            map.put("status", "error");
            map.put("count", 0);
            map.put("isLiked", 0);
        }
        
        return map;
    }
}