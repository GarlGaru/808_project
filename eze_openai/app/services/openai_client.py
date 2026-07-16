"""
OpenAI Responses API 공통 래퍼.

챗봇의 intent 분류 / 추천 문구 생성에서 공통으로 사용한다.
"""

from __future__ import annotations

import httpx
import openai

from app.config import OPENAI_API_KEY, CHAT_MODEL
from app.log import log_request, log_response, log_error


class OpenAIResponsesError(RuntimeError):
    """Responses API 호출 실패를 서비스 레이어에서 일관되게 처리하기 위한 예외."""


_client = openai.OpenAI(
    api_key=OPENAI_API_KEY,
    max_retries=5,
    timeout=httpx.Timeout(30.0, connect=5.0, read=25.0, write=10.0),
)


def create_text_response(
    *,
    instructions: str,
    input_text: str,
    max_output_tokens: int,
    model: str = CHAT_MODEL,
) -> str:
    """Responses API를 호출하고 output_text를 반환한다."""
    log_request(
        caller="create_text_response",
        model=model,
        instructions=instructions,
        input_text=input_text,
        max_output_tokens=max_output_tokens,
    )
    print("Asking AI : ", input_text)
    try:
        response = _client.responses.create(
            model=model,
            instructions=instructions,
            input=input_text,
            max_output_tokens=max_output_tokens,
            reasoning={"effort": "low"},
        )
        print("AI response : ", response)
    except openai.APIConnectionError as exc:
        log_error(caller="create_text_response", error=exc)
        raise OpenAIResponsesError("OpenAI connection failed") from exc
    except openai.APIStatusError as exc:
        log_error(caller="create_text_response", error=exc)
        status_code = getattr(exc, "status_code", "unknown")
        request_id = getattr(exc, "request_id", None)
        raise OpenAIResponsesError(
            f"OpenAI Responses API failed with status={status_code}, request_id={request_id}"
        ) from exc
    except Exception as exc:
        log_error(caller="create_text_response", error=exc)
        raise OpenAIResponsesError("OpenAI Responses API failed unexpectedly") from exc

    # ── incomplete 먼저 체크 (reasoning에 토큰을 다 쓰면 output이 잘림) ──
    status = getattr(response, "status", None)
    if status == "incomplete":
        reason = getattr(response, "incomplete_details", None)
        log_error(
            caller="create_text_response",
            error=OpenAIResponsesError(f"incomplete — {reason}"),
        )
        raise OpenAIResponsesError(
            f"OpenAI response was incomplete: {reason}"
        )

    output_text = (response.output_text or "").strip()
    if output_text:
        log_response(caller="create_text_response", output_text=output_text)
        return output_text

    log_error(caller="create_text_response", error=OpenAIResponsesError("empty"))
    raise OpenAIResponsesError("OpenAI response text was empty")
