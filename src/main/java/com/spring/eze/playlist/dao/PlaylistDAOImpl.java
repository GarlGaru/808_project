package com.spring.eze.playlist.dao;


import com.spring.eze.playlist.dto.PlaylistDTO;
import com.spring.eze.playlist.dto.PlaylistEleDTO;
import com.spring.eze.playlist.service.PlaylistType;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class PlaylistDAOImpl implements PlaylistDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;



    /**
     * 플레이리스트 하나 가져오기
     * */
    @Override
    public List<PlaylistEleDTO> getPlaylist(int playListId) {
        System.out.println("PlaylistDAOImpl - getPlayList");

        PlaylistDAO dao = sqlSession.getMapper(PlaylistDAO.class);
        List<PlaylistEleDTO> dto = dao.getPlaylist(playListId);
        return dto;
    }

    /**
     * 만든 플레이리스트 전부 가져오기
     * */
    @Override
    public List<PlaylistDTO> getPlaylistAll(int userId) {
        System.out.println("PlaylistDAOImpl - getPlaylistAll");

        PlaylistDAO dao = sqlSession.getMapper(PlaylistDAO.class);
        List<PlaylistDTO> dto = dao.getPlaylistAll(userId);
        return dto;
    }

    /**
     * 플레이리스트 하나 만들기
     * */
    @Override
    public void createPlaylist(PlaylistDTO dto) {
        System.out.println("PlaylistDAOImpl - createPlaylist");
        PlaylistDAO dao = sqlSession.getMapper(PlaylistDAO.class);
        dao.createPlaylist(dto);
    }

    /**
     * 플레이 리스트 검색
     * */
    @Override
    public int checkPlaylistExist(PlaylistDTO dto) {
        System.out.println("PlaylistDAOImpl - checkPlaylistExist");
        PlaylistDAO dao = sqlSession.getMapper(PlaylistDAO.class);
        return dao.checkPlaylistExist(dto);
    }

    @Override
    public PlaylistDTO getUniquePlaylist(Map<String, Object> map) {
        System.out.println("PlaylistDAOImpl - getUniquePlaylist");

        PlaylistDAO dao = sqlSession.getMapper(PlaylistDAO.class);
        PlaylistDTO dto = dao.getUniquePlaylist(map);
        return dto;
    }


}
