
export async function getPlaylistAll() {
    const response = await fetch("/eze/playlist/all");
    const list = await response.json();
    return list;
}

export async function getPlaylist(e) {
    const value = e.currentTarget.dataset.value;

    const response = await fetch("/eze/playlist?playListId=" + value);
    const list = await response.json();
    console.log(list);
    // 페이지 이동
}