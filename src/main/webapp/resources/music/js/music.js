// ==============================
// 비동기 작업
// ==============================

// 메인 콘텐츠 영역에 URL의 HTML을 비동기로 불러와 넣는 함수
// pushState: true면 히스토리에 추가 (기본값 true, popstate에서 호출 시 false)
async function loadMainContent(url, pushState) {
    if (pushState === undefined) pushState = true;

    // 서버에서 받아온 결과를 넣을 영역
    const result = document.getElementById("main-content-area");

    try {
        // fetch로 GET 요청 전송
        const response = await fetch(url, {
            method: "GET"
        });

        // 응답 실패 시 상태코드와 함께 에러 문구 출력
        if (!response.ok) {
            result.innerHTML = "불러오기 실패 : " + response.status;
            return;
        }

        // 응답 본문을 텍스트(HTML 문자열)로 읽음
        const html = await response.text();

        // 받아온 HTML을 해당 영역에 삽입
        result.innerHTML = html;
		//받아온 RESULT 안에 initFn 이 있으면 실행해라
        const initFn = result.querySelector('[data-init]')?.dataset.init;
        if (initFn && typeof window[initFn] === 'function') {
            window[initFn]();
        }

        // 히스토리에 현재 URL 기록 (뒤로가기 지원)
        if (pushState) {
            history.pushState({ musicUrl: url }, '', location.pathname + location.search);
        }

    } catch (error) {
        // 네트워크 오류 등 요청 자체가 실패한 경우
        result.innerHTML = "요청 실패";
        console.error(error);
    }
}

// 브라우저 뒤로가기/앞으로가기 시 콘텐츠 복원
window.addEventListener('popstate', function(e) {
    if (e.state && e.state.musicUrl) {
        loadMainContent(e.state.musicUrl, false);
    }
});

// ==============================
// 전역 경로 / 플레이어 루트 설정
// ==============================

// JSP 등에서 window.APP_PATH = "/eze" 같은 식으로 넣어둔 context path 사용
// 없으면 빈 문자열 사용
const path = window.APP_PATH || '';

// 전역 플레이어 전체를 감싸는 루트 요소
const playerRoot = document.getElementById('globalPlayerRoot');

// 플레이어 루트가 없으면 콘솔에 오류 출력
if (!playerRoot) {
    console.error('globalPlayerRoot를 찾지 못했습니다.');
}

