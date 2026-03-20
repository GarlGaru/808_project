package com.spring.eze.admin.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.eze.admin.dto.AdminMusicDTO;

@Repository
public class AdminMusicDAO {

    private final SqlSessionTemplate sqlSession;

    public AdminMusicDAO(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    private static final String NAMESPACE = "com.spring.eze.admin.dao.AdminMusicDAO.";

    public List<AdminMusicDTO> selectMusicList() {
        return sqlSession.selectList(NAMESPACE + "selectMusicList");
    }

    public void insertSong(AdminMusicDTO dto) {
        sqlSession.insert(NAMESPACE + "insertSong", dto);
    }

    public int selectLastSongId() {
        return sqlSession.selectOne(NAMESPACE + "selectLastSongId");
    }

    public void insertSongGenre(AdminMusicDTO dto) {
        sqlSession.insert(NAMESPACE + "insertSongGenre", dto);
    }
}