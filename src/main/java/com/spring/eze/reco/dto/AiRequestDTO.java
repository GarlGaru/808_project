package com.spring.eze.reco.dto;

public class AiRequestDTO {
    String user_id;
    String message;

    public AiRequestDTO() {
    }

    public AiRequestDTO(String user_id, String message) {
        this.user_id = user_id;
        this.message = message;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @Override
    public String toString() {
        return "AiRequestDTO{" +
                "user_id=" + user_id +
                ", message='" + message + '\'' +
                '}';
    }
}
