package com.spring.eze.main.service;

import com.spring.eze.main.dao.MainDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MainServiceImpl implements MainService {

    @Autowired
    private MainDAO dao;

    @Override
    public void testDBconnection() {
        dao.testDBConnection();
    }
}
