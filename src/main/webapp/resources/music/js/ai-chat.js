
function initAiChat() {
    const API_URL = '/eze/api/chat/ask';
    const box = document.getElementById('ai-chat-messages');
    const ta    = document.getElementById('ai-chat-msg');
    const btn = document.getElementById('ai-chat-send');
    let busy = false;

    ta.oninput = () => {
        ta.style.height = 'auto';
        ta.style.height = Math.min(ta.scrollHeight, 100) + 'px';
    };

    ta.onkeydown = (e) => {
        if(e.key==='Enter' && !e.shiftKey){ e.preventDefault(); go(); }
    };
    btn.onclick = go;

    function go(){
        const t = ta.value.trim();
        if(!t || busy) return;
        addMsg('ai-chat-user', t);
        ta.value = ''; ta.style.height = 'auto';
        busy = true; btn.disabled = true;
        const dots = addDots();

        fetch(API_URL, {
            method:'POST',
            headers:{'Content-Type':'application/json'},
            body: JSON.stringify({message: t})
        })
        .then(r => { if(!r.ok) throw new Error(r.status); return r.json(); })
        .then(d => { dots.remove(); renderBot(d); })
        .catch(e => { dots.remove(); addMsg('ai-chat-bot','오류가 발생했습니다. ('+e.message+')'); })
        .finally(() => { busy=false; btn.disabled=false; });
    }

    function addMsg(cls, txt){
        const d = document.createElement('div');
        d.className = cls;
        d.textContent = txt;
        box.appendChild(d);
        box.scrollTop = box.scrollHeight;
    }

    function renderBot(data){
        const wrap = document.createElement('div');
        wrap.className = 'ai-chat-bot';

        if(data.reply){
            const p = document.createElement('div');
            p.textContent = data.reply;
            wrap.appendChild(p);
        }

        if(data.songs && data.songs.length){
            const list = document.createElement('div');
            list.className = 'ai-chat-songs';
            data.songs.forEach(s => {
                const c = document.createElement('div');
                c.className = 'ai-chat-card';
                let h = '<div class="ai-chat-card-title">'+esc(s.song_title)+'</div>';
                h += '<div class="ai-chat-card-meta">'+esc(s.artist_name)+' · '+esc(s.album_title)+'</div>';
                if(s.genres && s.genres.length){
                    h += '<div class="ai-chat-card-genres">';
                    s.genres.forEach(g => { h += '<span>'+esc(g)+'</span>'; });
                    h += '</div>';
                }
                c.innerHTML = h;
                list.appendChild(c);
            });
            wrap.appendChild(list);
        }

        box.appendChild(wrap);
        box.scrollTop = box.scrollHeight;
    }

    function addDots(){
        const d = document.createElement('div');
        d.className = 'ai-chat-dots';
        d.innerHTML = '<i></i><i></i><i></i>';
        box.appendChild(d);
        box.scrollTop = box.scrollHeight;
        return d;
    }

    function esc(s){
        const d = document.createElement('div');
        d.textContent = s||'';
        return d.innerHTML;
    }

}