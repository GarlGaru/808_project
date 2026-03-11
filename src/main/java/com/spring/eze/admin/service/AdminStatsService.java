package com.spring.eze.admin.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.eze.admin.dto.AdminMusicDTO;
import com.spring.eze.admin.dto.AdminPaymentOrderDTO;
import com.spring.eze.admin.dto.AdminUserDTO;
import com.spring.eze.admin.dto.DailyCountDTO;

@Service
public class AdminStatsService {

    private final SqlSessionTemplate sqlSession;
    
    public AdminStatsService(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    public List<AdminUserDTO> selectUserList() {
        return sqlSession.selectList("com.spring.eze.admin.dao.AdminStatsDAO.selectUserList");
    }
    
    public List<DailyCountDTO> signupLast5() {
        return sqlSession.selectList("com.spring.eze.admin.dao.AdminStatsDAO.selectSignupLast5");
    }

    public List<DailyCountDTO> payLast5() {
        return sqlSession.selectList("com.spring.eze.admin.dao.AdminStatsDAO.selectPayLast5");
    }
    
    public List<DailyCountDTO> payStatus() {
        return sqlSession.selectList("com.spring.eze.admin.dao.AdminStatsDAO.selectPayStatus");
    }
    
    public List<AdminPaymentOrderDTO> selectPayList() {
        return sqlSession.selectList("com.spring.eze.admin.dao.AdminStatsDAO.selectPayList");
    }
    
    public List<AdminMusicDTO> selectMusicList() {
        return sqlSession.selectList("com.spring.eze.admin.dao.AdminMusicMapper.selectMusicList");
    }
    
    // @Transactional = 여러 DB 작업을 하나로 묶는 안전장치
    // 4개중 하나라도 실패하면 전부취소
    // 작동방식 
    // 전부 성공 → COMMIT
    // 하나라도 실패 → ROLLBACK
    @Transactional
    public void insertMusicAll(AdminMusicDTO dto) {

        sqlSession.insert("com.spring.eze.admin.dao.AdminMusicMapper.insertArtist", dto);

        sqlSession.insert("com.spring.eze.admin.dao.AdminMusicMapper.insertAlbum", dto);

        sqlSession.insert("com.spring.eze.admin.dao.AdminMusicMapper.insertGenre", dto);

        sqlSession.insert("com.spring.eze.admin.dao.AdminMusicMapper.insertSong", dto);

    }

    
   
    
}