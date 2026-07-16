import sqlite3
from app.config import SQLITE_DB_PATH


def get_connection() -> sqlite3.Connection:
    conn = sqlite3.connect(str(SQLITE_DB_PATH))
    conn.row_factory = sqlite3.Row
    return conn


def get_filtered_tags_for_song(song_id: int) -> list[str]:
    """특정 곡의 태그 목록 조회"""
    conn = get_connection()
    try:
        rows = conn.execute(
            """
            SELECT t.tag_name
            FROM song_tag_map stm
            JOIN tags_tbl t ON t.tag_id = stm.tag_id
            WHERE stm.song_id = ?
            """,
            (song_id,),
        ).fetchall()
        return [r["tag_name"] for r in rows]
    finally:
        conn.close()


def get_all_song_tags() -> dict[int, list[str]]:
    """전체 곡의 태그를 {song_id: [tag_name, ...]} 형태로 반환"""
    conn = get_connection()
    try:
        rows = conn.execute(
            """
            SELECT stm.song_id, t.tag_name
            FROM song_tag_map stm
            JOIN tags_tbl t ON t.tag_id = stm.tag_id
            ORDER BY stm.song_id
            """,
        ).fetchall()

        result: dict[int, list[str]] = {}
        for r in rows:
            sid = r["song_id"]
            if sid not in result:
                result[sid] = []
            result[sid].append(r["tag_name"])
        return result
    finally:
        conn.close()
