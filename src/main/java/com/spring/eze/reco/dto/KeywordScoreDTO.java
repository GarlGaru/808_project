package com.spring.eze.reco.dto;

public class KeywordScoreDTO {
    private int genreId;
    private int totalScore;

    public KeywordScoreDTO() {
    }

    public KeywordScoreDTO(int genreId, int totalScore) {
        this.genreId = genreId;
        this.totalScore = totalScore;
    }

    public int getGenreId() {
        return genreId;
    }

    public void setGenreId(int genreId) {
        this.genreId = genreId;
    }

    public int getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(int totalScore) {
        this.totalScore = totalScore;
    }

    @Override
    public String toString() {
        return "KeywordScoreDTO{" +
                "genreId=" + genreId +
                ", totalScore=" + totalScore +
                '}';
    }
}
