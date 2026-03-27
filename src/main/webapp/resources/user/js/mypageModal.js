/**
 * mypageModal.js
 * 의존성: modalCore.js (window.ModalCore), authModal.js (window.AuthAPI)
 */
(function () {
  'use strict';

  /* ── CP — IIFE 상단 한 곳에서만 선언 ── */
  var CP = window.__AUTH_CP || '';

  /* ── 활동 내역 페이징 상태 ── */
  var _mpActPage    = 1;
  var _mpActLoading = false;
  var _mpActEnd     = false;

  /* ── 닉네임 중복확인 상태 ── */
  var _nickChecked    = false;
  var _nickCheckedVal = '';

  /* ── 비밀번호 상태 ── */
  var MP_PW_STATE = { codeVerified: false, serverCode: '', timerId: null };

  /* ── 차트 인스턴스 ── */
  var _mpChart = null;

  /* ════════════════════════════════════════════
     열기 / 닫기 — ModalCore 위임
     ════════════════════════════════════════════ */
  window.openMypage = function () { ModalCore.open('mpOverlay'); };
  
  window.mpClose    = function () { ModalCore.close('mpOverlay', 250); };

  document.addEventListener('DOMContentLoaded', function () {
    ModalCore.bindOutsideClick('mpOverlay', '.mypage-modal');
    ModalCore.bindEscKey('mpOverlay');
    ModalCore.bindOnClose && ModalCore.bindOnClose('mpOverlay', function () {
      /* 모달 닫힐 때 — 다음 번 열 때 최신 데이터로 갱신되도록 플래그 초기화 */
      window._mpReportLoaded = false;
      window._mpPayLoaded    = false;
      window._mpActLoaded    = false;
      window._mpChartInited  = false;
      _mpActPage    = 1;
      _mpActEnd     = false;
      _mpActLoading = false;
      /* 차트 인스턴스 제거 — 재진입 시 새로 생성 */
      if (_mpChart) { _mpChart.destroy(); _mpChart = null; }
      /* 비번 + 닉네임 상태 초기화 */
      mpResetPwState();
      mpResetNickCheck();
      /* 수정 모드 복구 */
      document.getElementById('mpPvEdit').style.display = 'none';
      document.getElementById('mpPvView').style.display = 'block';
    });
    var pwCode = document.getElementById('pwCode');
    if (pwCode) pwCode.addEventListener('input', mpCheckPwCode);
  });


  /* ════════════════════════════════════════════
     탭 전환 — Lazy Load
     ════════════════════════════════════════════ */

  window.mpTab = function (el, id, title, sub) {
  console.log("지금 클릭한 탭 ID는? :", id);
  
    $('.mypage-modal .nav-item').removeClass('active');
    $('.mypage-modal .tab-pane').removeClass('active');
    $(el).addClass('active');
    $('#tab-' + id).addClass('active');
    $('#mpTitle').text(title);
    $('#mpSub').text(sub);
	if (id === 'reservations' && !window._mpResLoaded) {
	window._mpResLoaded = true; 
	    if (typeof mpLoadReservations === 'function') {
	      mpLoadReservations();
	    } else {
	      console.error("mpLoadReservations 함수를 찾을 수 없습니다.");
	    }
	  }
    if (id === 'report'   && !window._mpReportLoaded) { window._mpReportLoaded = true; mpLoadPlayReport('THIS_MONTH'); }
    if (id === 'payments' && !window._mpPayLoaded)    { window._mpPayLoaded    = true; mpLoadPayments(); }
    if (id === 'activity' && !window._mpActLoaded)    { window._mpActLoaded    = true; mpLoadActivity(1); }
  };	

  /* ════════════════════════════════════════════
     아바타 변경
     ════════════════════════════════════════════ */

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
    $.ajax({
      url:         CP + '/mypage/updatePhoto',
      type:        'POST',
      data:        formData,
      processData: false,
      contentType: false,
      dataType:    'json',
      success: function (result) {
        if (result !== 1) { alert('사진 저장에 실패했습니다.'); }
      },
      error: function () { alert('사진 업로드 중 오류가 발생했습니다.'); }
    });
  };


  /* ════════════════════════════════════════════
     프로필 보기 ↔ 수정 토글
     ════════════════════════════════════════════ */

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


  /* ════════════════════════════════════════════
     닉네임 중복확인
     ════════════════════════════════════════════ */

  window.mpCheckNick = function () {
    var nick     = $('#eNick').val().trim();
    var origNick = $('#vNick').text().trim();
    var $msg     = $('#nickCheckMsg');
    var $btn     = $('#nickCheckBtn');

    if (!nick) { alert('닉네임을 입력해주세요.'); return; }

    /* auth와 동일한 검증 순서 — 서버 NICKNAME_PATTERN 기준 */
    if (nick.length < 2 || nick.length > 10) {
      _nickChecked = false;
      $('#eNick').removeClass('valid').addClass('invalid');
      $msg.text('✕ 닉네임은 2~10자로 입력해주세요.').removeClass('msg--ok msg--muted').addClass('msg--err').show();
      return;
    }
    if (!/^[가-힣a-zA-Z0-9]+$/.test(nick)) {
      _nickChecked = false;
      $('#eNick').removeClass('valid').addClass('invalid');
      $msg.text('✕ 한글, 영문, 숫자만 사용 가능합니다.').removeClass('msg--ok msg--muted').addClass('msg--err').show();
      return;
    }

    if (nick === origNick) {
      _nickChecked    = true;
      _nickCheckedVal = nick;
      $('#eNick').removeClass('valid invalid');
      $msg.text('현재 사용 중인 닉네임입니다.').removeClass('msg--ok msg--err').addClass('msg--muted').show();
      return;
    }

    $btn.prop('disabled', true).text('확인 중...');

    AuthAPI.checkNick(nick).then(function (cnt) {
      if (cnt > 0) {
        _nickChecked = false;
        $('#eNick').removeClass('valid').addClass('invalid');
        $msg.text('✕ 이미 사용 중인 닉네임입니다.').removeClass('msg--ok msg--muted').addClass('msg--err').show();
      } else {
        _nickChecked    = true;
        _nickCheckedVal = nick;
        $('#eNick').removeClass('invalid').addClass('valid');
        $msg.text('✓ 사용 가능한 닉네임입니다.').removeClass('msg--err msg--muted').addClass('msg--ok').show();
      }
    }).catch(function () {
      $msg.text('중복 확인에 실패했습니다. 다시 시도해주세요.').removeClass('msg--ok msg--err').addClass('msg--muted').show();
    }).then(function () {
      $btn.prop('disabled', false).text('중복확인');
    });
  };

  window.mpResetNickCheck = function () {
    _nickChecked    = false;
    _nickCheckedVal = '';
    $('#eNick').removeClass('valid invalid');
    $('#nickCheckMsg').hide().text('');
  };


  /* ════════════════════════════════════════════
     내 정보 저장
     ════════════════════════════════════════════ */

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
            $('#vBirth').text(d.getFullYear() + '년 ' + (d.getMonth() + 1) + '월 ' + d.getDate() + '일');
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


  /* ════════════════════════════════════════════
     비밀번호 변경
     ════════════════════════════════════════════ */

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
    MP_PW_STATE.timerId = ModalCore.timer.start(timerEl, 300);
  }

  function mpStopPwTimer() {
    var timerEl = document.getElementById('pwTimer');
    ModalCore.timer.stop(timerEl, MP_PW_STATE.timerId);
    MP_PW_STATE.timerId = null;
  }

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

  function mpCheckPwCode() {
    var inp = document.getElementById('pwCode');
    if (!inp) return;
    var val = inp.value.trim();
    inp.classList.remove('valid', 'invalid');
    if (!val) { MP_PW_STATE.codeVerified = false; return; }
    if (val.length === 6) {
      if (val === MP_PW_STATE.serverCode) {
        inp.classList.add('valid');   MP_PW_STATE.codeVerified = true;
      } else {
        inp.classList.add('invalid'); MP_PW_STATE.codeVerified = false;
      }
    } else {
      inp.classList.add('invalid'); MP_PW_STATE.codeVerified = false;
    }
  }

  window.mpChangePw = function () {
    var current   = document.getElementById('pwCurrent');
    var pwNew     = document.getElementById('pwNew');
    var pwConfirm = document.getElementById('pwConfirm');
    var code      = document.getElementById('pwCode');

    if (!current || !current.value.trim())                  { alert('현재 비밀번호를 입력해주세요.'); return; }
    if (!MP_PW_STATE.codeVerified)                          { alert('이메일 인증을 완료해주세요.'); return; }
    if (!pwNew || !pwNew.value)                             { alert('새 비밀번호를 입력해주세요.'); return; }
    if (pwNew.value.length < 8 || pwNew.value.length > 20) { alert('비밀번호는 8~20자로 입력해주세요.'); return; }
    if (pwNew.value !== pwConfirm.value)                    { alert('비밀번호가 일치하지 않습니다.'); return; }

    /* /mypage/updatePw — currentPw + code + newPw
       (AuthAPI.resetPw는 분실비번용 /updatePw로 가므로 사용 불가) */
    $.ajax({
      url:      CP + '/mypage/updatePw',
      type:     'POST',
      data: {
        currentPw: current.value,
        code:      code.value,   /* 사용자가 입력한 인증코드 */
        newPw:     pwNew.value
      },
      dataType: 'json',
      success: function (result) {
        if (result === 1) {
          mpResetPwState();
          alert('비밀번호가 변경되었습니다.');
        } else if (result === -1) {
          alert('현재 비밀번호가 일치하지 않습니다.');
        } else if (result === -2) {
          alert('인증코드가 만료되었거나 올바르지 않습니다.');
        } else {
          alert('비밀번호 변경에 실패했습니다.');
        }
      },
      error: function () { alert('비밀번호 변경 중 오류가 발생했습니다.'); }
    });
  };


  /* ════════════════════════════════════════════
     멤버십 구독
     ════════════════════════════════════════════ */

 /* 구독 업그레이드 버튼 클릭 시 (FREE -> PRO) 
  handleProMembership - JSP에서 넘겨받은 현재 등급 ('FREE' or 'PRO') */

