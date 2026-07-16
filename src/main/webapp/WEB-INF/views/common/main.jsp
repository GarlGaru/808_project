<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>808 PROJECT</title>
    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
    <style>
        body.index2-page {
            background: #a86326;
            color: #e8e8e8;
            min-height: 100vh;
            margin: 0;
            display: flex;
            flex-direction: column;
        }

        .index2-stage {
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            background: linear-gradient(180deg, #a86326 0%, #1f1206 100%);
            position: relative;
            overflow: hidden;
        }

        .index2-stage::before,
        .index2-stage::after {
            content: "";
            position: absolute;
            border-radius: 50%;
            pointer-events: none;
            z-index: 0;
        }

        .index2-stage::before {
            width: 420px;
            height: 420px;
            left: -140px;
            top: -150px;
            background: radial-gradient(circle, rgba(255, 200, 120, 0.10) 0%, rgba(255, 200, 120, 0) 72%);
        }

        .index2-stage::after {
            width: 520px;
            height: 520px;
            right: -180px;
            top: 640px;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.04) 0%, rgba(255, 255, 255, 0) 74%);
        }

        .index2-hero {
            min-height: 240px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 28px 24px 18px;
            position: relative;
            z-index: 1;
            background: transparent;
        }

        .index2-logo {
            width: min(100%, 560px);
            height: auto;
            display: block;
            margin: 0 auto;
            filter: drop-shadow(0 8px 24px rgba(0, 0, 0, 0.45));
        }

        .index2-section {
            position: relative;
            z-index: 1;
            padding: 26px 18px 34px;
        }

        .music-section {
            background: transparent;
            border-top: 0;
            border-bottom: 0;
        }

        .show-section {
            background: transparent;
            border-bottom: 0;
        }

        .section-inner {
            width: min(100%, 1180px);
            margin: 0 auto;
            position: relative;
        }

        .section-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 18px;
        }

        .section-title-wrap {
            min-width: 0;
        }

        .section-title {
            margin: 0;
            font-size: clamp(1.6rem, 2.6vw, 2.35rem);
            line-height: 1.1;
            font-weight: 800;
            letter-spacing: -0.03em;
            color: #fff;
        }

        .section-title-link {
            color: inherit;
            text-decoration: none;
        }

        .section-title-link:hover {
            color: #fff;
            text-decoration: none;
        }

        .section-subtitle {
            margin-top: 8px;
            color: rgba(255, 255, 255, 0.92);
            font-size: 1rem;
            line-height: 1.5;
            font-weight: 600;
        }

        .section-arrows {
            display: flex;
            gap: 10px;
            padding-top: 8px;
            flex: 0 0 auto;
        }

        .index2-arrow {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            border: 0;
            background: rgba(255, 255, 255, 0.16);
            color: #fff;
            font-size: 1.3rem;
            line-height: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: transform 0.2s ease, background 0.2s ease;
        }

        .index2-arrow:hover {
            transform: translateY(-1px);
            background: rgba(255, 255, 255, 0.24);
        }

        .track-row {
            display: flex;
            gap: 14px;
            overflow-x: auto;
            padding: 2px 2px 8px;
            scroll-snap-type: x mandatory;
            scrollbar-width: none;
        }

        .track-row::-webkit-scrollbar {
            display: none;
        }

        .music-row {
            padding-bottom: 4px;
        }

        .music-card {
            width: 100%;
            scroll-snap-align: start;
            background: transparent;
            border: 0;
            border-radius: 14px;
            padding: 14px;
            box-shadow: none;
        }

        .music-card-link,
        .show-card-link {
            display: block;
            flex: 0 0 298px;
            width: 298px;
            color: inherit;
            text-decoration: none;
        }

        .music-card-link:hover,
        .show-card-link:hover {
            color: inherit;
            text-decoration: none;
        }

        .music-card-link:hover .music-card,
        .show-card-link:hover .show-card {
            transform: translateY(-3px);
        }

        .music-card,
        .show-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .music-cover {
            width: 100%;
            aspect-ratio: 300 / 424;
            border-radius: 14px;
            object-fit: cover;
            display: block;
            background: rgba(255, 255, 255, 0.10);
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.22);
        }

        .music-name {
            margin-top: 12px;
            color: #fff;
            font-weight: 700;
            font-size: 0.98rem;
            line-height: 1.35;
        }

        .music-artist {
            margin-top: 8px;
            color: rgba(255, 255, 255, 0.82);
            font-size: 0.88rem;
            font-weight: 700;
        }

        .music-category {
            margin-top: 4px;
            color: rgba(255, 255, 255, 0.68);
            font-size: 0.85rem;
        }

        .show-row {
            gap: 18px;
        }

        #showTrackRow > * {
            flex: 0 0 298px;
            width: 298px;
            max-width: 298px;
            padding: 0;
            scroll-snap-align: start;
        }

        .show-card {
            width: 100%;
            scroll-snap-align: start;
        }

        .show-poster {
            width: 100%;
            aspect-ratio: 300 / 424;
            border-radius: 14px;
            object-fit: cover;
            display: block;
            background: rgba(255, 255, 255, 0.06);
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.22);
        }

        #showTrackRow .show-card {
            width: 100%;
            background: transparent;
            border: 0;
            box-shadow: none;
            overflow: visible;
        }

        #showTrackRow .show-card img.show-poster {
            width: 100%;
        }

        #showTrackRow .card {
            background: transparent;
            border: 0;
            box-shadow: none;
        }

        #showTrackRow .card-body {
            padding: 12px 0 0;
            background: transparent;
        }

        #showTrackRow a {
            color: inherit;
            text-decoration: none;
        }

        #showTrackRow a:hover {
            color: inherit;
            text-decoration: none;
        }

        #showTrackRow .show-title {
            margin: 0;
            color: #fff;
            font-weight: 700;
            font-size: 0.98rem;
            line-height: 1.4;
        }

        #showTrackRow .show-meta {
            margin: 6px 0 0;
            color: rgba(255, 255, 255, 0.72);
            font-size: 0.88rem;
            font-weight: 600;
        }

        .show-name {
            margin-top: 10px;
            color: #fff;
            font-weight: 700;
            font-size: 0.98rem;
            line-height: 1.4;
        }

        .show-venue {
            margin-top: 4px;
            color: rgba(255, 255, 255, 0.72);
            font-size: 0.88rem;
            font-weight: 600;
        }

        .section-end-spacer {
            height: 10px;
        }

        @media (max-width: 768px) {
            .index2-hero {
                min-height: 200px;
                padding: 22px 16px 12px;
            }

            .index2-logo {
                width: min(100%, 380px);
            }

            .index2-section {
                padding: 22px 14px 28px;
            }

            .section-header {
                align-items: center;
            }

            .section-subtitle {
                font-size: 0.92rem;
            }

            .music-card {
                padding: 12px;
            }

            .music-card-link,
            .show-card-link {
                flex-basis: 252px;
                width: 252px;
            }

            .show-card {
                width: 100%;
            }

            .index2-arrow {
                width: 34px;
                height: 34px;
                font-size: 1.15rem;
            }
        }
    </style>
