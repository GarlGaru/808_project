package com.spring.eze.reco.dto;

public class KeywordScoreDTO {
    private int keywordId;
    private int totalScore;

    public KeywordScoreDTO() {
    }

    public KeywordScoreDTO(int keywordId, int totalScore) {
        this.keywordId = keywordId;
        this.totalScore = totalScore;
    }

    public int getKeywordId() {
        return keywordId;
    }

    public void setKeywordId(int keywordId) {
        this.keywordId = keywordId;
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
                "keywordId=" + keywordId +
                ", totalScore=" + totalScore +
                '}';
    }
}
