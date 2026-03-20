async function loadMainContent(url) {
    const result = document.getElementById("main-content-area");

    try {
        const response = await fetch(url, {
            method: "GET"
        });

        if (!response.ok) {
            result.innerHTML = "불러오기 실패 : " + response.status;
            return;
        }

        const html = await response.text();
        result.innerHTML = html;

        const initFn = result.querySelector('[data-init]')?.dataset.init;
        if (initFn && typeof window[initFn] === 'function') {
            window[initFn]();
        }

    } catch (error) {
        result.innerHTML = "요청 실패";
        console.error(error);
    }
}

const path = window.APP_PATH || '';
const playerRoot = document.getElementById('globalPlayerRoot');

if (!playerRoot) {
    console.error('globalPlayerRoot를 찾지 못했습니다.');
}

const playerManager = playerRoot ? {
    audio: playerRoot.querySelector('#audioPlayer'),
    btnPrev: playerRoot.querySelector('#btnPrev'),
    btnPlayPause: playerRoot.querySelector('#btnPlayPause'),
    btnNext: playerRoot.querySelector('#btnNext'),
    btnLike: playerRoot.querySelector('#btnLike'),
    currentSongIdInput: playerRoot.querySelector('#currentSongId'),
    coverEl: playerRoot.querySelector('#playerCover'),
    titleEl: playerRoot.querySelector('#playerTrackTitle'),
    artistEl: playerRoot.querySelector('#playerTrackArtist'),
    currentTimeEl: playerRoot.querySelector('#currentTime'),
    totalTimeEl: playerRoot.querySelector('#totalTime'),
    progressEl: playerRoot.querySelector('#playerProgress'),
    progressFillEl: playerRoot.querySelector('#playerProgressFill'),
    volumeBarEl: playerRoot.querySelector('#playerVolumeBar'),
    volumeFillEl: playerRoot.querySelector('#playerVolumeFill'),

    playlist: [],
    currentIndex: -1,
    playScoreSent: false,
    intervalScoreSent: false,

    init() {
        if (!this.audio) {
            console.error('audioPlayer를 찾지 못했습니다.');
            return;
        }

        this.audio.volume = 0.7;
        if (this.volumeFillEl) {
            this.volumeFillEl.style.width = '70%';
        }
        this.bindEvents();
    },

    bindEvents() {
        if (this.btnPlayPause) {
            this.btnPlayPause.addEventListener('click', () => {
                if (!this.audio.src) {
                    alert('재생할 곡이 없습니다.');
                    return;
                }

                if (this.audio.paused) {
                    this.audio.play().catch(err => {
                        console.error('재생 실패:', err);
                    });
                } else {
                    this.audio.pause();
                }
            });
        }

        if (this.btnPrev) {
            this.btnPrev.addEventListener('click', () => {
                this.playPrev();
            });
        }

        if (this.btnNext) {
            this.btnNext.addEventListener('click', () => {
                this.playNext();
            });
        }

        if (this.btnLike) {
            this.btnLike.addEventListener('click', () => {
                this.likeCurrentSong();
            });
        }

        this.audio.addEventListener('play', () => {
            if (this.btnPlayPause) {
                this.btnPlayPause.textContent = '⏸';
            }

            if (!this.playScoreSent && this.getCurrentSongId()) {
                this.sendScore(path + '/music/playScore');
                this.playScoreSent = true;
            }
        });

        this.audio.addEventListener('pause', () => {
            if (this.btnPlayPause) {
                this.btnPlayPause.textContent = '▶';
            }
        });

        this.audio.addEventListener('loadedmetadata', () => {
            if (this.totalTimeEl) {
                this.totalTimeEl.textContent = this.formatTime(this.audio.duration);
            }
        });

        this.audio.addEventListener('timeupdate', () => {
            if (this.currentTimeEl) {
                this.currentTimeEl.textContent = this.formatTime(this.audio.currentTime);
            }

            if (this.audio.duration && this.progressFillEl) {
                const percent = (this.audio.currentTime / this.audio.duration) * 100;
                this.progressFillEl.style.width = percent + '%';
            }

            if (!this.intervalScoreSent && this.audio.currentTime >= 30 && this.getCurrentSongId()) {
                this.sendScore(path + '/music/intervalScore');
                this.intervalScoreSent = true;
            }
        });

        this.audio.addEventListener('ended', () => {
            this.playNext();
        });

        if (this.progressEl) {
            this.progressEl.addEventListener('click', (e) => {
                const rect = this.progressEl.getBoundingClientRect();
                const ratio = (e.clientX - rect.left) / rect.width;

                if (this.audio.duration) {
                    this.audio.currentTime = this.audio.duration * ratio;
                }
            });
        }

        if (this.volumeBarEl) {
            this.volumeBarEl.addEventListener('click', (e) => {
                const rect = this.volumeBarEl.getBoundingClientRect();
                let ratio = (e.clientX - rect.left) / rect.width;
                ratio = Math.max(0, Math.min(1, ratio));

                this.audio.volume = ratio;
                if (this.volumeFillEl) {
                    this.volumeFillEl.style.width = (ratio * 100) + '%';
                }
            });
        }
    },

    formatTime(sec) {
        sec = Math.floor(sec || 0);
        const m = Math.floor(sec / 60);
        let s = sec % 60;
        if (s < 10) s = '0' + s;
        return m + ':' + s;
    },

    getCurrentSongId() {
        return this.currentSongIdInput ? this.currentSongIdInput.value : '';
    },

    setPlaylist(list) {
        this.playlist = Array.isArray(list) ? list : [];
    },

    async playByButton(btn) {
        console.log('재생 버튼 클릭 dataset:', btn.dataset);

        const scope = btn.closest('[data-playlist-scope]');
        const playlist = this.extractPlaylist(scope);
        const songId = String(btn.dataset.songId || '');

        if (!songId) {
            alert('곡 정보가 올바르지 않습니다.');
            return;
        }

        if (playlist.length > 0) {
            this.setPlaylist(playlist);
            this.currentIndex = playlist.findIndex(song => String(song.songId) === songId);
        } else {
            this.setPlaylist([]);
            this.currentIndex = -1;
        }

        const song = {
            songId: songId,
            title: btn.dataset.title || '',
            artistName: btn.dataset.artist || '',
            coverImageUrl: btn.dataset.cover || ''
        };

        console.log('재생할 song 객체:', song);

        await this.loadAndPlay(song);
    },

    extractPlaylist(scopeEl) {
        if (!scopeEl) return [];

        const buttons = scopeEl.querySelectorAll('.js-play-song');
        return Array.from(buttons).map(btn => ({
            songId: btn.dataset.songId || '',
            title: btn.dataset.title || '',
            artistName: btn.dataset.artist || '',
            coverImageUrl: btn.dataset.cover || ''
        }));
    },

    async loadAndPlay(song) {
        try {
            console.log('loadAndPlay 시작:', song);

            const songPath = await this.fetchSongPath(song.songId);
            console.log('songPath 최종값:', songPath);

            if (!songPath || songPath.trim() === '') {
                alert('이 곡의 재생 파일 경로가 없습니다.');
                return;
            }

            this.setSong({
                ...song,
                songPath: songPath
            });

            console.log('audio.src 세팅 후:', this.audio.src);

            await this.audio.play();
            console.log('audio.play 성공');
        } catch (e) {
            console.error('loadAndPlay 오류:', e);
            alert('곡 경로를 불러오지 못했습니다.');
        }
    },

    setSong(song) {
        if (this.currentSongIdInput) {
            this.currentSongIdInput.value = song.songId || '';
        }

        if (this.titleEl) {
            this.titleEl.textContent = song.title || '제목 없음';
        }

        if (this.artistEl) {
            this.artistEl.textContent = song.artistName || '-';
        }

        let coverSrc = path + '/resources/music/img/default_album.jpg';
        if (song.coverImageUrl) {
            if (song.coverImageUrl.startsWith('http')) {
                coverSrc = song.coverImageUrl;
            } else if (song.coverImageUrl.startsWith(path)) {
                coverSrc = song.coverImageUrl;
            } else {
                coverSrc = path + song.coverImageUrl;
            }
        }

        if (this.coverEl) {
            this.coverEl.src = coverSrc;
        }

        this.playScoreSent = false;
        this.intervalScoreSent = false;

        this.audio.pause();

        let finalSongPath = song.songPath || '';
        if (finalSongPath.startsWith('http')) {
            // 그대로 사용
        } else if (finalSongPath.startsWith(path)) {
            // 그대로 사용
        } else {
            finalSongPath = path + finalSongPath;
        }

        console.log('최종 오디오 경로:', finalSongPath);

        this.audio.src = finalSongPath;
        this.audio.load();

        if (this.currentTimeEl) {
            this.currentTimeEl.textContent = '0:00';
        }
        if (this.totalTimeEl) {
            this.totalTimeEl.textContent = '0:00';
        }
        if (this.progressFillEl) {
            this.progressFillEl.style.width = '0%';
        }
        if (this.btnPlayPause) {
            this.btnPlayPause.textContent = '▶';
        }
    },

    async fetchSongPath(songId) {
        console.log('songPath 요청 songId:', songId);

        const response = await fetch(path + '/music/songPath?songId=' + encodeURIComponent(songId), {
            method: 'GET'
        });

        if (!response.ok) {
            throw new Error('songPath fetch failed: ' + response.status);
        }

        const result = (await response.text()).trim();
        console.log('songPath 응답값:', result);

        return result;
    },

    sendScore(url) {
        const songId = this.getCurrentSongId();
        console.log('sendScore 호출됨', url, songId);
        if (!songId) return;

        $.ajax({
            url: url,
            type: 'GET',
            data: { songId: songId },
            success: function(res) {
                console.log('score result:', res);
            },
            error: function() {
                console.log('score ajax error');
            }
        });
    },

    likeCurrentSong() {
        const songId = this.getCurrentSongId();
        if (!songId) {
            alert('좋아요를 누를 곡이 없습니다.');
            return;
        }

        $.ajax({
            url: path + '/music/likeScore',
            type: 'GET',
            data: { songId: songId },
            success: (res) => {
                if (res === 'success') {
                    if (this.btnLike) {
                        this.btnLike.textContent = '♥';
                    }
                } else if (res === 'noLogin') {
                    alert('로그인 후 이용해주세요.');
                }
            },
            error: function() {
                alert('좋아요 처리 중 오류가 발생했습니다.');
            }
        });
    },

    playPrev() {
        if (this.playlist.length === 0) return;
        if (this.currentIndex <= 0) return;

        this.currentIndex--;
        this.loadAndPlay(this.playlist[this.currentIndex]);
    },

    playNext() {
        if (this.playlist.length === 0) return;
        if (this.currentIndex < 0) return;
        if (this.currentIndex >= this.playlist.length - 1) return;

        this.currentIndex++;
        this.loadAndPlay(this.playlist[this.currentIndex]);
    }
} : null;

document.addEventListener('click', function(e) {
    const playBtn = e.target.closest('.js-play-song');
    if (!playBtn) return;
    if (!playerManager) return;

    e.preventDefault();
    e.stopPropagation();

    console.log('mainstory play clicked', playBtn.dataset);

    playerManager.playByButton(playBtn);
});

window.addEventListener('DOMContentLoaded', function() {
    if (playerManager) {
        playerManager.init();
    }
});