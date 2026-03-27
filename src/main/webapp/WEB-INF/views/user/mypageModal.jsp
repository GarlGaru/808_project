<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="now" value="<%=System.currentTimeMillis()%>" />
<%--
  mypageModal.jsp — 헤더 include 전용 fragment
  열기: <button onclick="openMypage()">마이페이지</button>

  로드 의존성:
    modalCore.css → mypageModal.css → modalCore.js → mypageModal.js
--%>
<script>if (!window.__AUTH_CP) window.__AUTH_CP = "${pageContext.request.contextPath}";</script>
<%-- modalCore.css는 authModal.jsp에서 이미 로드됨 — 중복 방지 주석 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/user/css/mypageModal.css">

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
                <img src="${pageContext.request.contextPath}${loginUser.profile.photoUrl}?v=${now}" alt="프로필">
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
            <c:when test="${loginUser.profile.membershipType eq 'PRO'}">
              <span class="grade-badge pro">PRO</span>
            </c:when>
            <c:otherwise>
              <span class="grade-badge free">${loginUser.profile.membershipType}</span>
            </c:otherwise>
          </c:choose>
          <!-- 나중에 여유 생기면 때 Lv. 기능추가 -->
          <!-- <span class="level-badge" id="mpLevelBadge">Lv.24</span> -->
        </div>
      </div>
      
      

      <nav class="sb-nav">
        <div class="nav-item active"
             onclick="mpTab(this,'report','808 플레이 리포트','이번 달 나의 음악 청취 현황')">
          <span class="nav-icon"><i class="fa-sharp fa-solid fa-headphones"></i></span>808 플레이 리포트
        </div>
		<div class="nav-item"
		     onclick="mpTab(this,'activity','통합 활동 내역','내가 작성한 글, 댓글, 리뷰 목록')">
		  <span class="nav-icon"><i class="fa-solid fa-list-ul"></i></span>활동 내역
		</div>
        <div class="nav-item"
             onclick="mpTab(this,'reservation','예매 내역','공연 예매 내역')">
          <span class="nav-icon"><i class="fa-sharp fa-solid fa-calendar-check"></i></span>예매 내역
        </div>
        <div class="nav-item"
             onclick="mpTab(this,'payments','결제 내역','결제 기록')">
          <span class="nav-icon"><i class="fa-sharp fa-solid fa-credit-card"></i></span>결제 내역
        </div>
        <div class="nav-item"
             onclick="mpTab(this,'membership','멤버십 정보','현재 등급 및 혜택')">
          <span class="nav-icon"><i class="fa-solid fa-chess-queen"></i></span>멤버십
        </div>
        <div class="nav-item"
             onclick="mpTab(this,'profile','내정보 수정','프로필 및 비밀번호 변경')">
          <span class="nav-icon"><i class="fa-solid fa-id-badge"></i></span>내정보 수정
        </div>
      </nav>
    </div>

    <!-- ══════════════════ MAIN PANE ══════════════════ -->
    <div class="main-pane">

      <div class="pane-header">
        <div class="pane-title" id="mpTitle"><i class="fa-solid fa-headphones"></i> 808 플레이 리포트</div>
        
        <div class="pane-sub"   id="mpSub">이번 달 나의 음악 청취 현황</div>
      </div>

      <div class="pane-body">

        <!-- ─── 808 REPORT ─── -->
        <div class="tab-pane active" id="tab-report">
          <div class="stat-grid">
            <div class="stat-card">
              <div class="stat-label">총 청취 시간<span class="mp-tip" data-tip="실제로 감상한 곡들의 누적 시간이에요">?</span></div>
              <div class="stat-num" id="mpStatTime">-</div>
              <div class="stat-sub" id="mpStatTimeSub">-</div>
            </div>
            <div class="stat-card">
              <div class="stat-label">재생한 곡<!-- <span class="mp-tip" data-tip="재생 버튼을 누른 총 횟수예요. 같은 곡을 여러 번 들으면 중복 집계돼요."></span> --></div>
              <div class="stat-num" id="mpStatPlay">-</div>
              <div class="stat-sub" id="mpStatPlaySub">-</div>
            </div>
            <div class="stat-card">
              <div class="stat-label">활발한 요일<span class="mp-tip" data-tip="청취한 기록이 가장 많은 요일이에요.">?</span></div>
              <div class="stat-num stat-num--day" id="mpStatDay">-</div>
              <div class="stat-sub">최다 청취 요일</div>
            </div>
          </div>
          <div class="two-col">
            <%-- TOP 10 — stat-card 박스로 감싸서 빈 상태 정렬 --%>
            <div class="stat-card stat-card--inner">
              <div class="row-between row-between--mb">
                <div class="sec-title sec-title--inline">TOP 10<span class="mp-tip" data-tip="선택 기간 동안 가장 많이 감상한 순위예요.">?</span></div>
                <div class="select-wrap">
                  <select class="mp-select" id="mpSongPeriod" onchange="mpLoadTopSongs(this.value)">
                    <option value="THIS_MONTH">이번 달</option>
                    <option value="LAST_MONTH">지난 달</option>
                    <option value="3MONTH">최근 3개월</option>
                  </select>
                </div>
              </div>
              <div id="mpTopList"></div>
            </div>
            <%-- 장르 + 아티스트 --%>
            <div class="two-col__right">
              <div class="stat-card stat-card--inner stat-card--flex">
                <div class="sec-title sec-title--sm">TOP 장르<span class="mp-tip" data-tip="자주 감상한 곡들의 장르를 분석해 취향을 반영했어요.">?</span></div>
                <div class="genre-grid" id="mpTopGenres"></div>
              </div>
              <div class="stat-card stat-card--inner stat-card--flex">
                <div class="sec-title sec-title--sm">TOP 아티스트<span class="mp-tip" data-tip="다양한 곡을 가장 오래 감상한 결과로 찾아낸 아티스트예요.">?</span></div>
                <div id="mpTopArtists"></div>
              </div>
            </div>
          </div>
        </div>

        <!-- ─── ACTIVITY ─── -->
        <div class="tab-pane" id="tab-activity">
		  <div id="mpActivityList"></div>
		  <div class="more-link-wrap">
		    <button id="mpActMoreBtn" class="outline-btn outline-btn--full" onclick="mpMoreActivity()" style="display:none">더보기</button>
		  </div>
		</div>

        <!-- ─── RESERVATION ─── -->
        <div class="tab-pane" id="tab-reservation">
          <div class="sec-title">최근 예매 내역</div>
          <div id="mpResCards"></div>
          <div class="more-link-wrap">
            <a href="${pageContext.request.contextPath}/show/mypage/myTicket" class="more-link">
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

  <c:choose>
    <%-- 1. PRO 구독 중 (서버 로딩 시점 기준) --%>
    <c:when test="${loginUser.profile.membershipType eq 'PRO'}">
      <div class="ms-card ms-card--pro">
        <div class="ms-title">PRO</div>
        <%-- [기존 ID 유지] 만약 서버에서 데이터가 없어도 JS가 채울 수 있게 빈 tag로 둡니다 --%>
        <div class="ms-expire" id="membershipArea">
          만료: <span id="expireDate">${membership.expireDate}</span> 
          · D-<span id="daysLeft">${membership.daysLeft}</span>
        </div>
        <div class="ms-benefits">
          <div class="ms-item">무제한 스트리밍</div>
          <div class="ms-item">AI 음악 추천</div>
          <div class="ms-item">광고 없는 청취</div>
          <div class="ms-item">고음질 스트리밍</div>
          <div class="ms-item">독점 콘텐츠</div>
          <div class="ms-item">가사 실시간 지원</div>
        </div>
      </div>
      <%-- [기존 클래스 유지] upgrade-btn--pro --%>
      <button class="upgrade-btn upgrade-btn--pro" 
              onclick="mpCancelMembership('${membership.orderId}')">구독 해지</button>
    </c:when>

    <%-- 2. FREE 상태 --%>
    <c:otherwise>
      <div class="ms-card ms-card--free">
        <div class="ms-title">FREE</div>
        <div class="ms-benefits">
          <div class="ms-item">광고 노출</div>
          <div class="ms-item">스트리밍 불가</div>
          <div class="ms-item">아티스트 정보 제공</div>
          <div class="ms-item">기본 굿즈 구매</div>
        </div>
      </div>

      <div class="ms-card ms-card--pro">
        <div class="ms-title">PRO</div>
        <div class="ms-benefits">
          <div class="ms-item">무제한 스트리밍</div>
          <div class="ms-item">AI 음악 추천</div>
          <div class="ms-item">808 플레이리스트</div>
          <div class="ms-item">고음질 스트리밍</div>
          <div class="ms-item">독점 콘텐츠</div>
        </div>
      </div>
      <%-- FREE일 때는 membership.orderId가 없으므로 빈 값 전달 방지 --%>
      <button class="upgrade-btn" onclick="handleProMembership()">PRO로 업그레이드</button>
    </c:otherwise>
  </c:choose>

