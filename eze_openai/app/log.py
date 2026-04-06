"""
OpenAI API 호출 로거.

data/log/openai_{timestamp}.log 파일에 요청/응답을 기록.
noise_filter.py와 동일한 패턴. 앱 기동 시점에 1개 로그 파일 생성.
"""

import logging
from datetime import datetime

from app.config import DATA_DIR

# ── 로거 설정 ──
logger = logging.getLogger("openai_api")
logger.setLevel(logging.DEBUG)

_log_dir = DATA_DIR / "log"
_log_dir.mkdir(parents=True, exist_ok=True)

_log_path = _log_dir / f"openai_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"

_file_handler = logging.FileHandler(str(_log_path), encoding="utf-8")
_file_handler.setFormatter(
    logging.Formatter("%(asctime)s [%(levelname)s] %(message)s", datefmt="%H:%M:%S")
)
logger.addHandler(_file_handler)


def log_request(
    *,
    caller: str,
    model: str,
    instructions: str,
    input_text: str,
    max_output_tokens: int,
) -> None:
    """Responses API 요청 기록."""
    logger.info(f"── REQUEST ({caller}) ──")
    logger.info(f"  model            : {model}")
    logger.info(f"  max_output_tokens: {max_output_tokens}")
    logger.info(f"  instructions     : {instructions[:200]}{'…' if len(instructions) > 200 else ''}")
    logger.info(f"  input            : {input_text[:300]}{'…' if len(input_text) > 300 else ''}")


def log_response(*, caller: str, output_text: str) -> None:
    """Responses API 응답 기록."""
    logger.info(f"── RESPONSE ({caller}) ──")
    logger.info(f"  output: {output_text[:500]}{'…' if len(output_text) > 500 else ''}")
    logger.info("")


def log_error(*, caller: str, error: Exception) -> None:
    """API 호출 실패 기록."""
    logger.error(f"── ERROR ({caller}) ──")
    logger.error(f"  {type(error).__name__}: {error}")
    logger.error("")