/* 멤버십 관련 버튼 클릭 시 (PRO ↔ FREE 전환 처리) */
window.handleProMembership = function(currentMembership) {
    if (currentMembership === 'PRO') {
        if (confirm('현재 PRO 멤버십을 이용 중입니다.\n구독을 취소하시겠습니까?')) {
            if (!orderId || orderId === 'null' || orderId === '') {
                alert('구독 정보를 찾을 수 없습니다.\n고객센터로 문의해주세요.');
                return;
            }

            window.mpCancelMembership(orderId);
        }
        return;
    }

    // FREE → PRO 업그레이드
    if (typeof window.openSubscribeModal === 'function') {
        window.openSubscribeModal();
    } else {
        alert('결제 시스템을 불러올 수 없습니다. 잠시 후 다시 시도해주세요.');
    }
};

/**
 * 결제 실패 시 재시도 (결제팀 연동)
 */
window.retryMembershipPayment = function(orderId) {
    if(!orderId) return;
    
    if (confirm('결제에 실패한 이력이 있습니다. 다시 결제를 진행하시겠습니까?')) {
        // 결제팀의 재결제 로직 호출 (예: 카카오페이 재요청)
        location.href = CP + '/kakaopay/retry?orderId=' + orderId;
    }
};


 /* 멤버십 구독 취소(PRO -> FREE) — 결제팀 취소 API 직접 호출 */
