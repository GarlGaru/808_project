import openai
import numpy as np

from app.config import OPENAI_API_KEY, EMBEDDING_MODEL

_client = openai.OpenAI(api_key=OPENAI_API_KEY)


def embed_text(text: str) -> np.ndarray:
    """텍스트 1개를 임베딩하여 numpy 배열로 반환"""
    response = _client.embeddings.create(
        model=EMBEDDING_MODEL,
        input=text,
    )
    return np.array(response.data[0].embedding, dtype=np.float32)


def embed_texts(texts: list[str]) -> np.ndarray:
    """텍스트 여러 개를 배치 임베딩. shape (len(texts), D)"""
    response = _client.embeddings.create(
        model=EMBEDDING_MODEL,
        input=texts,
    )
    return np.array(
        [item.embedding for item in response.data],
        dtype=np.float32,
    )
