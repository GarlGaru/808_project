<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" href="${path}/resources/music/css/player.css">

<div class="music-player-fixed">

    <!-- 왼쪽: 현재 곡 정보 -->
    <div class="player-left">
        <div class="player-cover-wrap">
            <c:choose>
                <c:when test="${not empty song and not empty song.coverImageUrl}">
                    <img src="${path}${song.coverImageUrl}" alt="cover" id="playerCover">
                </c:when>
                <c:otherwise>
                    <img src="${path}/resources/music/img/default_album.jpg" alt="cover" id="playerCover">
                </c:otherwise>
            </c:choose>
        </div>

        <div class="player-track-info">
            <div class="player-track-title" id="playerTrackTitle">
                <c:choose>
                    <c:when test="${not empty song}">
                        ${song.title}
                    </c:when>
                    <c:otherwise>
                        곡을 선택해주세요
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="player-track-artist" id="playerTrackArtist">
                <c:choose>
                    <c:when test="${not empty song}">
                        ${song.artistName}
                    </c:when>
                    <c:otherwise>
                        -
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- 가운데: 재생 컨트롤 -->
    <div class="player-center">

        <div class="player-controls">
            <button type="button" class="player-btn" id="btnPrev">⏮</button>
            <button type="button" class="player-btn player-btn-main" id="btnPlayPause">▶</button>
            <button type="button" class="player-btn" id="btnNext">⏭</button>
        </div>

        <div class="player-progress-area">
            <span class="player-time" id="currentTime">0:00</span>

            <div class="player-progress" id="playerProgress">
                <div class="player-progress-fill" id="playerProgressFill"></div>
            </div>

            <span class="player-time" id="totalTime">0:00</span>
        </div>
    </div>

    <!-- 오른쪽: 부가 버튼 -->
    <div class="player-right">
        <button type="button" class="player-btn" id="btnLike">♡</button>

        <div class="player-volume-wrap">
            <span class="player-volume-icon">🔊</span>
            <div class="player-volume-bar" id="playerVolumeBar">
                <div class="player-volume-fill" id="playerVolumeFill"></div>
            </div>
        </div>
    </div>

    <!-- hidden -->
    <input type="hidden" id="currentSongId"
           value="<c:choose><c:when test='${not empty song}'>${song.songId}</c:when><c:otherwise></c:otherwise></c:choose>">

    <!-- 오디오 -->
	<audio id="audioPlayer" preload="metadata">
		<c:if test="${not empty song and not empty song.songPath}">
			<source src="${path}${song.songPath}" type="audio/mpeg">
		</c:if>
	</audio>
</div>

<script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
<script>
(function () {
    const audio = document.getElementById('audioPlayer');
    const btnPlayPause = document.getElementById('btnPlayPause');
    const btnLike = document.getElementById('btnLike');
    const currentSongIdInput = document.getElementById('currentSongId');
    let currentSongId = currentSongIdInput ? currentSongIdInput.value : '';
    
    const currentTimeEl = document.getElementById('currentTime');
    const totalTimeEl = document.getElementById('totalTime');
    const progress = document.getElementById('playerProgress');
    const progressFill = document.getElementById('playerProgressFill');
    const volumeBar = document.getElementById('playerVolumeBar');
    const volumeFill = document.getElementById('playerVolumeFill');

    let playScoreSent = false;
    let intervalScoreSent = false;

    if (!audio) return;

    audio.volume = 0.7;
    if (volumeFill) {
        volumeFill.style.width = '70%';
    }

    function formatTime(sec) {
        sec = Math.floor(sec || 0);
        const m = Math.floor(sec / 60);
        let s = sec % 60;
        if (s < 10) s = '0' + s;
        return m + ':' + s;
    }

    function sendScore(url) {
        if (!currentSongId) return;

        $.ajax({
            url: url,
            type: 'GET',
            data: { songId: currentSongId },
            success: function (res) {
                console.log('score result:', res);
            },
            error: function () {
                console.log('score ajax error');
            }
        });
    }

    if (btnPlayPause) {
        btnPlayPause.addEventListener('click', function () {
            if (!audio.querySelector('source')) {
                alert('재생할 곡이 없습니다.');
                return;
            }

            if (audio.paused) {
                audio.play();

                if (!playScoreSent && currentSongId) {
                    sendScore('${path}/music/playScore');
                    playScoreSent = true;
                }
            } else {
                audio.pause();
            }
        });
    }

    audio.addEventListener('play', function () {
        if (btnPlayPause) btnPlayPause.textContent = '⏸';
    });

    audio.addEventListener('pause', function () {
        if (btnPlayPause) btnPlayPause.textContent = '▶';
    });

    audio.addEventListener('loadedmetadata', function () {
        if (totalTimeEl) {
            totalTimeEl.textContent = formatTime(audio.duration);
        }
    });

    audio.addEventListener('timeupdate', function () {
        if (currentTimeEl) {
            currentTimeEl.textContent = formatTime(audio.currentTime);
        }

        if (audio.duration && progressFill) {
            const percent = (audio.currentTime / audio.duration) * 100;
            progressFill.style.width = percent + '%';
        }

        // 30초 이상 재생 시 interval 점수 1회
        if (!intervalScoreSent && audio.currentTime >= 30 && currentSongId) {
            sendScore('${path}/music/intervalScore');
            intervalScoreSent = true;
        }
    });

    if (progress) {
        progress.addEventListener('click', function (e) {
            const rect = progress.getBoundingClientRect();
            const offsetX = e.clientX - rect.left;
            const ratio = offsetX / rect.width;

            if (audio.duration) {
                audio.currentTime = audio.duration * ratio;
            }
        });
    }

    if (volumeBar) {
        volumeBar.addEventListener('click', function (e) {
            const rect = volumeBar.getBoundingClientRect();
            const offsetX = e.clientX - rect.left;
            let ratio = offsetX / rect.width;

            ratio = Math.max(0, Math.min(1, ratio));
            audio.volume = ratio;

            if (volumeFill) {
                volumeFill.style.width = (ratio * 100) + '%';
            }
        });
    }

    if (btnLike) {
        btnLike.addEventListener('click', function () {
            if (!currentSongId) {
                alert('좋아요를 누를 곡이 없습니다.');
                return;
            }

            $.ajax({
                url: '${path}/music/likeScore',
                type: 'GET',
                data: { songId: currentSongId },
                success: function (res) {
                    if (res === 'success') {
                        btnLike.textContent = '♥';
                    } else if (res === 'noLogin') {
                        alert('로그인 후 이용해주세요.');
                    }
                },
                error: function () {
                    alert('좋아요 처리 중 오류가 발생했습니다.');
                }
            });
        });
    }
})();

function setPlayerSong(song) {
    if (!song) return;

    const cover = document.getElementById('playerCover');
    const title = document.getElementById('playerTrackTitle');
    const artist = document.getElementById('playerTrackArtist');

    if (cover) {
        cover.src = song.coverImageUrl && song.coverImageUrl !== ''
            ? '${path}' + song.coverImageUrl
            : '${path}/resources/music/img/default_album.jpg';
    }

    if (title) title.textContent = song.title || '제목 없음';
    if (artist) artist.textContent = song.artistName || '-';

    currentSongId = song.songId || '';
    if (currentSongIdInput) {
        currentSongIdInput.value = currentSongId;
    }

    playScoreSent = false;
    intervalScoreSent = false;

    audio.pause();
    audio.src = '${path}' + song.songPath;
    audio.load();

    if (btnPlayPause) {
        btnPlayPause.textContent = '▶';
    }
}

window.setPlayerSong = setPlayerSong;
</script>