</div>
        <!-- ─── PROFILE ─── -->
        <div class="tab-pane" id="tab-profile">

          <div id="mpPvView">
            <div class="row-between row-between--mb14">
              <div class="pv-title">기본 정보</div>
              <button class="outline-btn" onclick="mpEditStart()">✎ 수정</button>
            </div>
            <div class="pv-field">
              <span class="pv-label">닉네임</span>
              <span class="pv-val" id="vNick"><c:out value="${loginUser.nickname}"/></span>
            </div>
            <div class="pv-field">
              <span class="pv-label">이메일</span>
              <span class="pv-val muted"><c:out value="${loginUser.email} "/><i class="fa-sharp fa-solid fa-shield-halved"></i></span>
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
                  <c:when test="${loginUser.profile.membershipType eq 'PRO'}">PRO</c:when>
                  <c:otherwise>FREE</c:otherwise>
                </c:choose>
              <i class="fa-sharp fa-solid fa-circle-play"></i></span>
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
               <div class="danger-zone">
              <button class="danger-btn" onclick="mpWithdraw()">계정 탈퇴</button>
            </div>
            </div>

          </div><%-- /mpPvView --%>

          <div id="mpPvEdit" style="display:none">
            <div class="row-between row-between--mb14">
              <div class="pv-title">기본 정보 수정</div>
              <div class="btn-group">
                <button class="outline-btn" onclick="mpEditCancel()">취소</button>
                <button class="primary-btn" onclick="mpEditSave()">저장</button>
              </div>
            </div>

            <%-- 닉네임 + 중복확인 --%>
            <div class="f-group">
              <label>닉네임</label>
              <div class="code-row">
                <input type="text" class="f-input" id="eNick"
                       value="<c:out value='${loginUser.nickname}'/>"
                       oninput="mpResetNickCheck()">
                <button type="button" class="code-btn" id="nickCheckBtn"
                        onclick="mpCheckNick()">중복확인</button>
              </div>
              <div id="nickCheckMsg" class="field-msg" style="display:none"></div>
            </div>

            <div class="f-group">
              <label>생년월일</label>
              <input type="date" class="f-input" id="eBirth"
                     value="<fmt:formatDate value='${loginUser.profile.birthDate}' pattern='yyyy-MM-dd'/>">
            </div>
            <div class="f-group">
              <label>이메일 (변경 불가)</label>
              <input type="email" class="f-input"
                     value="<c:out value='${loginUser.email}'/>" disabled>
            </div>
            <div class="f-group">
              <label>소개</label>
              <textarea class="f-input f-textarea" id="eBio" rows="3"
                placeholder="자신을 소개해주세요..."><c:out value="${loginUser.profile.bio}"/></textarea>
            </div>

            <%-- 비밀번호 변경 — 수정 폼 안으로 이동 --%>
            <div class="pw-box">
              <div class="pw-title"><i class="fa-sharp fa-solid fa-unlock-keyhole"></i> 비밀번호 변경</div>
              <div class="f-group">
                <label>현재 비밀번호</label>
                <input type="password" class="f-input" id="pwCurrent" placeholder="현재 비밀번호 입력">
              </div>
              <div class="f-group">
                <label>이메일 인증</label>
                <div class="code-row">
                  <input type="text" class="f-input f-input--readonly" id="pwEmail" readonly
                    value="<c:out value='${loginUser.email}'/>">
                  <button class="code-btn" id="pwSendBtn"
                    onclick="mpSendCode('<c:out value="${loginUser.email}"/>')">코드 발송</button>
                </div>
              </div>
              <div class="f-group pw-code-field" id="pwCodeField" style="display:none">
                <label>인증코드</label>
                <div class="code-row">
                  <input type="text" class="f-input" id="pwCode" placeholder="인증코드 6자리" maxlength="6">
                  <div class="code-addon">
                    <span class="pw-timer" id="pwTimer">5:00</span>
                    <button type="button" class="code-btn sm"
                      onclick="mpSendCode('<c:out value="${loginUser.email}"/>')">재발송</button>
                  </div>
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
              <button type="button" class="primary-btn pw-change-btn" onclick="mpChangePw()">비밀번호 변경</button>
            </div>
          </div><%-- /mpPvEdit --%>

        </div><%-- /tab-profile --%>

      </div><%-- /pane-body --%>
    </div><%-- /main-pane --%>

  </div><%-- /mypage-modal --%>
