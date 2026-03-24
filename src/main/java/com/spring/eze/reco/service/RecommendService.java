package com.spring.eze.reco.service;

import com.spring.eze.music.dto.SongDTO;
import com.spring.eze.reco.dao.RecommendDAO;
import com.spring.eze.reco.dto.KeywordScoreDTO;
import com.spring.eze.reco.dto.SongCardDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RecommendService {

    @Autowired
    private RecommendDAO dao;

    public List<SongCardDTO> getUserRecommend(int userId) {
        List<KeywordScoreDTO> topKeywords = dao.selectTopKeywords(userId);
        if (topKeywords.isEmpty()) {   // 아무것도 재생한적 없으면
            return List.of();
        }

        List<Integer> recommendSongs = dao.selectRecommendedSongs(userId, topKeywords, 15);

        return dao.getResultSongs(recommendSongs);
    }

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

}
