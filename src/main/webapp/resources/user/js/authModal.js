/* ────────────────────────────────────────────
   authModal.js
   의존성: modalCore.js (window.ModalCore)

   변경 내역:
     - 오버레이 open/close/ESC/외부클릭 → ModalCore 위임
     - 닫기버튼 id: modal-close-btn → auth-close-btn
     - 로그인 입력 필드(l-email, l-pw) 엔터키 → doLogin() 실행
     - resetLoginPanel / resetSignupPanel 분리 → 중복 제거
     - ModalCore.bindOnClose 훅으로 닫힘 시 자동 초기화
──────────────────────────────────────────── */
(function () {

  /* ────────────────────────────────────────────
     ① EL — DOM 요소 참조
  ──────────────────────────────────────────── */
  var EL;

  /* ────────────────────────────────────────────
     ② STATE
  ──────────────────────────────────────────── */
  var STATE = {
    nickChecked:         false,
    codeVerified:        false,
    serverGeneratedCode: "",
    timers:              {},
  };

  /* ────────────────────────────────────────────
     ③ API
  ──────────────────────────────────────────── */
  var CP = window.__AUTH_CP || "";
  console.log("[authModal] ContextPath:", CP);

  var API = {

    async login(email, pw) {
      var params = new URLSearchParams();
      params.append("email", email);
      params.append("password", pw);
      var res = await fetch(CP + "/login", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: params,
      });
      return await res.json();
    },

    async checkNick(nick) {
      var res = await fetch(CP + "/checkNickname?nickname=" + encodeURIComponent(nick));
      return await res.json();
    },

    async _sendCode(email) {
      var params = new URLSearchParams();
      params.append("email", email);
      var res = await fetch(CP + "/sendCode", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: params,
      });
      var serverCode = await res.json();
      if (serverCode && serverCode.toString().trim().length === 6) {
        return { ok: true, code: serverCode.toString().trim() };
      }
      return { ok: false, message: "인증코드 발송에 실패했습니다." };
    },

    async sendSignupCode(email) {
      var dupRes = await fetch(CP + "/checkEmail?email=" + encodeURIComponent(email));
      var dupCnt = await dupRes.json();
      if (dupCnt > 0) return { ok: false, message: "이미 사용 중인 이메일입니다." };
      return this._sendCode(email);
    },

    async sendResetCode(email) {
      var dupRes = await fetch(CP + "/checkEmail?email=" + encodeURIComponent(email));
      var cnt = await dupRes.json();
      if (cnt === 0) return { ok: false, message: "가입되지 않은 이메일입니다." };
      return this._sendCode(email);
    },

    async signup(nick, email, pw) {
      var params = new URLSearchParams();
      params.append("nickname", nick);
      params.append("email", email);
      params.append("password", pw);
      var res = await fetch(CP + "/signup", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: params,
      });
      var result = await res.json();
      if (result === 1) {
        await fetch(CP + "/verifyEmail", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: "email=" + encodeURIComponent(email),
        });
        return { ok: true };
      }
      return { ok: false, message: "회원가입에 실패했습니다." };
    },

    async resetPw(email, pw) {
      var params = new URLSearchParams();
      params.append("email", email);
      params.append("password", pw);
      var res = await fetch(CP + "/updatePw", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: params,
      });
      var result = await res.json();
      return result === 1 ? { ok: true } : { ok: false, message: "비밀번호 변경에 실패했습니다." };
    },
  };

  /* ────────────────────────────────────────────
     ④ HELPER
  ──────────────────────────────────────────── */

  function fieldError(input, errorEl, msg) {
    input.classList.remove("valid");
    input.classList.add("invalid");
    if (errorEl) { errorEl.textContent = msg; errorEl.style.display = "block"; }
  }

  function fieldOk(input, errorEl) {
    input.classList.remove("invalid");
    input.classList.add("valid");
    if (errorEl) errorEl.style.display = "none";
  }

  function fieldReset(input, errorEl) {
    input.classList.remove("invalid", "valid");
    if (errorEl) errorEl.style.display = "none";
  }

  var EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  function isValidEmail(val) { return EMAIL_RE.test(val); }

  var NICK_RE = /^[가-힣a-zA-Z0-9]+$/;
  function isValidNick(val) { return NICK_RE.test(val); }

  function handleEmailInput(input, errorEl) {
    if (input.classList.contains("valid")) { fieldReset(input, errorEl); return; }
    if (!input.value) { fieldReset(input, errorEl); return; }
    isValidEmail(input.value)
      ? fieldReset(input, errorEl)
      : fieldError(input, errorEl, "이메일 형식이 잘못되었습니다.");
  }

  function startTimer(timerEl, stateKey) {
    if (STATE.timers[stateKey]) clearInterval(STATE.timers[stateKey]);
    var sec = 300;
    STATE.timers[stateKey] = setInterval(function() {
      var m = Math.floor(sec / 60), s = sec % 60;
      timerEl.textContent = m + ":" + String(s).padStart(2, "0");
      if (--sec < 0) { clearInterval(STATE.timers[stateKey]); timerEl.textContent = "만료됨"; }
    }, 1000);
  }

  function stopTimer(timerEl, stateKey) {
    if (STATE.timers[stateKey]) { clearInterval(STATE.timers[stateKey]); STATE.timers[stateKey] = null; }
    timerEl.textContent = "5:00";
  }

  var PW_RULES = [
    { key: "letter",  re: /[a-zA-Z]/ },
    { key: "num",     re: /[0-9]/ },
    { key: "special", re: /[!@#$%^&*]/ },
    { key: "len",     test: function(v) { return v.length >= 8 && v.length <= 20; } },
  ];

  function updatePwChecklist(val, prefix) {
    var allOk = true;
    PW_RULES.forEach(function(rule) {
      var ok = rule.re ? rule.re.test(val) : rule.test(val);
      if (!ok) allOk = false;
      var el = document.getElementById(prefix + "check-" + rule.key);
      if (el) el.className = "pw-check" + (ok ? " ok" : "");
    });
    return allOk;
  }

  function resetPwChecklist(checklistEl, prefix) {
    PW_RULES.forEach(function(rule) {
      var el = document.getElementById(prefix + "check-" + rule.key);
      if (el) el.className = "pw-check";
    });
    checklistEl.style.display = "none";
  }

  function togglePwVisibility(inputEl, eyeEl) {
    var show = inputEl.type === "password";
    inputEl.type = show ? "text" : "password";
    eyeEl.innerHTML = show
      ? '<i class="fa-solid fa-eye"></i>'
      : '<i class="fa-solid fa-eye-slash"></i>';
  }

  function checkPwField(inp, checklistEl, prefix) {
    if (!inp.value) { resetPwChecklist(checklistEl, prefix); fieldReset(inp, null); return; }
    checklistEl.style.display = "flex";
    updatePwChecklist(inp.value, prefix) ? fieldOk(inp, null) : fieldError(inp, null, "");
  }

  /* ────────────────────────────────────────────
     ⑤ 패널별 초기화
     resetLoginPanel  : 로그인 + 비밀번호 재설정 패널
     resetSignupPanel : 회원가입 패널
     resetAuthModal   : 전체 (위 두 함수 재사용) + 패널 위치 복구
  ──────────────────────────────────────────── */

  function resetLoginPanel() {
    /* 로그인 입력 */
    EL.lEmail.value = ""; EL.lEmail.classList.remove("valid", "invalid");
    EL.lPw.value    = ""; EL.lPw.type = "password"; EL.lPw.classList.remove("valid", "invalid");

    /* 비밀번호 재설정 뷰 */
    EL.resetView.classList.remove("active");
    EL.loginView.style.display = "flex";
    EL.rEmail.value = ""; EL.rEmail.classList.remove("valid", "invalid");
    EL.rEmailError.textContent = ""; EL.rEmailError.style.display = "none";
    EL.rCodeField.style.display = "none";
    EL.rCode.value = ""; EL.rCode.classList.remove("valid", "invalid");
    EL.rPw.value   = ""; EL.rPw.type = "password"; EL.rPw.classList.remove("valid", "invalid");
    EL.rPwEye.innerHTML = '<i class="fa-solid fa-eye-slash"></i>';
    resetPwChecklist(EL.rPwChecklist, "r-");
    stopTimer(EL.rTimer, "reset");
  }

  function resetSignupPanel() {
    /* 회원가입 입력 */
    EL.nickname.value = ""; EL.nickname.classList.remove("valid", "invalid");
    EL.nickError.textContent = ""; EL.nickError.style.display = "none";
    EL.sEmail.value   = ""; EL.sEmail.classList.remove("valid", "invalid");
    EL.sEmailError.textContent = ""; EL.sEmailError.style.display = "none";
    EL.sCodeField.style.display = "none";
    EL.sCode.value = ""; EL.sCode.classList.remove("valid", "invalid");
    EL.sPw.value   = ""; EL.sPw.type = "password"; EL.sPw.classList.remove("valid", "invalid");
    EL.sPwEye.innerHTML = '<i class="fa-solid fa-eye-slash"></i>';
    resetPwChecklist(EL.sPwChecklist, "");
    stopTimer(EL.sTimer, "signup");

    /* 회원가입 성공 뷰 */
    EL.signupSuccess.classList.remove("active", "slide-out");
    EL.signupView.style.display = "flex";

    /* 회원가입 관련 STATE */
    STATE.nickChecked         = false;
    STATE.codeVerified        = false;
    STATE.serverGeneratedCode = "";
  }

  function resetAuthModal() {
    resetLoginPanel();
    resetSignupPanel();

    /* 패널 전환 상태 → 로그인(초기) 위치로 */
    if (EL.switchCtn.classList.contains("is-txr")) {
      EL.switchCtn.classList.remove("is-txr", "is-gx");
      EL.switchC1.classList.remove("is-hidden");
      EL.switchC2.classList.add("is-hidden");
      EL.aContainer.classList.remove("is-txl");
      EL.bContainer.classList.remove("is-txl", "is-z200");
    }
  }

  /* ────────────────────────────────────────────
     ⑥ 기능 함수
  ──────────────────────────────────────────── */

  function openModal(mode) {
    ModalCore.open("auth-overlay");
    if (mode === "register" && !EL.switchCtn.classList.contains("is-txr")) {
      changeForm();
    }
  }

  function closeModal() {
    ModalCore.close("auth-overlay");
  }

  function changeForm() {
    EL.switchCtn.classList.add("is-gx");
    setTimeout(function() { EL.switchCtn.classList.remove("is-gx"); }, 1500);
    EL.switchCtn.classList.toggle("is-txr");
    EL.switchC1.classList.toggle("is-hidden");
    EL.switchC2.classList.toggle("is-hidden");
    EL.aContainer.classList.toggle("is-txl");
    EL.bContainer.classList.toggle("is-txl");
    EL.bContainer.classList.toggle("is-z200");

    /* 떠나는 패널 초기화 */
    if (EL.switchCtn.classList.contains("is-txr")) {
      resetLoginPanel();   /* 로그인 → 회원가입: 로그인 패널 초기화 */
    } else {
      resetSignupPanel();  /* 회원가입 → 로그인: 회원가입 패널 초기화 */
    }
  }

  function socialPopup(platform) { alert("현재 준비 중입니다 :)"); }

  function showReset() { EL.loginView.style.display = "none";  EL.resetView.classList.add("active"); }
  function hideReset() { EL.loginView.style.display = "flex";  EL.resetView.classList.remove("active"); }

  async function doLogin() {
    var email = EL.lEmail.value.trim();
    var pw    = EL.lPw.value;
    if (!email || !pw) { alert("이메일과 비밀번호를 입력해주세요."); return; }

    var result = await API.login(email, pw);
    if      (result === 1) { window.location.href = CP + "/main"; }
    else if (result === 2) { alert("이메일 인증이 필요합니다."); }
    else                   { alert("이메일 또는 비밀번호가 올바르지 않습니다."); }
  }

  async function checkNickname() {
    var nick = EL.nickname.value.trim();
    if (!nick)                               { fieldError(EL.nickname, EL.nickError, "닉네임을 입력해주세요."); STATE.nickChecked = false; return; }
    if (nick.length < 2 || nick.length > 10) { fieldError(EL.nickname, EL.nickError, "닉네임은 2~10자로 입력해주세요."); STATE.nickChecked = false; return; }
    if (!isValidNick(nick))                  { fieldError(EL.nickname, EL.nickError, "한글, 영문, 숫자만 사용 가능합니다."); STATE.nickChecked = false; return; }

    var result = await API.checkNick(nick);
    if (result > 0) {
      fieldError(EL.nickname, EL.nickError, "이미 사용 중인 닉네임입니다.");
      STATE.nickChecked = false;
    } else {
      fieldOk(EL.nickname, EL.nickError);
      STATE.nickChecked = true;
      alert("사용 가능한 닉네임입니다!");
    }
  }

  async function sendCode() {
    var email = EL.sEmail.value.trim();
    if (!STATE.nickChecked)   { alert("닉네임 중복확인을 먼저 해주세요."); return; }
    if (!email)               { alert("이메일을 입력해주세요."); return; }
    if (!isValidEmail(email)) { alert("올바른 이메일을 입력해주세요."); return; }

    var result = await API.sendSignupCode(email);
    if (!result.ok) { fieldError(EL.sEmail, EL.sEmailError, result.message); return; }

    STATE.serverGeneratedCode = result.code;
    STATE.codeVerified = false;
    EL.sCode.value = "";
    fieldReset(EL.sCode, null);
    fieldOk(EL.sEmail, EL.sEmailError);
    EL.sCodeField.style.display = "block";
    startTimer(EL.sTimer, "signup");
    alert("[임시 인증번호] : " + STATE.serverGeneratedCode + "\n화면 하단에 입력해주세요.");
  }

  function checkCode(inp) {
    var val = inp.value.trim();
    if (!val) { fieldReset(inp, null); STATE.codeVerified = false; return; }

    if (val.length === 6) {
      if (val === STATE.serverGeneratedCode) {
        fieldOk(inp, null);
        STATE.codeVerified = true;
      } else {
        fieldError(inp, null, "인증번호가 일치하지 않습니다.");
        STATE.codeVerified = false;
      }
    } else {
      fieldError(inp, null, "");
      STATE.codeVerified = false;
    }
  }

  async function doSignup() {
    var nick  = EL.nickname.value.trim();
    var email = EL.sEmail.value.trim();
    var code  = EL.sCode.value.trim();
    var pw    = EL.sPw.value;

    if (!nick)                                       { alert("닉네임을 입력해주세요."); return; }
    if (!STATE.nickChecked)                          { alert("닉네임 중복확인을 해주세요."); return; }
    if (EL.nickname.classList.contains("invalid"))   { alert("닉네임을 확인해주세요."); return; }
    if (!email)                                      { alert("이메일을 입력해주세요."); return; }
    if (EL.sEmail.classList.contains("invalid"))     { alert("올바른 이메일을 입력해주세요."); return; }
    if (!code)                                       { alert("인증코드를 입력해주세요."); return; }
    if (!STATE.codeVerified)                         { alert("인증코드가 일치하지 않습니다."); return; }
    if (!pw || EL.sPw.classList.contains("invalid")) { alert("비밀번호 조건을 확인해주세요."); return; }

    var result = await API.signup(nick, email, pw);
    if (result.ok) {
      stopTimer(EL.sTimer, "signup");
      STATE.serverGeneratedCode = "";
      STATE.codeVerified = false;
      EL.signupView.style.display = "none";
      EL.signupSuccess.classList.add("active");
    } else {
      alert(result.message);
    }
  }

  function goLogin() {
    EL.signupSuccess.classList.add("slide-out");
    if (EL.switchCtn.classList.contains("is-txr")) changeForm();
    setTimeout(function() {
      EL.signupSuccess.classList.remove("active", "slide-out");
      EL.signupView.style.display = "flex";
      STATE.nickChecked = false;
    }, 1250);
  }

  async function sendReset() {
    var email = EL.rEmail.value.trim();
    if (!email)               { fieldError(EL.rEmail, EL.rEmailError, "이메일을 입력해주세요."); return; }
    if (!isValidEmail(email)) { fieldError(EL.rEmail, EL.rEmailError, "이메일 형식이 잘못되었습니다."); return; }

    var result = await API.sendResetCode(email);
    if (!result.ok) { fieldError(EL.rEmail, EL.rEmailError, result.message); return; }

    STATE.serverGeneratedCode = result.code;
    STATE.codeVerified = false;
    EL.rCode.value = "";
    fieldReset(EL.rCode, null);
    fieldOk(EL.rEmail, EL.rEmailError);
    EL.rCodeField.style.display = "block";
    startTimer(EL.rTimer, "reset");
    alert("[비밀번호 재설정 번호] : " + STATE.serverGeneratedCode + "\n입력창에 적어주세요.");
  }

  async function doReset() {
    var email = EL.rEmail.value.trim();
    var code  = EL.rCode.value.trim();
    var pw    = EL.rPw.value;

    if (!code)                                       { alert("인증코드를 입력해주세요."); return; }
    if (!STATE.codeVerified)                         { alert("인증코드가 일치하지 않습니다."); return; }
    if (!pw || EL.rPw.classList.contains("invalid")) { alert("비밀번호 조건을 확인해주세요."); return; }

    var result = await API.resetPw(email, pw);
    if (!result.ok) { alert(result.message); return; }

    resetLoginPanel();
    STATE.codeVerified        = false;
    STATE.serverGeneratedCode = "";
    hideReset();
    alert("비밀번호가 성공적으로 변경되었습니다!\n새로운 비밀번호로 로그인해주세요.");
  }

  /* ────────────────────────────────────────────
     ⑦ INIT
  ──────────────────────────────────────────── */
  window.addEventListener("load", function() {

    EL = {
      overlay:   document.getElementById("auth-overlay"),
      closeBtn:  document.getElementById("auth-close-btn"),

      switchCtn:  document.getElementById("switch-cnt"),
      switchC1:   document.getElementById("switch-c1"),
      switchC2:   document.getElementById("switch-c2"),
      switchBtns: document.querySelectorAll(".switch-btn"),
      submitBtns: document.querySelectorAll(".submit"),
      aContainer: document.getElementById("a-container"),
      bContainer: document.getElementById("b-container"),

      loginView: document.getElementById("login-view"),
      lEmail:    document.getElementById("l-email"),
      lPw:       document.getElementById("l-pw"),

      resetView:    document.getElementById("reset-view"),
      rEmail:       document.getElementById("r-email"),
      rEmailError:  document.getElementById("r-email-error"),
      rCodeField:   document.getElementById("r-code-field"),
      rCode:        document.getElementById("r-code"),
      rTimer:       document.getElementById("r-timer"),
      rPw:          document.getElementById("r-pw"),
      rPwEye:       document.getElementById("r-pw-eye"),
      rPwChecklist: document.getElementById("r-pw-checklist"),

      signupView:    document.getElementById("signup-view"),
      signupSuccess: document.getElementById("signup-success"),
      nickname:      document.getElementById("nickname"),
      nickError:     document.getElementById("nickname-error"),
      sEmail:        document.getElementById("s-email"),
      sEmailError:   document.getElementById("email-error"),
      sCodeField:    document.getElementById("s-code-field"),
      sCode:         document.getElementById("s-code"),
      sTimer:        document.getElementById("s-timer"),
      sPw:           document.getElementById("s-pw"),
      sPwEye:        document.getElementById("pw-eye"),
      sPwChecklist:  document.getElementById("pw-checklist"),
    };

    /* ── ModalCore 바인딩 ── */
    ModalCore.bindCloseBtn(EL.closeBtn, "auth-overlay");
    ModalCore.bindOutsideClick("auth-overlay", ".auth-main");
    ModalCore.bindEscKey("auth-overlay");
    ModalCore.bindOnClose("auth-overlay", resetAuthModal);

    /* ── 폼 submit 기본 동작 방지 ── */
    EL.submitBtns.forEach(function(b) {
      b.addEventListener("click", function(e) { e.preventDefault(); });
    });

    /* ── 패널 전환 버튼 ── */
    EL.switchBtns.forEach(function(b) {
      b.addEventListener("click", changeForm);
    });

    /* ── 로그인 엔터키 ── */
    function onLoginEnter(e) {
      if (e.key === "Enter") doLogin();
    }
    EL.lEmail.addEventListener("keydown", onLoginEnter);
    EL.lPw.addEventListener("keydown",   onLoginEnter);

    /* ── 이메일 실시간 형식 검사 ── */
    EL.sEmail.addEventListener("input", function() { handleEmailInput(EL.sEmail, EL.sEmailError); });
    EL.rEmail.addEventListener("input", function() { handleEmailInput(EL.rEmail, EL.rEmailError); });

    /* ── 닉네임 실시간 검사 ── */
    EL.nickname.addEventListener("input", function() {
      STATE.nickChecked = false;
      var nick = EL.nickname.value.trim();
      if (!nick)              { fieldReset(EL.nickname, EL.nickError); return; }
      if (!isValidNick(nick)) fieldError(EL.nickname, EL.nickError, "한글, 영문, 숫자만 사용 가능합니다.");
      else                    fieldReset(EL.nickname, EL.nickError);
    });

    /* ── 비밀번호 실시간 체크 ── */
    if (EL.sPw) EL.sPw.addEventListener("input", function() { checkPwField(EL.sPw, EL.sPwChecklist, ""); });
    if (EL.rPw) EL.rPw.addEventListener("input", function() { checkPwField(EL.rPw, EL.rPwChecklist, "r-"); });

    /* ── 인증코드 실시간 검증 ── */
    if (EL.sCode) EL.sCode.addEventListener("input", function() { checkCode(EL.sCode); });
    if (EL.rCode) EL.rCode.addEventListener("input", function() { checkCode(EL.rCode); });

    /* ── 비밀번호 눈 아이콘 토글 ── */
    if (EL.sPwEye) EL.sPwEye.addEventListener("click", function() { togglePwVisibility(EL.sPw, EL.sPwEye); });
    if (EL.rPwEye) EL.rPwEye.addEventListener("click", function() { togglePwVisibility(EL.rPw, EL.rPwEye); });

    /* ── register=true 파라미터 → 회원가입 패널 자동 오픈 ── */
    if (window.__AUTH_OPEN_REGISTER) openModal("register");
  });

  /* ────────────────────────────────────────────
     ⑧ 외부 노출
  ──────────────────────────────────────────── */
  window.openAuthModal  = function(mode) { openModal(mode || "login"); };
  window.closeAuthModal = closeModal;

  window.socialPopup   = socialPopup;
  window.showReset     = showReset;
  window.hideReset     = hideReset;
  window.doLogin       = doLogin;
  window.checkNickname = checkNickname;
  window.sendCode      = sendCode;
  window.doSignup      = doSignup;
  window.goLogin       = goLogin;
  window.sendReset     = sendReset;
  window.doReset       = doReset;

}());
