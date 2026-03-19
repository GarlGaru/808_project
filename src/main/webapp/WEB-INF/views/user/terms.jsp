<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>이용약관 및 개인정보 처리방침 — 808 PROJECT</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&display=swap"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg:         #0a0a0a;
      --bg-card:    #111111;
      --bg-hover:   #161616;
      --border:     #1e1e1e;
      --accent:     #ff6b2b;
      --accent-dim: rgba(255, 107, 43, 0.1);
      --text-1:     #efefef;
      --text-2:     #888888;
      --text-3:     #444444;
      --sidebar-w:  240px;
      --header-h:   56px;
      --font-body:  -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }

    html { scroll-behavior: smooth; }

    body {
      background: var(--bg);
      color: var(--text-1);
      font-family: var(--font-body);
      font-size: 14px;
      line-height: 1.75;
    }

    /* ── 헤더 ── */
    .header {
      position: fixed;
      top: 0; left: 0; right: 0;
      height: var(--header-h);
      background: rgba(10,10,10,0.95);
      backdrop-filter: blur(10px);
      border-bottom: 1px solid var(--border);
      display: flex;
      align-items: center;
      padding: 0 32px;
      gap: 14px;
      z-index: 100;
    }
    .header-logo { display: flex; align-items: center; text-decoration: none; }
    .header-logo img { height: 28px; width: auto; }
    .header-sep { width: 1px; height: 14px; background: var(--border); }
    .header-title { font-size: 13px; color: var(--text-2); }
    .header-close {
      margin-left: auto;
      font-size: 13px;
      color: var(--text-2);
      text-decoration: none;
      padding: 5px 12px;
      border: 1px solid var(--border);
      border-radius: 5px;
      transition: all 0.15s;
    }
    .header-close:hover { color: var(--text-1); border-color: var(--text-3); }

    /* ── 레이아웃 ── */
    .wrap {
      display: flex;
      padding-top: var(--header-h);
      min-height: 100vh;
    }

    /* ── 사이드바 ── */
    .sidebar {
      width: var(--sidebar-w);
      position: fixed;
      top: var(--header-h);
      bottom: 0;
      overflow-y: auto;
      border-right: 1px solid var(--border);
      padding: 28px 0;
    }
    .sidebar::-webkit-scrollbar { width: 2px; }
    .sidebar::-webkit-scrollbar-thumb { background: var(--border); }

    .sb-group { padding: 0 16px 20px; }
    .sb-label {
      font-size: 10px;
      font-weight: 600;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      color: var(--text-3);
      padding: 0 8px;
      margin-bottom: 6px;
    }
    .sb-link {
      display: block;
      padding: 7px 8px;
      font-size: 13px;
      color: var(--text-2);
      text-decoration: none;
      border-radius: 5px;
      transition: all 0.12s;
    }
    .sb-link:hover { color: var(--text-1); background: var(--bg-hover); }
    .sb-link.on { color: var(--accent); background: var(--accent-dim); }
    .sb-sep { height: 1px; background: var(--border); margin: 4px 16px 20px; }

    /* ── 본문 ── */
    .content {
      margin-left: var(--sidebar-w);
      flex: 1;
      max-width: 720px;
      padding: 48px 56px 100px;
    }

    /* ── 페이지 타이틀 ── */
    .hero {
      padding-bottom: 36px;
      border-bottom: 1px solid var(--border);
      margin-bottom: 52px;
    }
    .hero-tag {
      font-size: 11px;
      font-weight: 600;
      letter-spacing: 2px;
      text-transform: uppercase;
      color: var(--accent);
      margin-bottom: 14px;
    }
    .hero h1 {
      font-family: 'Syne', sans-serif;
      font-size: 30px;
      font-weight: 800;
      line-height: 1.2;
      letter-spacing: -0.8px;
      margin-bottom: 12px;
    }
    .hero-meta { font-size: 12px; color: var(--text-2); }
    .hero-meta span + span::before { content: '·'; margin: 0 8px; }

    /* ── 챕터 구분 ── */
    .chapter-div {
      display: flex;
      align-items: center;
      gap: 14px;
      margin: 68px 0 48px;
    }
    .chapter-div span {
      font-size: 10px;
      font-weight: 600;
      letter-spacing: 2px;
      text-transform: uppercase;
      color: var(--text-3);
      white-space: nowrap;
    }
    .chapter-div::after {
      content: '';
      flex: 1;
      height: 1px;
      background: var(--border);
    }

    /* ── 섹션 ── */
    .sec {
      margin-bottom: 56px;
      scroll-margin-top: 76px;
    }
    .sec-num {
      font-size: 11px;
      font-weight: 600;
      letter-spacing: 2px;
      text-transform: uppercase;
      color: var(--accent);
      margin-bottom: 10px;
    }
    .sec h2 {
      font-size: 17px;
      font-weight: 600;
      color: var(--text-1);
      margin-bottom: 20px;
      padding-bottom: 14px;
      border-bottom: 1px solid var(--border);
    }
    .sec h3 {
      font-size: 14px;
      font-weight: 600;
      color: var(--text-1);
      margin: 24px 0 8px;
    }
    .sec p { color: var(--text-2); margin-bottom: 12px; }
    .sec ul, .sec ol { padding-left: 18px; margin-bottom: 12px; }
    .sec li { color: var(--text-2); margin-bottom: 5px; }
    .sec li strong { color: var(--text-1); font-weight: 500; }

    /* ── 노트 박스 ── */
    .note {
      background: var(--accent-dim);
      border-left: 3px solid var(--accent);
      border-radius: 0 6px 6px 0;
      padding: 13px 16px;
      margin: 16px 0;
    }
    .note p { color: var(--text-1); margin: 0; font-size: 13px; }

    /* ── 테이블 ── */
    .tbl {
      width: 100%;
      border-collapse: collapse;
      margin: 14px 0 20px;
      font-size: 13px;
    }
    .tbl th {
      text-align: left;
      padding: 9px 12px;
      background: var(--bg-card);
      color: var(--text-2);
      font-weight: 500;
      border-top: 1px solid var(--border);
      border-bottom: 1px solid var(--border);
    }
    .tbl td {
      padding: 9px 12px;
      color: var(--text-2);
      border-bottom: 1px solid var(--border);
      vertical-align: top;
    }
    .tbl td.label { color: var(--text-1); font-weight: 500; width: 140px; }
    .tbl tr:last-child td { border-bottom: none; }

    /* ── 푸터 ── */
    .foot {
      margin-top: 64px;
      padding-top: 24px;
      border-top: 1px solid var(--border);
    }
    .foot p { font-size: 12px; color: var(--text-3); margin-bottom: 4px; }

    @media (max-width: 768px) {
      .sidebar { display: none; }
      .content { margin-left: 0; padding: 32px 20px 80px; }
    }
  </style>