window.mpCancelMembership = function (orderId) {
    // 1. 파라미터 체크
    if (!orderId || orderId === 'null' || orderId === '') {
        alert('결제 정보를 찾을 수 없어 해지가 불가능합니다.\n고객센터로 문의해주세요.');
        return;
    }

    // 2. 최종 의사 확인
    if (!confirm('정말 멤버십 구독을 해지하시겠습니까?\n해지 시 즉시 모든 PRO 혜택이 중단되고 FREE 등급으로 전환됩니다.')) {
        return;
    }

    // 3. 중복 클릭 방지 (버튼 비활성화)
    var $btn = $('.upgrade-btn--pro');
    $btn.prop('disabled', true).text('해지 처리 중...');

    $.ajax({
        url: CP + '/kakaopay/request_cancel',
        type: 'GET', // 결제팀 API 규격에 맞춤
        data: { orderId: orderId },
        success: function(response) {
            if (response === 'OK') {
                alert('PRO 멤버십 해지가 정상적으로 완료되었습니다.\n이용해주셔서 감사합니다.');
                
                /* * 세션 정보를 갱신해야 JSP의 <c:choose>가 FREE를 그릴 수 있으므로 
                 * 페이지를 새로고침하거나 마이페이지로 리다이렉트합니다.
                 */
                location.reload(); 
            } else {
                alert('취소 처리 중 오류가 발생했습니다: ' + response);
                $btn.prop('disabled', false).text('구독 해지');
            }
        },
        error: function(xhr, status, error) {
            console.error('Cancel Error:', error);
            alert('통신 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
            $btn.prop('disabled', false).text('구독 해지');
        }
    });
};


  /* ════════════════════════════════════════════
     계정 탈퇴
     ════════════════════════════════════════════ */

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
      error: function () { alert('탈퇴 처리 중 오류가 발생했습니다.'); }
    });
  };


  /* ════════════════════════════════════════════
     렌더 함수
     ════════════════════════════════════════════ */

  function rankClass(r) {
    return r === 1 ? 'gold' : r === 2 ? 'silver' : r === 3 ? 'bronze' : '';
  }

  /* 플레이 요약 stat-grid */
  function renderPlaySummary(data) {
    var totalSec = data.totalPlayTimeSec || 0;
    var totalH   = Math.floor(totalSec / 3600);
    var totalM   = Math.floor((totalSec % 3600) / 60);
    var prevH    = Math.floor((data.prevMonthPlayTimeSec || 0) / 3600);
    var diffPct  = prevH > 0 ? Math.round((totalH - prevH) / prevH * 100) : null;
    var diffText = diffPct !== null
      ? '전월 대비 ' + (diffPct >= 0 ? '+' : '') + diffPct + '%'
      : '전월 데이터 없음';

    var timeText;
    if (totalH > 0)      { timeText = totalH + '시간' + (totalM > 0 ? ' ' + totalM + '분' : ''); }
    else if (totalM > 0) { timeText = totalM + '분'; }
    else                 { timeText = '-'; diffText = '-'; }

    $('#mpStatTime').text(timeText);
    $('#mpStatTimeSub').text(diffText);
    $('#mpStatPlay').text(data.totalPlayCount ? data.totalPlayCount.toLocaleString() : '-');
    $('#mpStatPlaySub').text(data.uniqueTrackCount ? data.uniqueTrackCount.toLocaleString() + '개 고유 트랙' : '-');
    $('#mpStatDay').text(data.busiestDay || '-');
  }

  /* TOP 장르 */
  function renderGenres(list) {
    var $container = $('#mpTopGenres');
    if (!list || !list.length) {
      $container.html('<div class="empty-box">아직 장르 데이터가 없어요</div>');
      return;
    }
    var tmpl = document.getElementById('tmpl-genre-tag');
    var frag = document.createDocumentFragment();

    $.each(list, function (i, g) {
      var node = tmpl.content.cloneNode(true);
      node.querySelector('.genre-name').textContent = g.genreName;
      node.querySelector('.genre-pct').textContent  = g.percentage + '%';
      frag.appendChild(node);
    });
    $container.empty().append(frag);
  }

  /* TOP 10 곡 coverImageUrl만 cp없음(DB경로에 맞춤)*/
  function renderSongs(list) {
    var $container = $('#mpTopList');
    if (!list || !list.length) {
      $container.html('<div class="empty-box"><div class="empty-box__sub">아직 재생 기록이 없어요</div><div>음악을 들으면 여기에 TOP 10이 채워져요</div></div>');
      return;
    }
    var tmpl = document.getElementById('tmpl-list-item');
    var max  = list[0].playCount;
    var frag = document.createDocumentFragment();

    $.each(list, function (i, s) {
      var node = tmpl.content.cloneNode(true);
      var rank = i + 1;
      node.querySelector('.rank').textContent = rank;
      node.querySelector('.rank').className   = 'rank ' + rankClass(rank);
      
      var thumb = node.querySelector('.li-thumb');
	  if (s.coverImageUrl) {
	      var img = document.createElement('img');
	      img.src = s.coverImageUrl;
	      img.alt = s.title;
	      thumb.appendChild(img);
	  }
      
      node.querySelector('.li-name').textContent = s.title;
      node.querySelector('.li-sub').textContent  = s.artistName;
      node.querySelector('.prog-fill').style.width = Math.round(s.playCount / max * 100) + '%';
      node.querySelector('.li-right').textContent = s.playCount + '회';
      

      
      /* 아티스트 템플릿 재사용 — li-right 없으므로 숨김 처리 불필요 */
      frag.appendChild(node);
    });
    $container.empty().append(frag);
  }

  /* TOP 아티스트 */
  function renderArtists(list) {
    var $container = $('#mpTopArtists');
    if (!list || !list.length) {
      $container.html('<div class="empty-box">아직 아티스트 데이터가 없어요</div>');
      return;
    }
    var tmpl = document.getElementById('tmpl-list-item');
    var frag = document.createDocumentFragment();

    $.each(list, function (i, a) {
      var node = tmpl.content.cloneNode(true);
      var rank = i + 1;
      node.querySelector('.rank').textContent = rank;
      node.querySelector('.rank').className   = 'rank ' + rankClass(rank);
      /* 아티스트 썸네일 — 원형 + 이미지 */
      var thumb = node.querySelector('.li-thumb');
      thumb.className = 'li-thumb li-thumb--artist';
      if (a.coverImageUrl) {
        var img = document.createElement('img');
        img.src = CP + a.coverImageUrl;
        img.alt = a.name;
        thumb.appendChild(img);
      }
      node.querySelector('.li-name').textContent = a.name;
      /* node.querySelector('.li-sub').textContent  = a.playCount + '곡 재생'; */
      /* 아티스트는 prog-bar / li-right 불필요 — 숨김 */
      node.querySelector('.prog-bar').style.display  = 'none';
      node.querySelector('.li-right').style.display  = 'none';
      frag.appendChild(node);
    });
    $container.empty().append(frag);
  }

  /* 결제 내역 */
  function renderPayments(list) {
    var $container = $('#mpPayList');
    if (!list || !list.length) {
      $container.html('<div class="empty-box">결제 내역이 없습니다</div>');
      return;
    }
    var statusMap   = { APPROVED:'완료', FAIL:'결제 오류', READY:'대기', CANCEL:'결제 취소' };
	var statusClass = { APPROVED:'APPROVED', FAIL:'FAIL', READY:'READY', CANCEL:'CANCEL' };
    var typeIcon    = { CARD:'💳', VIRTUAL:'🏦', PHONE:'📱' };
    var tmpl = document.getElementById('tmpl-pay-item');
    var frag = document.createDocumentFragment();

    $.each(list, function (i, p) {
      var node = tmpl.content.cloneNode(true);
      node.querySelector('.pay-icon').textContent   = typeIcon[p.paymentType] || '💳';
      node.querySelector('.pay-name').textContent   = p.itemName;
      
      
 var targetDate;
  if (p.status === 'READY') {
    // 결제 대기일 때는 생성일(createdAt) 사용
    targetDate = p.createdAt;
  } else {
    // 결제 완료/취소 등은 승인일(approvedAt) 사용
    targetDate = p.approvedAt;
  }

  /* 날짜 변환 및 포맷팅 */
  var dateStr = '-'; // 기본값
  if (targetDate) {
    var d = new Date(targetDate);
    // 날짜가 유효한지 체크 (Invalid Date 방지)
    if (!isNaN(d.getTime())) {
      dateStr = d.getFullYear() + '.'
        + String(d.getMonth() + 1).padStart(2, '0') + '.'
        + String(d.getDate()).padStart(2, '0') + ' '
        + String(d.getHours()).padStart(2, '0') + ':'
        + String(d.getMinutes()).padStart(2, '0') + ':'
        + String(d.getSeconds()).padStart(2, '0');
    }
  } 
		  
      node.querySelector('.pay-sub').textContent = dateStr;
      node.querySelector('.pay-amount').textContent = '₩' + p.totalAmount.toLocaleString();
      
      var badge = node.querySelector('.status-badge');
      badge.textContent = statusMap[p.status] || p.status;
      badge.className   = 'status-badge ' + (statusClass[p.status] || '');
      frag.appendChild(node);
    });
    $container.empty().append(frag);
  }

  /* 활동 내역 */
  function renderActivity(list, isAppend) {
    var $list = $('#mpActivityList');
    var $btn  = $('#mpActMoreBtn');

    if (!list || !list.length) {
      if (!isAppend) {
        $list.html('<div class="empty-box empty-box--tall">활동 내역이 없습니다.</div>');
      }
      _mpActEnd = true;
      $btn.hide();
      return;
    }

    var TYPE_CLASS = { BOARD: 'act-badge--board', REPLY: 'act-badge--reply', REVIEW: 'act-badge--review' };
    var TYPE_LABEL = { BOARD: '게시글', REPLY: '댓글', REVIEW: '리뷰' };
    var tmpl = document.getElementById('tmpl-cmt-item');
    var frag = document.createDocumentFragment();

    $.each(list, function (i, item) {
      var type  = item.type || 'BOARD';
      var node  = tmpl.content.cloneNode(true);

      /* 뱃지 */
      var badge = node.querySelector('.act-badge');
      badge.textContent = TYPE_LABEL[type] || type;
      badge.className   = 'act-badge ' + (TYPE_CLASS[type] || TYPE_CLASS.BOARD);

      /* 원글 제목 */
      node.querySelector('.cmt-target-title').textContent = item.targetTitle || '내용 확인';

      /* 날짜 */
      var d = new Date(item.regdate);
      node.querySelector('.cmt-date').textContent =
        d.getFullYear() + '.' +
        String(d.getMonth() + 1).padStart(2, '0') + '.' +
        String(d.getDate()).padStart(2, '0');

      /* 내용 */
      node.querySelector('.cmt-text').textContent = item.content;

      /* 원글보기 URL */
      var url = (type === 'BOARD')
        ? CP + '/board/plusReadCnt?bno=' + item.targetNo
        : (type === 'REPLY')
        ? CP + '/board/plusReadCnt?bno=' + item.parentId
        : CP + '/show/showDetail?showId=' + item.parentId;

      var viewBtn = node.querySelector('.cmt-btn--view');
      viewBtn.addEventListener('click', (function (u) {
        return function () { location.href = u; };
      })(url));

      /* 삭제 버튼 — REPLY / REVIEW만 표시 */
      var delBtn = node.querySelector('.cmt-btn--del');
      if (type === 'REPLY' || type === 'REVIEW') {
        delBtn.style.display = '';
        delBtn.addEventListener('click', (function (tNo, pId, t) {
          return function () { mpDeleteActivity(tNo, pId, t); };
        })(item.targetNo, item.parentId, type));
      }

      frag.appendChild(node);
    });

    if (isAppend) { $list.append(frag); }
    else          { $list.empty().append(frag); }

    if (list.length < 10) { _mpActEnd = true; $btn.hide(); }
    else                  { $btn.show(); }
  }

  /* 예매 내역 */
  function renderReservations(dataList) {
    var el = document.getElementById('mpResCards');
    if (!el) return;

	// 1. 여기서 dataList가 없으면 빈 배열([])로 초기화합니다.
  	var list = dataList || [];

	// 2. 이제 RESERVATION_DUMMY 대신 list.length를 체크
    if (!list.length) {
      el.innerHTML = '<div class="res-empty"><div class="res-empty-icon">🎫</div><div>아직 예매 내역이 없습니다</div></div>';
      return;
    }

    var statusMap   = { APPROVED:'예매완료', CANCEL:'취소/환불'};
    var statusClass = { CONFIRMED:'confirmed', CANCELLED:'cancelled'};
    var tmpl = document.getElementById('tmpl-res-card');
    var grid = document.createElement('div');
    grid.className = 'res-grid';

    $.each(list, function (i, r) {
      var node = tmpl.content.cloneNode(true);

      /* 포스터 배경 — 이미지 URL 또는 그라데이션 (동적 데이터값이라 JS에서 처리) */
      var bg = node.querySelector('.res-poster-bg');
      bg.style.background = r.posterImg
        ? 'url(' + r.posterImg + ') center/cover'
        : r.gradient;

      node.querySelector('.res-name').textContent  = r.showTitle;
      node.querySelector('.res-date').textContent  = '📅 ' + r.startTime;

      var badge = node.querySelector('.status-badge');
      badge.textContent = statusMap[r.status] || r.status;
      badge.className   = 'status-badge ' + (statusClass[r.status] || '');

      node.querySelector('.res-venue').textContent = '📍 ' + r.venue;
      node.querySelector('.res-seat').textContent  = '💺 ' + r.seatLabel;
      node.querySelector('.res-amt').textContent   = r.amt;
      node.querySelector('.res-detail-btn').addEventListener('click', function () {
        alert('예매 상세');
      });

      grid.appendChild(node);
    });
    el.innerHTML = '';
    el.appendChild(grid);
  }


  /* ════════════════════════════════════════════
     차트 — 12개월 고정 빈 틀 → 데이터 업데이트
     ════════════════════════════════════════════ */

  function _buildMonthLabels() {
    var labels = [];
    for (var m = 1; m <= 12; m++) { labels.push(m + '월'); }
    return labels;
  }

  function _mapToMonthValues(statList) {
    var values = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    if (statList && statList.length) {
      $.each(statList, function (i, m) {
        var month = parseInt(m.yearMonth.substring(5), 10);
        if (month >= 1 && month <= 12) { values[month - 1] = m.totalAmount; }
      });
    }
    return values;
  }

 /* 1. 160도 톤의 묵직한 주황 + 반투명 그라데이션 추출 */
