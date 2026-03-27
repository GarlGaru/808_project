package com.spring.eze.user.dto;

/**
 * MypageTopArtistDTO
 * 808 플레이 리포트 — 탑 아티스트 Top10
 * coverImageUrl: 해당 아티스트 이미지사용
 */
public class MypageTopArtistDTO {

    private int    artistId;      // 아티스트 번호 
    private String name;          // 아티스트명 
    private String coverImageUrl; // 앨범 커버
    private int    playCount;     // 재생곡수

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
