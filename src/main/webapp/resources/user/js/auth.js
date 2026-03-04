/* ============================================================
   auth.js
   구조: EL → STATE → API → HELPER → 기능함수 → INIT
============================================================ */

/* ============================================================
   ① EL — DOM 요소 참조 모음
============================================================ */
const EL = {
  // ── 슬라이딩 패널 ──
  switchCtn:  document.querySelector("#switch-cnt"),
  switchC1:   document.querySelector("#switch-c1"),
  switchC2:   document.querySelector("#switch-c2"),
  switchBtns: document.querySelectorAll(".switch-btn"),
  submitBtns: document.querySelectorAll(".submit"),
  aContainer: document.querySelector("#a-container"),
  bContainer: document.querySelector("#b-container"),

  // ── 로그인 ──
  loginView: document.getElementById("login-view"),
  lEmail:    document.getElementById("l-email"),
  lPw:       document.getElementById("l-pw"),

  // ── 비밀번호 재설정 ──
  resetView:    document.getElementById("reset-view"),
  rEmail:       document.getElementById("r-email"),
  rEmailError:  document.getElementById("r-email-error"),
  rCodeField:   document.getElementById("r-code-field"),
  rCode:        document.getElementById("r-code"),
  rTimer:       document.getElementById("r-timer"),
  rPw:          document.getElementById("r-pw"),
  rPwEye:       document.getElementById("r-pw-eye"),
  rPwChecklist: document.getElementById("r-pw-checklist"),

  // ── 회원가입 ──
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

/* ============================================================
   ② STATE — 앱 상태 관리
============================================================ */
const STATE = {
  nickChecked:         false,  // 닉네임 중복확인 완료 여부
  codeVerified:        false,  // 인증코드 확인 완료 여부
  serverGeneratedCode: "",     // 서버에서 발급된 6자리 코드 임시 저장
  timers:              {},     // 타이머 interval ID 모음
};

/* ============================================================
   ③ API — 서버 통신
============================================================ */
const CP = document.querySelector("meta[name='ctx']")?.content || "eze";
console.log("현재 설정된 ContextPath:", CP);

const API = {

  // 반환값: 0(실패) / 1(성공) / 2(이메일 미인증)
  async login(email, pw) {
    const params = new URLSearchParams();
    params.append("email", email);
    params.append("password", pw);
    const res = await fetch(CP + "/login", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: params,
    });
    return await res.json();
  },

  // 반환값: 0(사용가능) / 1이상(중복)
  async checkNick(nick) {
    const res = await fetch(CP + "/checkNickname?nickname=" + encodeURIComponent(nick));
    return await res.json();
  },

  // 공통 코드 발송 — sendSignupCode / sendResetCode 모두 내부적으로 이 fetch 사용
  async _sendCode(email) {
    const params = new URLSearchParams();
    params.append("email", email);
    const res = await fetch(CP + "/sendCode", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: params,
    });
    const serverCode = await res.json();
    if (serverCode && serverCode.toString().trim().length === 6) {
      return { ok: true, code: serverCode.toString().trim() };
    }
    return { ok: false, message: "인증코드 발송에 실패했습니다." };
  },

  // 회원가입용: 이메일 중복 확인 후 코드 발송
  async sendSignupCode(email) {
    const dupRes = await fetch(CP + "/checkEmail?email=" + encodeURIComponent(email));
    const dupCnt = await dupRes.json();
    if (dupCnt > 0) return { ok: false, message: "이미 사용 중인 이메일입니다." };
    return this._sendCode(email);
  },

  // 비밀번호 재설정용: 가입된 이메일인지 확인 후 코드 발송
  async sendResetCode(email) {
    const dupRes = await fetch(CP + "/checkEmail?email=" + encodeURIComponent(email));
    const cnt = await dupRes.json();
    if (cnt === 0) return { ok: false, message: "가입되지 않은 이메일입니다." };
    return this._sendCode(email);
  },

  async signup(nick, email, pw) {
    const params = new URLSearchParams();
    params.append("nickname", nick);
    params.append("email", email);
    params.append("password", pw);
    const res = await fetch(CP + "/signup", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: params,
    });
    const result = await res.json();
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

  // 반환값: 1(성공) / 기타(실패)
  async resetPw(email, pw) {
    const params = new URLSearchParams();
    params.append("email", email);
    params.append("password", pw);
    const res = await fetch(CP + "/updatePw", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: params,
    });
    const result = await res.json();
    return result === 1 ? { ok: true } : { ok: false, message: "비밀번호 변경에 실패했습니다." };
  },
};