function _getOrangeGradient(ctx) {
    if (!ctx) return 'rgba(232, 93, 4, 0.5)';
    var w = ctx.canvas.width || 300;
    var h = ctx.canvas.height || 150;
    
    // 160도 각도 느낌을 위한 대각선 선형 그라데이션
    const g = ctx.createLinearGradient(0, 0, w * 0.4, h); 
    
    // 주황색 톤 유지 + 오퍼시티 0.45~0.55 (반투명)
    g.addColorStop(0,   'rgba(180, 60, 20, 0.45)');   // 딥 베이스
    g.addColorStop(0.4, 'rgba(237, 103, 1, 0.55)');   // 하이라이트 오렌지
    g.addColorStop(1,   'rgba(140, 45, 10, 0.45)');   // 묵직한 마무리
    return g;
}

/* 2. 막대 색상 계산 로직 (최대값 강조) */
function _calcBarColors(values, ctx) {
    var maxVal = Math.max.apply(null, values.concat([0]));
    var bg = [], bd = [];
    
    $.each(values, function (i, v) {
        if (v === maxVal && maxVal > 0) {
            // 최대값: 160도 그라데이션 + 진한 테두리
            bg.push(_getOrangeGradient(ctx));
            bd.push('rgba(232, 93, 4, 0.8)');
        } else {
            // 나머지: 은은한 반투명 흰색 (데이터 비례)
            var r = maxVal > 0 ? v / maxVal : 0;
            bg.push('rgba(255, 255, 255, ' + (0.04 + r * 0.1).toFixed(2) + ')');
            bd.push('rgba(255, 255, 255, 0.05)');
        }
    });
    return { bg: bg, bd: bd };
}

