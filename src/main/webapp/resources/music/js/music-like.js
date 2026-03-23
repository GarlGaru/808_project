/**
 * 
 현재 곡의 좋아요 상태 조회

하트 클릭 시 토글 요청

하트 UI 변경

곡 변경 시 상태 초기화/재조회
 
 */
 
 const likeManager = {
    currentSongId: null,
    liked: false,
    selectors: {
        likeBtn: '#btnLike'
    },

    init: function () {
        this.bindEvents();
    },

    bindEvents: function () {
        const self = this;

        $(document).on('click', this.selectors.likeBtn, function (e) {
            e.preventDefault();
            self.toggleLike();
        });
    },

    setSong: function (songId) {
        this.currentSongId = songId || null;
        this.resetLikeButton();

        if (!this.currentSongId) {
            return;
        }

        this.fetchLikeStatus();
    },

    resetLikeButton: function () {
        this.liked = false;
        this.render();
    },

    render: function () {
        const $btn = $(this.selectors.likeBtn);

        if (!$btn.length) return;

        $btn.toggleClass('is-liked', this.liked);
        $btn.attr('aria-pressed', this.liked ? 'true' : 'false');
        $btn.text(this.liked ? '♥' : '♡');
    },

    fetchLikeStatus: function () {
        const self = this;

        if (!this.currentSongId) return;

        $.ajax({
            url: path + '/music/likeStatus',
            type: 'GET',
            data: { songId: this.currentSongId },
            success: function (res) {
                if (res === 'liked') {
                    self.liked = true;
                } else {
                    self.liked = false;
                }
                self.render();
            },
            error: function () {
                self.liked = false;
                self.render();
            }
        });
    },

    toggleLike: function () {
        const self = this;

        if (!this.currentSongId) {
            alert('선택된 곡이 없습니다.');
            return;
        }

        $.ajax({
            url: path + '/music/toggleLike',
            type: 'GET',
            data: { songId: this.currentSongId },
            success: function (res) {
                if (res === 'noLogin') {
                    alert('로그인 후 이용 가능합니다.');
                    return;
                }

                if (res === 'liked') {
                    self.liked = true;
                } else if (res === 'unliked') {
                    self.liked = false;
                }

                self.render();

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