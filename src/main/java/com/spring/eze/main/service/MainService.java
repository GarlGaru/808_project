package com.spring.eze.main.service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface MainService {
	public void testDBconnection(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
}