/* 3. 차트 초기 생성 (제자리 애니메이션 & 축 가이드라인) */
function mpCreateChart() {
    var canvas = document.getElementById('mpPayChart');
    if (!canvas || !window.Chart) return;
    if (_mpChart) { _mpChart.destroy(); _mpChart = null; }

    var ctx = canvas.getContext('2d');
    var emptyValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    var colors = _calcBarColors(emptyValues, ctx);

    _mpChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: _buildMonthLabels(),
            datasets: [{
                data: emptyValues,
                backgroundColor: colors.bg,
                borderColor: colors.bd,
                borderWidth: 1,
                borderRadius: 6,
                barPercentage: 0.5
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            // [애니메이션] 왼쪽에서 날아오지 않고 제자리에서 솟구침
            animations: {
                y: {
                    duration: 800,
                    easing: 'easeOutQuart',
                    from: (ctx) => ctx.chart.scales.y.getPixelForValue(0)
                },
                x: { duration: 0 } 
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: 'rgba(15, 19, 25, 0.98)',
                    borderColor: 'rgba(255, 255, 255, 0.08)',
                    borderWidth: 1,
                    padding: 10,
                    callbacks: {
                        label: function (c) {
                            return c.raw > 0 ? '₩' + c.raw.toLocaleString() + ' 결제되었어요' : '결제 내역이 없어요';
                        }
                    }
                }
            },
            scales: {
                x: {
                    grid: { display: true, drawOnChartArea: false, color: 'rgba(255, 255, 255, 0.1)' },
                    ticks: { color: 'rgba(242, 242, 242, 0.3)', font: { size: 10 } }
                },
                y: {
                    display: true,
                    grid: { color: 'rgba(255, 255, 255, 0.05)', borderDash: [3, 3], drawTicks: false },
                    border: { display: false },
                    ticks: {
                        color: 'rgba(242, 242, 242, 0.2)',
                        font: { size: 9 },
                        maxTicksLimit: 4,
                        callback: function(v) { return v > 0 ? v.toLocaleString() : ''; }
                    }
                }
            }
        }
    });
}

