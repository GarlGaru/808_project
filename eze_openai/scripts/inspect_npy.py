"""
song_embeddings.npy + song_ids.json 내용 확인 스크립트.

사용법:
  python -m scripts.inspect_npy
  python -m scripts.inspect_npy --song_id 123
  python -m scripts.inspect_npy --index 0
"""

import json
import argparse
import numpy as np

from app.config import EMBEDDINGS_NPY_PATH, SONG_IDS_JSON_PATH


def main():
    parser = argparse.ArgumentParser(description="임베딩 데이터 확인")
    parser.add_argument("--song_id", type=int, help="특정 song_id의 벡터 확인")
    parser.add_argument("--index", type=int, help="특정 인덱스의 벡터 확인")
    args = parser.parse_args()

    # 파일 로드
    if not EMBEDDINGS_NPY_PATH.exists():
        print(f"[error] 파일 없음: {EMBEDDINGS_NPY_PATH}")
        return
    if not SONG_IDS_JSON_PATH.exists():
        print(f"[error] 파일 없음: {SONG_IDS_JSON_PATH}")
        return

    embeddings = np.load(str(EMBEDDINGS_NPY_PATH))
    with open(SONG_IDS_JSON_PATH, "r") as f:
        song_ids = json.load(f)

    # 전체 요약
    print("=" * 50)
    print(f"  파일: {EMBEDDINGS_NPY_PATH.name}")
    print(f"  shape: {embeddings.shape}")
    print(f"  dtype: {embeddings.dtype}")
    print(f"  곡 수: {len(song_ids)}")
    print(f"  차원:  {embeddings.shape[1]}")
    print(f"  파일 크기: {EMBEDDINGS_NPY_PATH.stat().st_size / 1024 / 1024:.2f} MB")
    print("=" * 50)

    # song_id 목록 미리보기
    print(f"\n  song_ids (처음 10개): {song_ids[:10]}")
    if len(song_ids) > 10:
        print(f"  song_ids (마지막 5개): {song_ids[-5:]}")

    # 특정 곡 조회
    target_idx = None

    if args.song_id is not None:
        if args.song_id in song_ids:
            target_idx = song_ids.index(args.song_id)
            print(f"\n  song_id {args.song_id} → index {target_idx}")
        else:
            print(f"\n  [error] song_id {args.song_id}를 찾을 수 없습니다.")
            return

    if args.index is not None:
        if 0 <= args.index < len(song_ids):
            target_idx = args.index
            print(f"\n  index {target_idx} → song_id {song_ids[target_idx]}")
        else:
            print(f"\n  [error] index {args.index}는 범위 밖입니다. (0~{len(song_ids) - 1})")
            return

    if target_idx is not None:
        vec = embeddings[target_idx]
        print(f"\n  벡터 (처음 10개 값): {vec[:10]}")
        print(f"  norm: {np.linalg.norm(vec):.6f}")
        print(f"  min:  {vec.min():.6f}")
        print(f"  max:  {vec.max():.6f}")
        print(f"  mean: {vec.mean():.6f}")


if __name__ == "__main__":
    main()