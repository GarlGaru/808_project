package com.spring.eze.show.service.review;

import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;



public interface ReviewService {
	
	//  후기 목록 가져오기 
	public void reviewListAction(HttpServletRequest request, HttpServletResponse response, Model model)
					throws ServletException, IOException;
	
    // 전체 후기 개수 가져오기 
    public int getTotalReviewCount(HttpServletRequest request, HttpServletResponse response, Model model);
    	
	//후기 작성
    public void reviewInsertAction(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException;
    
 // 4. 후기 수정 처리
    public void reviewUpdateAction(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException;

    // 5. 후기 삭제 처리
    public void reviewDeleteAction(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException;

    // 6. 아이디 마스킹 처리 
    public String maskUserId(String userId);
    
    // 7. 공연 목록 가져오기 (작성 폼 등에서 사용)
    public void getConcertListAction(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException;


}

    

