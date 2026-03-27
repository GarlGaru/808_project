package com.spring.eze.reco.dao;

import com.spring.eze.reco.dto.KeywordScoreDTO;
import com.spring.eze.reco.dto.SongCardDTO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

public interface RecommendDAO {

    // 상위 키워드 5개 고르기
    List<KeywordScoreDTO> selectTopKeywords(int userId);


//    List<Integer> getWholeScoreRanking();
//
//    List<Integer> getRecentSongs();


    // 상위 n개를 추리기
    List<Integer> selectRecommendedSongs(
            @Param("userId") int userId,
            @Param("topKeywords") List<KeywordScoreDTO> topKeywords,
            @Param("amount") int amount
    );

    // 결과 가져오기
    List<SongCardDTO> getResultSongs(List<Integer> songIds);
}
