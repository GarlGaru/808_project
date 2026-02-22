package com.spring.eze.main.controller;

import com.spring.eze.main.service.mainService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.Mapping;

@Controller
public class mainController {

    @Autowired
    private mainService service;

    public void testDBConnection(){

        try {
            service.testDBconnection();
        }catch (Exception e){
            System.out.println("이 메세지를 보고 있다면 DB에 문제가 생긴겁니다");
            e.printStackTrace();
        }
    }

}
