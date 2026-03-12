package com.spring.eze.user.dto;

/**
 * MypageTopArtistDTO
 * 808 플레이 리포트 — 탑 아티스트 Top10
 * SONG_SCORE_TBL → SONGS_TBL → ARTISTS_TBL → ALBUMS_TBL 조인 결과 매핑
 * coverImageUrl: 해당 아티스트의 가장 최근 앨범 커버 사용
 */
public class MypageTopArtistDTO {

    private int    artistId;      // 아티스트 번호 (ARTISTS_TBL.ARTIST_ID)
    private String name;          // 아티스트명 (ARTISTS_TBL.NAME)
    private String coverImageUrl; // 앨범 커버 URL (ALBUMS_TBL.COVER_IMAGE_URL)
    private int    playCount;     // 재생곡수 - SCORE=1 기준 COUNT(DISTINCT SONG_ID)

    public MypageTopArtistDTO() {
        super();
    }

    public MypageTopArtistDTO(int artistId, String name, String coverImageUrl, int playCount) {
        super();
        this.artistId = artistId;
        this.name = name;
        this.coverImageUrl = coverImageUrl;
        this.playCount = playCount;
    }

    public int getArtistId() {
        return artistId;
    }

    public void setArtistId(int artistId) {
        this.artistId = artistId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCoverImageUrl() {
        return coverImageUrl;
    }

    public void setCoverImageUrl(String coverImageUrl) {
        this.coverImageUrl = coverImageUrl;
    }

    public int getPlayCount() {
        return playCount;
    }

    public void setPlayCount(int playCount) {
        this.playCount = playCount;
    }

    @Override
    public String toString() {
        return "MypageTopArtistDTO [artistId=" + artistId + ", name=" + name
                + ", coverImageUrl=" + coverImageUrl + ", playCount=" + playCount + "]";
    }

}
