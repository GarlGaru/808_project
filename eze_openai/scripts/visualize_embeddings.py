"""
임베딩 벡터를 2D 산점도로 시각화하는 스크립트.
t-SNE로 1536차원 → 2차원 축소 후 인터랙티브 HTML 생성.

사용법:
  python -m scripts.visualize_embeddings
  python -m scripts.visualize_embeddings --output my_chart.html
"""

import json
import argparse
import numpy as np

from app.config import EMBEDDINGS_NPY_PATH, SONG_IDS_JSON_PATH, DATA_DIR


def reduce_to_2d(embeddings: np.ndarray) -> np.ndarray:
    """t-SNE로 2차원 축소"""
    from sklearn.manifold import TSNE

    print("[viz] t-SNE 차원 축소 중... (1~2분 소요될 수 있음)")
    tsne = TSNE(
        n_components=2,
        perplexity=min(30, len(embeddings) - 1),
        random_state=42,
        max_iter=1000,
    )
    return tsne.fit_transform(embeddings)


def build_html(points_2d: np.ndarray, song_ids: list[int]) -> str:
    """인터랙티브 산점도 HTML 생성"""
    data_points = []
    for i, sid in enumerate(song_ids):
        data_points.append({
            "x": round(float(points_2d[i][0]), 4),
            "y": round(float(points_2d[i][1]), 4),
            "song_id": sid,
            "index": i,
        })

    data_json = json.dumps(data_points, ensure_ascii=False)

    return f"""<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>eze-ai embedding visualization</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;600&family=Noto+Sans+KR:wght@300;500&display=swap');

  * {{ margin: 0; padding: 0; box-sizing: border-box; }}

  body {{
    background: #0a0a0f;
    color: #e0e0e0;
    font-family: 'Noto Sans KR', sans-serif;
    font-weight: 300;
    overflow: hidden;
    height: 100vh;
  }}

  .header {{
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 100;
    padding: 16px 24px;
    background: linear-gradient(to bottom, rgba(10,10,15,0.95), rgba(10,10,15,0));
    pointer-events: none;
  }}

  .header h1 {{
    font-family: 'JetBrains Mono', monospace;
    font-size: 14px;
    font-weight: 600;
    color: #7b8cff;
    letter-spacing: 2px;
    text-transform: uppercase;
  }}

  .header .stats {{
    font-family: 'JetBrains Mono', monospace;
    font-size: 11px;
    color: #555;
    margin-top: 4px;
  }}

  canvas {{
    display: block;
    cursor: crosshair;
  }}

  .tooltip {{
    position: fixed;
    display: none;
    background: rgba(20, 20, 30, 0.95);
    border: 1px solid #333;
    border-radius: 6px;
    padding: 10px 14px;
    font-family: 'JetBrains Mono', monospace;
    font-size: 12px;
    pointer-events: none;
    z-index: 200;
    backdrop-filter: blur(8px);
  }}

  .tooltip .label {{ color: #666; font-size: 10px; }}
  .tooltip .value {{ color: #7b8cff; margin-top: 2px; }}

  .controls {{
    position: fixed;
    bottom: 16px;
    right: 16px;
    display: flex;
    gap: 8px;
    z-index: 100;
  }}

  .controls button {{
    font-family: 'JetBrains Mono', monospace;
    font-size: 11px;
    padding: 6px 12px;
    background: rgba(30, 30, 45, 0.9);
    color: #888;
    border: 1px solid #333;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.2s;
  }}

  .controls button:hover {{
    color: #7b8cff;
    border-color: #7b8cff;
  }}
</style>
</head>
<body>

<div class="header">
  <h1>eze-ai embeddings</h1>
  <div class="stats">{len(song_ids)} songs · t-SNE 2D projection</div>
</div>

<canvas id="canvas"></canvas>

<div class="tooltip" id="tooltip">
  <div class="label">song_id</div>
  <div class="value" id="tip-id"></div>
  <div class="label" style="margin-top:6px">index</div>
  <div class="value" id="tip-idx"></div>
  <div class="label" style="margin-top:6px">position</div>
  <div class="value" id="tip-pos"></div>
</div>

<div class="controls">
  <button onclick="resetView()">reset</button>
</div>

<script>
const DATA = {data_json};

const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');
const tooltip = document.getElementById('tooltip');
const tipId = document.getElementById('tip-id');
const tipIdx = document.getElementById('tip-idx');
const tipPos = document.getElementById('tip-pos');

let width, height;
let offsetX = 0, offsetY = 0, scale = 1;
let dragging = false, lastMouse = {{ x: 0, y: 0 }};
let hoveredPoint = null;

// 데이터 범위 계산
const xs = DATA.map(d => d.x);
const ys = DATA.map(d => d.y);
const minX = Math.min(...xs), maxX = Math.max(...xs);
const minY = Math.min(...ys), maxY = Math.max(...ys);
const rangeX = maxX - minX || 1;
const rangeY = maxY - minY || 1;
const padding = 60;

function resize() {{
  width = canvas.width = window.innerWidth;
  height = canvas.height = window.innerHeight;
  draw();
}}

function toScreen(x, y) {{
  const sx = padding + ((x - minX) / rangeX) * (width - padding * 2);
  const sy = padding + ((y - minY) / rangeY) * (height - padding * 2);
  return {{
    x: (sx - width / 2) * scale + width / 2 + offsetX,
    y: (sy - height / 2) * scale + height / 2 + offsetY,
  }};
}}

function draw() {{
  ctx.clearRect(0, 0, width, height);

  // 점 그리기
  const radius = Math.max(2, 3 * scale);

  for (let i = 0; i < DATA.length; i++) {{
    const d = DATA[i];
    const p = toScreen(d.x, d.y);

    if (p.x < -20 || p.x > width + 20 || p.y < -20 || p.y > height + 20) continue;

    const isHovered = hoveredPoint === i;

    ctx.beginPath();
    ctx.arc(p.x, p.y, isHovered ? radius * 2.5 : radius, 0, Math.PI * 2);

    if (isHovered) {{
      ctx.fillStyle = '#7b8cff';
      ctx.shadowColor = '#7b8cff';
      ctx.shadowBlur = 12;
    }} else {{
      const alpha = 0.4 + 0.3 * scale;
      ctx.fillStyle = `rgba(123, 140, 255, ${{Math.min(alpha, 0.7)}})`;
      ctx.shadowBlur = 0;
    }}

    ctx.fill();
    ctx.shadowBlur = 0;
  }}
}}

function findNearest(mx, my, threshold) {{
  let best = -1, bestDist = threshold * threshold;
  for (let i = 0; i < DATA.length; i++) {{
    const p = toScreen(DATA[i].x, DATA[i].y);
    const dx = p.x - mx, dy = p.y - my;
    const dist = dx * dx + dy * dy;
    if (dist < bestDist) {{ bestDist = dist; best = i; }}
  }}
  return best;
}}

canvas.addEventListener('mousemove', (e) => {{
  if (dragging) {{
    offsetX += e.clientX - lastMouse.x;
    offsetY += e.clientY - lastMouse.y;
    lastMouse = {{ x: e.clientX, y: e.clientY }};
    draw();
    return;
  }}

  const idx = findNearest(e.clientX, e.clientY, 15 / scale + 10);
  if (idx >= 0) {{
    hoveredPoint = idx;
    const d = DATA[idx];
    tipId.textContent = d.song_id;
    tipIdx.textContent = d.index;
    tipPos.textContent = `(${{d.x}}, ${{d.y}})`;

    let tx = e.clientX + 16;
    let ty = e.clientY - 10;
    if (tx + 180 > width) tx = e.clientX - 180;
    if (ty + 100 > height) ty = e.clientY - 100;

    tooltip.style.left = tx + 'px';
    tooltip.style.top = ty + 'px';
    tooltip.style.display = 'block';
  }} else {{
    hoveredPoint = null;
    tooltip.style.display = 'none';
  }}
  draw();
}});

canvas.addEventListener('mousedown', (e) => {{
  dragging = true;
  lastMouse = {{ x: e.clientX, y: e.clientY }};
  canvas.style.cursor = 'grabbing';
}});

canvas.addEventListener('mouseup', () => {{
  dragging = false;
  canvas.style.cursor = 'crosshair';
}});

canvas.addEventListener('wheel', (e) => {{
  e.preventDefault();
  const factor = e.deltaY > 0 ? 0.9 : 1.1;
  const newScale = Math.max(0.3, Math.min(scale * factor, 20));

  // 마우스 위치 기준 줌
  const mx = e.clientX, my = e.clientY;
  offsetX = mx - (mx - offsetX) * (newScale / scale);
  offsetY = my - (my - offsetY) * (newScale / scale);
  scale = newScale;

  draw();
}}, {{ passive: false }});

function resetView() {{
  offsetX = 0; offsetY = 0; scale = 1;
  draw();
}}

window.addEventListener('resize', resize);
resize();
</script>
</body>
</html>"""


def main():
    parser = argparse.ArgumentParser(description="임베딩 2D 산점도 시각화")
    parser.add_argument("--output", type=str, default="embedding_viz.html", help="출력 HTML 파일명")
    args = parser.parse_args()

    if not EMBEDDINGS_NPY_PATH.exists() or not SONG_IDS_JSON_PATH.exists():
        print("[error] 임베딩 파일이 없습니다. run_embed.py를 먼저 실행하세요.")
        return

    embeddings = np.load(str(EMBEDDINGS_NPY_PATH))
    with open(SONG_IDS_JSON_PATH, "r") as f:
        song_ids = json.load(f)

    print(f"[viz] 로드 완료: {len(song_ids)}곡, shape={embeddings.shape}")

    points_2d = reduce_to_2d(embeddings)

    output_path = DATA_DIR / args.output
    html = build_html(points_2d, song_ids)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(html)

    print(f"[viz] 저장 완료: {output_path}")
    print(f"  브라우저에서 열어보세요.")


if __name__ == "__main__":
    main()