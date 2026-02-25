package com.spring.eze.music.controller;


import com.spring.eze.main.service.MainService;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/music")
public class MusicController {
	
	private static final Logger log = LoggerFactory.getLogger(MusicController.class);

	@Autowired
    private MainService service;

	@RequestMapping("")
    public String music(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		log.info("MusicController - main화면");

		return "music/music";
    }

}