/* ============================================================
   ④ HELPER — 공통 유틸리티
============================================================ */

// ── 입력 필드 상태 — CSS 클래스만 토글, 인라인 스타일 없음 ──
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

// ── 유효성 정규식 ──
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
function isValidEmail(val) { return EMAIL_RE.test(val); }

const NICK_RE = /^[가-힣a-zA-Z0-9]+$/;
function isValidNick(val) { return NICK_RE.test(val); }

// 이메일 실시간 형식 검사
// - .valid(발송 성공) 상태일 때 input 이벤트 발생 = 재입력 시작 → 초록불만 해제
// - 그 외: 비어있으면 리셋, 형식 오류면 빨간불, 형식 맞으면 리셋 (초록불은 발송 성공 시에만)
function handleEmailInput(input, errorEl) {
  if (input.classList.contains("valid")) { fieldReset(input, errorEl); return; }
  if (!input.value) { fieldReset(input, errorEl); return; }
  isValidEmail(input.value)
    ? fieldReset(input, errorEl)
    : fieldError(input, errorEl, "이메일 형식이 잘못되었습니다.");
}

// ── 인증코드 타이머 ──
function startTimer(timerEl, stateKey) {
  if (STATE.timers[stateKey]) clearInterval(STATE.timers[stateKey]);
  let sec = 300;
  STATE.timers[stateKey] = setInterval(() => {
    const m = Math.floor(sec / 60), s = sec % 60;
    timerEl.textContent = `${m}:${s.toString().padStart(2, "0")}`;
    if (--sec < 0) { clearInterval(STATE.timers[stateKey]); timerEl.textContent = "만료됨"; }
  }, 1000);
}

function stopTimer(timerEl, stateKey) {
  if (STATE.timers[stateKey]) { clearInterval(STATE.timers[stateKey]); STATE.timers[stateKey] = null; }
  timerEl.textContent = "5:00";
}

