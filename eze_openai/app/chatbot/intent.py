"""
GPT 의도 분류 모듈.

1회 호출로:
- intent (chat / recommend) 판별
- chat → 짧은 reply 포함
- recommend → keywords + 요청 개수 추출
- 항상 context fragment 생성

OpenAI Responses API 사용 (GPT-5 시리즈 권장)
https://platform.openai.com/docs/guides/reasoning
"""

import json
import logging

from app.services.openai_client import create_text_response, OpenAIResponsesError

logger = logging.getLogger("openai_api")

# ── 타입 ──

class IntentResult:
    def __init__(
        self,
        intent: str,
        fragment: str,
        reply: str = "",
        keywords: list[str] | None = None,
        count: int = 5,
    ):
        self.intent = intent          # "chat" | "recommend"
        self.fragment = fragment      # 영어 5단어 이내 context 요약
        self.reply = reply            # chat일 때만 사용
        self.keywords = keywords or []
        self.count = count            # 추천 곡 수 (기본 5, 최대 10)


# ── Instructions (developer 역할) ──

_INSTRUCTIONS = """\
You are an intent classifier for a music recommendation chatbot.
Given the user message and their context fragments, output ONLY a JSON object (no markdown, no explanation).

Rules:
- If the user is making casual conversation (greeting, question, chitchat): intent = "chat"
- If the user is requesting music recommendations: intent = "recommend"

For "chat":
{
  "intent": "chat",
  "reply": "<short Korean reply, max 100 chars, max 300 if needed>",
  "fragment": "<english context summary, max 5 words>"
}

For "recommend":
{
  "intent": "recommend",
  "keywords": ["keyword1", "keyword2", ...],
  "count": <number of songs requested, default 5, max 10>,
  "fragment": "<english context summary, max 5 words>"
}

Keyword rules:
- Extract keywords ONLY from the current user message
- Keywords describe genre, mood, artist, era, style, or situation
- Keywords must be in English
- Only include keywords that are clearly present — do NOT pad to fill a quota
- If user mentions specific count, use it (cap at 10)
- If user asks for too many, set count to 10

Fragment rules:
- Extract only from what the user actually expressed — do not infer or fabricate from existing context fragments
- Must capture the user's taste, mood, emotion, or situation (e.g. "feeling sad today", "likes jazz piano")
- NEVER include intent or action words (e.g. "wants recommendation", "asked for songs", "requesting music")
- Max 5 English words
- If the message has no meaningful taste/mood/situation info, use empty string ""
"""


def classify_intent(
    user_message: str,
    context_fragments: list[str],
) -> IntentResult:
    """
    유저 메시지를 분류하고 필요한 정보를 추출합니다.
    OpenAI Responses API 사용.

    - context_fragments: 유저의 최근 문맥 fragment 리스트 (최대 20개)
    """
    context_str = ", ".join(context_fragments) if context_fragments else "(none)"

    user_input = (
        f"User context: [{context_str}]\n"
        f"User message: {user_message}"
    )

    try:
        raw = create_text_response(
            instructions=_INSTRUCTIONS,
            input_text=user_input,
            max_output_tokens=1300,
        )
    except OpenAIResponsesError as e:
        logger.error(f"[intent] API 호출 실패: {e}")
        return IntentResult(
            intent="chat",
            reply="죄송해요, 지금 응답이 불안정해요. 잠시 후 다시 말씀해주세요!",
            fragment="",
        )


    try:
        data = json.loads(raw)
    except json.JSONDecodeError as e:
        logger.error(f"[intent] JSON 파싱 실패: {e}")
        logger.error(f"[intent] raw: {raw[:500]}")
        return IntentResult(
            intent="chat",
            reply="죄송해요, 잠시 문제가 있었어요. 다시 말씀해주세요!",
            fragment="",
        )

    intent = data.get("intent", "chat")
    fragment = data.get("fragment", "")

    if intent == "recommend":
        keywords = data.get("keywords", [])
        count = min(data.get("count", 5), 10)
        return IntentResult(
            intent="recommend",
            fragment=fragment,
            keywords=keywords,
            count=count,
        )
    else:
        reply = data.get("reply", "")
        return IntentResult(
            intent="chat",
            fragment=fragment,
            reply=reply,
        )
