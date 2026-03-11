function scrollTrack(trackId, dir) {
   var el = document.getElementById(trackId);
   if(!el) return;
   el.scrollBy({ left: dir * 420, behavior: 'smooth'});
}
  