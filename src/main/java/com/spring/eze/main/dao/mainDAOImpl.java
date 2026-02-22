package com.spring.eze.main.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class mainDAOImpl implements mainDAO{


    @Autowired
    private SqlSession sqlSession;

    @Override
    public void testDBConnection() {

    }
}
