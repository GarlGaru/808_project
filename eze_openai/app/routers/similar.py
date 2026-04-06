import numpy as np
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field

from app.config import SIMILAR_TOP_N_DEFAULT
from app.state import state
from app.services.embedding import embed_text
from app.services.similarity import cosine_similarity_batch

router = APIRouter()


class SimilarRequest(BaseModel):
    text: str = Field(..., description="검색 키워드 텍스트 (예: 'R&B, emotional, rainy')")
    top_n: int = Field(default=SIMILAR_TOP_N_DEFAULT, ge=1, le=100)


class SimilarItem(BaseModel):
    song_id: int
    score: float


class SimilarResponse(BaseModel):
    results: list[SimilarItem]


@router.post("/similar", response_model=SimilarResponse)
async def find_similar(req: SimilarRequest):
    if state.embeddings is None:
        raise HTTPException(status_code=503, detail="임베딩 데이터가 로드되지 않았습니다.")

    # 1. 쿼리 텍스트 임베딩
    query_vec = embed_text(req.text)

    # 2. 전체 곡과 cosine similarity
    scores = cosine_similarity_batch(query_vec, state.embeddings)

    # 3. 상위 N개 추출
    top_n = min(req.top_n, len(state.song_ids))
    top_indices = np.argsort(scores)[::-1][:top_n]

    results = [
        SimilarItem(
            song_id=state.song_ids[i],
            score=round(float(scores[i]), 4),
        )
        for i in top_indices
    ]

    return SimilarResponse(results=results)
