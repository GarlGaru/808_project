function getCoverSrc(song) {
    const path = window.APP_PATH || '';

    if (!song.coverImageUrl) {
        return path + '/resources/music/img/default_album.png';
    }

    if (song.coverImageUrl.startsWith('http')) {
        return song.coverImageUrl;
    }

    if (song.coverImageUrl.startsWith(path)) {
        return song.coverImageUrl;
    }

    return path + song.coverImageUrl;
}

function escapeHtml(value) {
    if (value === null || value === undefined) return '';

    return String(value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

export function renderLikeSongs(songList) {
    const path = window.APP_PATH || '';
    const mainContent = document.getElementById('main-content-area');

    if (!mainContent) {
        console.error('main-content-area를 찾지 못했습니다.');
        return;
    }

    if (!Array.isArray(songList) || songList.length === 0) {
        mainContent.innerHTML = `
            <section class="music-liked-page">
                <div class="music-liked-hero">
                    <div class="music-liked-hero-cover">
                        <div class="music-liked-hero-cover--placeholder">♪</div>
                    </div>

                    <div class="music-liked-hero-info">
                        <div class="music-liked-hero-type">좋아요 플레이리스트</div>
                        <h1 class="music-liked-hero-title">좋아요한 곡</h1>
                        <div class="music-liked-hero-meta">
                            <strong>내 플레이리스트</strong>
                            <span>•</span>
                            <span>곡 0개</span>
                        </div>
                    </div>
                </div>

                <div class="music-liked-toolbar">
                    <div class="music-liked-toolbar-left">
                        <button type="button" class="music-liked-toolbar-icon">+</button>
                        <button type="button" class="music-liked-toolbar-icon">…</button>
                    </div>
                    <div class="music-liked-toolbar-right">
                        <span class="music-liked-toolbar-view">목록</span>
                    </div>
                </div>

                <div class="music-liked-empty">
                    아직 좋아요한 곡이 없습니다.
                </div>
            </section>
        `;
        return;
    }

    const rowsHtml = songList.map((song, index) => {
        const songId = escapeHtml(song.songId);
        const artistId = escapeHtml(song.artistId);
        const title = escapeHtml(song.title || '');
        const artistName = escapeHtml(song.artistName || '');
        const albumTitle = escapeHtml(song.albumTitle || '');
        const genreName = escapeHtml(song.genreName || '');
        const coverSrc = escapeHtml(getCoverSrc(song));
        const rawCover = escapeHtml(song.coverImageUrl || '/resources/music/img/default_album.png');

        return `
            <tr onclick="loadMainContent('${path}/music/detail?songId=${songId}')">
                <td>
                    <span class="music-liked-rank">${index + 1}</span>
                </td>

                <td>
                    <div class="music-liked-song-cell">
                        <img class="music-liked-song-cover"
                             src="${coverSrc}"
                             alt="${title}">
                        <div class="music-liked-song-text">
                            <div class="music-liked-song-name">${title}</div>
                            <div class="music-liked-song-sub">좋아요한 곡</div>
                        </div>
                    </div>
                </td>

                <td>
                    <button type="button"
                            class="music-liked-artist-link"
                            onclick="event.stopPropagation(); loadMainContent('${path}/music/artist?artistId=${artistId}')">
                        ${artistName}
                    </button>
                </td>

                <td class="music-liked-album-cell">
                    <div class="music-liked-album-text">${albumTitle}</div>
                </td>

                <td class="music-liked-genre-cell">
                    <div class="music-liked-genre-text">${genreName}</div>
                </td>

                <td class="music-liked-play-cell">
                    <button type="button"
                            class="music-liked-play-btn js-play-song"
                            onclick="event.stopPropagation(); playerManager.playByButton(this);"
                            data-song-id="${songId}"
                            data-title="${title}"
                            data-artist="${artistName}"
                            data-cover="${rawCover}">
                        ▶
                    </button>
                </td>
            </tr>
        `;
    }).join('');

    mainContent.innerHTML = `
        <section class="music-liked-page">
            <div class="music-liked-hero">
                <div class="music-liked-hero-cover">
                    <div class="music-liked-hero-cover--placeholder">♥</div>
                </div>

                <div class="music-liked-hero-info">
                    <div class="music-liked-hero-type">좋아요 플레이리스트</div>
                    <h1 class="music-liked-hero-title">좋아요 표시한 곡</h1>
                    <div class="music-liked-hero-meta">
                        <strong>내 플레이리스트</strong>
                        <span>•</span>
                        <span>곡 ${songList.length}개</span>
                    </div>
                </div>
            </div>

        	<br/>

            <div class="music-liked-content">
                <table class="music-liked-table">
                    <thead>
                        <tr>
                            <th class="col-num">#</th>
                            <th class="col-title">제목</th>
                            <th class="col-artist">아티스트</th>
                            <th class="col-album">앨범</th>
                            <th class="col-genre">#해시태그</th>
                            <th class="col-play">재생</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${rowsHtml}
                    </tbody>
                </table>
            </div>
        </section>
    `;
}