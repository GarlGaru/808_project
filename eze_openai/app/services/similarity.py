import numpy as np


def cosine_similarity_batch(
    query_vec: np.ndarray,
    matrix: np.ndarray,
) -> np.ndarray:
    """
    query_vec: shape (D,)
    matrix:    shape (N, D)
    returns:   shape (N,) — 각 곡과의 cosine similarity
    """
    query_norm = query_vec / (np.linalg.norm(query_vec) + 1e-10)
    matrix_norms = matrix / (np.linalg.norm(matrix, axis=1, keepdims=True) + 1e-10)
    return matrix_norms @ query_norm
