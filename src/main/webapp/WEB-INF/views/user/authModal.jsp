<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  authModal.jsp — 헤더 include 전용 fragment
  ─────────────────────────────────────────────────────────────
  로드 의존성 (헤더 include 순서):
    1. modalCore.css
    2. authModal.css
    3. modalCore.js
    4. authModal.js

  헤더 버튼 사용법:
    onclick="openAuthModal()"            → 로그인 패널
    onclick="openAuthModal('register')"  → 회원가입 패널
  ─────────────────────────────────────────────────────────────
--%>

<%-- CP 전달 — IIFE 안 window.__AUTH_CP 로 읽음 --%>
<script>window.__AUTH_CP = "${path}";</script>

<%-- Fonts / FA / CSS --%>
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500&display=swap" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<link rel="stylesheet" href="${path}/resources/user/css/modalCore.css" />
<link rel="stylesheet" href="${path}/resources/user/css/authModal.css" />

<%--
  ★ 오버레이 래퍼
    .mc-overlay  : modalCore.css 기반 (position:fixed, backdrop, z-index)
    display:none → openAuthModal() 시 flex
    배경 클릭 / ESC → ModalCore 에서 처리
--%>
<div id="auth-overlay" class="mc-overlay" style="display:none;">

  <%-- .auth-main : 카드 --%>
  <div class="auth-main">

    <div class="auth-bg-layer"></div>
    <div class="auth-noise"></div>

    <div>

      <!-- [A] 로그인 컨테이너 -->
      <div class="auth-container a-container" id="a-container">
        <div class="auth-form" id="login-form-wrap">

          <!-- 기본 로그인 뷰 -->
          <div class="auth-view" id="login-view">
            <p class="auth-title"></p>
            <div class="auth-social">
              <div class="auth-social-icon google" onclick="socialPopup('google')">G</div>
              <div class="auth-social-icon naver"  onclick="socialPopup('naver')">N</div>
            </div>
            <p class="auth-divider">또는 이메일로 로그인</p>
            <%-- 엔터키 → doLogin() : authModal.js INIT 에서 keydown 이벤트 등록 --%>
            <input class="auth-input" type="email"    placeholder="이메일"   id="l-email" />
            <input class="auth-input" type="password" placeholder="비밀번호" id="l-pw" />
            <a class="auth-link" onclick="showReset()">비밀번호를 잊으셨나요?</a>
            <button class="auth-btn submit" onclick="doLogin()">Sign In</button>
          </div>

          <!-- 비밀번호 재설정 뷰 -->
          <div class="reset-view" id="reset-view">
            <button class="back-btn" onclick="hideReset()">← 뒤로가기</button>
            <p class="auth-title" style="font-size: 22px; line-height: 2">비밀번호 재설정</p>
            <p class="auth-desc" style="margin-bottom: 16px">가입한 이메일로 인증코드를 보내드립니다</p>

            <div style="position: relative; width: 300px">
              <input class="auth-input" type="email" placeholder="이메일" id="r-email"
                style="width: 100%; padding-right: 90px" />
              <button class="auth-send-btn" onclick="sendReset()"
                style="position: absolute; right: 8px; top: 50%; transform: translateY(-50%);">
                인증코드
              </button>
            </div>
            <p class="auth-error-msg" id="r-email-error" style="display: none"></p>

            <div class="code-sent-field" id="r-code-field" style="width: 300px">
              <div style="position: relative; width: 100%; margin: 5px 0">
                <input class="auth-input" type="text" placeholder="인증코드 6자리"
                  maxlength="6" id="r-code"
                  style="width: 100%; padding-right: 90px" />
                <div style="position: absolute; right: 8px; top: 50%; transform: translateY(-50%);
                            display: flex; align-items: center; gap: 6px;">
                  <span id="r-timer" style="font-size: 10px; color: rgba(242,242,242,0.5)">5:00</span>
                  <button class="auth-send-btn sm" onclick="sendReset()">재발송</button>
                </div>
              </div>

              <div style="position: relative; width: 100%; margin: 5px 0">
                <input class="auth-input" type="password" id="r-pw" placeholder="새 비밀번호"
                  maxlength="20" style="width: 100%; padding-right: 40px" />
                <span id="r-pw-eye"
                  style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
                         cursor: pointer; color: var(--gray); font-size: 14px;">
                  <i class="fa-solid fa-eye-slash"></i>
                </span>
              </div>

              <div id="r-pw-checklist"
                style="width: 100%; margin-top: 4px; display: none; gap: 6px; flex-wrap: wrap; justify-content: center;">
                <div id="r-check-letter"  class="pw-check">문자 1개 이상</div>
                <div id="r-check-num"     class="pw-check">숫자 1개 이상</div>
                <div id="r-check-special" class="pw-check">특수문자 1개 이상</div>
                <div id="r-check-len"     class="pw-check">8~20자</div>
              </div>
            </div>

            <button class="auth-btn" style="margin-top: 24px" onclick="doReset()">변경하기</button>
          </div>

        </div>
      </div>

      <!-- [B] 회원가입 컨테이너 -->
      <div class="auth-container b-container" id="b-container">
        <div class="auth-form">

          <!-- 기본 회원가입 뷰 -->
          <div class="auth-view" id="signup-view">
            <p class="auth-title"></p>
            <div class="auth-social">
              <div class="auth-social-icon google" onclick="socialPopup('google')">G</div>
              <div class="auth-social-icon naver"  onclick="socialPopup('naver')">N</div>
            </div>
            <p class="auth-divider">또는 이메일로 가입</p>

            <div style="position: relative; width: 300px">
              <input class="auth-input" id="nickname" type="text" placeholder="닉네임"
                style="width: 100%; padding-right: 80px" />
              <button class="auth-send-btn" onclick="checkNickname()"
                style="position: absolute; right: 8px; top: 50%; transform: translateY(-50%);">
                중복확인
              </button>
            </div>
            <p class="auth-error-msg" id="nickname-error"></p>

            <div style="position: relative; width: 300px">
              <input class="auth-input" type="email" placeholder="이메일" id="s-email"
                style="width: 100%; padding-right: 80px" />
              <button class="auth-send-btn" onclick="sendCode()"
                style="position: absolute; right: 8px; top: 50%; transform: translateY(-50%);">
                인증코드
              </button>
            </div>
            <p class="auth-error-msg" id="email-error" style="display: none">이메일 형식이 잘못되었습니다.</p>

            <div id="s-code-field" style="display: none; position: relative; width: 300px">
              <input class="auth-input" type="text" placeholder="인증코드 6자리"
                maxlength="6" id="s-code"
                style="width: 100%; padding-right: 90px" />
              <div style="position: absolute; right: 8px; top: 50%; transform: translateY(-50%);
                          display: flex; align-items: center; gap: 6px;">
                <span id="s-timer" style="font-size: 10px; color: rgba(242,242,242,0.5)">5:00</span>
                <button class="auth-send-btn sm" onclick="sendCode()">재발송</button>
              </div>
            </div>

            <div style="position: relative; width: 300px">
              <input class="auth-input" type="password" id="s-pw" data-show="false"
                placeholder="비밀번호" maxlength="20"
                style="width: 100%; padding-right: 40px" />
              <span id="pw-eye"
                style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
                       cursor: pointer; color: var(--gray); font-size: 14px;">
                <i class="fa-solid fa-eye-slash"></i>
              </span>
            </div>

            <div id="pw-checklist"
              style="width: 300px; margin-top: 4px; display: none; gap: 6px; flex-wrap: wrap; justify-content: center;">
              <div id="check-letter"  class="pw-check">문자 1개 이상</div>
              <div id="check-num"     class="pw-check">숫자 1개 이상</div>
              <div id="check-special" class="pw-check">특수문자 1개 이상</div>
              <div id="check-len"     class="pw-check">8~20자</div>
            </div>

            <p class="auth-terms">
              가입 시 서비스 <a href="#">이용약관</a> 및 <br />
              <a href="#">개인정보 처리방침</a>에 동의하게 됩니다.
            </p>
            <button class="auth-btn submit" onclick="doSignup()">Sign Up</button>
          </div>

          <!-- 가입 완료 뷰 -->
          <div class="success-wrap" id="signup-success">
            <div class="suc-icon">🎉</div>
            <div class="suc-title">가입 완료!</div>
            <div class="suc-sub">환영합니다!<br />지금 바로 음악 여행을 시작하세요.</div>
            <button class="auth-btn" style="margin-top: 28px" onclick="goLogin()">로그인하기</button>
          </div>

        </div>
      </div>

      <!-- SWITCH 패널 -->
      <div class="auth-switch" id="switch-cnt">
        <div class="switch_circle"></div>
        <div class="switch_circle switch_circle--t"></div>

        <div class="switch_container" id="switch-c1">
          <h2 class="auth-title" style="text-align: center">
            지금, <br />나만의 플레이리스트를 <br />만들어보세요!
          </h2>
          <p class="auth-desc" style="margin-top: 8px">
            아직 계정이 없으신가요?<br />지금 가입하고 음악 여행을 시작하세요
          </p>
          <button type="button" class="switch_button switch-btn">Sign Up</button>
        </div>

        <div class="switch_container is-hidden" id="switch-c2">
          <h2 class="auth-title" style="text-align: center">
            이제, <br />당신만의 플레이리스트가 <br />시작됩니다!
          </h2>
          <p class="auth-desc" style="margin-top: 8px">
            기존 계정으로 로그인하고<br />음악을 계속 즐기세요
          </p>
          <button type="button" class="switch_button switch-btn">Sign In</button>
        </div>
      </div>

    </div><%-- /inner --%>

  </div><%-- /.auth-main --%>

</div><%-- /#auth-overlay --%>

<%-- register=true 파라미터 → 회원가입 패널 자동 오픈 --%>
<c:if test="${param.register eq 'true'}">
  <script>window.__AUTH_OPEN_REGISTER = true;</script>
</c:if>

<script src="${path}/resources/user/js/modalCore.js"></script>
<script src="${path}/resources/user/js/authModal.js"></script>
