document.addEventListener("DOMContentLoaded", function () {
  var root = document.documentElement;
  var body = document.body;
  var listToggleBtn = document.getElementById("listToggleBtn");
  var playlistList = document.getElementById("playlistList");
  var confirmBtn = document.getElementById("confirmBtn");
  var cancelBtn = document.getElementById("cancelBtn");
  var sampleInput = document.getElementById("sampleInput");
  var modalConfirmBtn = document.getElementById("modalConfirmBtn");
  var statusMessage = document.getElementById("statusMessage");
  var darkModeToggle = document.getElementById("darkModeToggle");
  var themeButtons = document.querySelectorAll(".theme-choice-btn");
  var currentTheme = "blue";

  var themePalette = {
    blue: {
      light: {
        page: ["#dbeafe", "#93c5fd", "#3b82f6"],
        button: ["#2563eb", "#2563eb", "#1d4ed8", "#1d4ed8"]
      },
      dark: {
        page: ["#0f172a", "#1e3a8a", "#1d4ed8"],
        button: ["#2563eb", "#2563eb", "#1d4ed8", "#1d4ed8"]
      }
    },
    orange: {
      light: {
        page: ["#ffedd5", "#fdba74", "#f97316"],
        button: ["#ea580c", "#ea580c", "#c2410c", "#c2410c"]
      },
      dark: {
        page: ["#431407", "#9a3412", "#ea580c"],
        button: ["#ea580c", "#ea580c", "#c2410c", "#c2410c"]
      }
    },
    gradient: {
      light: {
        page: ["#dbeafe", "#93c5fd", "#fdba74"],
        button: [
          "linear-gradient(90deg, #2563eb 0%, #ea580c 100%)",
          "#2563eb",
          "linear-gradient(90deg, #1d4ed8 0%, #c2410c 100%)",
          "#1d4ed8"
        ]
      },
      dark: {
        page: ["#0f172a", "#1e3a8a", "#9a3412"],
        button: [
          "linear-gradient(90deg, #2563eb 0%, #ea580c 100%)",
          "#2563eb",
          "linear-gradient(90deg, #1d4ed8 0%, #c2410c 100%)",
          "#1d4ed8"
        ]
      }
    }
  };

  function setStatus(text, level) {
    statusMessage.className = "alert mt-4 mb-0 alert-" + level;
    statusMessage.textContent = "상태: " + text;
  }

  function applyTheme(themeName) {
    var mode = darkModeToggle.checked ? "dark" : "light";
    var selected = themePalette[themeName][mode];

    root.style.setProperty("--page-bg-start", selected.page[0]);
    root.style.setProperty("--page-bg-mid", selected.page[1]);
    root.style.setProperty("--page-bg-end", selected.page[2]);
    root.style.setProperty("--action-primary-bg", selected.button[0]);
    root.style.setProperty("--action-primary-border", selected.button[1]);
    root.style.setProperty("--action-primary-hover-bg", selected.button[2]);
    root.style.setProperty("--action-primary-hover-border", selected.button[3]);

    themeButtons.forEach(function (button) {
      var isActive = button.getAttribute("data-theme") === themeName;
      button.classList.toggle("active", isActive);
    });
  }

  listToggleBtn.addEventListener("click", function (event) {
    event.preventDefault();
    playlistList.classList.toggle("d-none");
    setStatus("링크 버튼으로 리스트 노출을 전환했습니다.", "info");
  });

  confirmBtn.addEventListener("click", function () {
    setStatus("확인 버튼 액션이 실행되었습니다. (예: 로그인/저장)", "success");
  });

  cancelBtn.addEventListener("click", function () {
    sampleInput.value = "";
    setStatus("취소 버튼으로 입력값을 초기화했습니다.", "dark");
  });

  modalConfirmBtn.addEventListener("click", function () {
    setStatus("일반(흰색) 버튼으로 알림 확인을 완료했습니다.", "secondary");
  });

  themeButtons.forEach(function (button) {
    button.addEventListener("click", function () {
      currentTheme = button.getAttribute("data-theme");
      applyTheme(currentTheme);
      setStatus("테마 컬러를 변경했습니다.", "primary");
    });
  });

  darkModeToggle.addEventListener("change", function () {
    body.classList.toggle("dark-mode", darkModeToggle.checked);
    applyTheme(currentTheme);
    setStatus("다크 모드가 전환되었습니다.", "warning");
  });

  applyTheme(currentTheme);
});






