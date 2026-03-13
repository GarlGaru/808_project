<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  mypageModal.jsp — 헤더 include 전용 fragment
  열기: <button onclick="openMypage()">마이페이지</button>

  로드 의존성:
    modalCore.css → mypageModal.css → modalCore.js → mypageModal.js
--%>
<%-- modalCore.css는 authModal.jsp에서 이미 로드됨 — 중복 방지 주석 --%>
<link rel="stylesheet" href="${path}/resources/user/css/mypageModal.css">

<%--
  .mc-overlay : modalCore.css 기반 (position:fixed, backdrop, z-index:9999)
  display:none → openMypage() 시 flex
--%>
<div class="mypage-overlay mc-overlay" id="mpOverlay" style="display:none">
  <div class="mypage-modal" id="mpModal">

    <%--
      ★ 닫기 버튼 — 카드 내부 우측 상단
         .mc-close-btn : modalCore.css 기반
         mypageModal.css 에서 위치/색상 override
    --%>
    <button class="mc-close-btn" onclick="mpClose()" title="닫기">✕</button>

    <!-- ══════════════════ SIDEBAR ══════════════════ -->
    <div class="sidebar">
      <div class="sb-prof">
        <div class="av-wrap">
          <div class="av" id="mpAv" onclick="document.getElementById('mpAvFile').click()">
            <c:choose>
              <c:when test="${not empty loginUser.profile.photoUrl}">
                <img src="${loginUser.profile.photoUrl}" alt="프로필">
              </c:when>
              <c:otherwise>
                ${fn:substring(loginUser.nickname, 0, 1)}
              </c:otherwise>
            </c:choose>
          </div>
          <div class="av-edit" onclick="document.getElementById('mpAvFile').click()">✎</div>
          <input type="file" id="mpAvFile" accept="image/*" onchange="mpChangeAvatar(this)" style="display:none">
        </div>
        <div class="sb-name"><c:out value="${loginUser.nickname}"/></div>
        <div class="sb-email"><c:out value="${loginUser.email}"/></div>
        <div class="sb-badges">
          <c:choose>
            <c:when test="${loginUser.profile.membershipType eq 'ULTIMATE'}">
              <span class="grade-badge ultimate">👑 Ultimate</span>
            </c:when>
            <c:when test="${loginUser.profile.membershipType eq 'PREMIUM'}">
              <span class="grade-badge premium">⚡ Premium</span>
            </c:when>
            <c:otherwise>
              <span class="grade-badge free">🎵 Free</span>
            </c:otherwise>
          </c:choose>
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

    <!-- ══════════════════ MAIN PANE ══════════════════ -->
    <div class="main-pane">

      <div class="pane-header">
        <div class="pane-title" id="mpTitle">🎧 808 플레이 리포트</div>
        <div class="pane-sub"   id="mpSub">이번 달 나의 음악 청취 현황</div>
      </div>

      <div class="pane-body">

        <!-- ─── REPORT ─── -->
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

        <!-- ─── COMMENTS ─── -->
        <div class="tab-pane" id="tab-comments">
          <div id="mpCmtList"></div>
        </div>

        <!-- ─── RESERVATION ─── -->
        <div class="tab-pane" id="tab-reservation">
          <div class="sec-title">최근 예매 내역</div>
          <div id="mpResCards"></div>
          <div style="text-align:center;margin-top:14px">
            <a href="${pageContext.request.contextPath}/reservation/list" class="more-link">
              전체 예매 내역 보기 →
            </a>
          </div>
        </div>

        <!-- ─── PAYMENTS ─── -->
        <div class="tab-pane" id="tab-payments">
          <div class="sec-title">월별 지출 현황</div>
          <div class="chart-wrap"><canvas id="mpPayChart"></canvas></div>
          <div class="sec-title">상세 내역</div>
          <div id="mpPayList"></div>
        </div>

        <!-- ─── MEMBERSHIP ─── -->
        <div class="tab-pane" id="tab-membership">
          <div class="ms-card">
            <div class="ms-title">
              <c:choose>
                <c:when test="${loginUser.profile.membershipType eq 'ULTIMATE'}">👑 Ultimate</c:when>
                <c:when test="${loginUser.profile.membershipType eq 'PREMIUM'}">⚡ Premium</c:when>
                <c:otherwise>🎵 Free</c:otherwise>
              </c:choose>
            </div>
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

        <!-- ─── PROFILE ─── -->
        <div class="tab-pane" id="tab-profile">

          <div id="mpPvView">
            <div class="row-between" style="margin-bottom:14px">
              <div class="pv-title">기본 정보</div>
              <button class="outline-btn" onclick="mpEditStart()">✎ 수정</button>
            </div>
            <div class="pv-field">
              <span class="pv-label">닉네임</span>
              <span class="pv-val" id="vNick"><c:out value="${loginUser.nickname}"/></span>
            </div>
            <div class="pv-field">
              <span class="pv-label">이메일</span>
              <span class="pv-val muted"><c:out value="${loginUser.email}"/> 🔒</span>
            </div>
            <div class="pv-field">
              <span class="pv-label">생년월일</span>
              <span class="pv-val" id="vBirth">
                <c:choose>
                  <c:when test="${not empty loginUser.profile.birthDate}">
                    <fmt:formatDate value="${loginUser.profile.birthDate}" pattern="yyyy년 MM월 dd일"/>
                  </c:when>
                  <c:otherwise>미입력</c:otherwise>
                </c:choose>
              </span>
            </div>
            <div class="pv-field">
              <span class="pv-label">소개</span>
              <span class="pv-val muted" id="vBio">
                <c:choose>
                  <c:when test="${not empty loginUser.profile.bio}">
                    <c:out value="${loginUser.profile.bio}"/>
                  </c:when>
                  <c:otherwise>소개를 입력해주세요</c:otherwise>
                </c:choose>
              </span>
            </div>
            <div class="pv-field">
              <span class="pv-label">멤버십</span>
              <span class="pv-val">
                <c:choose>
                  <c:when test="${loginUser.profile.membershipType eq 'ULTIMATE'}">👑 Ultimate</c:when>
                  <c:when test="${loginUser.profile.membershipType eq 'PREMIUM'}">⚡ Premium</c:when>
                  <c:otherwise>🎵 Free</c:otherwise>
                </c:choose>
              </span>
            </div>
            <div class="pv-field">
              <span class="pv-label">가입일</span>
              <span class="pv-val">
                <c:choose>
                  <c:when test="${not empty loginUser.createdAt}">
                    <fmt:formatDate value="${loginUser.createdAt}" pattern="yyyy년 MM월 dd일"/>
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </span>
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
                  <button class="code-btn"
                    onclick="mpSendCode('<c:out value="${loginUser.email}"/>')">코드 발송</button>
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
                <input type="text" class="f-input" id="eNick"
                       value="<c:out value='${loginUser.nickname}'/>">
              </div>
              <div class="f-group">
                <label>생년월일</label>
                <input type="date" class="f-input" id="eBirth"
                       value="<fmt:formatDate value='${loginUser.profile.birthDate}' pattern='yyyy-MM-dd'/>">
              </div>
            </div>
            <div class="f-group">
              <label>이메일 (변경 불가)</label>
              <input type="email" class="f-input"
                     value="<c:out value='${loginUser.email}'/>" disabled>
            </div>
            <div class="f-group">
              <label>소개</label>
              <input type="text" class="f-input" id="eBio"
                     placeholder="자신을 소개해주세요..."
                     value="<c:out value='${loginUser.profile.bio}'/>">
            </div>
          </div>

        </div><%-- /tab-profile --%>

      </div><%-- /pane-body --%>
    </div><%-- /main-pane --%>

  </div><%-- /mypage-modal --%>
</div><%-- /mpOverlay --%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/user/js/mypageModal.js"></script>
