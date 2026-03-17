package com.spring.eze.reco.controller;

import com.spring.eze.common.LoginSessionHandler;
import com.spring.eze.reco.service.RecommendService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

@Controller
public class RecommendController {
    
    private static final Logger log = LoggerFactory.getLogger(RecommendController.class);
    
    @Autowired
    private LoginSessionHandler lsh;

    @Autowired
    private RecommendService service;

    
    

}
