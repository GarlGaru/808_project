"""
챗봇 라우터 — POST /chat

전체 흐름:
1. 유저 메시지 → intent 분류 (GPT 1회)
2. fragment → memory 저장
3-a. chat → 바로 reply 반환
3-b. recommend → /similar 내부 호출 → Spring API → GPT 선별 → 응답
"""

import numpy as np
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field

from app.state import state
from app.services.embedding import embed_text
from app.services.openai_client import OpenAIResponsesError
from app.services.similarity import cosine_similarity_batch
from app.chatbot.intent import classify_intent
from app.chatbot.memory import get_fragments, add_fragment
from app.chatbot.spring_client import fetch_song_details, SongDetail
from app.chatbot.response import generate_recommendation

router = APIRouter(prefix="/chat", tags=["chatbot"])


# ── Request / Response 모델 ──

class ChatRequest(BaseModel):
    user_id: str = Field(..., description="유저 식별자")
    message: str = Field(..., min_length=1, max_length=1000, description="유저 메시지")


class SongItem(BaseModel):
    song_id: int
    song_title: str = ""
    album_title: str = ""
    artist_name: str = ""
    genres: list[str] = []


class ChatResponse(BaseModel):
    reply: str
    songs: list[SongItem] | None = None


# ── 엔드포인트 ──

@router.post("", response_model=ChatResponse)
async def chat(req: ChatRequest):
    # 1. 유저 문맥 불러오기
    fragments = get_fragments(req.user_id)

    # 2. 의도 분류 (GPT 1회)
    intent_result = classify_intent(req.message, fragments)

    # 3. fragment 저장
    if intent_result.fragment:
        add_fragment(req.user_id, intent_result.fragment)

    # 4-a. 잡담
    if intent_result.intent == "chat":
        return ChatResponse(reply=intent_result.reply, songs=None)

    # 4-b. 추천
    return await _handle_recommend(req, intent_result, fragments)


async def _handle_recommend(req, intent_result, fragments):
    """추천 흐름: similar → Spring → GPT 선별"""

    # 임베딩 데이터 확인
    if state.embeddings is None:
        raise HTTPException(
            status_code=503,
            detail="임베딩 데이터가 로드되지 않았습니다.",
        )

    # 1. 키워드 → 임베딩 유사도 검색 (상위 10개)
    keyword_text = ", ".join(intent_result.keywords)
    try:
        query_vec = embed_text(keyword_text)
    except OpenAIResponsesError as e:
        print(f"[chat] OpenAI embedding 호출 실패: {e}")
        raise HTTPException(
            status_code=503,
            detail="추천을 위한 OpenAI 임베딩 호출이 일시적으로 불안정합니다.",
        )

    scores = cosine_similarity_batch(query_vec, state.embeddings)

    top_n = 10
    top_indices = np.argsort(scores)[::-1][:top_n]
    song_ids = [state.song_ids[i] for i in top_indices]

    # 2. Spring API로 곡 상세 조회
    try:
        song_details = await fetch_song_details(song_ids)
    except Exception as e:
        # Spring 연결 실패 시 ID만으로 응답
        print(f"[chat] Spring API 호출 실패: {e}")
        return ChatResponse(
            reply="추천 곡을 찾았지만 상세 정보를 가져오지 못했어요. 잠시 후 다시 시도해주세요!",
            songs=[SongItem(song_id=sid) for sid in song_ids[:intent_result.count]],
        )

    # 3. GPT로 최종 선별 + 추천문 생성 (GPT 2회째)
    try:
        selected_indices, reply = await generate_recommendation(
            user_message=req.message,
            context_fragments=fragments,
            song_details=song_details,
            count=intent_result.count,
        )
    except OpenAIResponsesError as e:
        print(f"[chat] OpenAI 추천 생성 실패: {e}")
        selected_indices = list(range(min(intent_result.count, len(song_details))))
        reply = "추천 곡을 골라봤어요. 설명 생성이 잠시 불안정해서 우선 곡부터 보여드릴게요!"

    # 4. 선별된 인덱스로 곡 매핑
    songs = []
    for idx in selected_indices:
        if 0 <= idx < len(song_details):
            s = song_details[idx]
            songs.append(SongItem(
                song_id=s.song_id,
                song_title=s.song_title,
                album_title=s.album_title,
                artist_name=s.artist_name,
                genres=s.genres,
            ))

    return ChatResponse(reply=reply, songs=songs)
