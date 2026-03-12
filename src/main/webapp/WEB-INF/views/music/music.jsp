<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<script>
function loadCategory(genreId){

    $.ajax({
        url: '${pageContext.request.contextPath}/category/songs',
        type: 'POST',
        data: { genreId : genreId },
        success: function(result){
            $('#songArea').html(result);
        },
        error: function(){
            alert('카테고리 로딩 실패');
        }
    });

}
</script>

<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Bootstrap 4 Spotify-style buttons sample">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Music</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
 
	
	<!-- 이 페이지에서만 쓰는 간단한 음악 카드 스타일 -->
	
</head>
	<body class="dark-mode">

    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <%@ include file="/WEB-INF/views/music/aside.jsp"%>

    <div class="music-main-layout">
        <%@ include file="/WEB-INF/views/music/mainstory.jsp"%>
    </div>

    <%@ include file="/WEB-INF/views/music/player.jsp" %>


<!-- ============================================================================================ -->

    <!-- 공통 JS -->
    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
<%--     <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script> --%>
    <script src="${path}/resources/common/js/main.js"></script>

    <!-- Music 페이지 전용 JS -->
    <script>
        // 장르 버튼 클릭 시 카테고리 로딩
        function loadCategory(genreId) {
            $.ajax({
                url: '${pageContext.request.contextPath}/category/songs',
                type: 'POST',
                data: { genreId: genreId },
                success: function (result) {
                    $('#songArea').html(result);
                },
                error: function () {
                    alert('카테고리 로딩 실패');
                }
            });
        }

        $(function () {
            /* ------------------------------
               1) 주간 랭킹 가로 스크롤 자동 이동
               ------------------------------ */
            var $wrapper = $('#weeklyRankWrapper');
            var scrollAmount = 220;        // 한 번에 움직일 픽셀 (카드 하나 정도)
            var autoInterval = 4000;       // 자동 스크롤 간격(ms)
            var autoTimer = null;

            function scrollRight() {
                if ($wrapper.length === 0) return;

                var maxScroll = $wrapper[0].scrollWidth - $wrapper.outerWidth();
                var current = $wrapper.scrollLeft();
                var next = current + scrollAmount;

                // 끝에 거의 다 왔으면 처음으로
                if (next >= maxScroll - 5) {
                    next = 0;
                }

                $wrapper.stop().animate({ scrollLeft: next }, 600);
            }

            function scrollLeft() {
                if ($wrapper.length === 0) return;

                var maxScroll = $wrapper[0].scrollWidth - $wrapper.outerWidth();
                var current = $wrapper.scrollLeft();
                var next = current - scrollAmount;

                // 맨 앞으로 오면 끝으로 점프
                if (next <= 0) {
                    next = maxScroll;
                }

                $wrapper.stop().animate({ scrollLeft: next }, 600);
            }

            function startAuto() {
                if (autoTimer) return;
                autoTimer = setInterval(scrollRight, autoInterval);
            }

            function stopAuto() {
                if (autoTimer) {
                    clearInterval(autoTimer);
                    autoTimer = null;
                }
            }

            // 좌우 버튼
            $('.weekly-arrow-right').on('click', function () {
                stopAuto();
                scrollRight();
            });
            $('.weekly-arrow-left').on('click', function () {
                stopAuto();
                scrollLeft();
            });

            // 마우스 올리면 자동 스크롤 잠시 멈춤 / 떼면 다시 시작
            $wrapper.on('mouseenter', function () {
                stopAuto();
            }).on('mouseleave', function () {
                startAuto();
            });

            // 자동 시작
            startAuto();


            /* ------------------------------
               2) 하단 플레이어 기본 동작
               ------------------------------ */
            var audio = document.getElementById('audioPlayer');
            var $btnPlayPause = $('#btnPlayPause');
            var $currentTime = $('#currentTime');
            var $totalTime = $('#totalTime');
            var $progress = $('#playerProgress');
            var $progressFill = $('#playerProgressFill');
            var $volumeBar = $('#playerVolumeBar');
            var $volumeFill = $('#playerVolumeFill');

            // 재생 / 일시정지 버튼
            $btnPlayPause.on('click', function () {
                if (audio.paused) {
                    audio.play();
                    $btnPlayPause.html('&#10074;&#10074;'); // 일시정지(II)
                } else {
                    audio.pause();
                    $btnPlayPause.html('&#9658;');          // 재생(▶)
                }
            });

            // 메타데이터 로딩 후 총 시간 표시
            audio.addEventListener('loadedmetadata', function () {
                $totalTime.text(formatTime(audio.duration));
            });

            // 재생 중 시간/진행바 업데이트
            audio.addEventListener('timeupdate', function () {
                $currentTime.text(formatTime(audio.currentTime));
                if (audio.duration) {
                    var percent = (audio.currentTime / audio.duration) * 100;
                    $progressFill.css('width', percent + '%');
                }
            });

            // 진행바 클릭으로 위치 이동
            $progress.on('click', function (e) {
                var rect = this.getBoundingClientRect();
                var offsetX = e.clientX - rect.left;
                var ratio = offsetX / rect.width;
                if (audio.duration) {
                    audio.currentTime = audio.duration * ratio;
                }
            });

            // 볼륨 바 클릭
            $volumeBar.on('click', function (e) {
                var rect = this.getBoundingClientRect();
                var offsetX = e.clientX - rect.left;
                var ratio = offsetX / rect.width;
                ratio = Math.max(0, Math.min(1, ratio));
                audio.volume = ratio;
                $volumeFill.css('width', (ratio * 100) + '%');
            });

            function formatTime(sec) {
                sec = Math.floor(sec || 0);
                var m = Math.floor(sec / 60);
                var s = sec % 60;
                if (s < 10) s = '0' + s;
                return m + ':' + s;
            }
        });
    </script>
</body>
</html>

