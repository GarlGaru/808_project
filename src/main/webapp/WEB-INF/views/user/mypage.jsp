<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>마이페이지 · 808</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/user/css/mypage.css">
  <style>
    body { margin:0; background:#0a0c10; }
    #mpOverlay {
      display:flex !important;
      position:fixed; inset:0;
      align-items:center; justify-content:center;
      background:rgba(0,0,0,0.7);
      z-index:9999;
    }
  </style>
</head>
<body>

<%-- 헤더 --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="mypage-overlay" id="mpOverlay">
  <div class="mypage-modal" id="mpModal">

    <!-- SIDEBAR -->
    <div class="sidebar">
      <div class="sb-prof">
        <div class="av-wrap">
          <div class="av" id="mpAv" onclick="document.getElementById('mpAvFile').click()">
            U
          </div>
          <div class="av-edit" onclick="document.getElementById('mpAvFile').click()">✎</div>
          <input type="file" id="mpAvFile" accept="image/*" onchange="mpChangeAvatar(this)">
        </div>
        <div class="sb-name">User</div>
        <div class="sb-email">user@808.com</div>
        <div class="sb-badges">
          <span class="grade-badge free">🎵 Free</span>
          <span class="level-badge">🎵 Lv.24 Audiophile</span>
        </div>
      </div>

      <nav class="sb-nav">
        <div class="nav-item active"
             onclick="mpTab(this,'report','🎧 808 플레이 리포트','이번 달 나의 음악 청취 현황')">
          <span class="nav-icon">🎧</span>808 플레이 리포트
        </div>
        <div class="nav-item"
             onclick="mpTab(this,'comments','💬 내 댓글','내가 작성한 댓글 목록')">
          <span class="nav-icon">💬</span>댓글
        </div>
        <div class="nav-item"
             onclick="mpTab(this,'reservation','🎫 예매 내역','공연 예매 내역')">
          <span class="nav-icon">🎫</span>예매 내역
        </div>
        <div class="nav-item"
             onclick="mpTab(this,'payments','💳 결제 내역','결제 기록')">
          <span class="nav-icon">💳</span>결제 내역
        </div>
        <div class="nav-item"
             onclick="mpTab(this,'membership','👑 멤버십 정보','현재 등급 및 혜택')">
          <span class="nav-icon">👑</span>멤버십
        </div>
        <div class="nav-item"
             onclick="mpTab(this,'profile','👤 내정보 수정','프로필 및 비밀번호 변경')">
          <span class="nav-icon">👤</span>내정보 수정
        </div>
      </nav>
    </div>

    <!-- MAIN PANE -->
    <div class="main-pane">
      <a href="javascript:mpClose()" class="close-btn" title="닫기">✕</a>

      <div class="pane-header">
        <div class="pane-title" id="mpTitle">🎧 808 플레이 리포트</div>
        <div class="pane-sub"   id="mpSub">이번 달 나의 음악 청취 현황</div>
      </div>

      <div class="pane-body">

        <!-- REPORT -->
        <div class="tab-pane active" id="tab-report">
          <div class="stat-grid">
            <div class="stat-card">
              <div class="stat-label">총 청취 시간</div>
              <div class="stat-num">142h</div>
              <div class="stat-sub">전월 대비 +12%</div>
            </div>
            <div class="stat-card">
              <div class="stat-label">재생한 곡</div>
              <div class="stat-num">847</div>
              <div class="stat-sub">280개 고유 트랙</div>
            </div>
            <div class="stat-card">
              <div class="stat-label">활발한 요일</div>
              <div class="stat-num" style="font-size:17px">금요일</div>
              <div class="stat-sub">평균 3.2h</div>
            </div>
          </div>
          <div class="two-col">
            <div>
              <div class="row-between" style="margin-bottom:9px">
                <div class="sec-title">TOP 10</div>
                <select class="mp-select" onchange="mpShuffleSongs()">
                  <option>이번 달</option>
                  <option>지난 달</option>
                  <option>최근 3개월</option>
                </select>
              </div>
              <div id="mpTopList"></div>
            </div>
            <div>
              <div class="sec-title">TOP 장르</div>
              <div class="genre-grid">
                <div class="genre-tag"><div class="genre-name">Pop</div><div class="genre-pct">34%</div></div>
                <div class="genre-tag"><div class="genre-name">R&amp;B</div><div class="genre-pct">22%</div></div>
                <div class="genre-tag"><div class="genre-name">Hip-Hop</div><div class="genre-pct">18%</div></div>
                <div class="genre-tag"><div class="genre-name">Dance</div><div class="genre-pct">14%</div></div>
              </div>
              <div class="sec-title" style="margin-top:12px">TOP 아티스트</div>
              <div id="mpTopArtists"></div>
            </div>
          </div>
        </div>

        <!-- COMMENTS -->
        <div class="tab-pane" id="tab-comments">
          <div id="mpCmtList"></div>
        </div>

        <!-- RESERVATION -->
        <div class="tab-pane" id="tab-reservation">
          <div class="sec-title">최근 예매 내역</div>
          <div id="mpResCards"></div>
        </div>

        <!-- PAYMENTS -->
        <div class="tab-pane" id="tab-payments">
          <div class="sec-title">월별 지출 현황</div>
          <div class="chart-wrap"><canvas id="mpPayChart"></canvas></div>
          <div class="sec-title">상세 내역</div>
          <div id="mpPayList"></div>
        </div>

        <!-- MEMBERSHIP -->
        <div class="tab-pane" id="tab-membership">
          <div class="ms-card">
            <div class="ms-title">🎵 Free</div>
            <div class="ms-expire">만료: 2026년 4월 30일 · D-70</div>
            <div class="ms-benefits">
              <div class="ms-item">광고 없는 청취</div>
              <div class="ms-item">오프라인 다운로드</div>
              <div class="ms-item">고음질 스트리밍</div>
              <div class="ms-item">공연 우선 예매</div>
              <div class="ms-item">독점 콘텐츠</div>
              <div class="ms-item">가사 실시간 지원</div>
            </div>
          </div>
          <button class="upgrade-btn">👑 UPGRADE TO ULTIMATE →</button>
          <div class="stat-card" style="margin-top:10px">
            <div class="sec-title">Ultimate 추가 혜택</div>
            <div class="ms-benefits">
              <div class="ms-item">Premium 전체 포함</div>
              <div class="ms-item">공연 VIP 입장</div>
              <div class="ms-item">팬미팅 우선권</div>
              <div class="ms-item">굿즈 20% 할인</div>
            </div>
          </div>
        </div>

        <!-- PROFILE -->
        <div class="tab-pane" id="tab-profile">
          <div id="mpPvView">
            <div class="row-between" style="margin-bottom:14px">
              <div class="pv-title">기본 정보</div>
              <button class="outline-btn" onclick="mpEditStart()">✎ 수정</button>
            </div>
            <div class="pv-field">
              <span class="pv-label">닉네임</span>
              <span class="pv-val" id="vNick">User</span>
            </div>
            <div class="pv-field">
              <span class="pv-label">이메일</span>
              <span class="pv-val muted">user@808.com 🔒</span>
            </div>
            <div class="pv-field">
              <span class="pv-label">생년월일</span>
              <span class="pv-val" id="vBirth">미입력</span>
            </div>
            <div class="pv-field">
              <span class="pv-label">소개</span>
              <span class="pv-val muted" id="vBio">소개를 입력해주세요</span>
            </div>
            <div class="pv-field">
              <span class="pv-label">멤버십</span>
              <span class="pv-val">🎵 Free</span>
            </div>
            <div class="pv-field">
              <span class="pv-label">가입일</span>
              <span class="pv-val">2026년 01월 01일</span>
            </div>
            <div class="pw-box">
              <div class="pw-title">🔐 비밀번호 변경</div>
              <div class="f-group">
                <label>현재 비밀번호</label>
                <input type="password" class="f-input" id="pwCurrent" placeholder="현재 비밀번호">
              </div>
              <div class="f-group">
                <label>이메일 인증</label>
                <div class="code-row">
                  <input type="text" class="f-input" id="pwCode" placeholder="인증코드">
                  <button class="code-btn" onclick="mpSendCode('user@808.com')">코드 발송</button>
                </div>
              </div>
              <div class="f-row">
                <div class="f-group">
                  <label>새 비밀번호</label>
                  <input type="password" class="f-input" id="pwNew" placeholder="8자 이상">
                </div>
                <div class="f-group">
                  <label>비밀번호 확인</label>
                  <input type="password" class="f-input" id="pwConfirm" placeholder="다시 입력">
                </div>
              </div>
              <div class="danger-zone">
                <div class="danger-label">위험 구역</div>
                <button class="danger-btn" onclick="mpWithdraw()">계정 탈퇴</button>
              </div>
            </div>
          </div>

          <!-- 수정 모드 -->
          <div id="mpPvEdit" style="display:none">
            <div class="row-between" style="margin-bottom:14px">
              <div class="pv-title">기본 정보 수정</div>
              <div style="display:flex;gap:7px">
                <button class="outline-btn" onclick="mpEditCancel()">취소</button>
                <button class="primary-btn" onclick="mpEditSave()">저장</button>
              </div>
            </div>
            <div class="f-row">
              <div class="f-group">
                <label>닉네임</label>
                <input type="text" class="f-input" id="eNick" value="User">
              </div>
              <div class="f-group">
                <label>생년월일</label>
                <input type="date" class="f-input" id="eBirth">
              </div>
            </div>
            <div class="f-group">
              <label>이메일 (변경 불가)</label>
              <input type="email" class="f-input" value="user@808.com" disabled>
            </div>
            <div class="f-group">
              <label>소개</label>
              <input type="text" class="f-input" id="eBio" placeholder="자신을 소개해주세요...">
            </div>
          </div>
        </div>

      </div><!-- /pane-body -->
    </div><!-- /main-pane -->

  </div><!-- /mypage-modal -->
</div><!-- /mypage-overlay -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/user/js/mypage.js"></script>
<script>
  window.mpClose = function() { history.back(); };
</script>

<script>
  window.mpClose = function () {
    location.href = '${pageContext.request.contextPath}/main';
  };
</script>

</body>
</html>