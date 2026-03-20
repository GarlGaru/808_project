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
    // console.log("get path : " + path)

    /* ── 취향 기반 추천 ─────────────────────────────────────────── */
    MusicSlider({
        mountId:  'personal-recommend-mount',
        title:    '취향 기반 추천',
        subtitle: '좋아할 만한 곡들을 모아봤어요.',
        apiUrl:   `${path}/music/personal-recommend`,
        sliderId: 'weeklySlider',
        label:    '취향 기반 추천',
        path,
    });

    /* ── 좋아할만한 인기 트랙 ───────────────────────────────────────── */
    MusicSlider({
        mountId:  'today-slider-mount',
        title:    '좋아할만한 인기 트랙',
        subtitle: '나와 비슷한 취향의 사용자들이 많이 찾는 곡.',
        apiUrl:   `${path}/music/today-hits`,
        sliderId: 'todaySlider',
        label:    '좋아할만한 인기 트랙',
        path,
    });

    /* ── 좋아할만한 최신 곡 ─────────────────────────────────────────── */
    MusicSlider({
        mountId:  'genre-slider-mount',
        title:    '좋아할만한 최신 곡',
        subtitle: '새로나온 곡, 이런건 어떠세요?',
        apiUrl:   `${path}/music/genre-ranking`,
        sliderId: 'genreSlider',
        label:    '좋아할만한 최신 곡',
        path,
    });

}