</div><%-- /mpOverlay --%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>

<%-- ══════════════════════════════════════════
     HTML 템플릿 — JS가 값만 꽂아 넣는 뼈대
     display:none 으로 화면에 안 보임
     ══════════════════════════════════════════ --%>

<%-- TOP 10 / 아티스트 — list-item 1개 뼈대 --%>
<template id="tmpl-list-item">
  <div class="list-item">
    <div class="rank"></div>
    <div class="li-thumb"></div>
    <div class="li-info">
      <div class="li-name"></div>
      <div class="li-sub"></div>
      <div class="prog-bar"><div class="prog-fill"></div></div>
    </div>
    <div class="li-right"></div>
  </div>
</template>

<%-- TOP 장르 — genre-tag 1개 뼈대 --%>
<template id="tmpl-genre-tag">
  <div class="genre-tag">
    <div class="genre-name"></div>
    <div class="genre-pct"></div>
  </div>
</template>

<%-- 활동 내역 — cmt-item 1개 뼈대 --%>
<template id="tmpl-cmt-item">
  <div class="cmt-item">
    <div class="cmt-meta">
      <div class="cmt-target">
        <span class="act-badge"></span>
        <span class="cmt-target-title"></span>
      </div>
      <div class="cmt-date"></div>
    </div>
    <div class="cmt-text"></div>
    <div class="cmt-actions">
      <button class="cmt-btn cmt-btn--view">원글보기</button>
      <button class="cmt-btn del cmt-btn--del" style="display:none">삭제</button>
    </div>
  </div>
