package com.spring.eze.user.dto;

/**
 * MypageTopSongDTO
 * 808 플레이 리포트 — 탑 곡 Top10
 * SONG_SCORE_TBL → SONGS_TBL → ARTISTS_TBL 조인 결과 매핑
 * 기간 필터: THIS_MONTH / LAST_MONTH / 3MONTH
 */
public class MypageTopSongDTO {

    private int    songId;     // 곡 번호 (SONGS_TBL.SONG_ID)
    private String title;      // 곡 제목 (SONGS_TBL.TITLE)
    private String artistName; // 아티스트명 (ARTISTS_TBL.NAME)
    private int    playCount;  // 재생횟수 - SCORE=1 COUNT(*)

    public MypageTopSongDTO() {
        super();
    }

    public MypageTopSongDTO(int songId, String title, String artistName, int playCount) {
        super();
        this.songId = songId;
        this.title = title;
        this.artistName = artistName;
        this.playCount = playCount;
    }

    public int getSongId() {
        return songId;
    }

    public void setSongId(int songId) {
        this.songId = songId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getArtistName() {
        return artistName;
    }

    public void setArtistName(String artistName) {
        this.artistName = artistName;
    }

    public int getPlayCount() {
        return playCount;
    }

    public void setPlayCount(int playCount) {
        this.playCount = playCount;
    }

    @Override
    public String toString() {
        return "MypageTopSongDTO [songId=" + songId + ", title=" + title
                + ", artistName=" + artistName + ", playCount=" + playCount + "]";
    }

}