/* 4. 데이터 업데이트 (안정적 리사이즈 포함) */
function mpUpdateChart(statList) {
    if (!_mpChart) return;
    
    var values = _mapToMonthValues(statList);
    var colors = _calcBarColors(values, _mpChart.ctx);
    
    _mpChart.data.datasets[0].data = values;
    _mpChart.data.datasets[0].backgroundColor = colors.bg;
    _mpChart.data.datasets[0].borderColor = colors.bd;
    
    // 모달이 열린 직후 크기 계산 오류 방지
    _mpChart.resize(); 
    _mpChart.update({
        duration: 800,
        easing: 'easeOutQuart'
    });
}

/* 
 * 5. 모달 오픈 시 멤버십 데이터 로드 및 차트 리사이즈
 */
window.openMypage = function () { 
    // 모달 오버레이 오픈
    ModalCore.open('mpOverlay'); 
    
    /**
     * [Membership 정보 비동기 로드]
     * JSP Model에 멤버십 데이터가 없으므로 API를 통해 실시간 조회
     * 조회 성공 시: 해지 버튼에 orderId 주입 + 화면 날짜 텍스트 갱신
     */
    $.ajax({
        url:      CP + '/mypage/membershipInfo',
        type:     'GET',
        dataType: 'json',
        success: function(data) {
            console.log("<<< Membership API Response >>>", data); // 디버깅용 로그

            if (data && data.orderId) {
                // [1] 해지 버튼 속성 세팅
                $('.upgrade-btn--pro').attr('onclick', 
                    "mpCancelMembership('" + data.orderId + "')");
                
                // [2] 화면 데이터 렌더링 (ID 기반으로 텍스트 주입)
                // 만약 JSP에 해당 ID들이 없다면 추가가 필요합니다.
                if (data.expireDate) $('#expireDate').text(data.expireDate);
                if (data.daysLeft !== undefined) $('#daysLeft').text(data.daysLeft);
                
                // PRO 전용 UI 활성화 (필요 시)
                $('.ms-pro-badge').show();
            } else {
                // 멤버십 정보가 없을 때(FREE)의 처리
                $('.ms-pro-badge').hide();
                $('.upgrade-btn--pro').attr('onclick', "location.href='" + CP + "/payment/subscribe'");
            }
        },
        error: function(xhr, status, error) {
            console.error("<<< Membership API Error >>>", error);
        }
    });

    /**
     * [차트 리프레시]
     * 모달 애니메이션(0.2s)이 끝난 후 캔버스 크기를 재계산해야 차트가 깨지지 않음
     */
    setTimeout(function() {
        if (typeof _mpChart !== 'undefined' && _mpChart) {
            _mpChart.resize();
            _mpChart.update();
            console.log("<<< Chart Resized and Updated >>>");
        }
    }, 250); 
};

  /* ════════════════════════════════════════════
     Ajax 로드
     ════════════════════════════════════════════ */
  /* 플레이 리포트 */
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
        $('#mpTopList').html('<div class="empty-box">데이터를 불러오지 못했습니다</div>');
      }
    });
  }

  /* TOP 10 기간 변경 */
  window.mpLoadTopSongs = function (periodType) {
    $.ajax({
      url:      CP + '/mypage/playReport',
      type:     'GET',
      data:     { periodType: periodType },
      dataType: 'json',
      success: function (data) { if (data) renderSongs(data.topSongs); }
    });
  };

  /* 결제 내역 + 차트 */
  function mpLoadPayments() {
    if (!window._mpChartInited) { mpCreateChart(); }

    $.ajax({
      url:      CP + '/mypage/payments',
      type:     'GET',
      dataType: 'json',
      success:  function (data) { renderPayments(data); }
    });

    $.ajax({
      url:      CP + '/mypage/monthlyStats',
      type:     'GET',
      dataType: 'json',
      success:  function (data) { if (data && data.length) { mpUpdateChart(data); } }
    });
  }

  /* 활동 내역 */
  window.mpLoadActivity = function (page) {
    if (_mpActLoading || _mpActEnd) return;
    _mpActLoading = true;

    var currentPage = page || 1;

    $.ajax({
      url:      CP + '/mypage/activity',
      type:     'GET',
      data:     { page: currentPage },
      dataType: 'json',
      success: function (data) {
        renderActivity(data, currentPage > 1);
        _mpActPage = currentPage;
      },
      error: function () {
        if (currentPage === 1) {
          $('#mpActivityList').html('<div class="empty-box empty-box--tall">활동 내역을 불러오지 못했습니다.</div>');
        } else {
          alert('추가 내역을 불러오는 중 오류가 발생했습니다.');
        }
      },
      complete: function () { _mpActLoading = false; }
    });
  };

  /* 더보기 */
  window.mpMoreActivity = function () {
    mpLoadActivity(_mpActPage + 1);
  };

