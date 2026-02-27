<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String cp = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>로그인 / 회원가입</title>
    <meta name="ctx" content="<%=cp%>" />
    <link rel="stylesheet" href="<%=cp%>/resources/user/css/auth.css" />
    <link
      href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
  </head>
  <body>
    <div class="bg-layer"></div>
    <div class="noise"></div>
    <div class="main">

      <!-- [A] 로그인 컨테이너 -->
      <div class="container a-container" id="a-container">
        <div class="form" id="login-form-wrap">

          <!-- 기본 로그인 뷰 -->
          <div style="display: flex; flex-direction: column; align-items: center; width: 100%;" id="login-view">
            <p class="title"></p>
            <div class="form_social">
              <div class="form_icon google" onclick="socialPopup('google')">G</div>
              <div class="form_icon naver"  onclick="socialPopup('naver')">N</div>
            </div>
            <p class="form_span">또는 이메일로 로그인</p>
            <input class="form_input" type="email"    placeholder="이메일"   id="l-email" />
            <input class="form_input" type="password" placeholder="비밀번호" id="l-pw" />
            <a class="form_link" onclick="showReset()">비밀번호를 잊으셨나요?</a>
            <button class="button submit" onclick="doLogin()">Sign In</button>
          </div>

          <!-- 비밀번호 재설정 뷰 -->
          <div class="reset-view" id="reset-view">
            <button class="back-btn" onclick="hideReset()">← 뒤로가기</button>
            <p class="title" style="font-size: 22px; line-height: 2">비밀번호 재설정</p>
            <p class="description" style="margin-bottom: 16px">가입한 이메일로 인증코드를 보내드립니다</p>

            <!-- 이메일 + 인증코드 버튼 -->
            <div style="position: relative; width: 300px">
              <input class="form_input" type="email" placeholder="이메일" id="r-email"
                style="width: 100%; padding-right: 90px" />
              <button class="send-btn" onclick="sendReset()"
                style="position: absolute; right: 8px; top: 50%; transform: translateY(-50%);">
                인증코드
              </button>
            </div>
            <p class="error-msg" id="r-email-error" style="display: none"></p>

            <!-- 인증코드 입력칸 -->
            <div class="code-sent-field" id="r-code-field" style="width: 300px">
              <div style="position: relative; width: 100%; margin: 5px 0">
                <input class="form_input" type="text" placeholder="인증코드 6자리"
                  maxlength="6" id="r-code" oninput="checkCode(this)"
                  style="width: 100%; padding-right: 90px" />
                <div style="position: absolute; right: 8px; top: 50%; transform: translateY(-50%);
                            display: flex; align-items: center; gap: 6px;">
                  <span id="r-timer" style="font-size: 10px; color: rgba(242,242,242,0.5)">5:00</span>
                  <button class="send-btn" onclick="sendReset()" style="font-size: 9px; padding: 2px 6px">재발송</button>
                </div>
              </div>

              <!-- 새 비밀번호 + 눈 아이콘 -->
              <div style="position: relative; width: 100%; margin: 5px 0">
                <input class="form_input" type="password" id="r-pw" placeholder="새 비밀번호"
                  maxlength="20" oninput="checkResetPw(this)" style="width: 100%; padding-right: 40px" />
                <span onclick="toggleResetPw()" id="r-pw-eye"
                  style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
                         cursor: pointer; color: var(--gray); font-size: 14px;">
                  <i class="fa-solid fa-eye-slash"></i>
                </span>
              </div>

              <!-- 비밀번호 체크리스트 -->
              <div id="r-pw-checklist"
                style="width: 100%; margin-top: 4px; display: none; gap: 6px; flex-wrap: wrap; justify-content: center;">
                <div id="r-check-letter"  class="pw-check">문자 1개 이상</div>
                <div id="r-check-num"     class="pw-check">숫자 1개 이상</div>
                <div id="r-check-special" class="pw-check">특수문자 1개 이상</div>
                <div id="r-check-len"     class="pw-check">8~20자</div>
              </div>
            </div>

            <button class="button" style="margin-top: 24px" onclick="doReset()">변경하기</button>
          </div>

        </div>
      </div>

      <!-- [B] 회원가입 컨테이너 -->
      <div class="container b-container" id="b-container">
        <div class="form">

          <!-- 기본 회원가입 뷰 -->
          <div style="display: flex; flex-direction: column; align-items: center; width: 100%;" id="signup-view">
            <p class="title"></p>
            <div class="form_social">
              <div class="form_icon google" onclick="socialPopup('google')">G</div>
              <div class="form_icon naver"  onclick="socialPopup('naver')">N</div>
            </div>
            <p class="form_span">또는 이메일로 가입</p>

            <!-- 닉네임 -->
            <div style="position: relative; width: 300px">
              <input class="form_input" id="nickname" type="text" placeholder="닉네임"
                style="width: 100%; padding-right: 80px" />
              <button class="send-btn" onclick="checkNickname()"
                style="position: absolute; right: 8px; top: 50%; transform: translateY(-50%);">
                중복확인
              </button>
            </div>
            <p class="error-msg" id="nickname-error"></p>

            <!-- 이메일 -->
            <div style="position: relative; width: 300px">
              <input class="form_input" type="email" placeholder="이메일" id="s-email"
                style="width: 100%; padding-right: 80px" />
              <button class="send-btn" onclick="sendCode()"
                style="position: absolute; right: 8px; top: 50%; transform: translateY(-50%);">
                인증코드
              </button>
            </div>
            <p class="error-msg" id="email-error" style="display: none">이메일 형식이 잘못되었습니다.</p>

            <!-- 인증코드 -->
            <div id="s-code-field" style="display: none; position: relative; width: 300px">
              <input class="form_input" type="text" placeholder="인증코드 6자리"
                maxlength="6" id="s-code" oninput="checkCode(this)"
                style="width: 100%; padding-right: 90px" />
              <div style="position: absolute; right: 8px; top: 50%; transform: translateY(-50%);
                          display: flex; align-items: center; gap: 6px;">
                <span id="s-timer" style="font-size: 10px; color: rgba(242,242,242,0.5)">5:00</span>
                <button class="send-btn" onclick="sendCode()" style="font-size: 9px; padding: 2px 6px">재발송</button>
              </div>
            </div>

            <!-- 비밀번호 -->
            <div style="position: relative; width: 300px">
              <input class="form_input" type="password" id="s-pw" data-show="false"
                placeholder="비밀번호" maxlength="20"
                style="width: 100%; padding-right: 40px" oninput="checkPw(this)" />
              <span onclick="togglePw()" id="pw-eye"
                style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
                       cursor: pointer; color: var(--gray); font-size: 14px;">
                <i class="fa-solid fa-eye-slash"></i>
              </span>
            </div>

            <!-- 비밀번호 체크리스트 -->
            <div id="pw-checklist"
              style="width: 300px; margin-top: 4px; display: flex; gap: 6px; flex-wrap: wrap; justify-content: center;">
              <div id="check-letter"  class="pw-check">문자 1개 이상</div>
              <div id="check-num"     class="pw-check">숫자 1개 이상</div>
              <div id="check-special" class="pw-check">특수문자 1개 이상</div>
              <div id="check-len"     class="pw-check">8~20자</div>
            </div>

            <p class="terms">
              가입 시 서비스 <a href="#">이용약관</a> 및 <br />
              <a href="#">개인정보 처리방침</a>에 동의하게 됩니다.
            </p>
            <button class="button submit" onclick="doSignup()">Sign Up</button>
          </div>

          <!-- 가입 완료 뷰 -->
          <div class="success-wrap" id="signup-success">
            <div class="suc-icon">🎉</div>
            <div class="suc-title">가입 완료!</div>
            <div class="suc-sub">환영합니다!<br />지금 바로 음악 여행을 시작하세요.</div>
            <button class="button" style="margin-top: 28px" onclick="goLogin()">로그인하기</button>
          </div>

        </div>
      </div>

      <!-- SWITCH 패널 -->
      <div class="switch" id="switch-cnt">
        <div class="switch_circle"></div>
        <div class="switch_circle switch_circle--t"></div>

        <!-- [C1] 처음엔 Sign Up 유도 -->
        <div class="switch_container" id="switch-c1">
          <h2 class="title" style="text-align: center">
            지금, <br />나만의 플레이리스트를 <br />만들어보세요!
          </h2>
          <p class="description" style="margin-top: 8px">
            아직 계정이 없으신가요?<br />지금 가입하고 음악 여행을 시작하세요
          </p>
          <button type="button" class="switch_button switch-btn">Sign Up</button>
        </div>

        <!-- [C2] Sign In 유도 -->
        <div class="switch_container is-hidden" id="switch-c2">
          <h2 class="title" style="text-align: center">
            이제, <br />당신만의 플레이리스트가 <br />시작됩니다!
          </h2>
          <p class="description" style="margin-top: 8px">
            기존 계정으로 로그인하고<br />음악을 계속 즐기세요
          </p>
          <button type="button" class="switch_button switch-btn">Sign In</button>
        </div>
      </div>

    </div><!-- /main -->

	<!-- ajax용 추가 -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script src="<%=cp%>/resources/user/js/auth.js"></script>
  </body>
</html>
