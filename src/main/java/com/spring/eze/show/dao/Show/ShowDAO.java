package com.spring.eze.show.dao.Show;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.spring.eze.show.dto.Myticket.MyticketDTO;
import com.spring.eze.show.dto.Show.ShowDTO;

public interface ShowDAO {

	//상단 공연정보 표기
	public List<ShowDTO> selectShowMainList(Map<String, Object> map);
	
	//하단 오픈예정 표기
	public List<ShowDTO> selectShowUpcoming();
	
	//장르별 상세페이지 가져오기
	public List<ShowDTO> getShowListByCategory(@Param("category") String category, @Param("subCategory") String subCategory);
	
	//개별 상세페이지 가져오기
	public ShowDTO getShowDetail(@Param("showId") String showId);
	
	//날짜,회차 리스트만 가져오도록 
	public List<ShowDTO> getShowSchedule(@Param("showID") String showId, @Param("playDate") String playDate);

	//랭킹 페이지
	public List<ShowDTO> getShowRanking(String genre);

	//seat용 추가
	public String selectVenueName(String showId);

	// 마이티켓 목록
	public List<MyticketDTO> getMyPageTicket(long userId);
	
	// 마이티켓 카운트(예매내역 확인)
	public int getMyTicketCount(long userId);

	//seat 팝업에 공연회차 가져오랴거 만듦
	public Map<String, Object> selectScheduleInfo(String scheduleId);

}
