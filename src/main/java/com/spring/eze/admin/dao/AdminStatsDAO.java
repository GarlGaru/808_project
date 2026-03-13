package com.spring.eze.admin.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.spring.eze.admin.dto.AdminUserDTO;
import com.spring.eze.admin.dto.DailyCountDTO;


@Mapper
public interface AdminStatsDAO {

	List<DailyCountDTO> selectSignupLast5();
    List<DailyCountDTO> selectPayLast5();
    List<AdminUserDTO> selectUserList();
    List<AdminUserDTO> setProfileImageUrl();
    
    
}