// ── 비밀번호 조건 체크리스트 ──
const PW_RULES = [
  { key: "letter",  re: /[a-zA-Z]/ },
  { key: "num",     re: /[0-9]/ },
  { key: "special", re: /[!@#$%^&*]/ },
  { key: "len",     test: (v) => v.length >= 8 && v.length <= 20 },
];

function updatePwChecklist(val, prefix) {
  let allOk = true;
  PW_RULES.forEach(({ key, re, test }) => {
    const ok = re ? re.test(val) : test(val);
    if (!ok) allOk = false;
    const el = document.getElementById(`${prefix}check-${key}`);
    if (el) el.className = "pw-check" + (ok ? " ok" : "");
  });
  return allOk;
}

function resetPwChecklist(checklistEl, prefix) {
  PW_RULES.forEach(({ key }) => {
    const el = document.getElementById(`${prefix}check-${key}`);
    if (el) el.className = "pw-check";
  });
  checklistEl.style.display = "none";
}

// ── 비밀번호 보기/숨기기 ──
function togglePwVisibility(inputEl, eyeEl) {
  const show = inputEl.type === "password";
  inputEl.type = show ? "text" : "password";
  eyeEl.innerHTML = show
    ? '<i class="fa-solid fa-eye"></i>'
    : '<i class="fa-solid fa-eye-slash"></i>';
}

// ── 비밀번호 실시간 체크 (회원가입/재설정 공용) ──
// checklistEl: 체크리스트 컨테이너, prefix: "" (회원가입) or "r-" (재설정)
// ── 비밀번호 실시간 체크 공통 로직 ──
function checkPwField(inp, checklistEl, prefix) {
  if (!inp.value) { resetPwChecklist(checklistEl, prefix); fieldReset(inp, null); return; }
  checklistEl.style.display = "flex";
  updatePwChecklist(inp.value, prefix) ? fieldOk(inp, null) : fieldError(inp, null, "");
}

/* ============================================================
   ⑤ 기능 함수
============================================================ */

// ── 로그인 ↔ 회원가입 패널 슬라이드 전환 ──
function changeForm() {
  EL.switchCtn.classList.add("is-gx");
  setTimeout(() => EL.switchCtn.classList.remove("is-gx"), 1500);
  EL.switchCtn.classList.toggle("is-txr");
  EL.switchC1.classList.toggle("is-hidden");
  EL.switchC2.classList.toggle("is-hidden");
  EL.aContainer.classList.toggle("is-txl");
  EL.bContainer.classList.toggle("is-txl");
  EL.bContainer.classList.toggle("is-z200");
}

function socialPopup(platform) { alert("현재 준비 중입니다 :)"); }

// ── 비밀번호 재설정 뷰 전환 ──
function showReset() { EL.loginView.style.display = "none";  EL.resetView.classList.add("active"); }
function hideReset() { EL.loginView.style.display = "flex";  EL.resetView.classList.remove("active"); }

// ── 로그인 모달 ──
function openLoginModal()  { document.getElementById("login-modal-overlay").classList.add("active"); }
function closeLoginModal() { document.getElementById("login-modal-overlay").classList.remove("active"); }

// ── 로그인 ──
async function doLogin() {
  const email = EL.lEmail.value.trim();
  const pw    = EL.lPw.value;
  if (!email || !pw) { alert("이메일과 비밀번호를 입력해주세요."); return; }

  const result = await API.login(email, pw);
  if      (result === 1) { window.location.href = CP + "/main"; }
  else if (result === 2) { alert("이메일 인증이 필요합니다."); }
  else                   { alert("이메일 또는 비밀번호가 올바르지 않습니다."); }
}

// ── 닉네임 중복확인 ──
async function checkNickname() {
  const nick = EL.nickname.value.trim();
  if (!nick)                              { fieldError(EL.nickname, EL.nickError, "닉네임을 입력해주세요."); STATE.nickChecked = false; return; }
  if (nick.length < 2 || nick.length > 10) { fieldError(EL.nickname, EL.nickError, "닉네임은 2~10자로 입력해주세요."); STATE.nickChecked = false; return; }
  if (!isValidNick(nick))                 { fieldError(EL.nickname, EL.nickError, "한글, 영문, 숫자만 사용 가능합니다."); STATE.nickChecked = false; return; }

  const result = await API.checkNick(nick);
  if (result > 0) {
    fieldError(EL.nickname, EL.nickError, "이미 사용 중인 닉네임입니다.");
    STATE.nickChecked = false;
  } else {
    fieldOk(EL.nickname, EL.nickError);
    STATE.nickChecked = true;
    alert("사용 가능한 닉네임입니다!"); // alert는 fieldOk 뒤에 — focus 이탈로 글로우 덮어씌워지는 것 방지
  }
}

// ── 회원가입 인증코드 발송 ──
async function sendCode() {
  const email = EL.sEmail.value.trim();
  if (!STATE.nickChecked)   { alert("닉네임 중복확인을 먼저 해주세요."); return; }
  if (!email)               { alert("이메일을 입력해주세요."); return; }
  if (!isValidEmail(email)) { alert("올바른 이메일을 입력해주세요."); return; }

  const result = await API.sendSignupCode(email);
  if (!result.ok) { fieldError(EL.sEmail, EL.sEmailError, result.message); return; }

  STATE.serverGeneratedCode = result.code;
  STATE.codeVerified = false;
  EL.sCode.value = "";
  fieldReset(EL.sCode, null);
  fieldOk(EL.sEmail, EL.sEmailError);
  EL.sCodeField.style.display = "block";
  startTimer(EL.sTimer, "signup");
  alert("[임시 인증번호] : " + STATE.serverGeneratedCode + "\n화면 하단에 입력해주세요."); // alert 마지막으로 이동
}

// ── 인증코드 실시간 검증 (회원가입 / 비밀번호 재설정 공용) ──
function checkCode(inp) {
  const val = inp.value.trim();
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

// ── 회원가입 완료 ──
async function doSignup() {
  const nick  = EL.nickname.value.trim();
  const email = EL.sEmail.value.trim();
  const code  = EL.sCode.value.trim();
  const pw    = EL.sPw.value;

  if (!nick)                                       { alert("닉네임을 입력해주세요."); return; }
  if (!STATE.nickChecked)                          { alert("닉네임 중복확인을 해주세요."); return; }
  if (EL.nickname.classList.contains("invalid"))   { alert("닉네임을 확인해주세요."); return; }
  if (!email)                                      { alert("이메일을 입력해주세요."); return; }
  if (EL.sEmail.classList.contains("invalid"))     { alert("올바른 이메일을 입력해주세요."); return; }
  if (!code)                                       { alert("인증코드를 입력해주세요."); return; }
  if (!STATE.codeVerified)                         { alert("인증코드가 일치하지 않습니다."); return; }
  if (!pw || EL.sPw.classList.contains("invalid")) { alert("비밀번호 조건을 확인해주세요."); return; }

  const result = await API.signup(nick, email, pw);
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

// ── 가입 완료 → 로그인 탭으로 이동 ──
function goLogin() {
  EL.signupSuccess.classList.add("slide-out");
  if (EL.switchCtn.classList.contains("is-txr")) changeForm();
  setTimeout(() => {
    EL.signupSuccess.classList.remove("active", "slide-out");
    EL.signupView.style.display = "flex";
    STATE.nickChecked = false;
  }, 1250);
}

// ── 비밀번호 재설정 인증코드 발송 ──
async function sendReset() {
  const email = EL.rEmail.value.trim();
  if (!email)               { fieldError(EL.rEmail, EL.rEmailError, "이메일을 입력해주세요."); return; }
  if (!isValidEmail(email)) { fieldError(EL.rEmail, EL.rEmailError, "이메일 형식이 잘못되었습니다."); return; }

  const result = await API.sendResetCode(email);
  if (!result.ok) { fieldError(EL.rEmail, EL.rEmailError, result.message); return; }

  STATE.serverGeneratedCode = result.code;
  STATE.codeVerified = false;
  EL.rCode.value = "";
  fieldReset(EL.rCode, null);
  fieldOk(EL.rEmail, EL.rEmailError);
  EL.rCodeField.style.display = "block";
  startTimer(EL.rTimer, "reset");
  alert("[비밀번호 재설정 번호] : " + STATE.serverGeneratedCode + "\n입력창에 적어주세요."); // alert 마지막으로 이동
}

// ── 비밀번호 변경 완료 ──
async function doReset() {
  const email = EL.rEmail.value.trim();
  const code  = EL.rCode.value.trim();
  const pw    = EL.rPw.value;

  if (!code)                                       { alert("인증코드를 입력해주세요."); return; }
  if (!STATE.codeVerified)                         { alert("인증코드가 일치하지 않습니다."); return; }
  if (!pw || EL.rPw.classList.contains("invalid")) { alert("비밀번호 조건을 확인해주세요."); return; }

  const result = await API.resetPw(email, pw);
  if (!result.ok) { alert(result.message); return; }

  // 초기화 후 alert
  EL.rPw.value   = "";
  EL.rCode.value = "";
  fieldReset(EL.rPw, null);
  fieldReset(EL.rEmail, EL.rEmailError);
  EL.rCodeField.style.display = "none";
  stopTimer(EL.rTimer, "reset");
  resetPwChecklist(EL.rPwChecklist, "r-");
  STATE.codeVerified        = false;
  STATE.serverGeneratedCode = "";
  hideReset();
  alert("비밀번호가 성공적으로 변경되었습니다!\n새로운 비밀번호로 로그인해주세요.");
}

/* ============================================================
   ⑥ INIT — 이벤트 리스너 등록
============================================================ */
window.addEventListener("load", () => {
  // 폼 submit 기본 동작 방지
  EL.submitBtns.forEach((b) => b.addEventListener("click", (e) => e.preventDefault()));

  // 패널 전환 버튼
  EL.switchBtns.forEach((b) => b.addEventListener("click", changeForm));

  // 이메일 실시간 형식 검사 (회원가입 / 비밀번호 재설정 공용)
  EL.sEmail.addEventListener("input", () => handleEmailInput(EL.sEmail, EL.sEmailError));
  EL.rEmail.addEventListener("input", () => handleEmailInput(EL.rEmail, EL.rEmailError));

  // 닉네임 실시간 검사 (중복확인은 버튼 클릭으로)
  EL.nickname.addEventListener("input", () => {
    STATE.nickChecked = false;
    const nick = EL.nickname.value.trim();
    if (!nick)            { fieldReset(EL.nickname, EL.nickError); return; }
    if (!isValidNick(nick)) fieldError(EL.nickname, EL.nickError, "한글, 영문, 숫자만 사용 가능합니다.");
    else                    fieldReset(EL.nickname, EL.nickError);
  });

  // 비밀번호 실시간 체크 — checkPwField로 통합
  if (EL.sPw)    EL.sPw.addEventListener("input",   () => checkPwField(EL.sPw, EL.sPwChecklist, ""));
  if (EL.rPw)    EL.rPw.addEventListener("input",   () => checkPwField(EL.rPw, EL.rPwChecklist, "r-"));

  // 인증코드 실시간 검증 (공용 checkCode 사용)
  if (EL.sCode)  EL.sCode.addEventListener("input",  () => checkCode(EL.sCode));
  if (EL.rCode)  EL.rCode.addEventListener("input",  () => checkCode(EL.rCode));

  // 비밀번호 눈 아이콘 토글
  if (EL.sPwEye) EL.sPwEye.addEventListener("click", () => togglePwVisibility(EL.sPw, EL.sPwEye));
  if (EL.rPwEye) EL.rPwEye.addEventListener("click", () => togglePwVisibility(EL.rPw, EL.rPwEye));
});
