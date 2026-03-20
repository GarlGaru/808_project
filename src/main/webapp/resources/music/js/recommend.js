/**
 * recommend.js
 * 페이지 로드 시 MusicSlider 컴포넌트 3개를 초기화합니다.
 *
 * 의존: MusicSlider.js, moveSlider(), loadMainContent(), playSong()
 */
function initMusicReco(){
    console.log("Recoomand tab init start")

    // 컨텍스트 루트 경로 (recommend.jsp의 <html data-context-path="${path}"> 에서 주입)
    const path = document.documentElement.dataset.contextPath ?? '';
    console.log("get path : " + path)

    /* ── 주간 인기곡 ─────────────────────────────────────────── */
    MusicSlider({
        mountId:  'weekly-slider-mount',
        title:    '주간 인기곡',
        subtitle: '이번 주 가장 많이 사랑받은 곡들이에요.',
        apiUrl:   `${path}/music/weekly-ranking`,
        sliderId: 'weeklySlider',
        label:    '주간 인기곡',
        path,
    });

    /* ── 오늘의 히트곡 ───────────────────────────────────────── */
    MusicSlider({
        mountId:  'today-slider-mount',
        title:    '오늘의 히트곡',
        subtitle: '오늘 많이 재생된 곡들을 모아봤어요.',
        apiUrl:   `${path}/music/today-hits`,
        sliderId: 'todaySlider',
        label:    '오늘의 히트곡',
        path,
    });

    /* ── 장르 인기곡 ─────────────────────────────────────────── */
    MusicSlider({
        mountId:  'genre-slider-mount',
        title:    '장르 인기곡',
        subtitle: '지금 인기 있는 장르별 추천 곡이에요.',
        apiUrl:   `${path}/music/genre-ranking`,
        sliderId: 'genreSlider',
        label:    '장르 인기곡',
        path,
    });

}
