package com.spring.eze.admin.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Service;

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
    
   
    
}