</template>

<%-- 결제 내역 — pay-item 1개 뼈대 --%>
<template id="tmpl-pay-item">
  <div class="pay-item">
    <div class="pay-icon"></div>
    <div class="pay-info">
      <div class="pay-name"></div>
      <div class="pay-sub"></div>
    </div>
    <div class="pay-right">
      <span class="pay-amount"></span>
      <div><span class="status-badge"></span></div>
    </div>
  </div>
</template>


<div class="tab-pane" id="tab-reservations">
<!-- 예매 내역 출력 컨테이너 -->
<div id="mpResCards">></div>
</div>


<!-- 예매 내역 — res-card 1개 뼈대 -->
<template id="tmpl-res-card">
<li class="nav-item" 
    onclick="mpTab(this, 'reservations', '내 예매 내역', '최근 예매 정보입니다')">
    예매 내역
</li>

  <div class="res-card">
    <div class="res-poster">
      <div class="res-poster-bg"></div>
      <div class="res-poster-dim"></div>
      <div class="res-content">
        <div class="res-name"></div>
        <div class="res-date"></div>
        <span class="status-badge"></span>
      </div>
    </div>
    <div class="res-info">
      <div class="res-venue"></div>
      <div class="res-seat"></div>
      <div class="res-price">
        <span class="res-amt"></span>
        <button class="res-detail-btn" action="">상세보기</button>
      </div>
    </div>
  </div>
</template>

<script src="${pageContext.request.contextPath}/resources/user/js/mypageModal.js"></script>
