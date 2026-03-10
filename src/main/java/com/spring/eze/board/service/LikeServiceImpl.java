package com.spring.eze.board.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.eze.board.dao.LikeDAO;
import com.spring.eze.board.dto.LikeDTO;

@Service
public class LikeServiceImpl implements LikeService {
    
    @Autowired
    private LikeDAO likeDao;

    @Override
    public void insertLike(LikeDTO dto) {
        
    	likeDao.insertLike(dto);
    }

    @Override	
    public void deleteLike(LikeDTO dto) {
       
        likeDao.deleteLike(dto);
    }

    @Override
    public int checkLike(LikeDTO dto) {
        
        return likeDao.checkLike(dto);
    }

    @Override
    public int getLikeCount(int bno) {
       
        return likeDao.getLikeCount(bno);
    }
}
