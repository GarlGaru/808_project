/**
 * mypageModal.js
 * 의존성: modalCore.js (window.ModalCore), authModal.js (window.AuthAPI)
 *
 * [리팩토링 요약]
 * - window.xxx 개별 전역 함수 → window.Mypage 단일 네임스페이스 객체로 통합
 * - 반복되는 $.ajax 패턴 → _ajax() 공통 헬퍼로 추출
 * - mpEditSave의 들여쓰기 불일치 수정 (IIFE 바깥에 누락된 문제 수정 — 로직 동일)
 * - 섹션별 주석 블록 유지 및 보강
 * - 내부(private) 함수는 _ 접두사 유지, 외부 노출 함수는 Mypage 객체 메서드로 통합
 */
(function () {
  'use strict';

  /* 컨텍스트 패스 (JSP에서 주입) */
  const CP = window.__AUTH_CP || '';


  /* ════════════════════════════════════════════════════════════
     공통 Ajax 헬퍼
     - 반복되는 $.ajax 옵션 구조를 하나로 통합
     - 호출부에서 url / type / data / success / error / complete 만 지정
     ════════════════════════════════════════════════════════════ */

  /**
   * 공통 Ajax 요청 래퍼
   * @param {Object} opts - url, type, data, dataType, success, error, complete, processData, contentType
   */
  function _ajax(opts) {
    $.ajax({
      url:         opts.url,
      type:        opts.type        || 'GET',
      data:        opts.data        || undefined,
      dataType:    opts.dataType    || 'json',
      processData: opts.processData !== undefined ? opts.processData : true,
      contentType: opts.contentType !== undefined ? opts.contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
      success:     opts.success     || $.noop,
      error:       opts.error       || $.noop,
      complete:    opts.complete    || $.noop
    });
  }


  /* ════════════════════════════════════════════════════════════
     1. MODAL — 열기 / 닫기 / 초기화
     ════════════════════════════════════════════════════════════ */

  /** 마이페이지 모달 열기 */
  function _openMypage() {
    ModalCore.open('mpOverlay');

    // 항상 808 플레이 리포트 탭으로 시작 (데이터 로드 포함)
    const firstNav = document.querySelector('.mypage-modal .nav-item');
    _mpTab(firstNav, 'report', '808 플레이 리포트', '이번 달 나의 음악 취향과 사운드 인사이트');

    // 모달 열릴 때마다 멤버십 정보 새로 조회
    _apiLoadMembership();
    _apiLoadReport('THIS_MONTH');
  }

  /** 마이페이지 모달 닫기 */
  function _mpClose() {
    ModalCore.close('mpOverlay', 250);
  }

  document.addEventListener('DOMContentLoaded', function () {
    // 외부 클릭 / ESC 키로 닫기
    ModalCore.bindOutsideClick('mpOverlay', '.mypage-modal');
    ModalCore.bindEscKey('mpOverlay');

    // 모달 닫힐 때 상태 리셋
    if (ModalCore.bindOnClose) {
      ModalCore.bindOnClose('mpOverlay', _resetOnClose);
    }

    // 비밀번호 인증코드 실시간 검사
    const pwCode = document.getElementById('pwCode');
    if (pwCode) { pwCode.addEventListener('input', _checkPwCode); }
  });

  /** 모달 닫힐 때 실행 — 다음 오픈을 위해 초기화 */
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
    const editEl = document.getElementById('mpPvEdit');
    const viewEl = document.getElementById('mpPvView');
    if (editEl) { editEl.style.display = 'none'; }
    if (viewEl) { viewEl.style.display = 'block'; }
  }


  /* ════════════════════════════════════════════════════════════
     2. TAB — 탭 전환 (항상 Ajax 호출, 상태 캐싱 없음)
     ════════════════════════════════════════════════════════════ */

  /**
   * 탭 전환 처리
   * @param {Element} el    - 클릭된 nav-item 요소
   * @param {string}  id    - 탭 ID (report / payments / reservations / activity)
   * @param {string}  title - 모달 타이틀 텍스트
   * @param {string}  sub   - 모달 서브타이틀 텍스트
   */
  function _mpTab(el, id, title, sub) {
    // 이미 활성화된 탭이면 막기
    if ($(el).hasClass('active')) { return; }

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
    if (id === 'activity') {
      // 활동 탭은 페이징 포함 — 초기화 후 1페이지 로드
      _act.page    = 1;
      _act.end     = false;
      _act.loading = false;
      $('#mpActivityList').empty();
      _apiLoadActivity(1);
    }
  }


  /* ════════════════════════════════════════════════════════════
     3. API — Ajax 요청 (데이터 받아서 render 함수로 넘김)
     ════════════════════════════════════════════════════════════ */

  /* ── 플레이 리포트 ── */

  /**
   * 플레이 리포트 전체 로드
   * @param {string} periodType - 'THIS_MONTH' 등
   */
  function _apiLoadReport(periodType) {
    _ajax({
      url:  CP + '/mypage/playReport',
      data: { periodType: periodType || 'THIS_MONTH' },
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

  /**
   * TOP 10 기간 변경 (리포트 탭 내 셀렉트박스용)
   * @param {string} periodType
   */
  function _mpLoadTopSongs(periodType) {
    _ajax({
      url:  CP + '/mypage/playReport',
      data: { periodType: periodType },
      success: function (data) {
        if (data) { _renderSongs(data.topSongs); }
      }
    });
  }

  /* ── 결제 내역 ── */

  /** 결제 내역 페이징 상태 */
  const _pay = { page: 1, loading: false, end: false };

  /** 결제 내역 탭 진입 시 초기 로드 (차트 포함) */
  function _apiLoadPayments() {
    // 탭 진입 시 페이징 초기화
    _pay.page    = 1;
    _pay.end     = false;
    _pay.loading = false;
    $('#mpPayList').empty();

    // 차트는 탭 진입 시마다 새로 생성
    _createChart();

    _apiLoadPaymentPage(1);

    // 월별 통계 로드 → 차트 업데이트
    _ajax({
      url: CP + '/mypage/monthlyStats',
      success: function (data) {
        if (data && data.length) { _updateChart(data); }
      }
    });
  }

  /**
   * 결제 내역 페이지 단위 로드
   * @param {number} page
   */
  function _apiLoadPaymentPage(page) {
    if (_pay.loading || _pay.end) { return; }
    _pay.loading = true;

    _ajax({
      url:  CP + '/mypage/payments',
      data: { page: page },
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

  /** 결제 내역 더보기 */
  function _mpMorePayments() {
    _apiLoadPaymentPage(_pay.page + 1);
  }

  /* ── 예매 내역 ── */

  /** 예매 내역 로드 */
  function _apiLoadReservations() {
    _ajax({
      url:     CP + '/mypage/reservations',
      success: function (list) { _renderReservations(list); },
      error:   function () {
        $('#mpResCards').html('<div class="empty-box">예매 내역을 불러오지 못했습니다.</div>');
      }
    });
  }

  /* ── 활동 내역 ── */

  /** 활동 내역 페이징 상태 */
  const _act = { page: 1, loading: false, end: false };

  /**
   * 활동 내역 페이지 단위 로드
   * @param {number} page
   */
  function _apiLoadActivity(page) {
    if (_act.loading || _act.end) { return; }
    _act.loading = true;

    _ajax({
      url:  CP + '/mypage/activity',
      data: { page: page },
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

  /** 활동 내역 더보기 */
  function _mpMoreActivity() {
    _apiLoadActivity(_act.page + 1);
  }

  /* ── 멤버십 정보 ── */

  /** 멤버십 정보 조회 및 버튼 상태 업데이트 */
  function _apiLoadMembership() {
  console.log(CP + '/mypage/membershipInfo');
    _ajax({
      url: CP + '/mypage/membershipInfo',
      success: function (data) {
        if (data && data.orderId) {
          // PRO 회원: 해지 버튼에 orderId 주입
          $('.upgrade-btn--pro').attr('onclick', "Mypage.cancelMembership('" + data.orderId + "')");
          if (data.expireDate)             { $('#expireDate').text(data.expireDate); }
          if (data.daysLeft !== undefined) { $('#daysLeft').text(data.daysLeft); }
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

  /**
   * 순위 CSS 클래스 반환 (1→gold, 2→silver, 3→bronze)
   * @param {number} rank
   * @returns {string}
   */
  function _rankClass(rank) {
    return rank === 1 ? 'gold' : rank === 2 ? 'silver' : rank === 3 ? 'bronze' : '';
  }

  /**
   * 날짜 문자열을 'yyyy.mm.dd' 형식으로 변환
   * @param {string} dateStr
   * @returns {string}
   */
  function _formatDate(dateStr) {
    if (!dateStr) { return ''; }
    const d = new Date(dateStr);
    return d.getFullYear() + '.'
      + ('0' + (d.getMonth() + 1)).slice(-2) + '.'
      + ('0' + d.getDate()).slice(-2);
  }

  /**
   * 숫자 이외 문자 제거 후 정수 반환 (금액 파싱용)
   * @param {string} str
   * @returns {number}
   */
  function _parsePrice(str) {
    if (!str) { return 0; }
    return Number(str.replace(/[^\d]/g, '')) || 0;
  }

  /* ── 플레이 리포트 요약 ── */

  /**
   * 플레이 리포트 상단 통계 카드 렌더링
   * @param {Object} data - 서버 응답 DTO
   */
  function _renderPlaySummary(data) {
    const totalSec = data.totalPlayTimeSec || 0;
    const totalH   = Math.floor(totalSec / 3600);
    const totalM   = Math.floor((totalSec % 3600) / 60);
    const prevH    = Math.floor((data.prevMonthPlayTimeSec || 0) / 3600);
    const diffPct  = prevH > 0 ? Math.round((totalH - prevH) / prevH * 100) : null;
    let diffText   = diffPct !== null
      ? '전월 대비 ' + (diffPct >= 0 ? '+' : '') + diffPct + '%'
      : '전월 데이터 없음';

    let timeText;
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
let _genreChart = null;

function _renderGenres(list) {
  const $container = $('#mpTopGenres');

  if (!list || !list.length) {
    $container.html('<div class="empty-box">아직 장르 데이터가 없어요</div>');
    return;
  }

  const labels = list.map(g => g.genreName);
  const data   = list.map(g => g.percentage);
  const colors = [
	  'rgba(232, 120,  50, 0.55)', // 메인 오렌지
	  'rgba(255, 180,  80, 0.55)', // 앰버
	  'rgba(99,  179, 255, 0.55)', // 아이스 블루 (대비)
	  'rgba(183, 110, 255, 0.55)', // 퍼플 (대비)
	  'rgba(0,   210, 180, 0.55)', // 민트 (대비)
	  'rgba(255, 100, 120, 0.55)', // 코랄
	  'rgba(120, 140, 255, 0.55)', // 페리윙클
	];

  if (_genreChart) {
    _genreChart.destroy();
    _genreChart = null;
  }

  const ctx = document.getElementById('genreDonutChart').getContext('2d');

  _genreChart = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: labels,
      datasets: [{
        data:            data,
        backgroundColor: colors.slice(0, data.length),
        borderWidth:     0
      }]
    },
    options: {
      cutout: '65%',
      plugins: {
        legend: {
          position: 'bottom',
          labels: {
            color:     'rgba(255, 255, 255, 0.35)',
            font:      { size: 10 },
            boxWidth:  8,
            boxHeight: 8,
            padding:   6
          }
        },
        tooltip: {
          callbacks: {
            label: ctx => ` ${ctx.label}  ${ctx.raw}%`
          }
        }
      }
    },
    plugins: [{
      id: 'centerText',
      afterDraw(chart) {
        const { ctx, chartArea: { top, bottom, left, right } } = chart;
        const cx = (left + right) / 2;
        const cy = (top + bottom) / 2;
        ctx.save();
        ctx.font         = '11px sans-serif';
        ctx.fillStyle    = 'rgba(255, 255, 255, 0.25)';
        ctx.textAlign    = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText('TOP 장르', cx, cy);
        ctx.restore();
      }
    }]
  });
}

  /* ── TOP 10 곡 ── */

  /**
   * TOP 10 곡 목록 렌더링 (재생 횟수 기준 프로그레스 바 포함)
   * @param {Array} list - 곡 목록
   */
  function _renderSongs(list) {
    const $container = $('#mpTopList');
    if (!list || !list.length) {
      $container.html(
        '<div class="empty-box">' +
          '<div class="empty-box__sub">아직 재생 기록이 없어요</div>' +
          '<div>음악을 들으면 여기에 TOP 10이 채워져요</div>' +
        '</div>'
      );
      return;
    }
    const tmpl = document.getElementById('tmpl-list-item');
    const max  = list[0].playCount;
    const frag = document.createDocumentFragment();

    $.each(list, function (i, s) {
      const node = tmpl.content.cloneNode(true);
      const rank = i + 1;
      node.querySelector('.rank').textContent = rank;
      node.querySelector('.rank').className   = 'rank ' + _rankClass(rank);

      const thumb = node.querySelector('.li-thumb');
      if (s.coverImageUrl) {
        const img = document.createElement('img');
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

  /**
   * TOP 아티스트 목록 렌더링
   * @param {Array} list - 아티스트 목록
   */
  function _renderArtists(list) {
    const $container = $('#mpTopArtists');
    if (!list || !list.length) {
      $container.html('<div class="empty-box">아직 아티스트 데이터가 없어요</div>');
      return;
    }
    const tmpl = document.getElementById('tmpl-list-item');
    const frag = document.createDocumentFragment();

    $.each(list, function (i, a) {
      const node = tmpl.content.cloneNode(true);
      const rank = i + 1;
      node.querySelector('.rank').textContent = rank;
      node.querySelector('.rank').className   = 'rank ' + _rankClass(rank);

      const thumb = node.querySelector('.li-thumb');
      thumb.className = 'li-thumb li-thumb--artist';
      if (a.coverImageUrl) {
        const img = document.createElement('img');
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

  /**
   * 결제 내역 목록 렌더링
   * @param {Array}   list     - 결제 내역 배열
   * @param {boolean} isAppend - true이면 기존 목록에 추가, false면 교체
   */
  function _renderPayments(list, isAppend) {
    const $container = $('#mpPayList');
    const $btn       = $('#mpPayMoreBtn');

    if (!list || !list.length) {
      if (!isAppend) {
        $container.html('<div class="empty-box">결제 내역이 없습니다.</div>');
      }
      _pay.end = true;
      $btn.hide();
      return;
    }

    const statusMap   = { APPROVED: '완료', FAIL: '결제 오류', READY: '대기', CANCEL: '결제 취소' };
    const statusClass = { APPROVED: 'APPROVED', FAIL: 'FAIL', READY: 'READY', CANCEL: 'CANCEL' };
    const typeIcon    = { CARD: '💳', VIRTUAL: '🏦', PHONE: '📱' };
    const tmpl = document.getElementById('tmpl-pay-item');
    const frag = document.createDocumentFragment();

    $.each(list, function (i, p) {
      const node = tmpl.content.cloneNode(true);
      node.querySelector('.pay-icon').textContent   = typeIcon[p.paymentType] || '💳';
      node.querySelector('.pay-name').textContent   = p.itemName;
      node.querySelector('.pay-amount').textContent = '₩' + p.totalAmount.toLocaleString();

      // READY는 생성일, 나머지는 승인일 표시
      const targetDate = (p.status === 'READY') ? p.createdAt : p.approvedAt;
      let dateStr      = '-';
      if (targetDate) {
        const d = new Date(targetDate);
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

      const badge = node.querySelector('.status-badge');
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

  /**
   * 예매 내역 카드 목록 렌더링 (같은 예약 ID끼리 좌석 합산)
   * @param {Array} dataList - 예매 내역 배열
   */
  function _renderReservations(dataList) {
    const el   = document.getElementById('mpResCards');
    const list = dataList || [];

    if (!list.length) {
      el.innerHTML = '<div class="res-empty"><div class="res-empty-icon">🎫</div><div>아직 예매 내역이 없습니다.</div></div>';
      return;
    }

    const statusMap   = { APPROVED: '예매완료', CANCEL: '취소/환불', CONFIRMED: '예매완료' };
    const statusClass = { APPROVED: 'confirmed', CONFIRMED: 'confirmed', CANCEL: 'cancelled' };
    const tmpl = document.getElementById('tmpl-res-card');
    const grid = document.createElement('div');
    grid.className = 'res-grid';

    // 같은 예약 ID끼리 묶어서 좌석 합산 표시
    const grouped = {};
    list.forEach(function (r) {
      if (!grouped[r.reservationId]) { grouped[r.reservationId] = []; }
      grouped[r.reservationId].push(r);
    });

    Object.keys(grouped).forEach(function (key) {
      const group = grouped[key];
      const rep   = group[0];
      const node  = tmpl.content.cloneNode(true);

      // 포스터 배경
      const bg = node.querySelector('.res-poster-bg');
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
      const seatParts   = group.map(function (s) {
        return (s.seatGrade ? s.seatGrade + ' ' : '') + (s.seatLabel || '-');
      });
      const seatSummary = seatParts.length > 1
        ? seatParts[0] + ' 외 ' + (seatParts.length - 1) + '매'
        : seatParts[0];
      node.querySelector('.res-seat').textContent = seatSummary;

      // 금액 합산
      const totalPrice = group.reduce(function (sum, s) { return sum + _parsePrice(s.ticketPrice); }, 0);
      node.querySelector('.res-amt').textContent = '₩' + totalPrice.toLocaleString();

      // 상태 뱃지
      const badge = node.querySelector('.status-badge');
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

  /**
   * 활동 내역(댓글/리뷰/게시글) 목록 렌더링
   * @param {Array}   list     - 활동 내역 배열
   * @param {boolean} isAppend - true이면 기존 목록에 추가
   */
  function _renderActivity(list, isAppend) {
    const $list = $('#mpActivityList');
    const $btn  = $('#mpActMoreBtn');

    if (!list || !list.length) {
      if (!isAppend) {
        $list.html('<div class="empty-box empty-box--tall">활동 내역이 없습니다.</div>');
      }
      _act.end = true;
      $btn.hide();
      return;
    }

    const TYPE_CLASS = { BOARD: 'act-badge--board', REPLY: 'act-badge--reply', REVIEW: 'act-badge--review' };
    const TYPE_LABEL = { BOARD: '게시글', REPLY: '댓글', REVIEW: '리뷰' };
    const tmpl = document.getElementById('tmpl-cmt-item');
    const frag = document.createDocumentFragment();

    $.each(list, function (i, item) {
      const type = item.type || 'BOARD';
      const node = tmpl.content.cloneNode(true);

      const badge = node.querySelector('.act-badge');
      badge.textContent = TYPE_LABEL[type] || type;
      badge.className   = 'act-badge ' + (TYPE_CLASS[type] || TYPE_CLASS.BOARD);

      node.querySelector('.cmt-target-title').textContent = item.targetTitle || '내용 확인';

      const d = new Date(item.regdate);
      node.querySelector('.cmt-date').textContent =
        d.getFullYear() + '.' +
        String(d.getMonth() + 1).padStart(2, '0') + '.' +
        String(d.getDate()).padStart(2, '0');

      node.querySelector('.cmt-text').textContent = item.content;

      // 보기 버튼 URL (타입별 분기)
      const url = (type === 'BOARD')
        ? CP + '/board/plusReadCnt?bno=' + item.targetNo
        : (type === 'REPLY')
        ? CP + '/board/plusReadCnt?bno=' + item.parentId
        : CP + '/show/showDetail?showId=' + item.parentId;

      const viewBtn = node.querySelector('.cmt-btn--view');
      viewBtn.addEventListener('click', (function (u) {
        return function () { location.href = u; };
      })(url));

      // 삭제 버튼 (댓글/리뷰만 표시)
      const delBtn = node.querySelector('.cmt-btn--del');
      if (type === 'REPLY' || type === 'REVIEW') {
        delBtn.style.display = '';
        delBtn.addEventListener('click', (function (tNo, pId, t) {
          return function () { Mypage.deleteActivity(tNo, pId, t); };
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

  /** Chart.js 인스턴스 (탭 이탈 시 파괴, 재진입 시 재생성) */
  let _chart = null;

  /** 1~12월 레이블 배열 생성 */
  function _buildMonthLabels() {
    const labels = [];
    for (let m = 1; m <= 12; m++) { labels.push(m + '월'); }
    return labels;
  }

  /**
   * 서버 응답 월별 통계를 12개 슬롯 배열로 변환
   * @param {Array} statList - [{ yearMonth: 'yyyy-MM', totalAmount: number }]
   * @returns {number[]} 길이 12 배열
   */
  function _mapToMonthValues(statList) {
    const values = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    if (statList && statList.length) {
      $.each(statList, function (i, m) {
        const month = parseInt(m.yearMonth.substring(5), 10);
        if (month >= 1 && month <= 12) { values[month - 1] = m.totalAmount; }
      });
    }
    return values;
  }

  /**
   * Canvas 컨텍스트에서 주황 그라디언트 생성
   * @param {CanvasRenderingContext2D} ctx
   * @returns {CanvasGradient|string}
   */
  function _getOrangeGradient(ctx) {
    if (!ctx) { return 'rgba(232, 93, 4, 0.5)'; }
    const w = ctx.canvas.width  || 300;
    const h = ctx.canvas.height || 150;
    const g = ctx.createLinearGradient(0, 0, w * 0.4, h);
    g.addColorStop(0,   'rgba(180, 60, 20, 0.45)');
    g.addColorStop(0.4, 'rgba(237, 103, 1, 0.55)');
    g.addColorStop(1,   'rgba(140, 45, 10, 0.45)');
    return g;
  }

  /**
   * 최대값 막대만 주황 강조, 나머지는 반투명 흰색
   * @param {number[]} values
   * @param {CanvasRenderingContext2D} ctx
   * @returns {{ bg: Array, bd: Array }}
   */
  function _calcBarColors(values, ctx) {
    const maxVal = Math.max.apply(null, values.concat([0]));
    const bg = [], bd = [];
    $.each(values, function (i, v) {
      if (v === maxVal && maxVal > 0) {
        bg.push(_getOrangeGradient(ctx));
        bd.push('rgba(232, 93, 4, 0.8)');
      } else {
        const r = maxVal > 0 ? v / maxVal : 0;
        bg.push('rgba(230, 230, 230, ' + (0.5 + r * 0.2).toFixed(2) + ')');
        bd.push('rgba(255, 255, 255, 0.05)');
      }
    });
    return { bg: bg, bd: bd };
  }

  /** 결제 탭 차트 초기 생성 (빈 데이터로 렌더링) */
  function _createChart() {
    const canvas = document.getElementById('mpPayChart');
    if (!canvas || !window.Chart) { return; }

    // 이전 차트 파괴 후 재생성
    if (_chart) { _chart.destroy(); _chart = null; }

    const ctx         = canvas.getContext('2d');
    const emptyValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    const colors      = _calcBarColors(emptyValues, ctx);

    _chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels:   _buildMonthLabels(),
        datasets: [{
          data:            emptyValues,
          backgroundColor: colors.bg,
          borderColor:     colors.bd,
          borderWidth:     0,
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

  /**
   * 차트 데이터 업데이트 및 애니메이션 재생
   * @param {Array} statList - 서버 응답 월별 통계
   */
  function _updateChart(statList) {
    if (!_chart) { return; }
    const values = _mapToMonthValues(statList);
    const colors = _calcBarColors(values, _chart.ctx);
    _chart.data.datasets[0].data            = values;
    _chart.data.datasets[0].backgroundColor = colors.bg;
    _chart.data.datasets[0].borderColor     = colors.bd;
    _chart.resize();
    _chart.update({ duration: 800, easing: 'easeOutQuart' });
  }


  /* ════════════════════════════════════════════════════════════
     6. PROFILE — 아바타 / 프로필 수정
     ════════════════════════════════════════════════════════════ */


  // 아바타 파일 선택 시 미리보기 표시 및 서버 업로드
  function _mpChangeAvatar(input) {
    if (!input.files || !input.files[0]) { return; }
    const file = input.files[0];

    // 미리보기
    const reader = new FileReader();
    reader.onload = function (e) {
      document.getElementById('mpAv').innerHTML = '<img src="' + e.target.result + '" alt="프로필">';
    };
    reader.readAsDataURL(file);

    // 서버 업로드 (multipart/form-data)
    const formData = new FormData();
    formData.append('photoFile', file);
    _ajax({
      url:         CP + '/mypage/updatePhoto',
      type:        'POST',
      data:        formData,
      processData: false,
      contentType: false,
      success: function (result) {
        if (result !== 1) { alert('사진 저장에 실패했습니다.'); }
      },
      error: function () { alert('사진 업로드 중 오류가 발생했습니다.'); }
    });
  }

  /** 프로필 수정 모드 진입 */
  function _mpEditStart() {
    _resetNickCheck();
    document.getElementById('mpPvView').style.display = 'none';
    document.getElementById('mpPvEdit').style.display = 'block';
  }

  /** 프로필 수정 취소 — 보기 모드로 복귀 */
  function _mpEditCancel() {
    _resetPwState();
    _resetNickCheck();
    document.getElementById('mpPvEdit').style.display = 'none';
    document.getElementById('mpPvView').style.display = 'block';
  }

  /* ── 닉네임 중복 확인 상태 ── */
  const _nick = { checked: false, val: '' };

  /** 닉네임 중복 확인 요청 */
  function _mpCheckNick() {
    const nick     = $('#eNick').val().trim();
    const origNick = $('#vNick').text().trim();
    const $msg     = $('#nickCheckMsg');
    const $btn     = $('#nickCheckBtn');

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
  }

  /** 닉네임 중복 확인 상태 초기화 */
  function _resetNickCheck() {
    _nick.checked = false;
    _nick.val     = '';
    $('#eNick').removeClass('valid invalid');
    $('#nickCheckMsg').hide().text('');
  }

  /**
   * 내 정보(닉네임/소개/생년월일) 저장
   * - 변경 여부 → confirm → 유효성 검사 → Ajax 순으로 처리
   */
  function _mpEditSave() {
    const nick     = $('#eNick').val().trim();
    const bio      = $('#eBio').val().trim();
    const birth    = $('#eBirth').val();

    const origNick      = $('#vNick').text().trim();
    const origBio       = $('#vBio').text().trim();
    const origBirthText = $('#vBirth').text().trim();

    // birth 원본값 파싱 (yyyy년 m월 d일 → yyyy-mm-dd)
    let origBirth = '';
    if (origBirthText) {
      const match = origBirthText.match(/(\d+)년 (\d+)월 (\d+)일/);
      if (match) {
        origBirth = match[1] + '-' +
          match[2].padStart(2, '0') + '-' +
          match[3].padStart(2, '0');
      }
    }

    // 변경 여부 체크
    const isChanged =
      nick !== origNick ||
      bio  !== origBio  ||
      birth !== origBirth;

    if (!isChanged) { alert('변경된 내용이 없습니다.'); return; }
    if (!confirm('수정하시겠습니까?')) { return; }
    if (!nick) { alert('닉네임을 입력해주세요.'); return; }

    if (nick !== origNick && (!_nick.checked || _nick.val !== nick)) {
      alert('닉네임 중복확인을 해주세요.');
      $('#eNick').focus();
      return;
    }

    _ajax({
      url:  CP + '/mypage/updateInfo',
      type: 'POST',
      data: { nickname: nick, bio: bio, birthDate: birth },
      success: function (result) {
        if (result === 1) {
          $('#vNick').text(nick);
          $('#vBio').text(bio || '소개를 입력해주세요');

          if (birth) {
            const d = new Date(birth);
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

          Mypage.editCancel();
        } else if (result === -1) {
          alert('닉네임을 입력해주세요.');
        } else {
          alert('저장에 실패했습니다.');
        }
      },
      error: function () { alert('저장 중 오류가 발생했습니다.'); }
    });
  }


  /* ════════════════════════════════════════════════════════════
     7. PASSWORD — 비밀번호 변경
     ════════════════════════════════════════════════════════════ */

  /** 비밀번호 변경 폼 상태 */
  const _pw = { codeVerified: false, serverCode: '', timerId: null };

  /** 비밀번호 변경 폼 전체 초기화 */
  function _resetPwState() {
    _stopPwTimer();
    _pw.codeVerified = false;
    _pw.serverCode   = '';
    const f   = document.getElementById('pwCodeField');
    const c   = document.getElementById('pwCode');
    const cur = document.getElementById('pwCurrent');
    const pn  = document.getElementById('pwNew');
    const pc  = document.getElementById('pwConfirm');
    if (f)   { f.style.display = 'none'; }
    if (c)   { c.value = ''; c.classList.remove('valid', 'invalid'); }
    if (cur) { cur.value = ''; }
    if (pn)  { pn.value = ''; }
    if (pc)  { pc.value = ''; }
  }

  /** 인증코드 타이머 시작 */
  function _startPwTimer() {
    const timerEl = document.getElementById('pwTimer');
    if (!timerEl) { return; }
    _pw.timerId = ModalCore.timer.start(timerEl, 300);
  }

  /** 인증코드 타이머 정지 */
  function _stopPwTimer() {
    const timerEl = document.getElementById('pwTimer');
    ModalCore.timer.stop(timerEl, _pw.timerId);
    _pw.timerId = null;
  }

  /**
   * 이메일 인증코드 발송
   * @param {string} email - 발송 대상 이메일
   */
  function _mpSendCode(email) {
    if (!email) { return; }
    const $btn      = $('#pwSendBtn');
    const codeField = document.getElementById('pwCodeField');
    const codeInput = document.getElementById('pwCode');

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
  }

  /** 인증코드 입력 실시간 검사 (6자리 + 서버코드 일치 여부) */
  function _checkPwCode() {
    const inp = document.getElementById('pwCode');
    if (!inp) { return; }
    const val = inp.value.trim();
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

  /**
   * 비밀번호 변경 제출
   * - 현재 비밀번호 / 인증 완료 / 새 비밀번호 / 확인 순으로 유효성 검사 후 Ajax 호출
   */
  function _mpChangePw() {
    const current   = document.getElementById('pwCurrent');
    const pwNew     = document.getElementById('pwNew');
    const pwConfirm = document.getElementById('pwConfirm');
    const code      = document.getElementById('pwCode');

    if (!current || !current.value.trim())                  { alert('현재 비밀번호를 입력해주세요.'); return; }
    if (!_pw.codeVerified)                                  { alert('이메일 인증을 완료해주세요.'); return; }
    if (!pwNew || !pwNew.value)                             { alert('새 비밀번호를 입력해주세요.'); return; }
    if (pwNew.value.length < 8 || pwNew.value.length > 20) { alert('비밀번호는 8~20자로 입력해주세요.'); return; }
    if (pwNew.value !== pwConfirm.value)                    { alert('비밀번호가 일치하지 않습니다.'); return; }

    _ajax({
      url:  CP + '/mypage/updatePw',
      type: 'POST',
      data: { currentPw: current.value, code: code.value, newPw: pwNew.value },
      success: function (result) {
        if      (result === 1)  { _resetPwState(); alert('비밀번호가 변경되었습니다.'); }
        else if (result === -1) { alert('현재 비밀번호가 일치하지 않습니다.'); }
        else if (result === -2) { alert('인증코드가 만료되었거나 올바르지 않습니다.'); }
        else                    { alert('비밀번호 변경에 실패했습니다.'); }
      },
      error: function () { alert('비밀번호 변경 중 오류가 발생했습니다.'); }
    });
  }


  /* ════════════════════════════════════════════════════════════
     8. MEMBERSHIP — 멤버십 구독 / 해지
     ════════════════════════════════════════════════════════════ */

  /**
   * 멤버십 버튼 클릭 핸들러 (PRO 안내 or 구독 모달 열기)
   * @param {string} currentMembership - 'PRO' | 'FREE'
   */
  function _handleProMembership(currentMembership) {
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
  }

  /**
   * 결제 실패 재시도
   * @param {string} orderId
   */
  function _retryMembershipPayment(orderId) {
    if (!orderId) { return; }
    if (confirm('결제에 실패한 이력이 있습니다. 다시 결제를 진행하시겠습니까?')) {
      location.href = CP + '/kakaopay/retry?orderId=' + orderId;
    }
  }

  /**
   * 멤버십 해지 요청
   * @param {string} orderId - 해지할 주문 ID
   */
  function _mpCancelMembership(orderId) {
    if (!orderId || orderId === 'null' || orderId === '') {
      alert('결제 정보를 찾을 수 없어 해지가 불가능합니다.\n고객센터로 문의해주세요.');
      return;
    }
    if (!confirm('정말 멤버십 구독을 해지하시겠습니까?\n해지 시 즉시 모든 PRO 혜택이 중단되고 FREE 등급으로 전환됩니다.')) {
      return;
    }

    const $btn = $('.upgrade-btn--pro');
    $btn.prop('disabled', true).text('해지 처리 중...');

    _ajax({
      url:      CP + '/kakaopay/request_cancel',
      type: 'GET',
      dataType: 'text', // 서버가 숫자(int)만 던지므로 text로 받아야 함
      data:     { orderId: orderId },
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
  }


  /* ════════════════════════════════════════════════════════════
     9. ACTIVITY — 활동 내역 삭제 / 계정 탈퇴
     ════════════════════════════════════════════════════════════ */

  /**
   * 활동 내역 단건 삭제 (댓글/리뷰)
   * - 타입에 따라 URL 및 파라미터 분기
   * @param {number} targetNo - 삭제 대상 번호 (cno or reviewId)
   * @param {number} parentId - 부모 글 번호 (bno 등)
   * @param {string} type     - 'REPLY' | 'REVIEW'
   */
  function _mpDeleteActivity(targetNo, parentId, type) {
    if (!confirm('정말 삭제하시겠습니까?')) { return; }

    const url    = (type === 'REPLY') ? CP + '/reply/delete' : CP + '/show/reviewDelete';
    const params = (type === 'REPLY')
      ? { cno: targetNo, bno: parentId }
      : { reviewId: targetNo };

    _ajax({
      url:  url,
      type: 'POST',
      data: params,
      dataType: 'text', // 서버가 숫자(int)만 던지므로 text로 받아야 함
      success: function (res) {
        const resStr = String(res).trim();
        // 성공 판정: '1'(댓글팀 숫자) | 'success'(리뷰팀 문자) | JSP 응답 포함('<')
        const ok = (resStr === '1' || resStr === 'success' || resStr.indexOf('<') !== -1);
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
  }

  /** 계정 탈퇴 요청 */
  function _mpWithdraw() {
    if (!confirm('정말 탈퇴하시겠습니까?\n탈퇴 후 모든 데이터가 삭제되며 복구가 불가능합니다.')) { return; }

    _ajax({
      url:  CP + '/mypage/withdraw',
      type: 'POST',
      success: function (result) {
        if      (result === 1)    { alert('탈퇴가 완료되었습니다.\n그동안 808 Music을 이용해주셔서 감사합니다:)'); location.href = CP + '/main'; }
        else if (result === -999) { alert('로그인 정보가 없습니다. 다시 로그인해주세요.'); }
        else                      { alert('탈퇴 처리 중 오류가 발생했습니다.'); }
      },
      error: function () { alert('탈퇴 처리 중 오류가 발생했습니다.'); }
    });
  }


  /* ════════════════════════════════════════════════════════════
     PUBLIC API — 단일 네임스페이스로 외부 노출
     JSP/HTML에서 Mypage.xxx() 형태로 호출
     ════════════════════════════════════════════════════════════ */

  const Mypage = {
    /* 1. MODAL */
    open:    _openMypage,
    close:   _mpClose,

    /* 2. TAB */
    tab:     _mpTab,

    /* 3. API (외부 트리거용) */
    loadTopSongs:  _mpLoadTopSongs,   // 리포트 탭 기간 셀렉트박스
    morePayments:  _mpMorePayments,   // 결제 더보기 버튼
    moreActivity:  _mpMoreActivity,   // 활동 더보기 버튼

    /* 6. PROFILE */
    changeAvatar:  _mpChangeAvatar,
    editStart:     _mpEditStart,
    editCancel:    _mpEditCancel,
    checkNick:     _mpCheckNick,
    resetNickCheck: _resetNickCheck,
    editSave:      _mpEditSave,

    /* 7. PASSWORD */
    resetPwState:  _resetPwState,
    sendCode:      _mpSendCode,
    changePw:      _mpChangePw,

    /* 8. MEMBERSHIP */
    handleProMembership:      _handleProMembership,
    retryMembershipPayment:   _retryMembershipPayment,
    cancelMembership:         _mpCancelMembership,

    /* 9. ACTIVITY */
    deleteActivity: _mpDeleteActivity,
    withdraw:       _mpWithdraw
  };

  /* 전역 노출 — JSP 인라인 onclick 등에서 Mypage.xxx() 로 접근 */
  window.Mypage = Mypage;

  /*
   * [하위 호환 별칭]
   * 다른 팀 JSP/JS가 기존 window.openMypage, window.mpTab 등을 직접 호출하는 경우를 대비해
   * 기존 함수명도 동일하게 유지합니다. 추후 JSP가 Mypage.xxx()로 전환되면 제거 가능.
   */
  window.openMypage                = Mypage.open;
  window.mpClose                   = Mypage.close;
  window.mpTab                     = Mypage.tab;
  window.mpLoadTopSongs            = Mypage.loadTopSongs;
  window.mpMorePayments            = Mypage.morePayments;
  window.mpMoreActivity            = Mypage.moreActivity;
  window.mpChangeAvatar            = Mypage.changeAvatar;
  window.mpEditStart               = Mypage.editStart;
  window.mpEditCancel              = Mypage.editCancel;
  window.mpCheckNick               = Mypage.checkNick;
  window.mpResetNickCheck          = Mypage.resetNickCheck;
  window.mpEditSave                = Mypage.editSave;
  window.mpResetPwState            = Mypage.resetPwState;
  window.mpSendCode                = Mypage.sendCode;
  window.mpChangePw                = Mypage.changePw;
  window.handleProMembership       = Mypage.handleProMembership;
  window.retryMembershipPayment    = Mypage.retryMembershipPayment;
  window.mpCancelMembership        = Mypage.cancelMembership;
  window.mpDeleteActivity          = Mypage.deleteActivity;
  window.mpWithdraw                = Mypage.withdraw;

}());