</head>
<body>

<header class="header">
  <%-- 로고 이미지 경로를 아래 src에 입력하세요 --%>
  <a href="${cp}/main" class="header-logo">
    <img src="${cp}/resources/TODO_로고이미지경로" alt="808 PROJECT" />
  </a>
  <div class="header-sep"></div>
  <span class="header-title">이용약관 및 개인정보 처리방침</span>
  <a href="javascript:window.close()" class="header-close">닫기</a>
</header>

<div class="wrap">

  <nav class="sidebar">
    <div class="sb-group">
      <div class="sb-label">이용약관</div>
      <a href="#t1" class="sb-link">제1조 목적</a>
      <a href="#t2" class="sb-link">제2조 정의</a>
      <a href="#t3" class="sb-link">제3조 약관의 효력</a>
      <a href="#t4" class="sb-link">제4조 서비스 이용</a>
      <a href="#t5" class="sb-link">제5조 회원의 의무</a>
      <a href="#t6" class="sb-link">제6조 서비스 변경 및 중단</a>
      <a href="#t7" class="sb-link">제7조 면책조항</a>
    </div>
    <div class="sb-sep"></div>
    <div class="sb-group">
      <div class="sb-label">개인정보 처리방침</div>
      <a href="#p1" class="sb-link">제1조 수집 항목</a>
      <a href="#p2" class="sb-link">제2조 수집 목적</a>
      <a href="#p3" class="sb-link">제3조 보유 기간</a>
      <a href="#p4" class="sb-link">제4조 제3자 제공</a>
      <a href="#p5" class="sb-link">제5조 이용자 권리</a>
      <a href="#p6" class="sb-link">제6조 보안 조치</a>
      <a href="#p7" class="sb-link">제7조 문의</a>
    </div>
  </nav>

  <main class="content">

    <div class="hero">
      <div class="hero-tag">Legal</div>
      <h1>이용약관 및<br>개인정보 처리방침</h1>
      <div class="hero-meta">
        <span>시행일 2025년 03월 01일</span>
        <span>808 PROJECT 운영팀</span>
      </div>
    </div>

    <%-- ═══ 이용약관 ═══ --%>

    <div class="sec" id="t1">
      <div class="sec-num">Terms · 01</div>
      <h2>제1조 목적</h2>
      <p>본 약관은 808 PROJECT(이하 "서비스")가 제공하는 음악 감상 및 공연 티켓 예매 서비스의 이용과 관련하여 서비스와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.</p>
    </div>

    <div class="sec" id="t2">
      <div class="sec-num">Terms · 02</div>
      <h2>제2조 정의</h2>
      <ul>
        <li><strong>"서비스"</strong>란 808 PROJECT가 운영하는 음악 스트리밍 및 공연 예매 플랫폼을 의미합니다.</li>
        <li><strong>"이용자"</strong>란 본 약관에 동의하고 서비스를 이용하는 모든 회원을 의미합니다.</li>
        <li><strong>"계정"</strong>이란 서비스 이용을 위해 이용자가 등록한 이메일 및 비밀번호의 조합을 의미합니다.</li>
        <li><strong>"콘텐츠"</strong>란 서비스 내에서 제공되는 음악, 플레이리스트, 공연 정보 등 일체의 정보를 의미합니다.</li>
      </ul>
    </div>

    <div class="sec" id="t3">
      <div class="sec-num">Terms · 03</div>
      <h2>제3조 약관의 효력 및 변경</h2>
      <p>본 약관은 서비스 화면에 게시하거나 기타 방법으로 이용자에게 공지함으로써 효력이 발생합니다. 서비스는 합리적인 사유가 발생할 경우 약관을 변경할 수 있으며, 변경된 약관은 공지 후 7일 이내에 효력이 발생합니다.</p>
      <div class="note">
        <p>약관 변경 시 이메일 또는 서비스 내 알림으로 사전 고지합니다. 변경된 약관에 동의하지 않을 경우 서비스 이용을 중단하고 탈퇴할 수 있습니다.</p>
      </div>
    </div>

    <div class="sec" id="t4">
      <div class="sec-num">Terms · 04</div>
      <h2>제4조 서비스 이용</h2>
      <h3>가입 자격</h3>
      <p>서비스는 만 14세 이상 누구나 가입할 수 있습니다. 이메일 인증을 완료한 계정에 한해 서비스의 모든 기능을 이용할 수 있습니다.</p>
      <h3>제공 서비스</h3>
      <ul>
        <li>음악 스트리밍 및 플레이리스트 관리</li>
        <li>공연 정보 조회 및 티켓 예매</li>
        <li>예매 내역 조회 및 관리 (마이페이지)</li>
        <li>커뮤니티 게시판 이용</li>
      </ul>
    </div>

    <div class="sec" id="t5">
      <div class="sec-num">Terms · 05</div>
      <h2>제5조 회원의 의무</h2>
      <p>이용자는 다음 행위를 해서는 안 됩니다.</p>
      <ul>
        <li>타인의 계정 정보를 도용하거나 부정하게 이용하는 행위</li>
        <li>서비스의 운영을 방해하거나 서버에 과부하를 주는 행위</li>
        <li>저작권 등 타인의 지적재산권을 침해하는 행위</li>
        <li>음란물, 혐오 표현 등 불법적인 콘텐츠를 게시하는 행위</li>
        <li>영리 목적의 광고성 정보를 무단으로 게시하는 행위</li>
      </ul>
    </div>

    <div class="sec" id="t6">
      <div class="sec-num">Terms · 06</div>
      <h2>제6조 서비스 변경 및 중단</h2>
      <p>서비스는 운영상, 기술상의 필요에 따라 제공하고 있는 서비스의 전부 또는 일부를 변경할 수 있습니다. 변경이 있는 경우 변경 사유 및 일정을 사전에 공지합니다.</p>
      <p>불가항력적인 사유(천재지변, 서버 장애 등)로 인한 서비스 중단에 대해서는 책임을 지지 않습니다.</p>
    </div>

    <div class="sec" id="t7">
      <div class="sec-num">Terms · 07</div>
      <h2>제7조 면책조항</h2>
      <p>서비스는 이용자 간 또는 이용자와 제3자 간에 서비스를 매개로 발생한 분쟁에 대해 개입할 의무가 없으며, 이로 인한 손해를 배상할 책임도 없습니다.</p>
      <p>서비스 내 게시된 공연 정보는 주최사 사정에 의해 변경될 수 있으며, 이에 대한 최종 책임은 공연 주최사에 있습니다.</p>
    </div>

    <div class="chapter-div"><span>개인정보 처리방침</span></div>

    <%-- ═══ 개인정보 처리방침 ═══ --%>

    <div class="sec" id="p1">
      <div class="sec-num">Privacy · 01</div>
      <h2>제1조 수집하는 개인정보 항목</h2>
      <table class="tbl">
        <thead>
          <tr><th>구분</th><th>수집 항목</th><th>수집 방법</th></tr>
        </thead>
        <tbody>
          <tr><td class="label">필수</td><td>이메일, 비밀번호, 닉네임</td><td>회원가입 시</td></tr>
          <tr><td class="label">선택</td><td>프로필 이미지</td><td>마이페이지 설정</td></tr>
          <tr><td class="label">자동 수집</td><td>접속 IP, 이용 기록, 쿠키</td><td>서비스 이용 중</td></tr>
          <tr><td class="label">결제</td><td>결제 수단 정보 (PG사 처리)</td><td>티켓 예매 시</td></tr>
        </tbody>
      </table>
    </div>

    <div class="sec" id="p2">
      <div class="sec-num">Privacy · 02</div>
      <h2>제2조 개인정보 수집 및 이용 목적</h2>
      <ul>
        <li>회원 가입 및 본인 확인</li>
        <li>서비스 제공 및 맞춤형 콘텐츠 추천</li>
        <li>공연 티켓 예매 및 결제 처리</li>
        <li>고객 문의 및 불만 처리</li>
        <li>서비스 개선을 위한 통계 분석</li>
      </ul>
    </div>

    <div class="sec" id="p3">
      <div class="sec-num">Privacy · 03</div>
      <h2>제3조 개인정보 보유 및 이용 기간</h2>
      <p>회원 탈퇴 시 개인정보는 즉시 삭제됩니다. 단, 관련 법령에 의해 보존이 필요한 경우 아래 기간 동안 보관합니다.</p>
      <table class="tbl">
        <thead>
          <tr><th>보존 항목</th><th>보존 기간</th><th>근거 법령</th></tr>
        </thead>
        <tbody>
          <tr><td>계약 또는 청약철회에 관한 기록</td><td>5년</td><td>전자상거래법</td></tr>
          <tr><td>대금결제 및 재화 공급에 관한 기록</td><td>5년</td><td>전자상거래법</td></tr>
          <tr><td>소비자 불만 및 분쟁처리에 관한 기록</td><td>3년</td><td>전자상거래법</td></tr>
        </tbody>
      </table>
    </div>

    <div class="sec" id="p4">
      <div class="sec-num">Privacy · 04</div>
      <h2>제4조 개인정보의 제3자 제공</h2>
      <p>808 PROJECT는 원칙적으로 이용자의 개인정보를 제3자에게 제공하지 않습니다. 다만, 아래의 경우는 예외로 합니다.</p>
      <ul>
        <li>이용자가 사전에 동의한 경우</li>
        <li>법령의 규정에 의거하거나 수사 목적으로 법령에 정해진 절차에 따라 수사기관의 요구가 있는 경우</li>
      </ul>
      <div class="note">
        <p>결제 처리는 PG사를 통해 이루어지며, 카드 번호 등 결제 정보는 808 PROJECT 서버에 저장되지 않습니다.</p>
      </div>
    </div>

    <div class="sec" id="p5">
      <div class="sec-num">Privacy · 05</div>
      <h2>제5조 이용자의 권리</h2>
      <p>이용자는 언제든지 등록된 개인정보를 조회·수정하거나, 회원 탈퇴를 통해 삭제를 요청할 수 있습니다.</p>
      <ul>
        <li><strong>열람 및 수정</strong> — 마이페이지 &gt; 프로필 설정</li>
        <li><strong>삭제 (탈퇴)</strong> — 마이페이지 &gt; 계정 설정 &gt; 회원 탈퇴</li>
        <li><strong>처리 정지</strong> — 고객센터를 통한 서면 요청</li>
      </ul>
    </div>

    <div class="sec" id="p6">
      <div class="sec-num">Privacy · 06</div>
      <h2>제6조 개인정보 보호를 위한 기술적 조치</h2>
      <ul>
        <li>비밀번호는 암호화하여 저장하며, 운영자도 확인할 수 없습니다.</li>
        <li>개인정보 전송은 SSL 암호화 통신으로 보호됩니다.</li>
        <li>개인정보 접근 권한을 최소한의 인원으로 제한합니다.</li>
        <li>보안 취약점 점검을 정기적으로 실시합니다.</li>
      </ul>
    </div>

    <div class="sec" id="p7">
      <div class="sec-num">Privacy · 07</div>
      <h2>제7조 개인정보 관련 문의</h2>
      <table class="tbl">
        <tbody>
          <tr><td class="label">개인정보 책임자</td><td>808 PROJECT 운영팀</td></tr>
          <tr><td class="label">이메일</td><td>privacy@808project.kr</td></tr>
        </tbody>
      </table>
    </div>

    <div class="foot">
      <p>본 약관은 2025년 03월 01일부터 시행됩니다.</p>
      <p>© 2025 808 PROJECT. All rights reserved.</p>
    </div>

  </main>
</div>

<script>
  (function() {
    var sections = document.querySelectorAll('.sec');
    var links    = document.querySelectorAll('.sb-link');

    function activate() {
      var scrollY = window.scrollY + 90;
      var current = '';
      sections.forEach(function(s) {
        if (s.offsetTop <= scrollY) current = s.id;
      });
      links.forEach(function(a) {
        a.classList.toggle('on', a.getAttribute('href') === '#' + current);
      });
    }

    window.addEventListener('scroll', activate, { passive: true });
    activate();
  }());
</script>

</body>
</html>
