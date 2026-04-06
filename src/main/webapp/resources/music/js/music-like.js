/**
 * 
 현재 곡의 좋아요 상태 조회

하트 클릭 시 토글 요청

하트 UI 변경

곡 변경 시 상태 초기화/재조회
 
 */
 
 const likeManager = {
    currentSongId: null, // 플레이어 현재곡
    likedSongMap: {},

    init: function () {
        this.bindEvents();
        this.syncInitialButtons();
    },

    bindEvents: function () {
        const self = this;

        $(document).on('click', '.js-like-btn', function (e) {
            e.preventDefault();
            e.stopPropagation();

            const $btn = $(this);
            const scope = $btn.data('like-scope');

            let songId = '';

            // 플레이어 버튼이면 현재 재생곡 기준
            if (scope === 'player') {
                songId = self.currentSongId;
            } else {
                // 디테일 버튼이면 자기 data-song-id 기준
                songId = $btn.data('song-id');
            }

            if (!songId) {
                alert('곡 정보가 없습니다.');
                return;
            }

            self.toggleLike(songId);
        });
    },

    setSong: function (songId) {
        this.currentSongId = songId || null;
        this.syncPlayerButton();

        if (!this.currentSongId) return;

        this.fetchLikeStatus(this.currentSongId);
    },

    syncInitialButtons: function () {
        const $detailBtn = $('#detailLikeBtn');
        if ($detailBtn.length) {
            const detailSongId = $detailBtn.data('song-id');
            if (detailSongId) {
                this.fetchLikeStatus(detailSongId);
            }
        }

        if (this.currentSongId) {
            this.fetchLikeStatus(this.currentSongId);
        }
    },

    syncPlayerButton: function () {
        const $playerBtn = $('#playerLikeBtn');

        if (!$playerBtn.length) return;

        const liked = !!this.likedSongMap[this.currentSongId];

        $playerBtn.toggleClass('is-liked', liked);
        $playerBtn.attr('aria-pressed', liked ? 'true' : 'false');
        $playerBtn.text(liked ? '♥' : '♡');
    },

    renderSongButtons: function (songId, liked) {
        // 플레이어 버튼 갱신
        if (String(this.currentSongId || '') === String(songId)) {
            const $playerBtn = $('#playerLikeBtn');
            $playerBtn.toggleClass('is-liked', liked);
            $playerBtn.attr('aria-pressed', liked ? 'true' : 'false');
            $playerBtn.text(liked ? '♥' : '♡');
        }

        // 디테일 버튼 갱신
        $('.js-like-btn[data-song-id]').each(function () {
            const $btn = $(this);
            if (String($btn.data('song-id')) === String(songId)) {
                $btn.toggleClass('is-liked', liked);
                $btn.attr('aria-pressed', liked ? 'true' : 'false');
                $btn.text(liked ? '♥' : '♡');
            }
        });
    },

    fetchLikeStatus: function (songId) {
        const self = this;

        if (!songId) return;

        $.ajax({
            url: path + '/music/likeStatus',
            type: 'GET',
            data: { songId: songId },
            success: function (res) {
                const liked = (res === 'liked');
                self.likedSongMap[String(songId)] = liked;
                self.renderSongButtons(songId, liked);
            },
            error: function () {
                self.likedSongMap[String(songId)] = false;
                self.renderSongButtons(songId, false);
            }
        });
    },

    toggleLike: function (songId) {
        const self = this;

        $.ajax({
            url: path + '/music/toggleLike',
            type: 'GET',
            data: { songId: songId },
            success: function (res) {
                if (res === 'noLogin') {
                    alert('로그인 후 이용 가능합니다.');
                    return;
                }

                let liked = false;

                if (res === 'liked') {
                    liked = true;
                } else if (res === 'unliked') {
                    liked = false;
                } else {
                    alert('좋아요 처리에 실패했습니다.');
                    return;
                }

                self.likedSongMap[String(songId)] = liked;
                self.renderSongButtons(songId, liked);

                if (typeof loadLikedSidebar === 'function') {
                    loadLikedSidebar();
                }
            },
            error: function () {
                alert('좋아요 처리 중 오류가 발생했습니다.');
            }
        });
    }
};

window.likeManager = likeManager;

document.addEventListener('DOMContentLoaded', function () {
    likeManager.init();
});