import json
import numpy as np
from contextlib import asynccontextmanager
from fastapi import FastAPI

from app.config import EMBEDDINGS_NPY_PATH, SONG_IDS_JSON_PATH
from app.routers import similar
from app.chatbot import router as chatbot_router
from app.chatbot.memory import init_user_context_table

from app.state import state


@asynccontextmanager
async def lifespan(app: FastAPI):
    # ── Startup ──
    print("[startup] 임베딩 데이터 로딩 시작...")

    # SQLite user_context 테이블 초기화
    init_user_context_table()
    print("[startup] user_context 테이블 준비 완료")

    if EMBEDDINGS_NPY_PATH.exists() and SONG_IDS_JSON_PATH.exists():
        state.embeddings = np.load(str(EMBEDDINGS_NPY_PATH))
        with open(SONG_IDS_JSON_PATH, "r") as f:
            state.song_ids = json.load(f)
        print(f"[startup] 로딩 완료: {len(state.song_ids)}곡, shape={state.embeddings.shape}")
    else:
        print("[startup] 경고: 임베딩 파일이 없습니다. /similar 사용 불가.")
        print(f"  - embeddings: {EMBEDDINGS_NPY_PATH.exists()}")
        print(f"  - song_ids:   {SONG_IDS_JSON_PATH.exists()}")

    yield

    # ── Shutdown ──
    state.embeddings = None
    state.song_ids = []
    print("[shutdown] 메모리 해제 완료")


app = FastAPI(
    title="eze-ai",
    description="음악 추천 임베딩 유사도 검색 서비스",
    lifespan=lifespan,
)

app.include_router(similar.router)
app.include_router(chatbot_router.router)


@app.get("/health")
async def health():
    loaded = state.embeddings is not None
    return {
        "status": "ok" if loaded else "no_data",
        "song_count": len(state.song_ids),
    }
