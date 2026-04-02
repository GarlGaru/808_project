/**
 * slider-init.js
 * 페이지 로드 시 MusicSlider 컴포넌트를 초기화합니다.
 *
 * 의존: MusicSlider.js, moveSlider(), loadMainContent(), playSong()
 * 
 */



function initMainStory() {
    console.log("MainStory tab init start");

    const path = document.documentElement.dataset.contextPath ?? '';

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
        title:    'K-POP 인기곡',
        subtitle: '이번주 K-POP에서 인기가 높은 곡입니다.',
        apiUrl:   `${path}/music/genre-ranking`,
        sliderId: 'genreSlider',
        label:    'K-POP 인기곡',
        path,
    });
}

/**
 * ranking.js
 * ranking.jsp 페이지 로드 시 MusicSlider 컴포넌트를 초기화합니다.
 *
 */
function initRanking() {
    console.log("Ranking tab init start");

    const path = document.documentElement.dataset.contextPath ?? '';

    /* ── 최근 인기 랭킹 ───────────────────────────────────────── */
    MusicSlider({
        mountId:  'weekly-ranking-mount',
        title:    '최근 인기 랭킹',
        subtitle: '가장 많이 재생된 곡들을 확인해보세요.',
        apiUrl:   `${path}/music/weekly-ranking`,
        sliderId: 'weeklyRankingSlider',
        label:    '최근 인기 랭킹',
        path,
    });

    /* ── 오늘의 히트곡 ───────────────────────────────────────── */
    MusicSlider({
        mountId:  'today-ranking-mount',
        title:    '오늘의 히트곡',
        subtitle: '오늘 가장 반응이 좋은 곡입니다.',
        apiUrl:   `${path}/music/today-hits`,
        sliderId: 'todayRankingSlider',
        label:    '오늘의 히트곡',
        path,
    });

    /* ── 장르 인기곡 ─────────────────────────────────────────── */
    MusicSlider({
        mountId:  'genre-ranking-mount',
        title:    'K-POP 인기곡',
        subtitle: '이번주 K-POP에서 인기가 높은 곡입니다.',
        apiUrl:   `${path}/music/genre-ranking`,
        sliderId: 'genreRankingSlider',
        label:    'K-POP 인기곡',
        path,
    });
}


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
        sliderId: 'recoSlider',
        label:    '취향 기반 추천',
        path,
    });

    /* ── 좋아할만한 인기 트랙 ───────────────────────────────────────── */
    MusicSlider({
        mountId:  'reco-popular-slider-mount',
        title:    '좋아할만한 인기 트랙',
        subtitle: '나와 비슷한 취향의 사용자들이 많이 찾는 곡.',
        apiUrl:   `${path}/music/personal-recommend-popular`,
        sliderId: 'recoPopularSlider',
        label:    '좋아할만한 인기 트랙',
        path,
    });

    /* ── 좋아할만한 최신 곡 ─────────────────────────────────────────── */
    MusicSlider({
        mountId:  'reco-latest-slider-mount',
        title:    '좋아할만한 최신 곡',
        subtitle: '새로나온 곡, 이런건 어떠세요?',
        apiUrl:   `${path}/music/personal-recommend-latest`,
        sliderId: 'recoLatestSlider',
        label:    '좋아할만한 최신 곡',
        path,
    });

}
