package com.spring.eze.main.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MainDAOImpl implements MainDAO{


    @Autowired
    private SqlSession sqlSession;

    @Override
    public void testDBConnection() {

    }
}
