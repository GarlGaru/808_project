"""
추천 응답 생성 모듈.

song detail 리스트를 GPT에 넘겨서:
1. 유저 요청에 맞는 곡을 count개 선별
2. 한국어 추천 문구 생성

OpenAI Responses API 사용 (GPT-5 시리즈 권장)
"""

import json

from app.chatbot.spring_client import SongDetail
from app.services.openai_client import create_text_response

_INSTRUCTIONS_TEMPLATE = """\
You are a music recommendation assistant. You will receive:
1. The user's original request
2. The user's context fragments
3. A numbered list of candidate songs

Your job:
- Select up to {count} songs that best match the user's request from the candidates.
- Only select songs that are genuinely good matches — do NOT pad to fill the count.
- Write a short, friendly Korean recommendation message.
- The reply must NOT contain any song numbers, song titles, artist names, or album titles — the system displays song details separately.
- Output ONLY a JSON object (no markdown, no explanation):

{{
  "selected": [1, 3, 5],
  "reply": "<Korean recommendation message, conversational tone, max 200 chars, max 500 if needed>"
}}

Rules:
- "selected" contains the candidate numbers (1-based) you chose.
- Consider genres, mood, artist, and user context when selecting.
- The reply should briefly explain why these songs were chosen.
- Keep the reply natural and concise.
"""


async def generate_recommendation(
    user_message: str,
    context_fragments: list[str],
    song_details: list[SongDetail],
    count: int = 5,
) -> tuple[list[int], str]:
    """
    GPT에게 곡 리스트를 인덱스로 넘겨 선별 + 추천문을 받습니다.

    Returns:
        (selected_indices (0-based), reply_text)
    """
    context_str = ", ".join(context_fragments) if context_fragments else "(none)"
    candidates_str = "\n".join(
        f"#{i + 1}. {s.to_description()}" for i, s in enumerate(song_details)
    )

    instructions = _INSTRUCTIONS_TEMPLATE.replace("{count}", str(count))

    user_input = (
        f"User request: {user_message}\n"
        f"User context: [{context_str}]\n"
        f"Candidates:\n{candidates_str}"
    )

    raw = create_text_response(
        instructions=instructions,
        input_text=user_input,
        max_output_tokens=4000,
    )

    try:
        data = json.loads(raw)
        # GPT가 반환한 1-based 번호를 0-based 인덱스로 변환
        selected_indices = [n - 1 for n in data.get("selected", []) if 1 <= n <= len(song_details)]
        reply = data.get("reply", "추천 곡을 준비했어요!")
    except json.JSONDecodeError:
        selected_indices = list(range(min(count, len(song_details))))
        reply = "추천 곡을 준비했어요!"

    return selected_indices, reply
