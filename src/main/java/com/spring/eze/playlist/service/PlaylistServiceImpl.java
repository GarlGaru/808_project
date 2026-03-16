package com.spring.eze.playlist.service;


import com.spring.eze.playlist.dao.PlaylistDAO;
import com.spring.eze.playlist.dto.PlaylistDTO;
import com.spring.eze.playlist.dto.PlaylistEleDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class PlaylistServiceImpl implements PlaylistService {

    @Autowired
    private PlaylistDAO dao;


    private static final String PLAYLIST_LIKE_TITLE = "_LIKE_";
    private static final String PLAYLIST_HISTORY_TITLE = "_HISTORY_";

    /**
     * 만든 플레이리스트 전부 가져오기
     * 좋아요, 히스토리 포함
     * */
    @Override
    public List<PlaylistDTO> getPlaylistAll(int userId) {

        List<PlaylistDTO> list = dao.getPlaylistAll(userId);
        if (list.size() < 2){    // 먼저 있는지 확인하고
            //없으면 생성
            PlaylistDTO like = new PlaylistDTO(-1 , userId, PLAYLIST_LIKE_TITLE, PlaylistType.LIKE);
            PlaylistDTO history = new PlaylistDTO(-1 , userId, PLAYLIST_HISTORY_TITLE, PlaylistType.HISTORY);
            dao.createPlaylist(like);
            dao.createPlaylist(history);
            list = dao.getPlaylistAll(userId);  // 갱신
        }
        return list;
    }

    /**
     * 플레이리스트 하나 만들기
     * */
    @Override
    public int createPlaylist(int userId, String title) {
        // 먼저 확인
        // 이미 있으면 에러 메세지 표시
        PlaylistDTO normal = new PlaylistDTO(-1, userId, title, PlaylistType.NORMAL);
        int isExist = dao.checkPlaylistExist(normal);
        if (isExist == 1) {
            dao.createPlaylist(normal);
            return 1;
        } else {
            return 0;
        }
    }


    /**
     * 플레이리스트 하나 가져오기
     * */
    @Override
    public List<PlaylistEleDTO> getPlaylist(int playListId) {
        System.out.println("PlaylistServiceImpl - getPlaylist");
        List<PlaylistEleDTO> dto = dao.getPlaylist(playListId);
        return dto;
    }

    @Override
    public PlaylistDTO getLikes(int userId) {
        System.out.println("PlaylistServiceImpl - getLikes");
        Map<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        map.put("listType", PlaylistType.LIKE);
        PlaylistDTO dto = dao.getUniquePlaylist(map);
        return dto;
    }

    @Override
    public PlaylistDTO getHistory(int userId) {
        System.out.println("PlaylistServiceImpl - getHistory");
        Map<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        map.put("listType", PlaylistType.HISTORY);
        PlaylistDTO dto = dao.getUniquePlaylist(map);
        return dto;
    }
}
