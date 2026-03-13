package com.spring.eze.playlist.service;


import com.spring.eze.playlist.dao.PlaylistDAO;
import com.spring.eze.playlist.dto.PlaylistDTO;
import com.spring.eze.playlist.dto.PlaylistEleDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class PlaylistServiceImpl implements PlaylistService {

    @Autowired
    private PlaylistDAO dao;


    private static final String PLAYLIST_LIKE_STR = "_LIKE_";
    private static final String PLAYLIST_HISTORY_STR = "_HISTORY_";

    /**
     * 만든 플레이리스트 전부 가져오기
     * 좋아요, 히스토리 포함
     * */
    @Override
    public List<PlaylistDTO> getPlaylistAll(int userId) {

        List<PlaylistDTO> dto = dao.getPlaylistAll(userId);
        if (dto.size() < 2){    // 먼저 있는지 확인하고
            //없으면 생성 (insert ignore)

        }


        return dto;
    }
    private void initUserPlaylist (int userId, String title){

    }


    /**
     * 플레이리스트 하나 가져오기
     * */
    @Override
    public List<PlaylistEleDTO> getPlaylist(int playListId) {
        System.out.println("PlaylistServiceImpl - getPlaylist");
        // 먼저 있는지 확인하고

        // 그 다음 play element list를 받아와야 함
        List<PlaylistEleDTO> dto = dao.getPlaylist(playListId);


        return dto;
    }

    @Override
    public PlaylistDTO getLikes(int playListId) {
        System.out.println("PlaylistServiceImpl - getLikes");
        return null;
    }

    @Override
    public PlaylistDTO getHistory(int playListId) {
        System.out.println("PlaylistServiceImpl - getHistory");
        return null;
    }
}