/* 활동 내역 삭제 — REPLY(댓글) / REVIEW(공연리뷰) URL 분리 */
  window.mpDeleteActivity = function (targetNo, parentId, type) {
    if (!confirm('정말 삭제하시겠습니까?')) return;

    var url    = (type === 'REPLY') ? CP + '/reply/delete' : CP + '/show/reviewDelete';
    var params = (type === 'REPLY')
      ? { cno: targetNo, bno: parentId }
      : { reviewId: targetNo };          /* 공연팀: reviewId만 받음 */

    $.ajax({
      url:  url,
      type: 'POST',
      data: params,
      success: function (res) {
        var resStr = String(res).trim();
        
        /* [핵심 수정] 
           1. resStr === '1' (댓글 성공 숫자)
           2. resStr === 'success' (리뷰 성공 문자열)
           3. resStr.indexOf('<') !== -1 (댓글팀이 JSP/HTML을 통째로 보낸 경우) 
        */
        var ok = (resStr === '1' || resStr === 'success' || resStr.indexOf('<') !== -1);

        if (ok) {
          // 성공 시 상태 초기화 및 리스트 재로딩
          _mpActPage    = 1;
          _mpActEnd     = false;
          _mpActLoading = false;
          
          // 기존 리스트 비우고 새로고침 (이게 빠지면 밑에 쌓일 수 있음)
          $('#mpActivityList').empty(); 
          mpLoadActivity(1);
          
          // alert('삭제가 완료되었습니다.');
        } else {
          alert('삭제에 실패했습니다. (응답: ' + resStr.substring(0, 20) + '...)');
        }
      },
      error: function () { alert('삭제 중 오류가 발생했습니다.'); }
    });
  };


  /* ════════════════════════════════════════════
     초기 렌더
     ════════════════════════════════════════════ */
  document.addEventListener('DOMContentLoaded', function () {
    mpLoadPlayReport('THIS_MONTH');
    window._mpReportLoaded = true;
  });

}());