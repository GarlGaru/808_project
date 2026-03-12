import { getPlaylistAll, getPlaylist } from './api.js'


document.addEventListener("DOMContentLoaded", async ()=>{

    // 회원이 가지고 있는 모든 플레이 리스트 가져오고, 분리하기
    const playlistIdAllList = await getPlaylistAll();

    // 결과 리스트 3개 초기화
    let likePlaylist = null;
    let historyPlaylist = null;
    let playlistRest = [];

    const targetLikeStr = "_LIKE_";
    const targetHistoryStr = "_HISTORY_";

    for(const playlist of playlistIdAllList){
        if(!likePlaylist && playlist.title === targetLikeStr){
            likePlaylist = playlist;
            continue;
        }
        
        if(!historyPlaylist && playlist.title === targetHistoryStr){
            historyPlaylist = playlist;
            continue;
        }

        playlistRest.push(playlist);
    }
    
    // value 넣기 
    const btnLike = document.getElementById("btnLike");
    const btnHistory = document.getElementById("btnHistory");
    
    if (likePlaylist) {
        btnLike.dataset.value = likePlaylist.playlistId;
        btnLike.addEventListener("click", getPlaylist);
    }

    if(historyPlaylist){
        btnHistory.dataset.value = historyPlaylist.playlistId;
        btnHistory.addEventListener("click", getPlaylist);
    }



})

