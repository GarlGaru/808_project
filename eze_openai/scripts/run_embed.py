"""
필터링된 태그 + 곡 메타데이터로 곡별 최종 임베딩을 생성.
SQLite에서 태그, Oracle에서 곡 정보를 읽어옴.

사용법:
  python -m scripts.run_embed

전제: scripts/run_noise_filter.py가 먼저 실행되어 SQLite에 데이터가 있어야 함.
"""

import oracledb

from app.config import ORACLE_DSN, ORACLE_USER, ORACLE_PASSWORD, DATA_DIR
from app.db.sqlite_client import get_all_song_tags
from app.preprocessing.embed_songs import build_song_text, generate_and_save_embeddings


def load_song_metadata_from_oracle() -> dict[int, dict]:
    """Oracle에서 곡 메타데이터 조회 → {song_id: {title, artist}}"""
    conn = oracledb.connect(user=ORACLE_USER, password=ORACLE_PASSWORD, dsn=ORACLE_DSN)
    cursor = conn.cursor()


    cursor.execute("""
        SELECT s.song_id, s.title, a.name AS artist_name
        FROM songs_tbl s
        JOIN artists_tbl a ON a.artist_id = s.artist_id
    """)

    result = {}
    for r in cursor.fetchall():
        result[r[0]] = {
            "title": r[1] or "",
            "artist": r[2] or "",
        }

    cursor.close()
    conn.close()
    print(f"[embed] Oracle에서 {len(result)}곡 메타데이터 로드")
    return result


def main():
    DATA_DIR.mkdir(parents=True, exist_ok=True)

    # 1. Oracle에서 곡 메타데이터
    song_meta = load_song_metadata_from_oracle()

    # 2. SQLite에서 필터링된 태그
    song_tags = get_all_song_tags()

    # 3. 임베딩용 텍스트 생성
    songs = []
    for song_id, meta in song_meta.items():
        tags = song_tags.get(song_id, [])
        text = build_song_text(
            title=meta["title"],
            artist=meta["artist"],
            tags=tags,
        )
        songs.append({"song_id": song_id, "text": text})

    print(f"[embed] 임베딩 대상: {len(songs)}곡")

    # 4. 임베딩 생성 + 저장
    generate_and_save_embeddings(songs)


if __name__ == "__main__":
    main()
