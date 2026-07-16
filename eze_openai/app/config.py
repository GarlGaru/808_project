import os
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

# ── Paths ──
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"

SQLITE_DB_PATH = DATA_DIR / "metadata.db"
EMBEDDINGS_NPY_PATH = DATA_DIR / "song_embeddings.npy"
SONG_IDS_JSON_PATH = DATA_DIR / "song_ids.json"

# ── OpenAI ──
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
EMBEDDING_MODEL = "text-embedding-3-small"
CHAT_MODEL = "gpt-5-nano"

# ── Oracle (전처리 스크립트용) ──
ORACLE_DSN = os.getenv("ORACLE_DSN", "")
ORACLE_USER = os.getenv("ORACLE_USER", "")
ORACLE_PASSWORD = os.getenv("ORACLE_PASSWORD", "")

# ── Spring Backend ──
SPRING_API_BASE_URL = os.getenv("SPRING_API_BASE_URL", "http://localhost:8080")

# ── FastAPI ──
SIMILAR_TOP_N_DEFAULT = 20
