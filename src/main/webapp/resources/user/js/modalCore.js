/* ============================================================
   modalCore.js
   ─────────────────────────────────────────────────────────────
   authModal / mypageModal 공통 오버레이 유틸

   제공 API (window 노출):
     ModalCore.open(overlayId)          → 오버레이 표시
     ModalCore.close(overlayId, ms?)    → 페이드아웃 후 hide (기본 250ms)
     ModalCore.bindOutsideClick(overlayId, modalSelector)
                                        → 오버레이 배경 클릭 시 닫기
     ModalCore.bindEscKey(overlayId)    → ESC 키로 닫기
     ModalCore.bindCloseBtn(btnEl, overlayId)
                                        → 닫기버튼 click 이벤트 등록

   사용 예:
     // authModal.js INIT 안
     ModalCore.open('auth-overlay');
     ModalCore.bindOutsideClick('auth-overlay', '.auth-main');
     ModalCore.bindEscKey('auth-overlay');
     ModalCore.bindCloseBtn(EL.closeBtn, 'auth-overlay');

     // mypageModal.js 안
     ModalCore.open('mpOverlay');
     ModalCore.bindOutsideClick('mpOverlay', '.mypage-modal');
     ModalCore.bindEscKey('mpOverlay');
   ─────────────────────────────────────────────────────────────
   ⚠ jQuery 미의존 — 순수 Vanilla JS
   ⚠ 각 모달 JS보다 먼저 로드되어야 함
============================================================ */
(function () {
  'use strict';

  /* ── 내부 헬퍼 ── */
  function getOverlay(id) {
    return document.getElementById(id);
  }

  /* ── ESC 핸들러 맵 (중복 등록 방지) ── */
  var _escHandlers = {};

  /* ── 외부클릭 핸들러 맵 ── */
  var _outsideHandlers = {};

  /* ── onClose 콜백 맵 ── */
  var _closeCallbacks = {};

  /* ── 열린 오버레이 카운터 (버그2: scroll 복구 안전화) ── */
  var _openCount = 0;

  /* ────────────────────────────────────────────
     open — 오버레이 표시 + body 스크롤 잠금
  ──────────────────────────────────────────── */
  function open(overlayId) {
    var ov = getOverlay(overlayId);
    if (!ov) return;
    /* 버그2: 이미 열려있으면 카운트 중복 방지 */
    if (ov.style.display !== 'flex') { _openCount++; }
    ov.style.opacity    = '';
    ov.style.transition = '';
    ov.style.display    = 'flex';
    document.body.style.overflow = 'hidden';
  }

  /* ────────────────────────────────────────────
     close — 페이드아웃 후 hide + body 스크롤 복구
     ms: 애니메이션 시간(기본 250ms)
  ──────────────────────────────────────────── */
  function close(overlayId, ms) {
    var ov = getOverlay(overlayId);
    if (!ov) return;
    /* 버그2: 이미 닫혀있으면 카운트 차감 안 함 */
    if (ov.style.display === 'flex') { _openCount = Math.max(0, _openCount - 1); }
    var duration = (ms !== undefined) ? ms : 250;
    ov.style.transition = 'opacity ' + duration + 'ms ease';
    ov.style.opacity    = '0';
    setTimeout(function () {
      ov.style.display    = 'none';
      ov.style.opacity    = '';
      ov.style.transition = '';
      /* 버그2: 다른 모달이 열려있으면 scroll 복구 안 함 */
      if (_openCount === 0) {
        document.body.style.overflow = '';
      }
      /* onClose 콜백 실행 */
      if (_closeCallbacks[overlayId]) {
        _closeCallbacks[overlayId]();
      }
    }, duration);
  }

  /* ────────────────────────────────────────────
     bindOutsideClick — 오버레이 배경(카드 바깥) 클릭 시 닫기
     overlayId     : 오버레이 div id
     modalSelector : 내부 카드 CSS 선택자 (e.g. '.auth-main', '.mypage-modal')
  ──────────────────────────────────────────── */
  function bindOutsideClick(overlayId, modalSelector) {
    var ov = getOverlay(overlayId);
    if (!ov) return;

    /* 이전 핸들러 제거 */
    if (_outsideHandlers[overlayId]) {
      ov.removeEventListener('click', _outsideHandlers[overlayId]);
    }

    var handler = function (e) {
      /* 오버레이 자체를 직접 클릭했을 때만 닫음 */
      if (e.target === ov) {
        close(overlayId);
      }
    };

    _outsideHandlers[overlayId] = handler;
    ov.addEventListener('click', handler);
  }

  /* ────────────────────────────────────────────
     bindEscKey — ESC 키로 닫기
     이미 열려있는 오버레이에만 반응
  ──────────────────────────────────────────── */
  function bindEscKey(overlayId) {
    /* 버그1 수정: 이미 등록된 핸들러 있으면 재등록 안 함 */
    if (_escHandlers[overlayId]) return;

    /* 버그4 수정: overlay를 클로저에 한 번만 캐싱 — 매 keydown마다 getElementById 호출 방지 */
    var ov = getOverlay(overlayId);
    if (!ov) return;

    var handler = function (e) {
      if (e.key !== 'Escape') return;
      if (ov.style.display !== 'none' && ov.style.display !== '') {
        close(overlayId);
      }
    };

    _escHandlers[overlayId] = handler;
    document.addEventListener('keydown', handler);
  }

  /* ────────────────────────────────────────────
     bindCloseBtn — 닫기버튼 이벤트 등록
  ──────────────────────────────────────────── */
  function bindCloseBtn(btnEl, overlayId) {
    if (!btnEl) return;
    btnEl.addEventListener('click', function () {
      close(overlayId);
    });
  }

  /* ────────────────────────────────────────────
     bindOnClose — 닫힌 후 실행할 콜백 등록
     overlayId : 오버레이 id
     fn        : 콜백 함수
  ──────────────────────────────────────────── */
  function bindOnClose(overlayId, fn) {
    if (typeof fn === 'function') {
      _closeCallbacks[overlayId] = fn;
    }
  }

  /* ── 전역 노출 ── */
  window.ModalCore = {
    open:             open,
    close:            close,
    bindOutsideClick: bindOutsideClick,
    bindEscKey:       bindEscKey,
    bindCloseBtn:     bindCloseBtn,
    bindOnClose:      bindOnClose,
  };

}());
