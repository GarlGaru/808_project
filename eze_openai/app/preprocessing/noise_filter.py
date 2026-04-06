"""
GPT를 사용하여 태그의 노이즈 여부를 판별하는 모듈.
1회성 전처리용. scripts/run_noise_filter.py에서 호출.
"""

import json
import logging
from datetime import datetime

import openai

from app.config import OPENAI_API_KEY, CHAT_MODEL, DATA_DIR

# ── 로거 설정 ──
logger = logging.getLogger("noise_filter")
logger.setLevel(logging.DEBUG)

log_dir = DATA_DIR / "log"
log_dir.mkdir(parents=True, exist_ok=True)

_log_path = log_dir / f"noise_filter_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"

_file_handler = logging.FileHandler(str(_log_path), encoding="utf-8")
_file_handler.setFormatter(logging.Formatter("%(message)s"))
logger.addHandler(_file_handler)

_client = openai.OpenAI(api_key=OPENAI_API_KEY)

CLASSIFICATION_PROMPT = """You are a music tag noise filter.
Given a list of tags, determine whether each tag is noise or not.

Valid tags: genre names, artist names, track names, moods, eras, regions.
Noise tags: meaningless strings, gibberish, inside jokes, profanity, random usernames, memes.

Be conservative: if unsure, mark as noise.

Respond ONLY with a JSON array. Each element:
{"tag": "<original tag>", "is_noise": true/false}

No markdown, no explanation. Just the JSON array."""


def classify_tags_batch(tags: list[str], batch_size: int = 50) -> list[dict]:
    """
    태그 리스트의 노이즈 여부를 GPT로 판별.
    batch_size 단위로 나눠서 호출.
    반환: [{"tag": "...", "is_noise": True/False}, ...]
    """
    all_results = []

    for i in range(0, len(tags), batch_size):
        batch = tags[i : i + batch_size]
        tag_list_str = json.dumps(batch, ensure_ascii=False)

        response = _client.chat.completions.create(
            model=CHAT_MODEL,
            messages=[
                {"role": "system", "content": CLASSIFICATION_PROMPT},
                {"role": "user", "content": tag_list_str},
            ],
        )

        content = response.choices[0].message.content.strip()
        if content.startswith("```"):
            content = content.split("\n", 1)[1].rsplit("```", 1)[0]

        try:
            parsed = json.loads(content)
            all_results.extend(parsed)

            # ── 판별 결과 로그 ──
            logger.info(f"=== batch {i // batch_size + 1} ({len(batch)} tags) ===")
            for item in parsed:
                tag = item.get("tag", "?")
                noise = item.get("is_noise", None)
                label = "NOISE" if noise else "OK"
                logger.info(f"  [{label}] {tag}")

            noise_in_batch = sum(1 for x in parsed if x.get("is_noise"))
            ok_in_batch = len(parsed) - noise_in_batch
            logger.info(f"  >> OK: {ok_in_batch}, NOISE: {noise_in_batch}")
            logger.info("")

        except json.JSONDecodeError as e:
            print(f"[warn] batch {i} JSON 파싱 실패: {e}")
            print(f"  raw: {content[:200]}")
            logger.info(f"=== batch {i // batch_size + 1} PARSE FAILED ===")
            logger.info(f"  raw: {content[:500]}")
            logger.info("")

        print(f"  판별 완료: {min(i + batch_size, len(tags))}/{len(tags)}")

    # ── 전체 요약 로그 ──
    total_noise = sum(1 for x in all_results if x.get("is_noise"))
    total_ok = len(all_results) - total_noise
    logger.info("=" * 40)
    logger.info(f"TOTAL: {len(all_results)} tags — OK: {total_ok}, NOISE: {total_noise}")
    logger.info("=" * 40)
    print(f"[noise_filter] 로그 저장: {_log_path}")

    return all_results