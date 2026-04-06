"""
유저별 문맥 메모리 (SQLite 기반).

- user_id 당 최대 MAX_FRAGMENTS(20)개의 영어 5단어 이내 fragment 유지
- 중복 fragment는 priority 증가 + updated_at 갱신
- 초과 시 priority 가장 낮은 것 삭제
"""

import sqlite3
from datetime import datetime, timezone

from app.config import SQLITE_DB_PATH

MAX_FRAGMENTS = 20


# ── 테이블 생성 ──

def init_user_context_table():
    """user_context 테이블이 없으면 생성"""
    conn = _get_conn()
    try:
        conn.executescript("""
            CREATE TABLE IF NOT EXISTS user_context (
                user_id    TEXT    NOT NULL,
                fragment   TEXT    NOT NULL,
                priority   INTEGER NOT NULL DEFAULT 1,
                created_at TEXT    NOT NULL,
                updated_at TEXT    NOT NULL,
                PRIMARY KEY (user_id, fragment)
            );

            CREATE INDEX IF NOT EXISTS idx_uc_user_id
                ON user_context(user_id);
        """)
        conn.commit()
    finally:
        conn.close()


# ── CRUD ──

def get_fragments(user_id: str) -> list[str]:
    """유저의 context fragments를 priority 내림차순으로 반환"""
    conn = _get_conn()
    try:
        rows = conn.execute(
            """
            SELECT fragment FROM user_context
            WHERE user_id = ?
            ORDER BY priority DESC, updated_at DESC
            """,
            (user_id,),
        ).fetchall()
        return [r["fragment"] for r in rows]
    finally:
        conn.close()


def add_fragment(user_id: str, fragment: str):
    """
    fragment 추가.
    - 이미 존재하면 priority + 1, updated_at 갱신
    - 새로 추가 시 20개 초과하면 priority 가장 낮은 것 삭제
    """
    if not fragment or not fragment.strip():
        return

    fragment = fragment.strip()[:100]  # 안전 장치
    now = _now_iso()
    conn = _get_conn()
    try:
        # upsert
        existing = conn.execute(
            "SELECT priority FROM user_context WHERE user_id = ? AND fragment = ?",
            (user_id, fragment),
        ).fetchone()

        if existing:
            conn.execute(
                """
                UPDATE user_context
                SET priority = priority + 1, updated_at = ?
                WHERE user_id = ? AND fragment = ?
                """,
                (now, user_id, fragment),
            )
        else:
            conn.execute(
                """
                INSERT INTO user_context (user_id, fragment, priority, created_at, updated_at)
                VALUES (?, ?, 1, ?, ?)
                """,
                (user_id, fragment, now, now),
            )
            # 초과분 삭제
            _evict_if_over_limit(conn, user_id)

        conn.commit()
    finally:
        conn.close()


def clear_fragments(user_id: str):
    """유저의 모든 fragment 삭제"""
    conn = _get_conn()
    try:
        conn.execute("DELETE FROM user_context WHERE user_id = ?", (user_id,))
        conn.commit()
    finally:
        conn.close()


# ── 내부 헬퍼 ──

def _get_conn() -> sqlite3.Connection:
    conn = sqlite3.connect(str(SQLITE_DB_PATH))
    conn.row_factory = sqlite3.Row
    return conn


def _now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def _evict_if_over_limit(conn: sqlite3.Connection, user_id: str):
    """MAX_FRAGMENTS 초과 시 priority 가장 낮은 것 삭제"""
    count = conn.execute(
        "SELECT COUNT(*) AS cnt FROM user_context WHERE user_id = ?",
        (user_id,),
    ).fetchone()["cnt"]

    if count > MAX_FRAGMENTS:
        excess = count - MAX_FRAGMENTS
        conn.execute(
            """
            DELETE FROM user_context
            WHERE rowid IN (
                SELECT rowid FROM user_context
                WHERE user_id = ?
                ORDER BY priority ASC, updated_at ASC
                LIMIT ?
            )
            """,
            (user_id, excess),
        )
