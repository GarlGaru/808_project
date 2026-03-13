package com.spring.eze.admin.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.eze.admin.dto.AdminMusicDTO;

@Repository
public class AdminArtistMapper {

    private final SqlSessionTemplate sqlSession;

    public AdminArtistMapper(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    private static final String NAMESPACE = "com.spring.eze.admin.dao.AdminArtistMapper.";

    public List<AdminMusicDTO> selectArtistList() {
        return sqlSession.selectList(NAMESPACE + "selectArtistList");
    }

    public void insertArtist(AdminMusicDTO dto) {
        sqlSession.insert(NAMESPACE + "insertArtist", dto);
    }
}