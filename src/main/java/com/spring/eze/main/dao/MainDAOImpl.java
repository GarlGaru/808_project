package com.spring.eze.main.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.eze.main.dto.TestDTO;

@Repository
public class MainDAOImpl implements MainDAO{


    @Autowired
    private SqlSession sqlSession;

    @Override
    public TestDTO testDBConnection() {
    	System.out.println("MainDAOImpl");
    	MainDAO dao = sqlSession.getMapper(MainDAO.class);
    	TestDTO dto = dao.testDBConnection();
    	return dto;
    }
}
