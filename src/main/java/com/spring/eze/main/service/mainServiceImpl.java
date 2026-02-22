package com.spring.eze.main.service;

import com.spring.eze.main.dao.mainDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class mainServiceImpl implements mainService {

    @Autowired
    private mainDAO dao;

    @Override
    public void testDBconnection() {
        dao.testDBConnection();
    }
}
