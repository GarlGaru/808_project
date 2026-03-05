<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Bootstrap 4 Spotify-style buttons sample">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Bootstrap 4 Button Sample</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
</head>
<body class="dark-mode">

    <br><br><br><br>

 <!-- 🔊 하단 플레이어 바 (footer 바로 위) -->
    <div class="bottom-player">
        <!-- LEFT : 앨범 이미지 + 곡 정보 -->
        <div class="player-left">
            <div class="player-cover">
                <!-- TODO: 현재 재생 중인 곡 커버로 교체 -->
                <img src="${path}/resources/music/img/default_album.jpg" alt="cover">
            </div>
            <div class="player-track-info">
                <!-- TODO: 서버에서 현재 곡 정보 바인딩 -->
                <div class="player-track-title" id="playerTrackTitle">혼자가 아니야</div>
                <div class="player-track-artist" id="playerTrackArtist">HYNN</div>
            </div>
        </div>

		<!-- CENTER : 재생/일시정지 + 진행바 -->
		<div class="player-center">
			<div class="player-controls">
				<button class="player-btn" id="btnPrev">
					<i class="bi bi-skip-backward-fill"></i>
				</button>

				<button class="player-btn main" id="btnPlayPause">
					<i class="bi bi-play-fill"></i>
				</button>

				<button class="player-btn" id="btnNext">
					<i class="bi bi-skip-forward-fill"></i>
				</button>
			</div>
			<div class="player-progress-row">
				<span class="player-time" id="currentTime">0:00</span>
				<div class="player-progress" id="playerProgress">
					<div class="player-progress-fill" id="playerProgressFill"></div>
				</div>
				<span class="player-time" id="totalTime">0:00</span>
			</div>
		</div>

		<!-- RIGHT : 각종 아이콘 + 볼륨 -->
        <div class="player-right">
            <button type="button" class="icon-btn" title="재생모드">⨯</button>
            <button type="button" class="icon-btn" title="가사/댓글">💬</button>

            <div class="player-volume-wrap">
                <span class="icon-btn" title="볼륨">🔊</span>
                <div class="player-volume-bar" id="playerVolumeBar">
                    <div class="player-volume-fill" id="playerVolumeFill"></div>
                </div>
            </div>
        </div>

        <!-- 실제 오디오 태그 (화면에는 안 보임 / controls 쓰지 않음) -->
        <audio id="audioPlayer">
            <!-- TODO: 실제 오디오 파일 경로로 교체 -->
            <source src="${path}/resources/music/audio/sample.mp3" type="audio/mpeg">
        </audio>
    </div>
 

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>
</body>
</html>
