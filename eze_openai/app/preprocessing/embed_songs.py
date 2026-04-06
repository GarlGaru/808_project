"""
필터링된 태그를 기반으로 곡별 최종 임베딩을 생성하는 모듈.
곡 하나당 벡터 1개 (제목 + 아티스트 + 장르 + 태그 → 텍스트 → 임베딩).
scripts/run_embed.py에서 호출.
"""

import json
import numpy as np

from app.config import EMBEDDINGS_NPY_PATH, SONG_IDS_JSON_PATH
from app.services.embedding import embed_texts


def build_song_text(
    title: str,
    artist: str,
    tags: list[str],
) -> str:
    """곡 메타데이터를 임베딩용 텍스트로 조합"""
    parts = [
        f"title: {title}",
        f"artist: {artist}",
    ]
    if tags:
        parts.append(f"tags: {', '.join(tags)}")
    return "\n".join(parts)


def generate_and_save_embeddings(
    songs: list[dict],
) -> None:
    """
    songs: [{"song_id": int, "text": str}, ...]
    임베딩 생성 후 .npy + .json 저장
    """
    if not songs:
        print("[embed] 임베딩할 곡이 없습니다.")
        return

    song_ids = [s["song_id"] for s in songs]
    texts = [s["text"] for s in songs]

    print(f"[embed] {len(texts)}곡 임베딩 시작...")

    # OpenAI 배치 임베딩 (한 번에 최대 2048개)
    batch_size = 2048
    all_embeddings = []

    for i in range(0, len(texts), batch_size):
        batch = texts[i : i + batch_size]
        batch_emb = embed_texts(batch)
        all_embeddings.append(batch_emb)
        print(f"  임베딩 완료: {min(i + batch_size, len(texts))}/{len(texts)}")

    embeddings = np.vstack(all_embeddings)  # shape (N, 1536)

    # 저장
    np.save(str(EMBEDDINGS_NPY_PATH), embeddings)
    with open(SONG_IDS_JSON_PATH, "w") as f:
        json.dump(song_ids, f)

    print(f"[embed] 저장 완료: {EMBEDDINGS_NPY_PATH} shape={embeddings.shape}")
    print(f"[embed] 저장 완료: {SONG_IDS_JSON_PATH} ({len(song_ids)}곡)")
