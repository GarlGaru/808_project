/**
 * MusicSlider
 * - recommend.jsp 안의 <template id="music-slider-template"> 을 복제해 DOM에 마운트합니다.
 * - REST API에서 곡 목록을 받아 카드를 동적으로 생성합니다.
 *
 * @param {Object} options
 * @param {string} options.mountId  - 마운트할 요소의 id, 슬라이드 넣을 곳
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

    
    /* ── 5 -> 0. REST API로 일단 데이터 있는지부터 검사 ─────────────────────────────── */
    const songs = await getSongList(apiUrl);
    if (!songs.length) {
        // 아얘 표시 안함
        return;
    }


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

    // /* ── 5. REST API로 데이터 로드 ─────────────────────────────── */
    // const songs = await getSongList(apiUrl);

    /* ── 6. 카드 렌더링 ────────────────────────────────────────── */
    // if (!songs.length) {
    //     empty.style.display               = '';
    //     track.parentElement.style.display = 'none';
    //     empty.textContent                 = `${title} 데이터가 없습니다.`;
    //     return;
    // }

    const cardBase = cardTpl.content.firstElementChild;

    songs.forEach(song => {
        // console.log(song);
        track.appendChild(createCard(cardBase, song, path, label));
    });

    /* ── 7. 카드 클릭 & 재생 버튼 이벤트 위임 ──────────────────── */
    track.addEventListener('click', (e) => {
        // 아티스트 버튼
        const artistBtn = e.target.closest('.music-artist-link');
        if (artistBtn) {
            e.stopPropagation();
            loadMainContent(`${path}/music/artist?artistId=${artistBtn.dataset.artistId}`);
            return;
        }
        
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



async function getSongList(apiUrl) {
    let songs = [];
    try {
        const res = await fetch(apiUrl);
        if (!res.ok) throw new Error(`API 오류: ${res.status}`);
        songs = await res.json();
    } catch (err) {
        console.error(`[MusicSlider] API 호출 오류 (${apiUrl})`, err);
    }
    return songs;
}





/**
 * musicCard.js
 * 카드 뼈대(#music-card-template)를 cloneNode로 복제한 뒤 곡 데이터를 채워 반환합니다.
 *
 * @param {Element} cardBase - <template id="music-card-template">의 firstElementChild
 * @param {Object}  song     - API 응답 곡 데이터
 * @param {string}  path     - 컨텍스트 루트 경로
 * @param {string}  label    - 카드 하단 라벨 텍스트
 * @returns {Element}
 */
function createCard(cardBase, song, path, label) {
    const card = cardBase.cloneNode(true);

    const cover = song.coverImageUrl
        ? `${song.coverImageUrl}`
        : `${path}/resources/music/img/default_album.png`;

    // 카드 루트
    card.dataset.songId = song.songId;

    // 썸네일
    const img = card.querySelector('.music-home-thumb');
    img.src = cover;
    img.alt = song.title;

    // 재생 버튼
    const playBtn = card.querySelector('.js-play-song');
    playBtn.dataset.songId = song.songId;
    playBtn.dataset.title  = song.title;
    playBtn.dataset.artist = song.artistName;
    playBtn.dataset.cover  = cover;
    playBtn.setAttribute('aria-label', `${song.title} 재생`);

    // 제목 / 라벨
    card.querySelector('[data-slot="title"]').textContent = song.title;
    card.querySelector('[data-slot="label"]').textContent = label;

    // 아티스트 버튼
    const artistBtn = card.querySelector('[data-slot="artist"]');
    artistBtn.textContent = song.artistName;
    artistBtn.dataset.artistId = song.artistId;
    artistBtn.type = 'button';

    return card;
}
