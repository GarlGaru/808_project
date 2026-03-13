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

  /* ────────────────────────────────────────────
     open — 오버레이 표시 + body 스크롤 잠금
  ──────────────────────────────────────────── */
  function open(overlayId) {
    var ov = getOverlay(overlayId);
    if (!ov) return;
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
    var duration = (ms !== undefined) ? ms : 250;
    ov.style.transition = 'opacity ' + duration + 'ms ease';
    ov.style.opacity    = '0';
    setTimeout(function () {
      ov.style.display    = 'none';
      ov.style.opacity    = '';
      ov.style.transition = '';
      document.body.style.overflow = '';
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
    /* 이전 핸들러 제거 */
    if (_escHandlers[overlayId]) {
      document.removeEventListener('keydown', _escHandlers[overlayId]);
    }

    var handler = function (e) {
      if (e.key !== 'Escape') return;
      var ov = getOverlay(overlayId);
      if (ov && ov.style.display !== 'none' && ov.style.display !== '') {
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

  /* ── 전역 노출 ── */
  window.ModalCore = {
    open:             open,
    close:            close,
    bindOutsideClick: bindOutsideClick,
    bindEscKey:       bindEscKey,
    bindCloseBtn:     bindCloseBtn,
  };

}());
