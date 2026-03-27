<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<div class="music-player-fixed" id="globalPlayerRoot">

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

<!-- ============================================ -->
