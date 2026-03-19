<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}" />


<div data-init="initMusicReco">
    <%-- 각 슬라이더의 마운트 포인트 --%>
    <div id="weekly-slider-mount"></div>
    <div id="today-slider-mount"></div>
    <div id="genre-slider-mount"></div>

</div>

<%-- 슬라이더 template --%>
<template id="music-slider-template">
    <section class="music-home-block">
        <div class="music-home-header">
            <div>
                <h2 class="music-home-title" data-slot="title"></h2>
                <p class="music-home-desc" data-slot="subtitle"></p>
            </div>

            <div class="music-home-controls">
                <button type="button"
                        class="music-home-arrow"
                        data-action="prev">
                    ‹
                </button>
                <button type="button"
                        class="music-home-arrow"
                        data-action="next">
                    ›
                </button>
            </div>
        </div>

        <div class="music-home-viewport" data-slot="viewport">
            <div class="music-home-track" data-slot="track">
                <!-- 카드들이 JS에 의해 여기에 주입됩니다 -->
            </div>
        </div>

        <div class="music-home-empty" data-slot="empty" style="display:none;"></div>
    </section>
</template>

<%-- 카드 template --%>
<template id="music-card-template">
    <div class="music-home-card" data-song-id="">
        <div class="music-home-thumb-wrap">
            <img class="music-home-thumb" src="" alt="">
            <button type="button"
                    class="music-home-play-btn js-play-song"
                    data-song-id=""
                    data-title=""
                    data-artist=""
                    data-cover=""
                    aria-label="">
                ▶
            </button>
        </div>
        <div class="music-home-body">
            <div class="music-home-song" data-slot="title"></div>
            <div class="music-home-artist" data-slot="artist"></div>
            <div class="music-home-score" data-slot="label"></div>
        </div>
    </div>
</template>

