
async function getSongList(apiUrl) {
    let songs = [];
    try {
        const res = await fetch(apiUrl);
        if (!res.ok) throw new Error(`API 오류: ${res.status}`);
        songs = await res.json();
    } catch (err) {
        console.error(`[MusicSlider] API 호출 오류 (${apiUrl})`, err);
    }
    return songs;
}