</head>
<body class="index2-page">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <main class="index2-stage">
        <section class="index2-hero">
            <img class="index2-logo" src="${path}/resources/images/show/808.png" alt="808 Project">
        </section>

        <section class="index2-section music-section">
            <div class="section-inner">
                <div class="section-header">
                    <div class="section-title-wrap">
                        <h2 class="section-title">
                            <a class="section-title-link" href="${path}/music">주간 인기곡</a>
                        </h2>
                        <div class="section-subtitle">이번 주 가장 많이 사랑받은 곡들이에요.</div>
                    </div>
                    <div class="section-arrows">
                        <button class="index2-arrow" type="button" data-target="#musicTrackRow" data-dir="-1" aria-label="이전 음악">‹</button>
                        <button class="index2-arrow" type="button" data-target="#musicTrackRow" data-dir="1" aria-label="다음 음악">›</button>
                    </div>
                </div>

                <div class="track-row music-row" id="musicTrackRow">
                    <a class="music-card-link" href="${path}/music">
                        <div class="music-card">
                            <img class="music-cover" src="${path}/resources/music/img/TWICE_Feel Special.jpg" alt="Feel Special">
                            <div class="music-name">Feel Special</div>
                            <div class="music-artist">TWICE</div>
                            <div class="music-category">주간 인기곡</div>
                        </div>
                    </a>
                    <a class="music-card-link" href="${path}/music">
                        <div class="music-card">
                            <img class="music-cover" src="${path}/resources/music/img/NewJeans_Ditto.jpg" alt="Ditto">
                            <div class="music-name">Ditto</div>
                            <div class="music-artist">NEWJEANS</div>
                            <div class="music-category">주간 인기곡</div>
                        </div>
                    </a>
                    <a class="music-card-link" href="${path}/music">
                        <div class="music-card">
                            <img class="music-cover" src="${path}/resources/music/img/타임캡슐.png" alt="타임캡슐">
                            <div class="music-name">타임캡슐</div>
                            <div class="music-artist">다비치</div>
                            <div class="music-category">주간 인기곡</div>
                        </div>
                    </a>
                    <a class="music-card-link" href="${path}/music">
                        <div class="music-card">
                            <img class="music-cover" src="${path}/resources/music/img/aespa_Next Level.jpg" alt="Next Level">
                            <div class="music-name">Next Level</div>
                            <div class="music-artist">aespa</div>
                            <div class="music-category">주간 인기곡</div>
                        </div>
                    </a>
                    <a class="music-card-link" href="${path}/music">
                        <div class="music-card">
                            <img class="music-cover" src="${path}/resources/music/img/IU_Good Day.jpg" alt="좋은 날">
                            <div class="music-name">좋은 날</div>
                            <div class="music-artist">아이유</div>
                            <div class="music-category">주간 인기곡</div>
                        </div>
                    </a>
                    <a class="music-card-link" href="${path}/music">
                        <div class="music-card">
                            <img class="music-cover" src="${path}/resources/music/img/자몽살구클럽.png" alt="0+0">
                            <div class="music-name">0+0</div>
                            <div class="music-artist">한로로</div>
                            <div class="music-category">주간 인기곡</div>
                        </div>
                    </a>
                </div>
            </div>
        </section>

        <section class="index2-section show-section">
            <div class="section-inner">
                <div class="section-header">
                    <div class="section-title-wrap">
                        <h2 class="section-title">
                            <a class="section-title-link" href="${path}/show">공연</a>
                        </h2>
                    </div>
                    <div class="section-arrows">
                        <button class="index2-arrow" type="button" data-target="#showTrackRow" data-dir="-1" aria-label="이전 공연">‹</button>
                        <button class="index2-arrow" type="button" data-target="#showTrackRow" data-dir="1" aria-label="다음 공연">›</button>
                    </div>
                </div>

                <div class="track-row show-row" id="showTrackRow">
                    <a class="show-card-link" href="${path}/show/showDetail?showId=PF281962">
                        <div class="show-card">
                            <img class="show-poster" src="${path}/resources/images/show/img1.png" alt="렉처 콘서트 IV, 미국 음악의 탄생 [공주]">
                            <div class="show-name">렉처 콘서트 IV, 미국 음악의 탄생 [공주]</div>
                            <div class="show-venue">공주문예회관</div>
                        </div>
                    </a>
                    <a class="show-card-link" href="${path}/show/showDetail?showId=PF283340">
                        <div class="show-card">
                            <img class="show-poster" src="${path}/resources/images/show/img2.png" alt="마이 케미컬 로맨스 내한공연">
                            <div class="show-name">마이 케미컬 로맨스 내한공연</div>
                            <div class="show-venue">파라다이스시티</div>
                        </div>
                    </a>
                    <a class="show-card-link" href="${path}/show/showDetail?showId=PF283678">
                        <div class="show-card">
                            <img class="show-poster" src="${path}/resources/images/show/img3.png" alt="옥타재즈 V. LUCA MINOR">
                            <div class="show-name">옥타재즈 V. LUCA MINOR</div>
                            <div class="show-venue">아트센터 인천</div>
                        </div>
                    </a>
                    <a class="show-card-link" href="${path}/show/showDetail?showId=PF284034">
                        <div class="show-card">
                            <img class="show-poster" src="${path}/resources/images/show/img4.png" alt="성남아트센터 오후의 콘서트">
                            <div class="show-name">성남아트센터 오후의 콘서트</div>
                            <div class="show-venue">성남아트센터</div>
                        </div>
                    </a>
                </div>
                <div class="section-end-spacer"></div>
            </div>
        </section>
    </main>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>
    <script>
        (function() {
            function scrollTrack(button) {
                var target = document.querySelector(button.getAttribute('data-target'));
                if (!target) {
                    return;
                }

                var direction = Number(button.getAttribute('data-dir')) || 1;
                var amount = Math.max(target.clientWidth * 0.82, 320);
                target.scrollBy({
                    left: amount * direction,
                    behavior: 'smooth'
                });
            }

            document.querySelectorAll('.index2-arrow').forEach(function(button) {
                button.addEventListener('click', function() {
                    scrollTrack(button);
                });
            });

            $.getJSON('${path}/music/weekly-ranking', function(songs) {
                if (!songs || !songs.length) {
                    return;
                }

                var html = '';
                songs.slice(0, 6).forEach(function(song) {
                    var cover = song.coverImageUrl || '${path}/resources/music/img/default_album.png';
                    html += ''
                        + '<a class="music-card-link" href="${path}/music" data-song-id="' + song.songId + '" data-song-title="' + (song.title || '') + '" data-song-artist="' + (song.artistName || '') + '" data-song-cover="' + cover + '">'
                        + '  <div class="music-card">'
                        + '    <img class="music-cover" src="' + cover + '" alt="' + song.title + '">'
                        + '    <div class="music-name">' + song.title + '</div>'
                        + '    <div class="music-artist">' + (song.artistName || '') + '</div>'
                        + '    <div class="music-category">주간 인기곡</div>'
                        + '  </div>'
                        + '</a>';
                });

                $('#musicTrackRow').html(html);
            });

            $('#musicTrackRow').on('click', '.music-card-link', function() {
                var $link = $(this);
                var payload = {
                    songId: String($link.data('song-id') || ''),
                    title: String($link.data('song-title') || ''),
                    artistName: String($link.data('song-artist') || ''),
                    coverImageUrl: String($link.data('song-cover') || '')
                };

                sessionStorage.setItem('pendingMusicSong', JSON.stringify(payload));
            });

            $.get('${path}/show/showListAjax?category=concert&subCategory=all', function(html) {
                var $frag = $(html);
                var $cards = $frag.filter('.col-lg-3, .col-md-4, .col-sm-6, .col-12');
                if ($cards.length === 0) {
                    $cards = $frag.find('.col-lg-3, .col-md-4, .col-sm-6, .col-12');
                }
                if ($cards.length > 0) {
                    $('#showTrackRow').html($cards);
                }
            });
        })();
    </script>
</body>
</html>
