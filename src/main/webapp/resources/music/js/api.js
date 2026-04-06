
export async function getPlaylistAll() {
    const response = await fetch("/eze/playlist/all");
    const list = await response.json();
    return list;
}

export async function getPlaylist(playlistId) {
    const response = await fetch("/eze/playlist?playlistId=" + playlistId);
    const list = await response.json();
    return list;
}

export async function getLikes() {
    const response = await fetch("/eze/like");
    const data = await response.json();
    return data;
}

export async function getLikeSongs() {
    const response = await fetch("/eze/music/like/songs");
    const data = await response.json();
    return data;
}

export async function getHistory() {
    const response = await fetch("/eze/history");
    const data = await response.json();
    return data;
}
