package com.spring.eze.music.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.eze.music.dto.SongDTO;
import com.spring.eze.music.service.MusicService;

@Controller
public class RankingController {
	@Autowired
	private MusicService musicService;
	//장르랭킹
	@RequestMapping("")
	public String rankingMain(Model model) {
		
		List<SongDTO> weeklyRanking = musicService.getweeklyRanking();
		
		List<SongDTO> todayHitSongs = musicService.getTodayHitSongs();
		
		List<SongDTO> genreRanking = musicService.getGenreRanking(1);

		model.addAttribute("weeklyRanking", weeklyRanking);
		model.addAttribute("todayHitSongs", todayHitSongs);
		model.addAttribute("genreRanking", genreRanking);	

		return "music/ranking";
		
	}
 
	//주간랭킹
	
	//오늘의 최고 히트곡
	
	//아티스트 랭킹

}
