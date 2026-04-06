"""
Oracle의 song_genre_tbl + genres_tbl에서 태그를 읽어와서
GPT로 노이즈 판별 → 노이즈 제거 → SQLite에 저장.

사용법:
  python -m scripts.run_noise_filter
"""

import sqlite3
import oracledb

from app.config import ORACLE_DSN, ORACLE_USER, ORACLE_PASSWORD, SQLITE_DB_PATH, DATA_DIR
from app.preprocessing.noise_filter import classify_tags_batch
from scripts.init_db import init_db


def load_tags_from_oracle() -> list[dict]:
    """Oracle에서 song_id, tag_name 쌍을 읽어옴"""
    conn = oracledb.connect(
        user=ORACLE_USER,
        password=ORACLE_PASSWORD,
        dsn=ORACLE_DSN
    )
    cursor = conn.cursor()

    cursor.execute("""
        SELECT sg.song_id, g.name
        FROM song_genre_tbl sg
        JOIN genres_tbl g ON g.genre_id = sg.genre_id
    """)

    rows = [{"song_id": r[0], "tag_name": r[1]} for r in cursor.fetchall()]
    cursor.close()
    conn.close()
    print(f"[noise_filter] Oracle에서 {len(rows)}개 태그 로드")
    return rows


def save_to_sqlite(
    clean_tags: list[str],
    song_tag_pairs: list[dict],
):
    """노이즈가 제거된 태그만 SQLite에 저장"""
    conn = sqlite3.connect(str(SQLITE_DB_PATH))
    cursor = conn.cursor()

    clean_set = set(clean_tags)

    # 1) tags_tbl 삽입
    tag_to_id: dict[str, int] = {}
    for tag_name in clean_tags:
        cursor.execute(
            "INSERT OR IGNORE INTO tags_tbl (tag_name) VALUES (?)",
            (tag_name,),
        )
        cursor.execute(
            "SELECT tag_id FROM tags_tbl WHERE tag_name = ?",
            (tag_name,),
        )
        row = cursor.fetchone()
        if row:
            tag_to_id[tag_name] = row[0]

    # 2) song_tag_map 삽입 (노이즈 태그는 clean_set에 없으므로 자동 제외)
    inserted = 0
    for pair in song_tag_pairs:
        if pair["tag_name"] not in clean_set:
            continue
        tag_id = tag_to_id.get(pair["tag_name"])
        if tag_id is not None:
            cursor.execute(
                "INSERT OR IGNORE INTO song_tag_map (song_id, tag_id) VALUES (?, ?)",
                (pair["song_id"], tag_id),
            )
            inserted += 1

    conn.commit()
    conn.close()
    print(f"[noise_filter] SQLite 저장 완료: tags={len(tag_to_id)}, mappings={inserted}")


def main():
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    init_db()

    # 1. Oracle에서 태그 로드
    song_tag_pairs = load_tags_from_oracle()

    # 2. 고유 태그 추출
    unique_tags = list({pair["tag_name"] for pair in song_tag_pairs})
    print(f"[noise_filter] 고유 태그 수: {len(unique_tags)}")

    # 3. GPT 노이즈 판별
    classified = classify_tags_batch(unique_tags)

    # 4. 노이즈 제거 — 살아남은 태그만 추출
    clean_tags = [item["tag"] for item in classified if not item.get("is_noise", True)]
    noise_count = len(classified) - len(clean_tags)
    print(f"[noise_filter] 노이즈: {noise_count}, 유효: {len(clean_tags)}")

    # 5. SQLite 저장
    save_to_sqlite(clean_tags, song_tag_pairs)


if __name__ == "__main__":
    main()
