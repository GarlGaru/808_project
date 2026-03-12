package com.spring.eze.playlist.dao;


import com.spring.eze.playlist.dto.PlaylistDTO;
import com.spring.eze.playlist.dto.PlaylistEleDTO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class PlaylistDAOImpl implements PlaylistDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;


    @Override
    public List<PlaylistEleDTO> getPlaylist(int playListId) {
        System.out.println("PlaylistDAOImpl - getPlayList");

        PlaylistDAO dao = sqlSession.getMapper(PlaylistDAO.class);
        List<PlaylistEleDTO> dto = dao.getPlaylist(playListId);
        return dto;
    }

    @Override
    public List<PlaylistDTO> getPlaylistAll(int userId) {
        System.out.println("PlaylistDAOImpl - getPlaylistAll");

        PlaylistDAO dao = sqlSession.getMapper(PlaylistDAO.class);
        List<PlaylistDTO> dto = dao.getPlaylistAll(userId);
        return dto;
    }


}
