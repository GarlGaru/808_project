"""
Spring 백엔드 API 클라이언트.

song_id 리스트를 보내고 곡 상세 정보를 받아옵니다.
endpoint는 config에서 관리 — Spring 쪽 API가 바뀌면 여기만 수정.
"""

import httpx

from app.config import SPRING_API_BASE_URL

# ── 타입 ──

class SongDetail:
    def __init__(
        self,
        song_id: int,
        song_title: str,
        album_title: str,
        artist_name: str,
        genres: list[str],
    ):
        self.song_id = song_id
        self.song_title = song_title
        self.album_title = album_title
        self.artist_name = artist_name
        self.genres = genres

    def to_description(self) -> str:
        """곡 설명 텍스트 (디버깅/로깅용)"""
        genres_str = ", ".join(self.genres) if self.genres else "unknown"
        return (
            f"{self.song_title} - {self.artist_name} "
            f"(album: {self.album_title}) [genres: {genres_str}]"
        )


# ── Spring API 엔드포인트 (변경 시 여기만 수정) ──

SONG_DETAIL_PATH = "/eze/api/songs/details"


async def fetch_song_details(song_ids: list[int]) -> list[SongDetail]:
    """
    Spring API에 song_id 리스트를 보내 곡 상세 정보를 받아옵니다.

    Expected Spring response format:
    [
        {
            "songId": 123,
            "songTitle": "Ditto",
            "albumTitle": "OMG",
            "artistName": "NewJeans",
            "genres": ["K-Pop", "dance"]
        },
        ...
    ]
    """
    if not song_ids:
        return []

    url = f"{SPRING_API_BASE_URL}{SONG_DETAIL_PATH}"

    async with httpx.AsyncClient(timeout=10.0) as client:
        resp = await client.post(url, json=song_ids)
        resp.raise_for_status()
        data = resp.json()

    results = []
    for item in data:
        results.append(SongDetail(
            song_id=item.get("song_id", 0),
            song_title=item.get("song_title", ""),
            album_title=item.get("album_title", ""),
            artist_name=item.get("artist_name", ""),
            genres=item.get("genres", []),
        ))

    return results
