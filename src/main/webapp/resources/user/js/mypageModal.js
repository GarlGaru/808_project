/**
 * mypageModal.js
 * 의존성: modalCore.js (window.ModalCore), authModal.js (window.AuthAPI)
 *
 */
(function () {
  'use strict';

  var CP = window.__AUTH_CP || '';


  /* ════════════════════════════════════════════════════════════
     1. MODAL — 열기 / 닫기 / 초기화
     ════════════════════════════════════════════════════════════ */

  window.openMypage = function () {
    ModalCore.open('mpOverlay');

    // 항상 808 플레이 리포트 탭으로 시작 (데이터 로드 포함)
    var firstNav = document.querySelector('.mypage-modal .nav-item');
    mpTab(firstNav, 'report', '808 플레이 리포트', '이번 달 나의 음악 취향과 사운드 인사이트');

    // 모달 열릴 때마다 멤버십 정보 새로 조회
    _apiLoadMembership();
  };

  window.mpClose = function () {
    ModalCore.close('mpOverlay', 250);
  };

  document.addEventListener('DOMContentLoaded', function () {
    // 외부 클릭 / ESC 키로 닫기
    ModalCore.bindOutsideClick('mpOverlay', '.mypage-modal');
    ModalCore.bindEscKey('mpOverlay');

    // 모달 닫힐 때 상태 리셋
    if (ModalCore.bindOnClose) {
      ModalCore.bindOnClose('mpOverlay', _resetOnClose);
    }

    // 비밀번호 인증코드 실시간 검사
    var pwCode = document.getElementById('pwCode');
    if (pwCode) { pwCode.addEventListener('input', _checkPwCode); }
  });

  // 모달 닫힐 때 실행 — 다음 오픈을 위해 초기화
  function _resetOnClose() {
    // 활동 내역 페이징 초기화
    _act.page    = 1;
    _act.loading = false;
    _act.end     = false;
    $('#mpActivityList').empty();
    $('#mpResCards').empty();

    // 차트 파괴 (재오픈 시 새로 생성)
    if (_chart) { _chart.destroy(); _chart = null; }

    // 폼 상태 초기화
    _resetPwState();
    _resetNickCheck();

    // 프로필 수정 → 보기 모드로 복구
    var editEl = document.getElementById('mpPvEdit');
    var viewEl = document.getElementById('mpPvView');
    if (editEl) { editEl.style.display = 'none'; }
    if (viewEl) { viewEl.style.display = 'block'; }
  }


  /* ════════════════════════════════════════════════════════════
     2. TAB — 탭 전환 (항상 Ajax 호출, 상태 캐싱 없음)
     ════════════════════════════════════════════════════════════ */

  window.mpTab = function (el, id, title, sub) {
    // 탭 UI 전환
    $('.mypage-modal .nav-item').removeClass('active');
    $('.mypage-modal .tab-pane').removeClass('active');
    $(el).addClass('active');
    $('#tab-' + id).addClass('active');
    $('#mpTitle').text(title);
    $('#mpSub').text(sub);

    // 탭에 맞는 데이터 항상 새로 조회
    if (id === 'report')       { _apiLoadReport('THIS_MONTH'); }
    if (id === 'payments')     { _apiLoadPayments(); }
    if (id === 'reservations') { _apiLoadReservations(); }
    if (id === 'activity')     {
      // 활동 탭은 페이징 포함 — 초기화 후 1페이지 로드
      _act.page    = 1;
      _act.end     = false;
      _act.loading = false;
      $('#mpActivityList').empty();
      _apiLoadActivity(1);
    }
  };


  /* ════════════════════════════════════════════════════════════
     3. API — Ajax 요청 (데이터 받아서 render 함수로 넘김)
     ════════════════════════════════════════════════════════════ */

  // 플레이 리포트
  function _apiLoadReport(periodType) {
    $.ajax({
      url:      CP + '/mypage/playReport',
      type:     'GET',
      data:     { periodType: periodType || 'THIS_MONTH' },
      dataType: 'json',
      success: function (data) {
        if (!data) { return; }
        _renderPlaySummary(data);
        _renderGenres(data.topGenres);
        _renderSongs(data.topSongs);
        _renderArtists(data.topArtists);
      },
      error: function () {
        $('#mpTopList').html('<div class="empty-box">데이터를 불러오지 못했습니다.</div>');
      }
    });
  }

  // TOP 10 기간 변경 (리포트 탭 내 셀렉트박스용)
  window.mpLoadTopSongs = function (periodType) {
    $.ajax({
      url:      CP + '/mypage/playReport',
      type:     'GET',
      data:     { periodType: periodType },
      dataType: 'json',
      success: function (data) { if (data) { _renderSongs(data.topSongs); } }
    });
  };

  // 결제 내역 페이징 상태
  var _pay = { page: 1, loading: false, end: false };

  // 결제 내역 + 차트
  function _apiLoadPayments() {
    // 탭 진입 시 페이징 초기화
    _pay.page    = 1;
    _pay.end     = false;
    _pay.loading = false;
    $('#mpPayList').empty();

    // 차트는 탭 진입 시마다 새로 생성
    _createChart();

    _apiLoadPaymentPage(1);

    $.ajax({
      url:      CP + '/mypage/monthlyStats',
      type:     'GET',
      dataType: 'json',
      success:  function (data) { if (data && data.length) { _updateChart(data); } }
    });
  }

  // 결제 내역 페이지 단위 로드
  function _apiLoadPaymentPage(page) {
    if (_pay.loading || _pay.end) { return; }
    _pay.loading = true;

    $.ajax({
      url:      CP + '/mypage/payments',
      type:     'GET',
      data:     { page: page },
      dataType: 'json',
      success: function (data) {
        _renderPayments(data, page > 1);
        _pay.page = page;
      },
      error: function () {
        if (page === 1) {
          $('#mpPayList').html('<div class="empty-box">결제 내역을 불러오지 못했습니다.</div>');
        } else {
          alert('추가 내역을 불러오는 중 오류가 발생했습니다.');
        }
      },
      complete: function () { _pay.loading = false; }
    });
  }

  // 결제 더보기
  window.mpMorePayments = function () { _apiLoadPaymentPage(_pay.page + 1); };

  // 예매 내역
  function _apiLoadReservations() {
    $.ajax({
      url:      CP + '/mypage/reservations',
      type:     'GET',
      dataType: 'json',
      success:  function (list) { _renderReservations(list); },
      error:    function () {
        $('#mpResCards').html('<div class="empty-box">예매 내역을 불러오지 못했습니다.</div>');
      }
    });
  }

  // 활동 내역 (페이징)
  var _act = { page: 1, loading: false, end: false };

  function _apiLoadActivity(page) {
    if (_act.loading || _act.end) { return; }
    _act.loading = true;

    $.ajax({
      url:      CP + '/mypage/activity',
      type:     'GET',
      data:     { page: page },
      dataType: 'json',
      success: function (data) {
        _renderActivity(data, page > 1);
        _act.page = page;
      },
      error: function () {
        if (page === 1) {
          $('#mpActivityList').html('<div class="empty-box empty-box--tall">활동 내역을 불러오지 못했습니다.</div>');
        } else {
          alert('추가 내역을 불러오는 중 오류가 발생했습니다.');
        }
      },
      complete: function () { _act.loading = false; }
    });
  }

  // 더보기 버튼
  window.mpMoreActivity = function () { _apiLoadActivity(_act.page + 1); };

  // 멤버십 정보
  function _apiLoadMembership() {
    $.ajax({
      url:      CP + '/mypage/membershipInfo',
      type:     'GET',
      dataType: 'json',
      success: function (data) {
        if (data && data.orderId) {
          // PRO 회원: 해지 버튼에 orderId 주입
          $('.upgrade-btn--pro').attr('onclick', "mpCancelMembership('" + data.orderId + "')");
          if (data.expireDate)              { $('#expireDate').text(data.expireDate); }
          if (data.daysLeft !== undefined)  { $('#daysLeft').text(data.daysLeft); }
          $('.ms-pro-badge').show();
        } else {
          // FREE 회원: 구독 페이지 이동
          $('.upgrade-btn--pro').attr('onclick', "location.href='" + CP + "/payment/subscribe'");
          $('.ms-pro-badge').hide();
        }
      },
      error: function () { console.error('멤버십 정보 조회 실패'); }
    });
  }


  /* ════════════════════════════════════════════════════════════
     4. RENDER — DOM 렌더링 (Ajax 직접 호출 안 함)
     ════════════════════════════════════════════════════════════ */

  /* ── 공통 유틸 ── */
  function _rankClass(r) {
    return r === 1 ? 'gold' : r === 2 ? 'silver' : r === 3 ? 'bronze' : '';
  }

  function _formatDate(dateStr) {
    if (!dateStr) { return ''; }
    var d = new Date(dateStr);
    return d.getFullYear() + '.'
      + ('0' + (d.getMonth() + 1)).slice(-2) + '.'
      + ('0' + d.getDate()).slice(-2);
  }

  function _parsePrice(str) {
    if (!str) { return 0; }
    return Number(str.replace(/[^\d]/g, '')) || 0;
  }

  /* ── 플레이 리포트 요약 ── */
  function _renderPlaySummary(data) {
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

  /* ── TOP 장르 ── */
  function _renderGenres(list) {
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

  /* ── TOP 10 곡 ── */
  function _renderSongs(list) {
    var $container = $('#mpTopList');
    if (!list || !list.length) {
      $container.html(
        '<div class="empty-box">' +
          '<div class="empty-box__sub">아직 재생 기록이 없어요</div>' +
          '<div>음악을 들으면 여기에 TOP 10이 채워져요</div>' +
        '</div>'
      );
      return;
    }
    var tmpl = document.getElementById('tmpl-list-item');
    var max  = list[0].playCount;
    var frag = document.createDocumentFragment();

    $.each(list, function (i, s) {
      var node = tmpl.content.cloneNode(true);
      var rank = i + 1;
      node.querySelector('.rank').textContent = rank;
      node.querySelector('.rank').className   = 'rank ' + _rankClass(rank);

      var thumb = node.querySelector('.li-thumb');
      if (s.coverImageUrl) {
        var img = document.createElement('img');
        img.src = s.coverImageUrl;
        img.alt = s.title;
        thumb.appendChild(img);
      }

      node.querySelector('.li-name').textContent   = s.title;
      node.querySelector('.li-sub').textContent    = s.artistName;
      node.querySelector('.prog-fill').style.width = Math.round(s.playCount / max * 100) + '%';
      node.querySelector('.li-right').textContent  = s.playCount + '회';
      frag.appendChild(node);
    });
    $container.empty().append(frag);
  }

  /* ── TOP 아티스트 ── */
  function _renderArtists(list) {
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
      node.querySelector('.rank').className   = 'rank ' + _rankClass(rank);

      var thumb = node.querySelector('.li-thumb');
      thumb.className = 'li-thumb li-thumb--artist';
      if (a.coverImageUrl) {
        var img = document.createElement('img');
        img.src = CP + a.coverImageUrl;
        img.alt = a.name;
        thumb.appendChild(img);
      }

      node.querySelector('.li-name').textContent    = a.name;
      node.querySelector('.prog-bar').style.display = 'none';
      node.querySelector('.li-right').style.display = 'none';
      frag.appendChild(node);
    });
    $container.empty().append(frag);
  }

  /* ── 결제 내역 ── */
  function _renderPayments(list, isAppend) {
    var $container = $('#mpPayList');
    var $btn       = $('#mpPayMoreBtn');

    if (!list || !list.length) {
      if (!isAppend) {
        $container.html('<div class="empty-box">결제 내역이 없습니다.</div>');
      }
      _pay.end = true;
      $btn.hide();
      return;
    }
    var statusMap   = { APPROVED: '완료', FAIL: '결제 오류', READY: '대기', CANCEL: '결제 취소' };
    var statusClass = { APPROVED: 'APPROVED', FAIL: 'FAIL', READY: 'READY', CANCEL: 'CANCEL' };
    var typeIcon    = { CARD: '💳', VIRTUAL: '🏦', PHONE: '📱' };
    var tmpl = document.getElementById('tmpl-pay-item');
    var frag = document.createDocumentFragment();

    $.each(list, function (i, p) {
      var node = tmpl.content.cloneNode(true);
      node.querySelector('.pay-icon').textContent   = typeIcon[p.paymentType] || '💳';
      node.querySelector('.pay-name').textContent   = p.itemName;
      node.querySelector('.pay-amount').textContent = '₩' + p.totalAmount.toLocaleString();

      // READY는 생성일, 나머지는 승인일 표시
      var targetDate = (p.status === 'READY') ? p.createdAt : p.approvedAt;
      var dateStr    = '-';
      if (targetDate) {
        var d = new Date(targetDate);
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

      var badge = node.querySelector('.status-badge');
      badge.textContent = statusMap[p.status] || p.status;
      badge.className   = 'status-badge ' + (statusClass[p.status] || '');
      frag.appendChild(node);
    });
    if (isAppend) { $container.append(frag); }
    else          { $container.empty().append(frag); }

    if (list.length < 10) { _pay.end = true; $btn.hide(); }
    else                  { $btn.show(); }
  }

  /* ── 예매 내역 ── */
  function _renderReservations(dataList) {
    var el   = document.getElementById('mpResCards');
    var list = dataList || [];

    if (!list.length) {
      el.innerHTML = '<div class="res-empty"><div class="res-empty-icon">🎫</div><div>아직 예매 내역이 없습니다.</div></div>';
      return;
    }

    var statusMap   = { APPROVED: '예매완료', CANCEL: '취소/환불', CONFIRMED: '예매완료' };
    var statusClass = { APPROVED: 'confirmed', CONFIRMED: 'confirmed', CANCEL: 'cancelled' };
    var tmpl = document.getElementById('tmpl-res-card');
    var grid = document.createElement('div');
    grid.className = 'res-grid';

    // 같은 예약 ID끼리 묶어서 좌석 합산 표시
    var grouped = {};
    list.forEach(function (r) {
      if (!grouped[r.reservationId]) { grouped[r.reservationId] = []; }
      grouped[r.reservationId].push(r);
    });

    Object.keys(grouped).forEach(function (key) {
      var group = grouped[key];
      var rep   = group[0];
      var node  = tmpl.content.cloneNode(true);

      // 포스터 배경
      var bg = node.querySelector('.res-poster-bg');
      if (rep.posterImg) {
        bg.style.backgroundImage    = 'url(' + rep.posterImg + ')';
        bg.style.backgroundSize     = 'cover';
        bg.style.backgroundPosition = 'center';
      } else {
        bg.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
      }

      node.querySelector('.res-name').textContent  = rep.showTitle;
      node.querySelector('.res-date').textContent  = _formatDate(rep.startDate) + ' ~ ' + _formatDate(rep.endDate);
      node.querySelector('.res-time').textContent  = _formatDate(rep.playDate);
      node.querySelector('.res-venue').textContent = rep.venue;

      // 좌석 요약: "VIP A1 외 2매"
      var seatParts   = group.map(function (s) {
        return (s.seatGrade ? s.seatGrade + ' ' : '') + (s.seatLabel || '-');
      });
      var seatSummary = seatParts.length > 1
        ? seatParts[0] + ' 외 ' + (seatParts.length - 1) + '매'
        : seatParts[0];
      node.querySelector('.res-seat').textContent = seatSummary;

      // 금액 합산
      var totalPrice = group.reduce(function (sum, s) { return sum + _parsePrice(s.ticketPrice); }, 0);
      node.querySelector('.res-amt').textContent = '₩' + totalPrice.toLocaleString();

      // 상태 뱃지
      var badge = node.querySelector('.status-badge');
      badge.textContent = statusMap[rep.status] || rep.status;
      badge.className   = 'status-badge ' + (statusClass[rep.status] || '');

      // 상세보기 버튼 숨김
      node.querySelector('.res-detail-btn').style.display = 'none';

      // 카드 클릭 → 마이티켓
      node.querySelector('.res-card').onclick = function () {
        window.location.href = CP + '/show/mypage/myTicket';
      };

      grid.appendChild(node);
    });

    el.innerHTML = '';
    el.appendChild(grid);
  }

  /* ── 활동 내역 ── */
  function _renderActivity(list, isAppend) {
    var $list = $('#mpActivityList');
    var $btn  = $('#mpActMoreBtn');

    if (!list || !list.length) {
      if (!isAppend) {
        $list.html('<div class="empty-box empty-box--tall">활동 내역이 없습니다.</div>');
      }
      _act.end = true;
      $btn.hide();
      return;
    }

    var TYPE_CLASS = { BOARD: 'act-badge--board', REPLY: 'act-badge--reply', REVIEW: 'act-badge--review' };
    var TYPE_LABEL = { BOARD: '게시글', REPLY: '댓글', REVIEW: '리뷰' };
    var tmpl = document.getElementById('tmpl-cmt-item');
    var frag = document.createDocumentFragment();

    $.each(list, function (i, item) {
      var type = item.type || 'BOARD';
      var node = tmpl.content.cloneNode(true);

      var badge = node.querySelector('.act-badge');
      badge.textContent = TYPE_LABEL[type] || type;
      badge.className   = 'act-badge ' + (TYPE_CLASS[type] || TYPE_CLASS.BOARD);

      node.querySelector('.cmt-target-title').textContent = item.targetTitle || '내용 확인';

      var d = new Date(item.regdate);
      node.querySelector('.cmt-date').textContent =
        d.getFullYear() + '.' +
        String(d.getMonth() + 1).padStart(2, '0') + '.' +
        String(d.getDate()).padStart(2, '0');

      node.querySelector('.cmt-text').textContent = item.content;

      var url = (type === 'BOARD')
        ? CP + '/board/plusReadCnt?bno=' + item.targetNo
        : (type === 'REPLY')
        ? CP + '/board/plusReadCnt?bno=' + item.parentId
        : CP + '/show/showDetail?showId=' + item.parentId;

      var viewBtn = node.querySelector('.cmt-btn--view');
      viewBtn.addEventListener('click', (function (u) {
        return function () { location.href = u; };
      })(url));

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

    if (list.length < 10) { _act.end = true; $btn.hide(); }
    else                  { $btn.show(); }
  }


  /* ════════════════════════════════════════════════════════════
     5. CHART — 결제 탭 막대 차트
     ════════════════════════════════════════════════════════════ */

  var _chart = null;

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

  function _getOrangeGradient(ctx) {
    if (!ctx) { return 'rgba(232, 93, 4, 0.5)'; }
    var w = ctx.canvas.width  || 300;
    var h = ctx.canvas.height || 150;
    var g = ctx.createLinearGradient(0, 0, w * 0.4, h);
    g.addColorStop(0,   'rgba(180, 60, 20, 0.45)');
    g.addColorStop(0.4, 'rgba(237, 103, 1, 0.55)');
    g.addColorStop(1,   'rgba(140, 45, 10, 0.45)');
    return g;
  }

  // 최대값 막대만 주황 강조
  function _calcBarColors(values, ctx) {
    var maxVal = Math.max.apply(null, values.concat([0]));
    var bg = [], bd = [];
    $.each(values, function (i, v) {
      if (v === maxVal && maxVal > 0) {
        bg.push(_getOrangeGradient(ctx));
        bd.push('rgba(232, 93, 4, 0.8)');
      } else {
        var r = maxVal > 0 ? v / maxVal : 0;
        bg.push('rgba(255, 255, 255, ' + (0.04 + r * 0.1).toFixed(2) + ')');
        bd.push('rgba(255, 255, 255, 0.05)');
      }
    });
    return { bg: bg, bd: bd };
  }

  function _createChart() {
    var canvas = document.getElementById('mpPayChart');
    if (!canvas || !window.Chart) { return; }

    // 이전 차트 파괴 후 재생성
    if (_chart) { _chart.destroy(); _chart = null; }

    var ctx         = canvas.getContext('2d');
    var emptyValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    var colors      = _calcBarColors(emptyValues, ctx);

    _chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels:   _buildMonthLabels(),
        datasets: [{
          data:            emptyValues,
          backgroundColor: colors.bg,
          borderColor:     colors.bd,
          borderWidth:     1,
          borderRadius:    6,
          barPercentage:   0.5
        }]
      },
      options: {
        responsive:          true,
        maintainAspectRatio: false,
        animations: {
          y: {
            duration: 800,
            easing:   'easeOutQuart',
            from: function (ctx) { return ctx.chart.scales.y.getPixelForValue(0); }
          },
          x: { duration: 0 }
        },
        plugins: {
          legend:  { display: false },
          tooltip: {
            backgroundColor: 'rgba(15, 19, 25, 0.98)',
            borderColor:     'rgba(255, 255, 255, 0.08)',
            borderWidth:     1,
            padding:         10,
            callbacks: {
              label: function (c) {
                return c.raw > 0 ? '₩' + c.raw.toLocaleString() + ' 결제되었어요' : '결제 내역이 없어요';
              }
            }
          }
        },
        scales: {
          x: {
            grid:  { display: true, drawOnChartArea: false, color: 'rgba(255,255,255,0.1)' },
            ticks: { color: 'rgba(242,242,242,0.3)', font: { size: 10 } }
          },
          y: {
            display: true,
            grid:    { color: 'rgba(255,255,255,0.05)', borderDash: [3, 3], drawTicks: false },
            border:  { display: false },
            ticks: {
              color:         'rgba(242,242,242,0.2)',
              font:          { size: 9 },
              maxTicksLimit: 4,
              callback: function (v) { return v > 0 ? v.toLocaleString() : ''; }
            }
          }
        }
      }
    });
  }

  function _updateChart(statList) {
    if (!_chart) { return; }
    var values = _mapToMonthValues(statList);
    var colors = _calcBarColors(values, _chart.ctx);
    _chart.data.datasets[0].data            = values;
    _chart.data.datasets[0].backgroundColor = colors.bg;
    _chart.data.datasets[0].borderColor     = colors.bd;
    _chart.resize();
    _chart.update({ duration: 800, easing: 'easeOutQuart' });
  }


  /* ════════════════════════════════════════════════════════════
     6. PROFILE — 아바타 / 프로필 수정
     ════════════════════════════════════════════════════════════ */

  // 아바타 변경
  window.mpChangeAvatar = function (input) {
    if (!input.files || !input.files[0]) { return; }
    var file = input.files[0];

    // 미리보기
    var reader = new FileReader();
    reader.onload = function (e) {
      document.getElementById('mpAv').innerHTML = '<img src="' + e.target.result + '" alt="프로필">';
    };
    reader.readAsDataURL(file);

    // 서버 업로드
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

  // 수정 모드 진입
  window.mpEditStart = function () {
    _resetNickCheck();
    document.getElementById('mpPvView').style.display = 'none';
    document.getElementById('mpPvEdit').style.display = 'block';
  };

  // 수정 취소
  window.mpEditCancel = function () {
    _resetPwState();
    _resetNickCheck();
    document.getElementById('mpPvEdit').style.display = 'none';
    document.getElementById('mpPvView').style.display = 'block';
  };

  // 닉네임 중복 확인
  var _nick = { checked: false, val: '' };

  window.mpCheckNick = function () {
    var nick     = $('#eNick').val().trim();
    var origNick = $('#vNick').text().trim();
    var $msg     = $('#nickCheckMsg');
    var $btn     = $('#nickCheckBtn');

    if (!nick) { alert('닉네임을 입력해주세요.'); return; }

    if (nick.length < 2 || nick.length > 10) {
      _nick.checked = false;
      $('#eNick').removeClass('valid').addClass('invalid');
      $msg.text('✕ 닉네임은 2~10자로 입력해주세요.').removeClass('msg--ok msg--muted').addClass('msg--err').show();
      return;
    }
    if (!/^[가-힣a-zA-Z0-9]+$/.test(nick)) {
      _nick.checked = false;
      $('#eNick').removeClass('valid').addClass('invalid');
      $msg.text('✕ 한글, 영문, 숫자만 사용 가능합니다.').removeClass('msg--ok msg--muted').addClass('msg--err').show();
      return;
    }
    if (nick === origNick) {
      _nick.checked = true;
      _nick.val     = nick;
      $('#eNick').removeClass('valid invalid');
      $msg.text('현재 사용 중인 닉네임입니다.').removeClass('msg--ok msg--err').addClass('msg--muted').show();
      return;
    }

    $btn.prop('disabled', true).text('확인 중...');

    AuthAPI.checkNick(nick).then(function (cnt) {
      if (cnt > 0) {
        _nick.checked = false;
        $('#eNick').removeClass('valid').addClass('invalid');
        $msg.text('✕ 이미 사용 중인 닉네임입니다.').removeClass('msg--ok msg--muted').addClass('msg--err').show();
      } else {
        _nick.checked = true;
        _nick.val     = nick;
        $('#eNick').removeClass('invalid').addClass('valid');
        $msg.text('✓ 사용 가능한 닉네임입니다.').removeClass('msg--err msg--muted').addClass('msg--ok').show();
      }
    }).catch(function () {
      $msg.text('중복 확인에 실패했습니다. 다시 시도해주세요.').removeClass('msg--ok msg--err').addClass('msg--muted').show();
    }).then(function () {
      $btn.prop('disabled', false).text('중복확인');
    });
  };

  function _resetNickCheck() {
    _nick.checked = false;
    _nick.val     = '';
    $('#eNick').removeClass('valid invalid');
    $('#nickCheckMsg').hide().text('');
  }
  window.mpResetNickCheck = _resetNickCheck;

  // 내 정보 저장
 window.mpEditSave = function () {
  var nick     = $('#eNick').val().trim();
  var bio      = $('#eBio').val().trim();
  var birth    = $('#eBirth').val();

  var origNick = $('#vNick').text().trim();
  var origBio  = $('#vBio').text().trim();
  var origBirthText = $('#vBirth').text().trim();

  // birth 원본값 파싱 (yyyy년 m월 d일 → yyyy-mm-dd)
  var origBirth = '';
  if (origBirthText) {
    var match = origBirthText.match(/(\d+)년 (\d+)월 (\d+)일/);
    if (match) {
      origBirth = match[1] + '-' +
        match[2].padStart(2, '0') + '-' +
        match[3].padStart(2, '0');
    }
  }

  // 변경 여부 체크
  var isChanged =
    nick !== origNick ||
    bio !== origBio ||
    birth !== origBirth;

  if (!isChanged) {
    alert('변경된 내용이 없습니다.');
    return;
  }

  // 수정 확인 알럿
  if (!confirm('수정하시겠습니까?')) {
    return;
  }

  if (!nick) {
    alert('닉네임을 입력해주세요.');
    return;
  }

  if (nick !== origNick && (!_nick.checked || _nick.val !== nick)) {
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
          $('#vBirth').text(
            d.getFullYear() + '년 ' +
            (d.getMonth() + 1) + '월 ' +
            d.getDate() + '일'
          );
        }

        $('#eNick').val(nick).removeClass('valid invalid');
        $('#eBio').val(bio);

        _nick.checked = false;
        _nick.val     = '';

        $('.mypage-modal .sb-name').text(nick);

        window.mpEditCancel();
      } else if (result === -1) {
        alert('닉네임을 입력해주세요.');
      } else {
        alert('저장에 실패했습니다.');
      }
    },
    error: function () {
      alert('저장 중 오류가 발생했습니다.');
    }
  });
};


  /* ════════════════════════════════════════════════════════════
     7. PASSWORD — 비밀번호 변경
     ════════════════════════════════════════════════════════════ */

  var _pw = { codeVerified: false, serverCode: '', timerId: null };

  function _resetPwState() {
    _stopPwTimer();
    _pw.codeVerified = false;
    _pw.serverCode   = '';
    var f   = document.getElementById('pwCodeField');
    var c   = document.getElementById('pwCode');
    var cur = document.getElementById('pwCurrent');
    var pn  = document.getElementById('pwNew');
    var pc  = document.getElementById('pwConfirm');
    if (f)   { f.style.display = 'none'; }
    if (c)   { c.value = ''; c.classList.remove('valid', 'invalid'); }
    if (cur) { cur.value = ''; }
    if (pn)  { pn.value = ''; }
    if (pc)  { pc.value = ''; }
  }
  window.mpResetPwState = _resetPwState;

  function _startPwTimer() {
    var timerEl = document.getElementById('pwTimer');
    if (!timerEl) { return; }
    _pw.timerId = ModalCore.timer.start(timerEl, 300);
  }

  function _stopPwTimer() {
    var timerEl = document.getElementById('pwTimer');
    ModalCore.timer.stop(timerEl, _pw.timerId);
    _pw.timerId = null;
  }

  // 인증코드 발송
  window.mpSendCode = function (email) {
    if (!email) { return; }
    var $btn      = $('#pwSendBtn');
    var codeField = document.getElementById('pwCodeField');
    var codeInput = document.getElementById('pwCode');

    $btn.prop('disabled', true).text('발송 중...');

    AuthAPI.sendResetCode(email).then(function (result) {
      if (!result.ok) { alert(result.message); return; }
      _pw.serverCode   = result.code;
      _pw.codeVerified = false;
      if (codeInput) { codeInput.value = ''; codeInput.classList.remove('valid', 'invalid'); }
      if (codeField) { codeField.style.display = 'block'; _startPwTimer(); }
      alert('[임시 인증번호] : ' + _pw.serverCode + '\n입력창에 입력해주세요.');
    }).catch(function () {
      alert('인증코드 발송에 실패했습니다.');
    }).then(function () {
      $btn.prop('disabled', false).text('코드 발송');
    });
  };

  // 인증코드 입력 실시간 검사
  function _checkPwCode() {
    var inp = document.getElementById('pwCode');
    if (!inp) { return; }
    var val = inp.value.trim();
    inp.classList.remove('valid', 'invalid');
    if (!val) { _pw.codeVerified = false; return; }
    if (val.length === 6) {
      if (val === _pw.serverCode) {
        inp.classList.add('valid');   _pw.codeVerified = true;
      } else {
        inp.classList.add('invalid'); _pw.codeVerified = false;
      }
    } else {
      inp.classList.add('invalid'); _pw.codeVerified = false;
    }
  }

  // 비밀번호 변경 제출
  window.mpChangePw = function () {
    var current   = document.getElementById('pwCurrent');
    var pwNew     = document.getElementById('pwNew');
    var pwConfirm = document.getElementById('pwConfirm');
    var code      = document.getElementById('pwCode');

    if (!current || !current.value.trim())                  { alert('현재 비밀번호를 입력해주세요.'); return; }
    if (!_pw.codeVerified)                                  { alert('이메일 인증을 완료해주세요.'); return; }
    if (!pwNew || !pwNew.value)                             { alert('새 비밀번호를 입력해주세요.'); return; }
    if (pwNew.value.length < 8 || pwNew.value.length > 20) { alert('비밀번호는 8~20자로 입력해주세요.'); return; }
    if (pwNew.value !== pwConfirm.value)                    { alert('비밀번호가 일치하지 않습니다.'); return; }

    $.ajax({
      url:      CP + '/mypage/updatePw',
      type:     'POST',
      data:     { currentPw: current.value, code: code.value, newPw: pwNew.value },
      dataType: 'json',
      success: function (result) {
        if      (result === 1)  { _resetPwState(); alert('비밀번호가 변경되었습니다.'); }
        else if (result === -1) { alert('현재 비밀번호가 일치하지 않습니다.'); }
        else if (result === -2) { alert('인증코드가 만료되었거나 올바르지 않습니다.'); }
        else                    { alert('비밀번호 변경에 실패했습니다.'); }
      },
      error: function () { alert('비밀번호 변경 중 오류가 발생했습니다.'); }
    });
  };


  /* ════════════════════════════════════════════════════════════
     8. MEMBERSHIP — 멤버십 구독 / 해지
     ════════════════════════════════════════════════════════════ */

  window.handleProMembership = function (currentMembership) {
    if (currentMembership === 'PRO') {
      if (confirm('현재 PRO 멤버십을 이용 중입니다.\n구독을 취소하시겠습니까?')) {
        alert('해지하려면 구독 해지 버튼을 직접 클릭해주세요.');
      }
      return;
    }
    if (typeof window.openSubscribeModal === 'function') {
      window.openSubscribeModal();
    } else {
      alert('결제 시스템을 불러올 수 없습니다. 잠시 후 다시 시도해주세요.');
    }
  };

  // 결제 실패 재시도
  window.retryMembershipPayment = function (orderId) {
    if (!orderId) { return; }
    if (confirm('결제에 실패한 이력이 있습니다. 다시 결제를 진행하시겠습니까?')) {
      location.href = CP + '/kakaopay/retry?orderId=' + orderId;
    }
  };

  // 멤버십 해지
  window.mpCancelMembership = function (orderId) {
    if (!orderId || orderId === 'null' || orderId === '') {
      alert('결제 정보를 찾을 수 없어 해지가 불가능합니다.\n고객센터로 문의해주세요.');
      return;
    }
    if (!confirm('정말 멤버십 구독을 해지하시겠습니까?\n해지 시 즉시 모든 PRO 혜택이 중단되고 FREE 등급으로 전환됩니다.')) {
      return;
    }

    var $btn = $('.upgrade-btn--pro');
    $btn.prop('disabled', true).text('해지 처리 중...');

    $.ajax({
      url:  CP + '/kakaopay/request_cancel',
      type: 'GET',
      data: { orderId: orderId },
      success: function (response) {
        if (response === 'OK') {
          alert('PRO 멤버십 해지가 완료되었습니다.\n이용해주셔서 감사합니다.');
          location.reload();
        } else {
          alert('취소 처리 중 오류가 발생했습니다: ' + response);
          $btn.prop('disabled', false).text('구독 해지');
        }
      },
      error: function () {
        alert('통신 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
        $btn.prop('disabled', false).text('구독 해지');
      }
    });
  };


  /* ════════════════════════════════════════════════════════════
     9. ACTIVITY — 활동 내역 삭제 / 계정 탈퇴
     ════════════════════════════════════════════════════════════ */

  // 활동 삭제 (댓글/리뷰)
  window.mpDeleteActivity = function (targetNo, parentId, type) {
    if (!confirm('정말 삭제하시겠습니까?')) { return; }

    var url    = (type === 'REPLY') ? CP + '/reply/delete' : CP + '/show/reviewDelete';
    var params = (type === 'REPLY')
      ? { cno: targetNo, bno: parentId }
      : { reviewId: targetNo };

    $.ajax({
      url:  url,
      type: 'POST',
      data: params,
      success: function (res) {
        var resStr = String(res).trim();
        // 성공 판정: '1'(댓글팀 숫자) | 'success'(리뷰팀 문자) | JSP 응답 포함('<')
        var ok = (resStr === '1' || resStr === 'success' || resStr.indexOf('<') !== -1);
        if (ok) {
          // 목록 초기화 후 1페이지 다시 로드
          _act.page    = 1;
          _act.end     = false;
          _act.loading = false;
          $('#mpActivityList').empty();
          _apiLoadActivity(1);
        } else {
          alert('삭제에 실패했습니다. (응답: ' + resStr.substring(0, 20) + '...)');
        }
      },
      error: function () { alert('삭제 중 오류가 발생했습니다.'); }
    });
  };

  // 계정 탈퇴
  window.mpWithdraw = function () {
    if (!confirm('정말 탈퇴하시겠습니까?\n탈퇴 후 모든 데이터가 삭제되며 복구가 불가능합니다.')) { return; }

    $.ajax({
      url:      CP + '/mypage/withdraw',
      type:     'POST',
      dataType: 'json',
      success: function (result) {
        if      (result === 1)    { alert('탈퇴가 완료되었습니다.'); location.href = CP + '/main'; }
        else if (result === -999) { alert('로그인 정보가 없습니다. 다시 로그인해주세요.'); }
        else                      { alert('탈퇴 처리 중 오류가 발생했습니다.'); }
      },
      error: function () { alert('탈퇴 처리 중 오류가 발생했습니다.'); }
    });
  };

}());
