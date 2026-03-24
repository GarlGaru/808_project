/**
 * MusicSlider
 * - recommend.jsp 안의 <template id="music-slider-template"> 을 복제해 DOM에 마운트합니다.
 * - REST API에서 곡 목록을 받아 카드를 동적으로 생성합니다.
 *
 * @param {Object} options
 * @param {string} options.mountId  - 마운트할 요소의 id
 * @param {string} options.title    - 섹션 제목
 * @param {string} options.subtitle - 섹션 부제목
 * @param {string} options.apiUrl   - 곡 목록을 반환하는 REST API URL
 * @param {string} options.sliderId - viewport 고유 id (moveSlider 연동용)
 * @param {string} options.path     - 컨텍스트 루트 경로 (ex. "/myapp")
 * @param {string} options.label    - 카드 하단 라벨 텍스트
 */
async function MusicSlider({
    mountId,
    title,
    subtitle,
    apiUrl,
    sliderId,
    path = '',
    label = '',
}) {
    /* ── 1. <template> 에서 뼈대 복제 ─────────────────────────── */
    const sliderTpl = document.getElementById('music-slider-template');
    const cardTpl   = document.getElementById('music-card-template');

    if (!sliderTpl || !cardTpl) {
        console.error('[MusicSlider] template 요소를 찾을 수 없습니다.');
        return;
    }

    /* ── 2. 마운트 포인트에 슬라이더 삽입 ─────────────────────── */
    const mount = document.getElementById(mountId);
    if (!mount) {
        console.error(`[MusicSlider] 마운트 포인트를 찾을 수 없습니다: #${mountId}`);
        return;
    }
    mount.appendChild(sliderTpl.content.cloneNode(true));

    /* ── 3. 슬롯 채우기 ────────────────────────────────────────── */
    mount.querySelector('[data-slot="title"]').textContent    = title;
    mount.querySelector('[data-slot="subtitle"]').textContent = subtitle;

    const viewport = mount.querySelector('[data-slot="viewport"]');
    const track    = mount.querySelector('[data-slot="track"]');
    const empty    = mount.querySelector('[data-slot="empty"]');

    // viewport 고유 id 부여 (moveSlider 연동용)
    viewport.id = sliderId;

    // aria-label 갱신
    mount.querySelector('[data-action="prev"]').setAttribute('aria-label', `${title} 이전`);
    mount.querySelector('[data-action="next"]').setAttribute('aria-label', `${title} 다음`);

    /* ── 4. 슬라이더 버튼 이벤트 ──────────────────────────────── */
    mount.querySelector('[data-action="prev"]')
         .addEventListener('click', () => moveSlider(sliderId, -1));
    mount.querySelector('[data-action="next"]')
         .addEventListener('click', () => moveSlider(sliderId,  1));

    /* ── 5. REST API로 데이터 로드 ─────────────────────────────── */
    const songs = await getSongList(apiUrl);

    /* ── 6. 카드 렌더링 ────────────────────────────────────────── */
    if (!songs.length) {
        empty.style.display               = '';
        track.parentElement.style.display = 'none';
        empty.textContent                 = `${title} 데이터가 없습니다.`;
        return;
    }

    const cardBase = cardTpl.content.firstElementChild;

    songs.forEach(song => {
        // console.log(song);
        track.appendChild(createCard(cardBase, song, path, label));
    });

    /* ── 7. 카드 클릭 & 재생 버튼 이벤트 위임 ──────────────────── */
    track.addEventListener('click', (e) => {
        // 재생 버튼
        const playBtn = e.target.closest('.js-play-song');
        if (playBtn) {
            e.stopPropagation();
            const { songId, title: t, artist, cover } = playBtn.dataset;
            playSong({ songId, title: t, artist, cover });
            return;
        }

        // 카드 전체 클릭 → 상세 페이지 이동
        const card = e.target.closest('.music-home-card');
        if (card) {
            loadMainContent(`${path}/music/detail?songId=${card.dataset.songId}`);
        }
    });
}
