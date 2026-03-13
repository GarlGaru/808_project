document.addEventListener("DOMContentLoaded", function () {
  var root = document.documentElement;
  var body = document.body;
  var darkModeToggle = document.getElementById("darkModeToggle");
  var statusMessage = document.getElementById("statusMessage");

  function applyDarkMode(isDark) {
    if (isDark) {
      root.setAttribute("data-theme", "dark");
      if (body) {
        body.classList.add("dark-mode");
      }
    } else {
      root.removeAttribute("data-theme");
      if (body) {
        body.classList.remove("dark-mode");
      }
    }
  }

  // 기본값은 dark mode
  applyDarkMode(true);

  // 토글이 존재하면 dark mode on/off 만 담당
  if (darkModeToggle) {
    darkModeToggle.checked = true;

    darkModeToggle.addEventListener("change", function () {
      applyDarkMode(darkModeToggle.checked);
    });
  }
});