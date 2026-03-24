package com.spring.eze.reco.service;

import com.spring.eze.reco.dao.RecoDAOImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RecommendService {

    @Autowired
    private RecoDAOImpl recoDAO;

}
