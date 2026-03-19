package com.spring.eze.user.dto;

import java.util.List;

/**
 * MypagePlayReportDTO
 * 808 플레이 리포트 전체 집계 결과
 * Service(MypageServiceImpl.getPlayReport)에서 조립 후 Controller → JS 반환
 *
 * Lazy Loading — 플레이리포트 탭 클릭 시 최초 1회만 Ajax 호출
 *
 * score 기준 (GlobalVariableHolder):
 *   SCORE = 1   → 재생 시작 (GLB_SCORE_PLAY)
 *   SCORE = 5   → 10초 청취 (GLB_SCORE_INTERVAL)
 *   SCORE = 300 → 좋아요 (집계 제외)
 */
public class MypagePlayReportDTO {

    /* 숫자 요약 — selectPlaySummary 로 한번에 조회 */
    private int totalPlayCount;       // 총 재생횟수 - SCORE=1 COUNT(*)
    private int totalPlayTimeSec;     // 총 청취시간(초) - SCORE=5 COUNT(*) * 10
    private int prevMonthPlayTimeSec; // 전월 청취시간(초) - 전월 대비 증가율 계산용
    private int uniqueTrackCount;     // 고유트랙수 - SCORE=1 COUNT(DISTINCT song_id)

    /* 기간 or 요일 */
    private String busiestDay; // 가장 활발한 요일명 ex) "금" - Service에서 계산
    private String periodType; // 기간 필터: THIS_MONTH / LAST_MONTH / 3MONTH

    /* 리스트 — 각각 별도 쿼리로 조회 후 Service에서 set */
    private List<MypageDayStatDTO>   dayStats;   // 요일별 재생통계 (Chart.js용, 7개 고정)
    private List<MypageGenreStatDTO> topGenres;  // 탑 장르 Top4 (30초 이상 기준)
    private List<MypageTopSongDTO>   topSongs;   // 탑 곡 Top10
    private List<MypageTopArtistDTO> topArtists; // 탑 아티스트 Top10

    public MypagePlayReportDTO() {
        super();
    }

    public MypagePlayReportDTO(int totalPlayCount, int totalPlayTimeSec,
            int prevMonthPlayTimeSec, int uniqueTrackCount,
            String busiestDay, String periodType,
            List<MypageDayStatDTO> dayStats, List<MypageGenreStatDTO> topGenres,
            List<MypageTopSongDTO> topSongs, List<MypageTopArtistDTO> topArtists) {
        super();
        this.totalPlayCount = totalPlayCount;
        this.totalPlayTimeSec = totalPlayTimeSec;
        this.prevMonthPlayTimeSec = prevMonthPlayTimeSec;
        this.uniqueTrackCount = uniqueTrackCount;
        this.busiestDay = busiestDay;
        this.periodType = periodType;
        this.dayStats = dayStats;
        this.topGenres = topGenres;
        this.topSongs = topSongs;
        this.topArtists = topArtists;
    }

    public int getTotalPlayCount() {
        return totalPlayCount;
    }

    public void setTotalPlayCount(int totalPlayCount) {
        this.totalPlayCount = totalPlayCount;
    }

    public int getTotalPlayTimeSec() {
        return totalPlayTimeSec;
    }

    public void setTotalPlayTimeSec(int totalPlayTimeSec) {
        this.totalPlayTimeSec = totalPlayTimeSec;
    }

    public int getPrevMonthPlayTimeSec() {
        return prevMonthPlayTimeSec;
    }

    public void setPrevMonthPlayTimeSec(int prevMonthPlayTimeSec) {
        this.prevMonthPlayTimeSec = prevMonthPlayTimeSec;
    }

    public int getUniqueTrackCount() {
        return uniqueTrackCount;
    }

    public void setUniqueTrackCount(int uniqueTrackCount) {
        this.uniqueTrackCount = uniqueTrackCount;
    }

    public String getBusiestDay() {
        return busiestDay;
    }

    public void setBusiestDay(String busiestDay) {
        this.busiestDay = busiestDay;
    }

    public String getPeriodType() {
        return periodType;
    }

    public void setPeriodType(String periodType) {
        this.periodType = periodType;
    }

    public List<MypageDayStatDTO> getDayStats() {
        return dayStats;
    }

    public void setDayStats(List<MypageDayStatDTO> dayStats) {
        this.dayStats = dayStats;
    }

    public List<MypageGenreStatDTO> getTopGenres() {
        return topGenres;
    }

    public void setTopGenres(List<MypageGenreStatDTO> topGenres) {
        this.topGenres = topGenres;
    }

    public List<MypageTopSongDTO> getTopSongs() {
        return topSongs;
    }

    public void setTopSongs(List<MypageTopSongDTO> topSongs) {
        this.topSongs = topSongs;
    }

    public List<MypageTopArtistDTO> getTopArtists() {
        return topArtists;
    }

    public void setTopArtists(List<MypageTopArtistDTO> topArtists) {
        this.topArtists = topArtists;
    }

    @Override
    public String toString() {
        return "MypagePlayReportDTO [totalPlayCount=" + totalPlayCount
                + ", totalPlayTimeSec=" + totalPlayTimeSec
                + ", prevMonthPlayTimeSec=" + prevMonthPlayTimeSec
                + ", uniqueTrackCount=" + uniqueTrackCount
                + ", busiestDay=" + busiestDay
                + ", periodType=" + periodType
                + ", dayStats=" + dayStats
                + ", topGenres=" + topGenres
                + ", topSongs=" + topSongs
                + ", topArtists=" + topArtists + "]";
    }

}
