"""
SQLite 스키마 초기화.
data/metadata.db 파일을 생성하고 테이블을 만듭니다.

사용법:
  python -m scripts.init_db
"""

import sqlite3
from app.config import SQLITE_DB_PATH, DATA_DIR


def init_db():
    DATA_DIR.mkdir(parents=True, exist_ok=True)

    conn = sqlite3.connect(str(SQLITE_DB_PATH))
    cursor = conn.cursor()

    cursor.executescript("""
        CREATE TABLE IF NOT EXISTS tags_tbl (
            tag_id   INTEGER PRIMARY KEY AUTOINCREMENT,
            tag_name TEXT NOT NULL UNIQUE
        );

        CREATE TABLE IF NOT EXISTS song_tag_map (
            song_id INTEGER NOT NULL,
            tag_id  INTEGER NOT NULL,
            PRIMARY KEY (song_id, tag_id),
            FOREIGN KEY (tag_id) REFERENCES tags_tbl(tag_id)
        );

        CREATE INDEX IF NOT EXISTS idx_stm_song_id ON song_tag_map(song_id);
        CREATE INDEX IF NOT EXISTS idx_stm_tag_id  ON song_tag_map(tag_id);

        CREATE TABLE IF NOT EXISTS user_context (
            user_id    TEXT    NOT NULL,
            fragment   TEXT    NOT NULL,
            priority   INTEGER NOT NULL DEFAULT 1,
            created_at TEXT    NOT NULL,
            updated_at TEXT    NOT NULL,
            PRIMARY KEY (user_id, fragment)
        );

        CREATE INDEX IF NOT EXISTS idx_uc_user_id ON user_context(user_id);
    """)

    conn.commit()
    conn.close()
    print(f"[init_db] 스키마 생성 완료: {SQLITE_DB_PATH}")


if __name__ == "__main__":
    init_db()
