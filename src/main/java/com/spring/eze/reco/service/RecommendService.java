package com.spring.eze.reco.service;

import com.spring.eze.music.dto.SongDTO;
import com.spring.eze.reco.dao.RecommendDAO;
import com.spring.eze.reco.dto.KeywordScoreDTO;
import com.spring.eze.reco.dto.SongCardDTO;
import com.spring.eze.reco.dto.SongDetailDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RecommendService {

    @Autowired
    private RecommendDAO dao;

    /**
     * 취향 기반 추천
     * */
    public List<SongCardDTO> getUserRecommend(int userId) {

        // 상위 키워드 5개 고르기 - 유저의 점수 포함
        List<KeywordScoreDTO> topKeywords = dao.selectTopKeywordsByUser(userId);
        if (topKeywords.isEmpty()) {   // 아무것도 재생한적 없으면 빈 리스트 반환
            return List.of();
        }
//        for (KeywordScoreDTO keyword : topKeywords) {
//            System.out.println(keyword);
//        }

        // 각 키워드의 점수를 이용해서 곡 상위 15개를 추리기
        List<Integer> recommendSongs = dao.selectSongsByKeywords(topKeywords, 15);
//        for (Integer songId : recommendSongs) {
//            System.out.println(songId);
//        }

        // 결과로 나온 song id로 화면에 뿌릴 정보 가져오기
        List<SongCardDTO> result = dao.getResultSongs(recommendSongs);
//        System.out.println("result : ");
//        for (SongCardDTO songCardDTO : result) {
//            System.out.println(songCardDTO);
//        }

        return result;
    }
    /**
     * 좋아할만한 인기 트랙
     * */
    public List<SongCardDTO> recommendPopularForUser(int userId) {
        // 상위 키워드 5개 고르기 - 유저의 점수 포함
        List<KeywordScoreDTO> topKeywords = dao.selectTopKeywordsByUser(userId);
        if (topKeywords.isEmpty()) {   // 아무것도 재생한적 없으면 빈 리스트 반환
            return List.of();
        }
        // 점수 무시하고 키워드만 가지고 곡의 총 점수 기준 인기 곡 가져오기
        List<Integer> recommendSongs = dao.selectPopularSongsByKeywords(topKeywords, 15);

        // 결과로 나온 song id로 화면에 뿌릴 정보 가져오기
        List<SongCardDTO> result = dao.getResultSongs(recommendSongs);

        return result;
    }

    /**
     * 좋아할만한 최신 곡
     * */
    public List<SongCardDTO> recommendLatestForUser(int userId) {
        // 상위 키워드 5개 고르기 - 유저의 점수 포함
        List<KeywordScoreDTO> topKeywords = dao.selectTopKeywordsByUser(userId);
        if (topKeywords.isEmpty()) {   // 아무것도 재생한적 없으면 빈 리스트 반환
            return List.of();
        }

        // 점수 무시하고 키워드만 가지고 최신곡 가져오기
        List<Integer> recommendSongs = dao.selectRecentSongsByTopKeywords(topKeywords, 15);

        // 결과로 나온 song id로 화면에 뿌릴 정보 가져오기
        List<SongCardDTO> result = dao.getResultSongs(recommendSongs);

        return result;
    }


    /**
     * 그냥 최신 곡
     * */




    public List<SongCardDTO> convertToSongCardDTO(List<SongDTO> list) {
        List<SongCardDTO> result = new ArrayList<>();
        for (SongDTO songDTO : list) {
            SongCardDTO songCardDTO = new SongCardDTO(
                    songDTO.getSongId(),
                    songDTO.getArtistName(),
                    songDTO.getTitle(),
                    songDTO.getCoverImageUrl()
            );
            result.add(songCardDTO);
        }
        return result;
    }

    public List<SongDetailDTO> getSongDetailListBySongId(List<Integer> songIds) {
        System.out.println("getSongDetailListBySongId");
        List<SongDetailDTO> result = dao.selectSongDetailsBySongIds(songIds);
        for (SongDetailDTO dto : result) {
            System.out.println(dto);
        }
        return result;
    }

}
