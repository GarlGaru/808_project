/**
 * mypage.js
 * ================================================================
 * ERD 매핑 주석:
 *   PLAY_LOG_TBL   → songs, artists 더미
 *   FREE_COMMENT   → cmts 더미
 *   RESERVATION_TBL + SEAT_TBL + SCHEDULE_TBL + SHOW_TBL → reservations 더미
 *   PAYMENT_ORDER  → pays 더미
 *
 * 실서비스 연동 시: 각 렌더 함수 앞 $.ajax 호출로 교체
 * ================================================================
 */
(function () {
  'use strict';

  /* ═══════════════════════════════════════════
     열기 / 닫기
  ═══════════════════════════════════════════ */

  /** 전역 노출 — 어느 페이지 버튼에서든 onclick="openMypage()" */
  window.openMypage = function () {
    var ov = document.getElementById('mpOverlay');
    if (!ov) return;
    ov.style.display = 'flex';
    ov.offsetHeight; // reflow — animation 재실행
    ov.classList.remove('genie-out');
    document.getElementById('mpModal').classList.remove('genie-out');
    document.body.style.overflow = 'hidden';
  };

  window.mpClose = function () {
    var ov    = document.getElementById('mpOverlay');
    var modal = document.getElementById('mpModal');
    var icon  = document.getElementById('mpAv');
    if (!ov || !modal) return;

    var ir = icon.getBoundingClientRect();
    var mr = modal.getBoundingClientRect();
    var offset = ir.left + ir.width / 2 - (mr.left + mr.width / 2);
    modal.style.transformOrigin = 'calc(50% + ' + offset.toFixed(1) + 'px) top';

    modal.classList.add('genie-out');
    ov.classList.add('genie-out');

    setTimeout(function () {
      icon.classList.add('icon-pop');
      setTimeout(function () {
        ov.style.display = 'none';
        modal.classList.remove('genie-out');
        ov.classList.remove('genie-out');
        modal.style.transformOrigin = '';
        icon.classList.remove('icon-pop');
        document.body.style.overflow = '';
      }, 500);
    }, 600);
  };

  /** overlay 직접 클릭 시만 닫힘 (modal 내부 버블링 차단) */
  window.mpOutsideClick = function (e) {
    if (e.target === document.getElementById('mpOverlay')) mpClose();
  };

  document.addEventListener('keydown', function (e) {
    if (e.key !== 'Escape') return;
    var ov = document.getElementById('mpOverlay');
    if (ov && ov.style.display !== 'none') mpClose();
  });

  /* ═══════════════════════════════════════════
     탭 전환
  ═══════════════════════════════════════════ */
  window.mpTab = function (el, id, title, sub) {
    document.querySelectorAll('.mypage-modal .nav-item').forEach(function (n) { n.classList.remove('active'); });
    document.querySelectorAll('.mypage-modal .tab-pane').forEach(function (p) { p.classList.remove('active'); });
    el.classList.add('active');
    document.getElementById('tab-' + id).classList.add('active');
    document.getElementById('mpTitle').textContent = title;
    document.getElementById('mpSub').textContent   = sub;
    if (id === 'payments' && !window._mpChartInited) mpInitChart();
  };

  /* ═══════════════════════════════════════════
     아바타 변경 (PROFILE_TBL.photo_url)
  ═══════════════════════════════════════════ */
  window.mpChangeAvatar = function (input) {
    if (!input.files || !input.files[0]) return;
    var reader = new FileReader();
    reader.onload = function (e) {
      document.getElementById('mpAv').innerHTML = '<img src="' + e.target.result + '" alt="프로필">';
    };
    reader.readAsDataURL(input.files[0]);
    /*
     * 실서비스 연동:
     * var form = new FormData();
     * form.append('file', input.files[0]);
     * $.ajax({
     *   url: contextPath + '/member/uploadPhoto',
     *   method: 'POST', data: form,
     *   processData: false, contentType: false,
     *   success: function(res) { ... }
     * });
     */
  };

  /* ═══════════════════════════════════════════
     프로필 보기 ↔ 수정 토글
     USER_TBL.nickname / PROFILE_TBL.birth_date, bio
  ═══════════════════════════════════════════ */
  window.mpEditStart = function () {
    document.getElementById('mpPvView').style.display = 'none';
    document.getElementById('mpPvEdit').style.display = 'block';
  };
  window.mpEditCancel = function () {
    document.getElementById('mpPvEdit').style.display = 'none';
    document.getElementById('mpPvView').style.display = 'block';
  };
  window.mpEditSave = function () {
    var nick  = document.getElementById('eNick').value.trim();
    var bio   = document.getElementById('eBio').value.trim();
    var birth = document.getElementById('eBirth').value;

    if (!nick) { alert('닉네임을 입력해주세요.'); return; }

    // 화면 즉시 반영
    if (nick)  document.getElementById('vNick').textContent = nick;
    if (bio)   document.getElementById('vBio').textContent  = bio || '소개를 입력해주세요';
    if (birth) {
      var d = new Date(birth);
      document.getElementById('vBirth').textContent =
        d.getFullYear() + '년 ' + (d.getMonth()+1) + '월 ' + d.getDate() + '일';
    }

    /*
     * 실서비스 연동 (USER_TBL + PROFILE_TBL UPDATE):
     * $.ajax({
     *   url: contextPath + '/member/update',
     *   method: 'POST',
     *   data: { nickname: nick, bio: bio, birthDate: birth },
     *   success: function(res) {
     *     if (res.result === 'ok') { mpEditCancel(); }
     *     else { alert(res.message); }
     *   }
     * });
     */
    mpEditCancel();
  };

  /* ═══════════════════════════════════════════
     이메일 인증코드 발송 (EMAIL_CODE_TBL)
  ═══════════════════════════════════════════ */
  window.mpSendCode = function (email) {
    if (!email) return;
    alert('인증 코드가 ' + email + ' 로 발송되었습니다. (데모)');
    /*
     * 실서비스:
     * $.ajax({
     *   url: contextPath + '/member/sendEmailCode',
     *   method: 'POST', data: { email: email },
     *   success: function(res) { alert(res.message); }
     * });
     */
  };

  /* ═══════════════════════════════════════════
     계정 탈퇴 (USER_TBL DELETE → CASCADE)
  ═══════════════════════════════════════════ */
  window.mpWithdraw = function () {
    if (confirm('정말 탈퇴하시겠습니까?\n탈퇴 후 모든 데이터가 삭제되며 복구가 불가능합니다.')) {
      location.href = '/member/withdraw';
    }
  };

  /* ═══════════════════════════════════════════
     더미 데이터
     실서비스: JSP EL 또는 Ajax로 교체
     ───────────────────────────────────────────
     ERD 필드 매핑:
     songs     → SONGS_TBL.song_id, title + ARTISTS_TBL.name + PLAY_LOG_TBL 집계
     artists   → ARTISTS_TBL.artist_id, name + PLAY_LOG_TBL 집계
     cmts      → FREE_COMMENT.cno, content + FREE_BOARD.title
     pays      → PAYMENT_ORDER.order_id, status + SHOW_TBL.title
     reservations → RESERVATION_TBL.reservation_id, status
                    + SEAT_TBL.seat_label
                    + SCHEDULE_TBL.start_time
                    + SHOW_TBL.title
  ═══════════════════════════════════════════ */
  var DUMMY = {
    songs: [
      /* song_id, SONGS_TBL.title, ARTISTS_TBL.name, PLAY_LOG_TBL COUNT */
      { rank:1,  title:'All the Right Moves', artist:'Leonardo Lastra', plays:340, em:'🎵' },
      { rank:2,  title:'Rescue Me',           artist:'Erika Marino',    plays:265, em:'💜' },
      { rank:3,  title:'Fantasy Land',        artist:'Isabella Romano', plays:212, em:'🌙' },
      { rank:4,  title:'Turn Your Face',      artist:'Limi',            plays:180, em:'🌸' },
      { rank:5,  title:'Stack It Up',         artist:'Ariana Ricci',    plays:155, em:'⚡' },
      { rank:6,  title:'Midnight Sun',        artist:'Sol Park',        plays:134, em:'🌅' },
      { rank:7,  title:'Blue Monday',         artist:'New Order',       plays:118, em:'💙' },
      { rank:8,  title:'Echoes',              artist:'Pink Floyd',      plays:95,  em:'🌊' },
      { rank:9,  title:'Gravity',             artist:'John Mayer',      plays:88,  em:'🎸' },
      { rank:10, title:'Blinding Lights',     artist:'The Weeknd',      plays:76,  em:'🔴' }
    ],
    artists: [
      /* ARTISTS_TBL.artist_id, name + PLAY_LOG_TBL 집계 */
      { rank:1, name:'Erika Marino',    count:54, em:'🎤' },
      { rank:2, name:'Leonardo Lastra', count:41, em:'🎵' },
      { rank:3, name:'Isabella Romano', count:38, em:'🎸' }
    ],
    cmts: [
      /* FREE_COMMENT.cno + FREE_BOARD.title + content + created_at */
      { target:'All the Right Moves',          date:'2026.02.14', text:'이 곡 정말 중독성 있어요! 계속 듣게 되는 매력이 있어요. 최고입니다 👏' },
      { target:'공연 리뷰: Erika Marino Live',  date:'2026.01.30', text:'라이브 무대가 상상 이상이었어요. 직접 보고 느끼는 에너지가 달랐습니다.' },
      { target:'Fantasy Land 앨범',            date:'2026.01.22', text:'앨범 전체가 하나의 이야기처럼 흘러가는 느낌이에요. 명반입니다!' }
    ],
    pays: [
      /* PAYMENT_ORDER.order_id, status(PAID/REFUNDED) + SHOW_TBL.title */
      { name:'Premium 정기 결제',  sub:'2026.02.01',                  amt:'₩9,900',   em:'⚡', status:'PAID'     },
      { name:'에릭카 마리노 공연', sub:'2026.01.15 · 서울 올림픽홀',  amt:'₩88,000',  em:'🎫', status:'PAID'     },
      { name:'굿즈 · 키링 세트',   sub:'2026.01.10',                  amt:'₩24,000',  em:'🛍️', status:'REFUNDED' },
      { name:'Premium 정기 결제',  sub:'2026.01.01',                  amt:'₩9,900',   em:'⚡', status:'PAID'     }
    ],
    reservations: [
      /* RESERVATION_TBL.reservation_id, status(CONFIRMED/CANCELLED)
         JOIN SEAT_TBL.seat_label
         JOIN SCHEDULE_TBL.start_time
         JOIN SHOW_TBL.title */
      {
        showTitle: '에릭카 마리노 단독 콘서트',
        startTime: '2026.03.15 (일) 19:00',
        venue:     '서울 올림픽홀',
        seatLabel: 'A구역 12열 3번',
        amt:       '₩88,000',
        status:    'CONFIRMED',
        gradient:  'linear-gradient(160deg,#4a1a3e 0%,#7a2a5e 40%,#5a1a4e 100%)',
        posterImg: '' /* 실서비스: SHOW_TBL에 poster_url 컬럼 추가 후 주입 */
      },
      {
        showTitle: 'Isabella Romano Live Tour',
        startTime: '2026.02.28 (토) 18:00',
        venue:     '부산 KBS홀',
        seatLabel: 'VIP 5열 7번',
        amt:       '₩120,000',
        status:    'CONFIRMED',
        gradient:  'linear-gradient(160deg,#1a2a5e 0%,#2a3a7e 40%,#2a1a6e 100%)',
        posterImg: ''
      },
      {
        showTitle: '808 Beats Festival',
        startTime: '2026.01.20 (화) 17:00',
        venue:     '잠실실내체육관',
        seatLabel: 'B구역 22열 15번',
        amt:       '₩65,000',
        status:    'CANCELLED',
        gradient:  'linear-gradient(160deg,#181820 0%,#22183a 40%,#2a1a40 100%)',
        posterImg: ''
      }
    ]
  };

  /* ═══════════════════════════════════════════
     렌더 함수
  ═══════════════════════════════════════════ */
  function rankClass(r) {
    return r === 1 ? 'gold' : r === 2 ? 'silver' : r === 3 ? 'bronze' : '';
  }

  /* PLAY_LOG_TBL 집계 기반 TOP 10 */
  function renderSongs(list) {
    var max = list[0].plays;
    document.getElementById('mpTopList').innerHTML = list.map(function (s) {
      return '<div class="list-item">'
        + '<div class="rank ' + rankClass(s.rank) + '">' + s.rank + '</div>'
        + '<div class="li-thumb">' + s.em + '</div>'
        + '<div class="li-info">'
        +   '<div class="li-name">' + s.title + '</div>'
        +   '<div class="li-sub">' + s.artist + '</div>'
        +   '<div class="prog-bar"><div class="prog-fill" style="width:' + Math.round(s.plays/max*100) + '%"></div></div>'
        + '</div>'
        + '<div class="li-right">' + s.plays + '회</div>'
        + '</div>';
    }).join('');
  }

  /* ARTISTS_TBL + PLAY_LOG_TBL 집계 */
  function renderArtists() {
    document.getElementById('mpTopArtists').innerHTML = DUMMY.artists.map(function (a) {
      return '<div class="list-item">'
        + '<div class="rank ' + rankClass(a.rank) + '">' + a.rank + '</div>'
        + '<div class="li-thumb">' + a.em + '</div>'
        + '<div class="li-info">'
        +   '<div class="li-name">' + a.name + '</div>'
        +   '<div class="li-sub">' + a.count + '곡 재생</div>'
        + '</div>'
        + '</div>';
    }).join('');
  }

  /* FREE_COMMENT 기반 */
  function renderComments() {
    document.getElementById('mpCmtList').innerHTML = DUMMY.cmts.map(function (c) {
      return '<div class="cmt-item">'
        + '<div class="cmt-meta"><div class="cmt-target">→ ' + c.target + '</div><div class="cmt-date">' + c.date + '</div></div>'
        + '<div class="cmt-text">' + c.text + '</div>'
        + '<div class="cmt-actions"><button class="cmt-btn">원글 보기</button><button class="cmt-btn del">삭제</button></div>'
        + '</div>';
    }).join('');
  }

  /* PAYMENT_ORDER 기반 */
  function renderPayments() {
    /* status 한글 매핑 (PAYMENT_ORDER.status) */
    var statusMap = { PAID:'완료', REFUNDED:'환불', PENDING:'대기' };
    var statusClass = { PAID:'confirmed', REFUNDED:'cancelled', PENDING:'pending' };

    document.getElementById('mpPayList').innerHTML = DUMMY.pays.map(function (p) {
      return '<div class="pay-item">'
        + '<div class="pay-icon">' + p.em + '</div>'
        + '<div class="pay-info"><div class="pay-name">' + p.name + '</div><div class="pay-sub">' + p.sub + '</div></div>'
        + '<div class="pay-right">' + p.amt
        +   '<div><span class="status-badge ' + (statusClass[p.status]||'') + '">' + (statusMap[p.status]||p.status) + '</span></div>'
        + '</div>'
        + '</div>';
    }).join('');
  }

  /* RESERVATION_TBL + SEAT_TBL + SCHEDULE_TBL + SHOW_TBL 조인 기반 */
  function renderReservations() {
    var el = document.getElementById('mpResCards');
    if (!el) return;

    if (!DUMMY.reservations.length) {
      el.innerHTML = '<div class="res-empty"><div class="res-empty-icon">🎫</div><div>아직 예매 내역이 없습니다</div></div>';
      return;
    }

    /* RESERVATION_TBL.status 한글 매핑 */
    var statusMap   = { CONFIRMED:'예매완료', CANCELLED:'취소/환불', PENDING:'대기중' };
    var statusClass = { CONFIRMED:'confirmed', CANCELLED:'cancelled', PENDING:'pending' };

    el.innerHTML = '<div class="res-grid">' + DUMMY.reservations.map(function (r) {
      var bgStyle = r.posterImg
        ? 'background-image:url(' + r.posterImg + ');background-color:#111'
        : 'background:' + r.gradient;

      return '<div class="res-card">'
        + '<div class="res-poster">'
        +   '<div class="res-poster-bg" style="' + bgStyle + '"></div>'
        +   '<div class="res-poster-dim"></div>'
        +   '<div class="res-content">'
        +     '<div class="res-name">' + r.showTitle + '</div>'          /* SHOW_TBL.title */
        +     '<div class="res-date">📅 ' + r.startTime + '</div>'      /* SCHEDULE_TBL.start_time */
        +     '<span class="status-badge ' + (statusClass[r.status]||'') + '">'
        +       (statusMap[r.status]||r.status)                          /* RESERVATION_TBL.status */
        +     '</span>'
        +   '</div>'
        + '</div>'
        + '<div class="res-info">'
        +   '<div class="res-venue">📍 ' + r.venue + '</div>'
        +   '<div class="res-seat">💺 ' + r.seatLabel + '</div>'        /* SEAT_TBL.seat_label */
        +   '<div class="res-price"><span>' + r.amt + '</span>'
        +     '<button class="res-detail-btn" onclick="alert(\'예매 상세 (데모)\')">상세보기</button>'
        +   '</div>'
        + '</div>'
        + '</div>';
    }).join('') + '</div>';
  }

  /* PAYMENT_ORDER 월별 집계 차트 */
  function mpInitChart() {
    window._mpChartInited = true;
    var canvas = document.getElementById('mpPayChart');
    if (!canvas || !window.Chart) return;
    new Chart(canvas.getContext('2d'), {
      type: 'bar',
      data: {
        labels: ['9월','10월','11월','12월','1월','2월'],
        datasets: [{
          data: [9900,33900,9900,98900,121800,9900],
          backgroundColor: ['rgba(255,255,255,.04)','rgba(255,255,255,.04)','rgba(255,255,255,.04)','rgba(255,255,255,.09)','rgba(255,255,255,.16)','rgba(255,255,255,.06)'],
          borderColor:     ['rgba(255,255,255,.10)','rgba(255,255,255,.10)','rgba(255,255,255,.10)','rgba(255,255,255,.22)','rgba(255,255,255,.45)','rgba(255,255,255,.13)'],
          borderWidth:1, borderRadius:5, borderSkipped:false
        }]
      },
      options: {
        responsive:true, maintainAspectRatio:false,
        plugins: {
          legend:{ display:false },
          tooltip:{
            backgroundColor:'rgba(15,19,25,.98)',
            borderColor:'rgba(255,255,255,.08)', borderWidth:1,
            titleColor:'#f2f2f2', bodyColor:'rgba(242,242,242,.4)', padding:9,
            callbacks:{ label:function(c){ return '₩'+c.raw.toLocaleString(); } }
          }
        },
        scales:{
          x:{ grid:{color:'rgba(255,255,255,.04)'}, ticks:{color:'rgba(242,242,242,.3)',font:{size:9,family:'DM Sans'}} },
          y:{ grid:{color:'rgba(255,255,255,.04)'}, border:{display:false},
              ticks:{color:'rgba(242,242,242,.3)',font:{size:9},callback:function(v){return '₩'+v.toLocaleString();}} }
        }
      }
    });
  }

  window.mpShuffleSongs = function () {
    renderSongs(DUMMY.songs.slice().sort(function(){ return Math.random()-.5; }));
  };

  /* ═══════════════════════════════════════════
     초기 렌더 — DOMContentLoaded
  ═══════════════════════════════════════════ */
  document.addEventListener('DOMContentLoaded', function () {
    renderSongs(DUMMY.songs);
    renderArtists();
    renderComments();
    renderPayments();
    renderReservations();
  });

}());