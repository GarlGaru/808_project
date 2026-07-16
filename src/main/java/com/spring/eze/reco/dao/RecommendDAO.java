package com.spring.eze.reco.dao;

import com.spring.eze.reco.dto.KeywordScoreDTO;
import com.spring.eze.reco.dto.SongCardDTO;
import com.spring.eze.reco.dto.SongDetailDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface RecommendDAO {

    /** 상위 키워드 5개 고르기 - 유저의 점수 포함 */
    List<KeywordScoreDTO> selectTopKeywordsByUser(
            @Param("userId") int userId);

    /** 각 키워드의 점수를 이용해서 곡 상위 {amount}개를 추리기 */
    List<Integer> selectSongsByKeywords(
            @Param("topKeywords") List<KeywordScoreDTO> topKeywords,
            @Param("amount") int amount);

    /** 점수 무시하고 키워드만 가지고 곡의 총 점수 기준 인기 곡 가져오기 */
    List<Integer> selectPopularSongsByKeywords(
            @Param("topKeywords") List<KeywordScoreDTO> topKeywords,
            @Param("amount") int amount);

    /** 점수 무시하고 키워드만 가지고 최신곡 가져오기 */
    List<Integer> selectRecentSongsByTopKeywords(
            @Param("topKeywords") List<KeywordScoreDTO> topKeywords,
            @Param("amount") int amount);



    /** 결과로 나온 song id로 화면에 뿌릴 정보 가져오기 */
    List<SongCardDTO> getResultSongs(
            @Param("songIds") List<Integer> songIds);


    // SongDetailDTO selectSongDetail(@Param("songId") Integer songId);

    List<SongDetailDTO> selectSongDetailsBySongIds(@Param("songIds") List<Integer> songIds);

}
