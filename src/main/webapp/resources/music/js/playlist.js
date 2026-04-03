import { getPlaylistAll, getPlaylist,getLikeSongs, getHistory } from './api.js'
import { renderLikeSongs } from './likedListView.js'

document.addEventListener("DOMContentLoaded", async () => {

    const btnLike = document.getElementById("btnGetLikeList");
    const btnHistory = document.getElementById("btnGetHistoryList");
    const normalContainer = document.getElementById("normalPlaylistContainer");

    // --- 좋아요 클릭 ---
    btnLike.addEventListener("click", async () => {
	    console.log("좋아요 리스트 버튼 클릭됨");

	    try {
	        const data = await getLikeSongs();
	        console.log("좋아요 곡 목록:", data);
	        console.log("배열인가?", Array.isArray(data));
	
	        renderLikeSongs(data);
	    } catch (error) {
	        console.error("좋아요 곡 목록 조회 실패:", error);
	    }
	});

    // --- 히스토리 클릭 ---
    btnHistory.addEventListener("click", async () => {
        const data = await getHistory();
        console.log("히스토리:", data);
    });

    // --- NORMAL 플레이리스트 동적 렌더링 ---
    const playlistAllList = await getPlaylistAll();
    console.log(playlistAllList);

    normalContainer.innerHTML = playlistAllList.map(playlist => `
        <div class="music-side-item" data-value="${playlist.playlistId}">
            <div class="music-side-icon">
                <i class="bi bi-music-note-list"></i>
            </div>
            <div class="music-side-info">
                <div class="music-side-title">${playlist.title}</div>
                <div class="music-side-meta">플레이리스트</div>
            </div>
        </div>
    `).join('');

    // --- NORMAL 클릭 이벤트 (이벤트 위임) ---
    normalContainer.addEventListener("click", async (e) => {
        const item = e.target.closest(".music-side-item");
        if (!item) return;

        const playlistId = item.dataset.value;
        const data = await getPlaylist(playlistId);
        console.log("플레이리스트 " + playlistId + ":", data);
    });

});


