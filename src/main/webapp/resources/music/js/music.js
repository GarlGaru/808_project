
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
	
	    } catch (error) {
	        result.innerHTML = "요청 실패";
	        console.error(error);
	    }
	}


	const path = '${path}';
	
	const playerRoot = document.getElementById('globalPlayerRoot');
	
	const playerManager = {
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
	        this.audio.volume = 0.7;
	        this.volumeFillEl.style.width = '70%';
	        this.bindEvents();
	    },
	
	    bindEvents() {
	        this.btnPlayPause.addEventListener('click', () => {
	            if (!this.audio.src) {
	                alert('재생할 곡이 없습니다.');
	                return;
	            }
	
	            if (this.audio.paused) {
	                this.audio.play();
	            } else {
	                this.audio.pause();
	            }
	        });
	
	        this.btnPrev.addEventListener('click', () => {
	            this.playPrev();
	        });
	
	        this.btnNext.addEventListener('click', () => {
	            this.playNext();
	        });
	
	        this.btnLike.addEventListener('click', () => {
	            this.likeCurrentSong();
	        });
	
	        this.audio.addEventListener('play', () => {
	            this.btnPlayPause.textContent = '⏸';
	
	            if (!this.playScoreSent && this.getCurrentSongId()) {
	                this.sendScore(path + '/music/playScore');
	                this.playScoreSent = true;
	            }
	        });
	
	        this.audio.addEventListener('pause', () => {
	            this.btnPlayPause.textContent = '▶';
	        });
	
	        this.audio.addEventListener('loadedmetadata', () => {
	            this.totalTimeEl.textContent = this.formatTime(this.audio.duration);
	        });
	
	        this.audio.addEventListener('timeupdate', () => {
	            this.currentTimeEl.textContent = this.formatTime(this.audio.currentTime);
	
	            if (this.audio.duration) {
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
	
	        this.progressEl.addEventListener('click', (e) => {
	            const rect = this.progressEl.getBoundingClientRect();
	            const ratio = (e.clientX - rect.left) / rect.width;
	
	            if (this.audio.duration) {
	                this.audio.currentTime = this.audio.duration * ratio;
	            }
	        });
	
	        this.volumeBarEl.addEventListener('click', (e) => {
	            const rect = this.volumeBarEl.getBoundingClientRect();
	            let ratio = (e.clientX - rect.left) / rect.width;
	            ratio = Math.max(0, Math.min(1, ratio));
	
	            this.audio.volume = ratio;
	            this.volumeFillEl.style.width = (ratio * 100) + '%';
	        });
	    },
	
	    formatTime(sec) {
	        sec = Math.floor(sec || 0);
	        const m = Math.floor(sec / 60);
	        let s = sec % 60;
	        if (s < 10) s = '0' + s;
	        return m + ':' + s;
	    },
	
	    getCurrentSongId() {
	        return this.currentSongIdInput.value;
	    },
	
	    setPlaylist(list) {
	        this.playlist = Array.isArray(list) ? list : [];
	    },
	
	    async playByButton(btn) {
	        const scope = btn.closest('[data-playlist-scope]');
	        const playlist = this.extractPlaylist(scope);
	        const songId = String(btn.dataset.songId);
	
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
	            const songPath = await this.fetchSongPath(song.songId);
	
	            if (!songPath || songPath.trim() === '') {
	                alert('이 곡의 재생 파일 경로가 없습니다.');
	                return;
	            }
	
	            this.setSong({
	                ...song,
	                songPath: songPath
	            });
	
	            await this.audio.play();
	        } catch (e) {
	            console.error(e);
	            alert('곡 경로를 불러오지 못했습니다.');
	        }
	    },
	
	    setSong(song) {
	        this.currentSongIdInput.value = song.songId || '';
	        this.titleEl.textContent = song.title || '제목 없음';
	        this.artistEl.textContent = song.artistName || '-';
	
	        if (song.coverImageUrl) {
	            this.coverEl.src = path + song.coverImageUrl;
	        } else {
	            this.coverEl.src = path + '/resources/music/img/default_album.jpg';
	        }
	
	        this.playScoreSent = false;
	        this.intervalScoreSent = false;
	
	        this.audio.pause();
	        this.audio.src = path + song.songPath;
	        this.audio.load();
	
	        this.currentTimeEl.textContent = '0:00';
	        this.totalTimeEl.textContent = '0:00';
	        this.progressFillEl.style.width = '0%';
	        this.btnPlayPause.textContent = '▶';
	    },
	
	    async fetchSongPath(songId) {
	        const response = await fetch(path + '/music/songPath?songId=' + encodeURIComponent(songId), {
	            method: 'GET'
	        });
	
	        if (!response.ok) {
	            throw new Error('songPath fetch failed');
	        }
	
	        return await response.text();
	    },
	
	    sendScore(url) {
	        const songId = this.getCurrentSongId();
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
	                    this.btnLike.textContent = '♥';
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
	};
	
	document.addEventListener('click', function(e) {
	    const playBtn = e.target.closest('.js-play-song');
	    if (!playBtn) return;
	
	    e.preventDefault();
	    e.stopPropagation();
	
	    playerManager.playByButton(playBtn);
	});
	
	window.addEventListener('DOMContentLoaded', function() {
	    playerManager.init();
	});
	