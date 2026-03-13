package com.spring.eze.admin.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.eze.admin.dto.AdminMusicDTO;

@Repository
public class AdminMetaMapper {

    private final SqlSessionTemplate sqlSession;

    public AdminMetaMapper(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    private static final String NAMESPACE = "com.spring.eze.admin.dao.AdminMetaMapper.";
    
    public List<AdminMusicDTO> selectArtistList() {
        return sqlSession.selectList(NAMESPACE + "selectArtistList");
    }

    public void insertArtist(AdminMusicDTO dto) {
        sqlSession.insert(NAMESPACE + "insertArtist", dto);
    }

    public List<AdminMusicDTO> selectAlbumList() {
        return sqlSession.selectList(NAMESPACE + "selectAlbumList");
    }

    public void insertAlbum(AdminMusicDTO dto) {
        sqlSession.insert(NAMESPACE + "insertAlbum", dto);
    }

    public List<AdminMusicDTO> selectGenreList() {
        return sqlSession.selectList(NAMESPACE + "selectGenreList");
    }

    public void insertGenre(AdminMusicDTO dto) {
        sqlSession.insert(NAMESPACE + "insertGenre", dto);
    }
}