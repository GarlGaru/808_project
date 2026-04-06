import numpy as np


class AppState:
    song_ids: list[int] = []
    embeddings: np.ndarray | None = None


state = AppState()