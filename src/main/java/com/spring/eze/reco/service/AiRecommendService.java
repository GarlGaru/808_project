package com.spring.eze.reco.service;

import com.spring.eze.reco.dto.AiRequestDTO;
import com.spring.eze.reco.dto.AiResponseDTO;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class AiRecommendService {

    private static final String AI_SERVER_URL = "http://localhost:8000";

    public AiResponseDTO askToChatBot(int userId, String message) {
        RestTemplate restTemplate = new RestTemplate();
        String url = AI_SERVER_URL + "/chat";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        // timeout 설정
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(5 * 1000); // TCP 연결 기다림 (ms)
        factory.setReadTimeout(30 * 1000);  // HTTP 응답 기다림 (ms)

        restTemplate.setRequestFactory(factory);

        // 요청 데이터 생성
        AiRequestDTO aiRequestDTO = new AiRequestDTO(String.valueOf(userId), message);

        HttpEntity<AiRequestDTO> entity = new HttpEntity<>(aiRequestDTO, headers);

        // post 요청
        ResponseEntity<AiResponseDTO> response =
                restTemplate.postForEntity(url, entity, AiResponseDTO.class);

        return response.getBody();
    }
}
