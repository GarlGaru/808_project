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
        ? `${path}${song.coverImageUrl}`
        : `${path}/resources/music/img/default_album.jpg`;

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

    // 텍스트 슬롯
    card.querySelector('[data-slot="title"]').textContent  = song.title;
    card.querySelector('[data-slot="artist"]').textContent = song.artistName;
    card.querySelector('[data-slot="label"]').textContent  = label;

    return card;
}