// ==============================
// 전역 플레이어 매니저
// playerRoot가 있을 때만 객체 생성, 없으면 null
// ==============================
const playerManager = playerRoot ? {
    // ===== 플레이어 내부 요소들 =====

    // 실제 오디오 태그
    audio: playerRoot.querySelector('#audioPlayer'),

    // 이전곡 버튼
    btnPrev: playerRoot.querySelector('#btnPrev'),

    // 재생/일시정지 버튼
    btnPlayPause: playerRoot.querySelector('#btnPlayPause'),

    // 다음곡 버튼
    btnNext: playerRoot.querySelector('#btnNext'),

    // 좋아요 버튼
    btnLike: playerRoot.querySelector('#playerLikeBtn'),

    // 현재 재생 중인 곡 ID를 담아두는 hidden/input 요소
    currentSongIdInput: playerRoot.querySelector('#currentSongId'),

    // 앨범 커버 이미지 요소
    coverEl: playerRoot.querySelector('#playerCover'),

    // 현재 곡 제목 표시 요소
    titleEl: playerRoot.querySelector('#playerTrackTitle'),

    // 현재 아티스트명 표시 요소
    artistEl: playerRoot.querySelector('#playerTrackArtist'),

    // 현재 재생 시간 표시 요소
    currentTimeEl: playerRoot.querySelector('#currentTime'),

    // 총 재생 시간 표시 요소
    totalTimeEl: playerRoot.querySelector('#totalTime'),

    // 진행바 전체 영역
    progressEl: playerRoot.querySelector('#playerProgress'),

    // 진행바 안에서 현재 진행된 길이를 표시하는 요소
    progressFillEl: playerRoot.querySelector('#playerProgressFill'),

    // 볼륨바 전체 영역
    volumeBarEl: playerRoot.querySelector('#playerVolumeBar'),

    // 볼륨바 안에서 현재 볼륨을 표시하는 요소
    volumeFillEl: playerRoot.querySelector('#playerVolumeFill'),

    // ===== 상태값 =====

    // 현재 재생 가능한 플레이리스트 배열
    playlist: [],

    // 플레이리스트에서 현재 재생 중인 곡 인덱스
    currentIndex: -1,

    // 재생 시작 점수 전송 여부 (중복 전송 방지)
    playScoreSent: false,

    // 30초 이상 재생 점수 전송 여부 (중복 전송 방지)
    intervalScoreSent: false,

    // ==============================
    // 초기화 함수
    // ==============================
    init() {
        // 오디오 태그가 없으면 초기화 중단
        if (!this.audio) {
            console.error('audioPlayer를 찾지 못했습니다.');
            return;
        }

        // 기본 볼륨 70% 설정
        this.audio.volume = 0.7;

        // 볼륨 UI도 70%로 표시
        if (this.volumeFillEl) {
            this.volumeFillEl.style.width = '70%';
        }

        // 이벤트 바인딩
        this.bindEvents();
    },

    // ==============================
    // 각종 이벤트 등록
    // ==============================
    bindEvents() {
        // 재생/일시정지 버튼 클릭 이벤트
        if (this.btnPlayPause) {
            this.btnPlayPause.addEventListener('click', () => {
                // src가 없으면 재생할 곡이 없는 상태
                if (!this.audio.src) {
                    alert('재생할 곡이 없습니다.');
                    return;
                }

                // 현재 일시정지 상태면 재생
                if (this.audio.paused) {
                    this.audio.play().catch(err => {
                        console.error('재생 실패:', err);
                    });
                } else {
                    // 재생 중이면 일시정지
                    this.audio.pause();
                }
            });
        }

        // 이전곡 버튼 클릭
        if (this.btnPrev) {
            this.btnPrev.addEventListener('click', () => {
                this.playPrev();
            });
        }

        // 다음곡 버튼 클릭
        if (this.btnNext) {
            this.btnNext.addEventListener('click', () => {
                this.playNext();
            });
        }

        // 실제 오디오가 재생 시작될 때
        this.audio.addEventListener('play', () => {
            // 버튼 아이콘을 일시정지 모양으로 변경
            if (this.btnPlayPause) {
                this.btnPlayPause.textContent = '⏸';
            }

            // 아직 재생 점수를 보내지 않았고 현재 곡 ID가 있으면 점수 전송
            if (!this.playScoreSent && this.getCurrentSongId()) {
                this.sendScore(path + '/music/playScore');
                this.playScoreSent = true;
            }
        });

        // 일시정지될 때
        this.audio.addEventListener('pause', () => {
            // 버튼 아이콘을 재생 모양으로 변경
            if (this.btnPlayPause) {
                this.btnPlayPause.textContent = '▶';
            }
        });

        // 메타데이터(총 길이 등) 로드 완료 시
        this.audio.addEventListener('loadedmetadata', () => {
            // 총 길이 표시
            if (this.totalTimeEl) {
                this.totalTimeEl.textContent = this.formatTime(this.audio.duration);
            }
        });

        // 재생 시간 변화 이벤트 (재생 중 계속 발생)
        this.audio.addEventListener('timeupdate', () => {
            // 현재 재생 시간을 화면에 표시
            if (this.currentTimeEl) {
                this.currentTimeEl.textContent = this.formatTime(this.audio.currentTime);
            }

            // 진행바 UI 갱신
            if (this.audio.duration && this.progressFillEl) {
                const percent = (this.audio.currentTime / this.audio.duration) * 100;
                this.progressFillEl.style.width = percent + '%';
            }

            // 30초 이상 재생되면 interval 점수 1회 전송
            if (!this.intervalScoreSent && this.audio.currentTime >= 30 && this.getCurrentSongId()) {
                this.sendScore(path + '/music/intervalScore');
                this.intervalScoreSent = true;
            }
        });

        // 곡이 끝나면 자동으로 다음곡 재생
        this.audio.addEventListener('ended', () => {
            this.playNext();
        });

        // 진행바 클릭 시 해당 위치로 재생 지점 이동
        if (this.progressEl) {
            this.progressEl.addEventListener('click', (e) => {
                // 진행바 위치와 크기 정보
                const rect = this.progressEl.getBoundingClientRect();

                // 클릭 위치 비율 계산
                const ratio = (e.clientX - rect.left) / rect.width;

                // 곡 길이가 있으면 해당 비율 위치로 이동
                if (this.audio.duration) {
                    this.audio.currentTime = this.audio.duration * ratio;
                }
            });
        }

        // 볼륨바 클릭 시 볼륨 조절
        if (this.volumeBarEl) {
            this.volumeBarEl.addEventListener('click', (e) => {
                // 볼륨바 위치와 크기 정보
                const rect = this.volumeBarEl.getBoundingClientRect();

                // 클릭 위치 비율 계산
                let ratio = (e.clientX - rect.left) / rect.width;

                // 0~1 범위로 강제 제한
                ratio = Math.max(0, Math.min(1, ratio));

                // 실제 오디오 볼륨 적용
                this.audio.volume = ratio;

                // 볼륨 UI 갱신
                if (this.volumeFillEl) {
                    this.volumeFillEl.style.width = (ratio * 100) + '%';
                }
            });
        }
    },

    // ==============================
    // 초 단위를 mm:ss 형식으로 바꾸는 함수
    // 예: 65 -> 1:05
    // ==============================
    formatTime(sec) {
        sec = Math.floor(sec || 0);
        const m = Math.floor(sec / 60);
        let s = sec % 60;

        if (s < 10) s = '0' + s;

        return m + ':' + s;
    },

    // ==============================
    // 현재 곡 ID 반환
    // ==============================
    getCurrentSongId() {
        return this.currentSongIdInput ? this.currentSongIdInput.value : '';
    },

    // ==============================
    // 플레이리스트 설정
    // 배열이 아니면 빈 배열로 초기화
    // ==============================
    setPlaylist(list) {
        this.playlist = Array.isArray(list) ? list : [];
    },

    // ==============================
    // 재생 버튼 클릭 시 호출되는 핵심 함수
    // 버튼 dataset을 읽어 현재 곡 + 플레이리스트 구성
    // ==============================
    async playByButton(btn) {
        console.log('재생 버튼 클릭 dataset:', btn.dataset);

        // 같은 영역(data-playlist-scope) 안의 곡들을 플레이리스트로 묶기 위해 scope 찾기
        const scope = btn.closest('[data-playlist-scope]');

        // scope 안의 .js-play-song 버튼들을 모아 플레이리스트 생성
        const playlist = this.extractPlaylist(scope);

        // 클릭된 버튼의 songId 읽기
        const songId = String(btn.dataset.songId || '');

        // songId가 없으면 재생 불가
        if (!songId) {
            alert('곡 정보가 올바르지 않습니다.');
            return;
        }

        // 플레이리스트가 있으면 설정하고 현재 곡 인덱스 찾기
        if (playlist.length > 0) {
            this.setPlaylist(playlist);
            this.currentIndex = playlist.findIndex(song => String(song.songId) === songId);
        } else {
            // 플레이리스트 없으면 초기화
            this.setPlaylist([]);
            this.currentIndex = -1;
        }

        // 버튼 data-* 속성으로 기본 song 객체 생성
        const song = {
            songId: songId,
            title: btn.dataset.title || '',
            artistName: btn.dataset.artist || '',
            coverImageUrl: btn.dataset.cover || ''
        };

        console.log('재생할 song 객체:', song);

        // 실제 곡 경로를 불러와 세팅 후 재생
        await this.loadAndPlay(song);
    },

    // ==============================
    // 특정 영역(scope) 안의 재생 버튼들을 전부 읽어
    // 플레이리스트 배열로 만드는 함수
    // ==============================
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

    // ==============================
    // 플레이어 UI + 오디오 src를 현재 곡 정보로 갱신
    // ==============================
    setSong(song) {
        // 현재 곡 ID 저장
        if (this.currentSongIdInput) {
            this.currentSongIdInput.value = song.songId || '';
        }

        // 곡 제목 표시
        if (this.titleEl) {
            this.titleEl.textContent = song.title || '제목 없음';
        }

        // 아티스트명 표시
        if (this.artistEl) {
            this.artistEl.textContent = song.artistName || '-';
        }

        // 기본 커버 이미지 경로
        let coverSrc = path + '/resources/music/img/default_album.png';

        // 커버 이미지가 있으면 상황에 따라 경로 보정
        if (song.coverImageUrl) {
            if (song.coverImageUrl.startsWith('http')) {
                // 절대 외부 주소면 그대로 사용
                coverSrc = song.coverImageUrl;
            } else if (song.coverImageUrl.startsWith(path)) {
                // 이미 context path가 붙어 있으면 그대로 사용
                coverSrc = song.coverImageUrl;
            } else {
                // 상대 경로면 path 붙여서 사용
                coverSrc = path + song.coverImageUrl;
            }
        }

        // 커버 이미지 적용
        if (this.coverEl) {
            this.coverEl.src = coverSrc;
        }

        // 새 곡이므로 점수 전송 여부 초기화
        this.playScoreSent = false;
        this.intervalScoreSent = false;

        // 기존 곡이 재생 중이면 일단 멈춤
        this.audio.pause();

        // 실제 음원 경로
        let finalSongPath = song.songPath || '';

        // 음원 경로도 상황에 따라 보정
        if (finalSongPath.startsWith('http')) {
            // 외부 절대 경로면 그대로 사용
        } else if (finalSongPath.startsWith(path)) {
            // 이미 path 포함이면 그대로 사용
        } else {
            // 상대 경로면 path 붙이기
            finalSongPath = path + finalSongPath;
        }

        console.log('최종 오디오 경로:', finalSongPath);

        // 오디오 소스 교체
        this.audio.src = finalSongPath;

        // 오디오 다시 로드
        this.audio.load();

        // likeManager가 있으면 현재 곡 ID 전달
        if (window.likeManager) {
            window.likeManager.setSong(song.songId || '');
        }

        // 시간 표시 초기화
        if (this.currentTimeEl) {
            this.currentTimeEl.textContent = '0:00';
        }

        // 총 시간 표시 초기화 (loadedmetadata에서 다시 실제 값 세팅)
        if (this.totalTimeEl) {
            this.totalTimeEl.textContent = '0:00';
        }

        // 진행바 초기화
        if (this.progressFillEl) {
            this.progressFillEl.style.width = '0%';
        }

        // 버튼 아이콘 재생 모양으로 초기화
        if (this.btnPlayPause) {
            this.btnPlayPause.textContent = '▶';
        }
    },

    // ==============================
    // songId로 서버에서 실제 songPath를 가져와
    // setSong() 후 곧바로 재생하는 함수
    // ==============================
    async loadAndPlay(song) {
        try {
            // 서버에서 실제 음원 경로 조회
            const songPath = await this.fetchSongPath(song.songId);

            // 경로가 없으면 재생 중단
            if (!songPath) {
                alert('음원 경로를 찾을 수 없습니다.');
                return;
            }

            // 조회한 경로를 song 객체에 넣기
            song.songPath = songPath;

            // 플레이어 UI/오디오 갱신
            this.setSong(song);

            // 실제 재생 시작
            await this.audio.play();

            // 버튼 아이콘을 일시정지 모양으로 변경
            if (this.btnPlayPause) {
                this.btnPlayPause.textContent = '⏸';
            }
        } catch (err) {
            console.error('곡 재생 실패:', err);
            alert('곡 재생 중 오류가 발생했습니다.');
        }
    },

    // ==============================
    // songId를 서버로 보내 실제 음원 경로를 가져오는 함수
    // 예: /music/songPath?songId=3
    // ==============================
    async fetchSongPath(songId) {
        console.log('songPath 요청 songId:', songId);

        const response = await fetch(path + '/music/songPath?songId=' + encodeURIComponent(songId), {
            method: 'GET'
        });

        // 응답 실패 시 에러 발생
        if (!response.ok) {
            throw new Error('songPath fetch failed: ' + response.status);
        }

        // 서버가 돌려준 경로 문자열 읽기
        const result = (await response.text()).trim();
        console.log('songPath 응답값:', result);

        return result;
    },

    // ==============================
    // 점수 전송 함수
    // 재생 시작 점수 / 30초 점수 등에 사용
    // ==============================
    sendScore(url) {
        const songId = this.getCurrentSongId();
        console.log('sendScore 호출됨', url, songId);

        // songId 없으면 전송 중단
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

    // ==============================
    // 이전곡 재생
    // ==============================
    playPrev() {
        // 플레이리스트가 없으면 중단
        if (this.playlist.length === 0) return;

        // 현재가 첫 곡이면 이전곡 없음
        if (this.currentIndex <= 0) return;

        // 인덱스 하나 감소 후 재생
        this.currentIndex--;
        this.loadAndPlay(this.playlist[this.currentIndex]);
    },

    // ==============================
    // 다음곡 재생
    // ==============================
    playNext() {
        // 플레이리스트가 없으면 중단
        if (this.playlist.length === 0) return;

        // 현재 인덱스가 비정상 상태면 중단
        if (this.currentIndex < 0) return;

        // 마지막 곡이면 다음곡 없음
        if (this.currentIndex >= this.playlist.length - 1) return;

        // 인덱스 하나 증가 후 재생
        this.currentIndex++;
        this.loadAndPlay(this.playlist[this.currentIndex]);
    }
} : null;

// ==============================
// 문서 전체에서 .js-play-song 클릭 감지
// 어디서 누르든 전역 플레이어로 연결
// ==============================
document.addEventListener('click', function(e) {
    // 클릭한 요소 또는 상위 요소 중 .js-play-song 찾기
    const playBtn = e.target.closest('.js-play-song');

    // 플레이 버튼이 아니면 무시
    if (!playBtn) return;

    // 플레이어 없으면 무시
    if (!playerManager) return;

    // 기본 이벤트/버블링 막기
    e.preventDefault();
    e.stopPropagation();

    console.log('mainstory play clicked', playBtn.dataset);

    // 전역 플레이어 매니저로 재생 처리
    playerManager.playByButton(playBtn);
});

// ==============================
// DOM 로드 완료 후 플레이어 초기화
// ==============================
window.addEventListener('DOMContentLoaded', function() {
    if (playerManager) {
        playerManager.init();
    }
});

// ==============================
// 슬라이더 상태 저장 객체
// 각 슬라이더별 현재 위치 기억
// ==============================
const sliderState = {};

// ==============================
// 화면 너비에 따라 한 번에 보여줄 카드 수 결정
// ==============================
function getVisibleCount() {
    const width = window.innerWidth;

    if (width <= 768) return 2;
    if (width <= 1200) return 4;
    if (width <= 1600) return 6;

    return 8;
}

// ==============================
// 슬라이더 이동 함수
// sliderId: 슬라이더 viewport id
// direction: 1(오른쪽), -1(왼쪽)
// ==============================
function moveSlider(sliderId, direction) {
    // 슬라이더 viewport 찾기
    const viewport = document.getElementById(sliderId);
    if (!viewport) return;

    // 일반 홈 카드용 track 또는 랭킹 카드용 track 찾기
    const track =
        viewport.querySelector('.music-home-track') ||
        viewport.querySelector('.music-ranking-track');

    if (!track) return;

    // 카드 목록 찾기
    const cards = track.querySelectorAll('.music-home-card, .music-ranking-card');
    if (!cards.length) return;

    // 현재 화면에서 한 번에 보이는 카드 수
    const visibleCount = getVisibleCount();

    // 최대 시작 인덱스 계산
    const maxIndex = Math.max(0, cards.length - visibleCount);

    // 슬라이더 상태 초기값 세팅
    if (sliderState[sliderId] == null) {
        sliderState[sliderId] = 0;
    }

    // direction 방향으로 visibleCount만큼 이동
    sliderState[sliderId] += direction * visibleCount;

    // 0보다 작아지지 않게 제한
    if (sliderState[sliderId] < 0) sliderState[sliderId] = 0;

    // 최대 인덱스보다 커지지 않게 제한
    if (sliderState[sliderId] > maxIndex) sliderState[sliderId] = maxIndex;

    // 카드 한 장 너비
    const cardWidth = cards[0].offsetWidth;

    // 카드 간 간격
    const gap = 18;

    // 총 이동 거리 계산
    const moveX = (cardWidth + gap) * sliderState[sliderId];

    // transform으로 왼쪽 이동
    track.style.transform = 'translateX(-' + moveX + 'px)';
}

// HTML 인라인 onclick에서도 쓸 수 있게 전역 등록
window.moveSlider = moveSlider;

// 랭킹 슬라이더용 래퍼 함수
window.moveRankingSlider = function(sliderId, direction) {
    moveSlider(sliderId, direction);
};

// 랭킹 재생 버튼 등에서 직접 호출할 수 있는 전역 함수
window.playRankingSong = function(e, btn) {
    // a태그/버튼 기본 이벤트 막기
    if (e) {
        e.preventDefault();
        e.stopPropagation();
    }

    // 버튼이나 플레이어 매니저가 없으면 중단
    if (!btn || !playerManager) return;

    // 버튼 기준으로 재생 처리
    playerManager.playByButton(btn);
};

// ==============================
// 화면 크기 변경 시 슬라이더 전부 초기 위치로 리셋
// ==============================
window.addEventListener('resize', function() {
    Object.keys(sliderState).forEach(function(sliderId) {
        // 상태값 0으로 초기화
        sliderState[sliderId] = 0;

        // viewport 찾기
        const viewport = document.getElementById(sliderId);
        if (!viewport) return;

        // track 찾기
        const track =
            viewport.querySelector('.music-home-track') ||
            viewport.querySelector('.music-ranking-track');

        // transform 원위치
        if (track) {
            track.style.transform = 'translateX(0)';
        }
    });
});

// ==============================
// 검색결과 값 받기
// ==============================
function submitMusicSearch(form) {
    
    const keywordInput = form.querySelector('input[name="keyword"]');  //input 찾기
    const keyword = keywordInput ? keywordInput.value.trim() : '';     //앞뒤 공백 제거

    if (!keyword) {
        alert('검색어를 입력해주세요.');
        return;
    }

    loadMainContent(path + '/music/search?keyword=' + encodeURIComponent(keyword));  // loadMainContent 함수를 쓰면서 주소및 encodeURIComponent(keyword) => 한글,공백 깨짐 방지
}


// 다른 스크립트에서도 접근 가능하도록 전역 공개
window.playerManager = playerManager;



