package com.spring.eze.user.dao;

import java.util.List;
import java.util.Map;

import com.spring.eze.board.dto.BoardDTO;
import com.spring.eze.board.dto.CommentDTO;
import com.spring.eze.payment.dto.PaymentOrderDTO;
import com.spring.eze.user.dto.MonthlyStatDTO;
import com.spring.eze.user.dto.UserDTO;

public interface MypageDAO {
	
	// 유저 + 프로필
	public UserDTO selectUserProfile(int userId);
	
	// 게시글
	public List<BoardDTO> selectMyBoardList(Map<String, Object> map);
	public int setlectMyBoardCount(int userId);
	
	// 댓글
	public List<CommentDTO> selectMyCommentList(Map<String, Object> map);
	
	// 예매
	/* public List<?> selectMyReservationList(int userId); */
	
	// 결제 
	public List<PaymentOrderDTO> selectMyPaymaentList(int userId);
	public List<MonthlyStatDTO> selecMonthlyStats(int userId);
	
	// 내 정보 수정
	public int updateNickname(Map<String, Object> map);
	public int updateProfile(Map<String, Object> map);
	public int updatePhotoUrl(Map<String, Object> map);
	
	// 계정 탈퇴
	public int deleteUser(int userId);
	
}
