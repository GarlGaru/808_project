/**
 * mypageModal.js
 * 의존성: modalCore.js (window.ModalCore)
 *
 * 변경 내역:
 *   - openMypage / mpClose → ModalCore.open / ModalCore.close 위임
 *   - mpOutsideClick 제거 → ModalCore.bindOutsideClick 으로 대체
 *   - ESC 핸들러 제거 → ModalCore.bindEscKey 로 대체
 *   - mc-close-btn 은 JSP onclick="mpClose()" 로 직접 연결 (별도 bindCloseBtn 불필요)
 *   - [FIX] mpChangeAvatar: 미리보기만 하던 것 → 서버 업로드(FormData POST) 추가
 *   - [FIX] mpEditSave: 성공 시 #eBio / #eNick DOM도 최신값으로 동기화
 */
(function () {
  'use strict';

  /* ────────────────────────────────────────────
     열기 / 닫기 — ModalCore 위임
  ──────────────────────────────────────────── */

  window.openMypage = function () {
    ModalCore.open('mpOverlay');
  };

  window.mpClose = function () {
    ModalCore.close('mpOverlay', 250);
  };

  /* ── ModalCore 바인딩 ── */
  document.addEventListener('DOMContentLoaded', function () {
    ModalCore.bindOutsideClick('mpOverlay', '.mypage-modal');
    ModalCore.bindEscKey('mpOverlay');
    ModalCore.bindOnClose && ModalCore.bindOnClose('mpOverlay', function () {
      /* 모달 닫힐 때 — 비번 + 닉네임 상태 전부 초기화 */
      mpResetPwState();
      mpResetNickCheck();
      /* 수정 모드 열려있었으면 보기 모드로 복구 */
      document.getElementById('mpPvEdit').style.display = 'none';
      document.getElementById('mpPvView').style.display = 'block';
    });
    var pwCode = document.getElementById('pwCode');
    if (pwCode) pwCode.addEventListener('input', mpCheckPwCode);
  });

  /* ────────────────────────────────────────────
     탭 전환 — 탭별 Lazy Load
  ──────────────────────────────────────────── */
  window.mpTab = function (el, id, title, sub) {
    $('.mypage-modal .nav-item').removeClass('active');
    $('.mypage-modal .tab-pane').removeClass('active');
    $(el).addClass('active');
    $('#tab-' + id).addClass('active');
    $('#mpTitle').text(title);
    $('#mpSub').text(sub);

    /* 탭별 최초 1회 Lazy Load */
    if (id === 'report'   && !window._mpReportLoaded) { window._mpReportLoaded = true; mpLoadPlayReport('THIS_MONTH'); }
    if (id === 'comments' && !window._mpCmtLoaded)    { window._mpCmtLoaded    = true; mpLoadComments(); }
    if (id === 'payments' && !window._mpPayLoaded)    { window._mpPayLoaded    = true; mpLoadPayments(); }
  };

  /* ────────────────────────────────────────────
     아바타 변경
     [FIX] FileReader 미리보기 + FormData로 서버 업로드 동시 처리
  ──────────────────────────────────────────── */
  window.mpChangeAvatar = function (input) {
    if (!input.files || !input.files[0]) return;
    var file = input.files[0];

    /* 미리보기 */
    var reader = new FileReader();
    reader.onload = function (e) {
      document.getElementById('mpAv').innerHTML = '<img src="' + e.target.result + '" alt="프로필">';
    };
    reader.readAsDataURL(file);

    /* 서버 업로드 */
    var formData = new FormData();
    formData.append('photoFile', file);
    var CP = window.__AUTH_CP || '';
    $.ajax({
      url:         CP + '/mypage/updatePhoto',
      type:        'POST',
      data:        formData,
      processData: false,
      contentType: false,
      dataType:    'json',
      success: function (result) {
        if (result !== 1) {
          alert('사진 저장에 실패했습니다.');
        }
      },
      error: function () {
        alert('사진 업로드 중 오류가 발생했습니다.');
      }
    });
  };
  
  /* ────────────────────────────────────────────
    멤버십 구독 취소
──────────────────────────────────────────── */
window.mpCancelMembership = function() {
    if (!confirm('정말 멤버십 구독을 취소하시겠습니까?\n취소 즉시 PRO 혜택이 중단됩니다.')) return;

    var CP = window.__AUTH_CP || '';
    
    $.ajax({
        url: CP + '/mypage/cancelMembership', // 서버의 취소 컨트롤러 주소
        type: 'POST',
        dataType: 'json',
        success: function(result) {
            if (result === 1) {
                alert('구독이 정상적으로 취소되었습니다.');
                // [핵심] 페이지를 새로고침하여 컨트롤러가 세션을 FREE로 갱신하게 만듦
                location.reload(); 
            } else {
                alert('취소 처리에 실패했습니다. 다시 시도해주세요.');
            }
        },
        error: function() {
            alert('서버 통신 중 오류가 발생했습니다.');
        }
    });
};

  /* ────────────────────────────────────────────
     프로필 보기 ↔ 수정 토글
  ──────────────────────────────────────────── */
  window.mpEditStart = function () {
    mpResetNickCheck();
    document.getElementById('mpPvView').style.display = 'none';
    document.getElementById('mpPvEdit').style.display = 'block';
  };

  window.mpEditCancel = function () {
    mpResetPwState();
    mpResetNickCheck();
    document.getElementById('mpPvEdit').style.display = 'none';
    document.getElementById('mpPvView').style.display = 'block';
  };

  /* ────────────────────────────────────────────
     닉네임 중복확인
     AuthAPI.checkNick() — GET /checkNickname?nickname=
     반환: 0 = 사용 가능, >0 = 중복
  ──────────────────────────────────────────── */
  var _nickChecked    = false;
  var _nickCheckedVal = '';

  window.mpCheckNick = function () {
    var nick     = $('#eNick').val().trim();
    var origNick = $('#vNick').text().trim();
    var $msg     = $('#nickCheckMsg');
    var $btn     = $('#nickCheckBtn');

    if (!nick) { alert('닉네임을 입력해주세요.'); return; }

    /* 현재 닉네임과 같으면 확인 불필요 */
    if (nick === origNick) {
      _nickChecked    = true;
      _nickCheckedVal = nick;
      $('#eNick').removeClass('valid invalid');
      $msg.text('현재 사용 중인 닉네임입니다.').css('color', 'rgba(242,242,242,0.45)').show();
      return;
    }

    $btn.prop('disabled', true).text('확인 중...');

    AuthAPI.checkNick(nick).then(function (cnt) {
      if (cnt > 0) {
        _nickChecked = false;
        $('#eNick').removeClass('valid').addClass('invalid');
        $msg.text('✕ 이미 사용 중인 닉네임입니다.').css('color', '#f87171').show();
      } else {
        _nickChecked    = true;
        _nickCheckedVal = nick;
        $('#eNick').removeClass('invalid').addClass('valid');
        $msg.text('✓ 사용 가능한 닉네임입니다.').css('color', '#4ade80').show();
      }
    }).catch(function () {
      $msg.text('중복 확인에 실패했습니다. 다시 시도해주세요.').css('color', 'rgba(242,242,242,0.45)').show();
    }).then(function () {
      $btn.prop('disabled', false).text('중복확인');
    });
  };

  /* input 수정 시 확인 상태 초기화 */
  window.mpResetNickCheck = function () {
    _nickChecked = false;
    _nickCheckedVal = '';
    $('#eNick').removeClass('valid invalid');
    $('#nickCheckMsg').hide().text('');
  };

  /* ────────────────────────────────────────────
     내정보 저장
  ──────────────────────────────────────────── */
  window.mpEditSave = function () {
    var nick     = $('#eNick').val().trim();
    var bio      = $('#eBio').val().trim();
    var birth    = $('#eBirth').val();
    var origNick = $('#vNick').text().trim();

    if (!nick) { alert('닉네임을 입력해주세요.'); return; }

    if (nick !== origNick && (!_nickChecked || _nickCheckedVal !== nick)) {
      alert('닉네임 중복확인을 해주세요.');
      $('#eNick').focus();
      return;
    }

    $.ajax({
      url:      CP + '/mypage/updateInfo',
      type:     'POST',
      data:     { nickname: nick, bio: bio, birthDate: birth },
      dataType: 'json',
      success: function (result) {
        if (result === 1) {
          $('#vNick').text(nick);
          $('#vBio').text(bio || '소개를 입력해주세요');
          if (birth) {
            var d = new Date(birth);
            $('#vBirth').text(d.getFullYear() + '년 ' + (d.getMonth()+1) + '월 ' + d.getDate() + '일');
          }
          $('#eNick').val(nick).removeClass('valid invalid');
          $('#eBio').val(bio);
          _nickChecked    = false;
          _nickCheckedVal = '';
          $('.mypage-modal .sb-name').text(nick);
          mpEditCancel();
        } else if (result === -1) {
          alert('닉네임을 입력해주세요.');
        } else {
          alert('저장에 실패했습니다.');
        }
      },
      error: function () { alert('저장 중 오류가 발생했습니다.'); }
    });
  };

  /* ────────────────────────────────────────────
     비밀번호 변경
     AuthAPI.sendResetCode() — GET /checkEmail + POST /sendCode
     AuthAPI.resetPw()       — POST /updatePw
  ──────────────────────────────────────────── */
  var MP_PW_STATE = { codeVerified: false, serverCode: '', timerId: null };

  function mpResetPwState() {
    mpStopPwTimer();
    MP_PW_STATE.codeVerified = false;
    MP_PW_STATE.serverCode   = '';
    var f = document.getElementById('pwCodeField');
    var c = document.getElementById('pwCode');
    var cur = document.getElementById('pwCurrent');
    var pn  = document.getElementById('pwNew');
    var pc  = document.getElementById('pwConfirm');
    if (f)   { f.style.display = 'none'; }
    if (c)   { c.value = ''; c.classList.remove('valid', 'invalid'); }
    if (cur) { cur.value = ''; }
    if (pn)  { pn.value = ''; }
    if (pc)  { pc.value = ''; }
  }

  function mpStartPwTimer() {
    var timerEl = document.getElementById('pwTimer');
    if (!timerEl) return;
    if (MP_PW_STATE.timerId) clearInterval(MP_PW_STATE.timerId);
    var sec = 300;
    timerEl.textContent = '5:00';
    MP_PW_STATE.timerId = setInterval(function () {
      var m = Math.floor(sec / 60), s = sec % 60;
      timerEl.textContent = m + ':' + String(s).padStart(2, '0');
      if (--sec < 0) {
        clearInterval(MP_PW_STATE.timerId);
        MP_PW_STATE.timerId = null;
        timerEl.textContent = '만료됨';
      }
    }, 1000);
  }

  function mpStopPwTimer() {
    if (MP_PW_STATE.timerId) { clearInterval(MP_PW_STATE.timerId); MP_PW_STATE.timerId = null; }
    var el = document.getElementById('pwTimer');
    if (el) el.textContent = '5:00';
  }

  /* 코드 발송 — AuthAPI.sendResetCode 재사용 */
  window.mpSendCode = function (email) {
    if (!email) return;
    var $btn      = $('#pwSendBtn');
    var codeField = document.getElementById('pwCodeField');
    var codeInput = document.getElementById('pwCode');

    $btn.prop('disabled', true).text('발송 중...');

    AuthAPI.sendResetCode(email).then(function (result) {
      if (!result.ok) { alert(result.message); return; }
      MP_PW_STATE.serverCode   = result.code;
      MP_PW_STATE.codeVerified = false;
      if (codeInput) { codeInput.value = ''; codeInput.classList.remove('valid', 'invalid'); }
      if (codeField) { codeField.style.display = 'block'; mpStartPwTimer(); }
      alert('[임시 인증번호] : ' + MP_PW_STATE.serverCode + '\n입력창에 입력해주세요.');
    }).catch(function () {
      alert('인증코드 발송에 실패했습니다.');
    }).then(function () {
      $btn.prop('disabled', false).text('코드 발송');
    });
  };

  /* 코드 실시간 검증 */
  function mpCheckPwCode() {
    var inp = document.getElementById('pwCode');
    if (!inp) return;
    var val = inp.value.trim();
    inp.classList.remove('valid', 'invalid');
    if (!val) { MP_PW_STATE.codeVerified = false; return; }
    if (val.length === 6) {
      if (val === MP_PW_STATE.serverCode) {
        inp.classList.add('valid');  MP_PW_STATE.codeVerified = true;
      } else {
        inp.classList.add('invalid'); MP_PW_STATE.codeVerified = false;
      }
    } else {
      inp.classList.add('invalid'); MP_PW_STATE.codeVerified = false;
    }
  }

  /* 비밀번호 변경 저장 — AuthAPI.resetPw 재사용 */
  window.mpChangePw = function () {
    var current   = document.getElementById('pwCurrent');
    var pwNew     = document.getElementById('pwNew');
    var pwConfirm = document.getElementById('pwConfirm');
    var userEmail = (document.getElementById('pwEmail') || {}).value || '';

    if (!current || !current.value.trim())                   { alert('현재 비밀번호를 입력해주세요.'); return; }
    if (!MP_PW_STATE.codeVerified)                           { alert('이메일 인증을 완료해주세요.'); return; }
    if (!pwNew || !pwNew.value)                              { alert('새 비밀번호를 입력해주세요.'); return; }
    if (pwNew.value.length < 8 || pwNew.value.length > 20)  { alert('비밀번호는 8~20자로 입력해주세요.'); return; }
    if (pwNew.value !== pwConfirm.value)                     { alert('비밀번호가 일치하지 않습니다.'); return; }

    AuthAPI.resetPw(userEmail, pwNew.value).then(function (result) {
      if (result.ok) {
        mpResetPwState();
        alert('비밀번호가 변경되었습니다.');
      } else {
        alert(result.message || '비밀번호 변경에 실패했습니다.');
      }
    }).catch(function () {
      alert('비밀번호 변경 중 오류가 발생했습니다.');
    });
  };

  /* ────────────────────────────────────────────
     계정 탈퇴
  ──────────────────────────────────────────── */
  window.mpWithdraw = function () {
    if (!confirm('정말 탈퇴하시겠습니까?\n탈퇴 후 모든 데이터가 삭제되며 복구가 불가능합니다.')) return;

    $.ajax({
      url:      CP + '/mypage/withdraw',
      type:     'POST',
      dataType: 'json',
      success: function (result) {
        if (result === 1) {
          alert('탈퇴가 완료되었습니다.');
          location.href = CP + '/main';
        } else if (result === -999) {
          alert('로그인 정보가 없습니다. 다시 로그인해주세요.');
        } else {
          alert('탈퇴 처리 중 오류가 발생했습니다.');
        }
      },
      error: function () {
        alert('탈퇴 처리 중 오류가 발생했습니다.');
      }
    });
  };

  /* ────────────────────────────────────────────
     예매 내역 — 예매팀 연동 전 더미 유지
  ──────────────────────────────────────────── */
  var RESERVATION_DUMMY = [
    {
      showTitle: '에릭카 마리노 단독 콘서트',
      startTime: '2026.03.15 (일) 19:00',
      venue:     '서울 올림픽홀',
      seatLabel: 'A구역 12열 3번',
      amt:       '₩88,000',
      status:    'CONFIRMED',
      gradient:  'linear-gradient(160deg,#4a1a3e 0%,#7a2a5e 40%,#5a1a4e 100%)',
      posterImg: ''
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
  ];

  /* ────────────────────────────────────────────
     렌더 함수
  ──────────────────────────────────────────── */
  function rankClass(r) {
    return r === 1 ? 'gold' : r === 2 ? 'silver' : r === 3 ? 'bronze' : '';
  }

  /* 플레이 리포트 — stat-grid */
  function renderPlaySummary(data) {
    var totalH   = Math.floor(data.totalPlayTimeSec / 3600);
    var totalM   = Math.floor((data.totalPlayTimeSec % 3600) / 60);
    var prevH    = Math.floor(data.prevMonthPlayTimeSec / 3600);
    var diffPct  = prevH > 0 ? Math.round((totalH - prevH) / prevH * 100) : null;
    var diffText = diffPct !== null
      ? '전월 대비 ' + (diffPct >= 0 ? '+' : '') + diffPct + '%'
      : '전월 데이터 없음';

    $('#mpStatTime').text(totalH + 'h' + (totalM > 0 ? ' ' + totalM + 'm' : ''));
    $('#mpStatTimeSub').text(diffText);
    $('#mpStatPlay').text(data.totalPlayCount.toLocaleString());
    $('#mpStatPlaySub').text(data.uniqueTrackCount.toLocaleString() + '개 고유 트랙');
    $('#mpStatDay').text(data.busiestDay || '-');
  }

  /* TOP 장르 */
  function renderGenres(list) {
    if (!list || !list.length) {
      $('#mpTopGenres').html('<div style="color:var(--c-muted);font-size:12px">장르 데이터 없음</div>');
      return;
    }
    var html = $.map(list, function (g) {
      return '<div class="genre-tag">'
        + '<div class="genre-name">' + g.genreName + '</div>'
        + '<div class="genre-pct">'  + g.percentage + '%</div>'
        + '</div>';
    }).join('');
    $('#mpTopGenres').html(html);
  }

  /* TOP 10 곡 */
  function renderSongs(list) {
    if (!list || !list.length) {
      $('#mpTopList').html('<div style="color:var(--c-muted);font-size:12px;padding:12px 0">재생 내역이 없습니다</div>');
      return;
    }
    var max  = list[0].playCount;
    var html = $.map(list, function (s, i) {
      var rank = i + 1;
      return '<div class="list-item">'
        + '<div class="rank ' + rankClass(rank) + '">' + rank + '</div>'
        + '<div class="li-thumb">🎵</div>'
        + '<div class="li-info">'
        +   '<div class="li-name">'  + s.title      + '</div>'
        +   '<div class="li-sub">'   + s.artistName  + '</div>'
        +   '<div class="prog-bar"><div class="prog-fill" style="width:'
        +     Math.round(s.playCount / max * 100) + '%"></div></div>'
        + '</div>'
        + '<div class="li-right">' + s.playCount + '회</div>'
        + '</div>';
    }).join('');
    $('#mpTopList').html(html);
  }

  /* TOP 아티스트 */
  function renderArtists(list) {
    if (!list || !list.length) {
      $('#mpTopArtists').html('<div style="color:var(--c-muted);font-size:12px">아티스트 데이터 없음</div>');
      return;
    }
    var html = $.map(list, function (a, i) {
      var rank  = i + 1;
      var thumb = a.coverImageUrl
        ? '<img src="' + a.coverImageUrl + '" alt="' + a.name + '" style="width:100%;height:100%;object-fit:cover;border-radius:50%">'
        : '🎤';
      return '<div class="list-item">'
        + '<div class="rank ' + rankClass(rank) + '">' + rank + '</div>'
        + '<div class="li-thumb">' + thumb + '</div>'
        + '<div class="li-info">'
        +   '<div class="li-name">' + a.name + '</div>'
        +   '<div class="li-sub">'  + a.playCount + '곡 재생</div>'
        + '</div>'
        + '</div>';
    }).join('');
    $('#mpTopArtists').html(html);
  }

  /* 댓글 */
  function renderComments(list) {
    if (!list || !list.length) {
      $('#mpCmtList').html('<div style="color:var(--c-muted);font-size:13px;padding:20px 0;text-align:center">작성한 댓글이 없습니다</div>');
      return;
    }
    var CP   = window.__AUTH_CP || '';
    var html = $.map(list, function (c) {
      return '<div class="cmt-item">'
        + '<div class="cmt-meta">'
        +   '<div class="cmt-target">→ ' + c.boardTitle + '</div>'
        +   '<div class="cmt-date">'     + c.regdate    + '</div>'
        + '</div>'
        + '<div class="cmt-text">' + c.content + '</div>'
        + '<div class="cmt-actions">'
        +   '<button class="cmt-btn" onclick="location.href=\'' + CP + '/board/view?bno=' + c.bno + '\'">원글 보기</button>'
        +   '<button class="cmt-btn del">삭제</button>'
        + '</div>'
        + '</div>';
    }).join('');
    $('#mpCmtList').html(html);
  }

  /* 결제 내역 */
  function renderPayments(list) {
    if (!list || !list.length) {
      $('#mpPayList').html('<div style="color:var(--c-muted);font-size:13px;padding:20px 0;text-align:center">결제 내역이 없습니다</div>');
      return;
    }
    var statusMap   = { PAID:'완료', REFUNDED:'환불', PENDING:'대기' };
    var statusClass = { PAID:'confirmed', REFUNDED:'cancelled', PENDING:'pending' };
    var typeIcon    = { CARD:'💳', VIRTUAL:'🏦', PHONE:'📱' };

    var html = $.map(list, function (p) {
      var icon = typeIcon[p.paymentType] || '💳';
      return '<div class="pay-item">'
        + '<div class="pay-icon">' + icon + '</div>'
        + '<div class="pay-info">'
        +   '<div class="pay-name">' + p.itemName   + '</div>'
        +   '<div class="pay-sub">'  + p.approvedAt + '</div>'
        + '</div>'
        + '<div class="pay-right">₩' + p.totalAmount.toLocaleString()
        +   '<div><span class="status-badge ' + (statusClass[p.status] || '') + '">'
        +     (statusMap[p.status] || p.status)
        +   '</span></div>'
        + '</div>'
        + '</div>';
    }).join('');
    $('#mpPayList').html(html);
  }

  /* 예매 내역 — 예매팀 연동 전 더미 유지 */
  function renderReservations() {
    var el = document.getElementById('mpResCards');
    if (!el) return;

    if (!RESERVATION_DUMMY.length) {
      el.innerHTML = '<div class="res-empty"><div class="res-empty-icon">🎫</div><div>아직 예매 내역이 없습니다</div></div>';
      return;
    }

    var statusMap   = { CONFIRMED:'예매완료', CANCELLED:'취소/환불', PENDING:'대기중' };
    var statusClass = { CONFIRMED:'confirmed', CANCELLED:'cancelled', PENDING:'pending' };

    var html = $.map(RESERVATION_DUMMY, function (r) {
      var bgStyle = r.posterImg
        ? 'background-image:url(' + r.posterImg + ');background-color:#111'
        : 'background:' + r.gradient;
      return '<div class="res-card">'
        + '<div class="res-poster">'
        +   '<div class="res-poster-bg" style="' + bgStyle + '"></div>'
        +   '<div class="res-poster-dim"></div>'
        +   '<div class="res-content">'
        +     '<div class="res-name">'  + r.showTitle + '</div>'
        +     '<div class="res-date">📅 ' + r.startTime + '</div>'
        +     '<span class="status-badge ' + (statusClass[r.status] || '') + '">'
        +       (statusMap[r.status] || r.status)
        +     '</span>'
        +   '</div>'
        + '</div>'
        + '<div class="res-info">'
        +   '<div class="res-venue">📍 ' + r.venue    + '</div>'
        +   '<div class="res-seat">💺 '  + r.seatLabel + '</div>'
        +   '<div class="res-price"><span>' + r.amt + '</span>'
        +     '<button class="res-detail-btn" onclick="alert(\'예매 상세 (데모)\')">상세보기</button>'
        +   '</div>'
        + '</div>'
        + '</div>';
    }).join('');
    $('#mpResCards').html('<div class="res-grid">' + html + '</div>');
  }

  /* Chart.js — monthlyStats 기반 */
  function mpInitChart(statList) {
    window._mpChartInited = true;
    var canvas = document.getElementById('mpPayChart');
    if (!canvas || !window.Chart) return;

    var labels  = $.map(statList, function (m) { return m.yearMonth.substring(5) + '월'; });
    var values  = $.map(statList, function (m) { return m.totalAmount; });
    var maxVal  = Math.max.apply(null, values.concat([0]));

    var bgColors = $.map(values, function (v) {
      var r = maxVal > 0 ? v / maxVal : 0;
      return 'rgba(255,255,255,' + (0.04 + r * 0.15).toFixed(2) + ')';
    });
    var bdColors = $.map(values, function (v) {
      var r = maxVal > 0 ? v / maxVal : 0;
      return 'rgba(255,255,255,' + (0.08 + r * 0.40).toFixed(2) + ')';
    });

    new Chart(canvas.getContext('2d'), {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          data: values,
          backgroundColor: bgColors,
          borderColor:     bdColors,
          borderWidth: 1, borderRadius: 5, borderSkipped: false
        }]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            backgroundColor: 'rgba(15,19,25,.98)',
            borderColor: 'rgba(255,255,255,.08)', borderWidth: 1,
            titleColor: '#f2f2f2', bodyColor: 'rgba(242,242,242,.4)', padding: 9,
            callbacks: { label: function (c) { return '₩' + c.raw.toLocaleString(); } }
          }
        },
        scales: {
          x: { grid: { color: 'rgba(255,255,255,.04)' }, ticks: { color: 'rgba(242,242,242,.3)', font: { size: 9, family: 'DM Sans' } } },
          y: { grid: { color: 'rgba(255,255,255,.04)' }, border: { display: false },
               ticks: { color: 'rgba(242,242,242,.3)', font: { size: 9 }, callback: function (v) { return '₩' + v.toLocaleString(); } } }
        }
      }
    });
  }

  /* ────────────────────────────────────────────
     Ajax 로드 함수
  ──────────────────────────────────────────── */
  var CP = window.__AUTH_CP || '';

  /* 플레이 리포트 — 탭 진입 or 기간 변경 시 호출 */
  /* periodType: THIS_MONTH(기본) / LAST_MONTH / 3MONTH */
  function mpLoadPlayReport(periodType) {
    $.ajax({
      url:      CP + '/mypage/playReport',
      type:     'GET',
      data:     { periodType: periodType || 'THIS_MONTH' },
      dataType: 'json',
      success: function (data) {
        if (!data) return;
        renderPlaySummary(data);
        renderGenres(data.topGenres);
        renderSongs(data.topSongs);
        renderArtists(data.topArtists);
      },
      error: function () {
        $('#mpTopList').html('<div style="color:var(--c-muted);font-size:12px;padding:12px 0">데이터를 불러오지 못했습니다</div>');
      }
    });
  }

  /* 기간 select 변경 — TOP 10만 재렌더 */
  window.mpLoadTopSongs = function (periodType) {
    $.ajax({
      url:      CP + '/mypage/playReport',
      type:     'GET',
      data:     { periodType: periodType },
      dataType: 'json',
      success: function (data) {
        if (data) renderSongs(data.topSongs);
      }
    });
  };

  /* 댓글 */
  function mpLoadComments() {
    $.ajax({
      url:      CP + '/mypage/comments',
      type:     'GET',
      dataType: 'json',
      success: function (data) { renderComments(data); },
      error:   function ()     { $('#mpCmtList').html('<div style="color:var(--c-muted);font-size:13px;padding:20px 0;text-align:center">불러오기 실패</div>'); }
    });
  }

  /* 결제 내역 + 월별 차트 */
  function mpLoadPayments() {
    $.ajax({
      url:      CP + '/mypage/payments',
      type:     'GET',
      dataType: 'json',
      success: function (data) { renderPayments(data); }
    });

    if (!window._mpChartInited) {
      $.ajax({
        url:      CP + '/mypage/monthlyStats',
        type:     'GET',
        dataType: 'json',
        success: function (data) { if (data && data.length) mpInitChart(data); }
      });
    }
  }

  /* ────────────────────────────────────────────
     초기 렌더 — 모달 열릴 때 기본 탭(report) 로드
  ──────────────────────────────────────────── */
  document.addEventListener('DOMContentLoaded', function () {
    renderReservations(); /* 예매는 더미라 즉시 렌더 */
    mpLoadPlayReport('THIS_MONTH'); /* 기본 탭 */
    window._mpReportLoaded = true;
  });

}());
