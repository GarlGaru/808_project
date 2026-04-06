# eze-ai

음악 추천 임베딩 유사도 검색 서비스 (FastAPI)

## 구조

```
eze-ai/
├── app/                      # FastAPI 애플리케이션
│   ├── main.py               # 엔트리포인트 + startup 로더
│   ├── config.py             # 환경변수, 경로 설정
│   ├── routers/similar.py    # POST /similar 엔드포인트
│   ├── services/
│   │   ├── embedding.py      # OpenAI 임베딩 호출
│   │   └── similarity.py     # cosine similarity 계산
│   ├── preprocessing/
│   │   ├── noise_filter.py   # GPT 노이즈 판별
│   │   └── embed_songs.py    # 곡 임베딩 생성
│   └── db/sqlite_client.py   # SQLite 조회
├── data/                     # .gitignore 대상
│   ├── metadata.db           # SQLite (tags_tbl, song_tag_map)
│   ├── song_embeddings.npy   # (N, 1536) float32
│   └── song_ids.json
├── scripts/                  # 1회성 전처리 스크립트
│   ├── init_db.py            # SQLite 스키마 생성
│   ├── run_noise_filter.py   # 노이즈 필터링 실행
│   └── run_embed.py          # 임베딩 배치 실행
```

## 데이터 저장

- **SQLite** (`data/metadata.db`): 노이즈 제거된 태그(`tags_tbl`)와 곡-태그 매핑(`song_tag_map`)
- **NPY** (`data/song_embeddings.npy`): 곡별 최종 임베딩 벡터 (N, 1536)
- **JSON** (`data/song_ids.json`): npy 행 인덱스 ↔ song_id 매핑

## 실행 순서

### 1. 환경 설정

```bash
cp .env.example .env
# .env에 OPENAI_API_KEY, Oracle 접속 정보 입력

# venv 설정
# 프로젝트 폴더에서 CMD (PowerShell x안됨)
# venv 생성
py -m venv .venv

# (.venv) 환경으로 진입
.\.venv\Scripts\activate

# venv 환경 확인
python -c "import sys; print(sys.executable)"

# 필요한 라이브러리 설치
pip install -r requirements.txt
```

### 2. 전처리 (1회)

```bash
# SQLite 스키마 생성
python -m scripts.init_db

# 노이즈 필터링 (Oracle → GPT 판별 → SQLite)
# !!! 오래걸리고 토큰 많이 사용하는 작업이므로 미리 만들어놓은 것을 받아 쓸 것 !!!
python -m scripts.run_noise_filter

# 곡 임베딩 생성 (Oracle + SQLite → OpenAI → .npy)
python -m scripts.run_embed
```

### 3. 서버 실행

```bash
uvicorn app.main:app --reload --port 8000
```

### 4. API 사용

```bash
# 헬스체크
curl http://localhost:8000/health

# 유사곡 검색
curl -X POST http://localhost:8000/similar \
  -H "Content-Type: application/json" \
  -d '{"text": "R&B, emotional, rainy, chill", "top_n": 10}'
```

### 5. swagger url
```
http://localhost:8000/docs
```
