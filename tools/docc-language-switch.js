// Language switch for the DocC site. tools/docc-language-switch.sh copies this file to the site root
// and loads it from every page with data-lang (the page's language) and data-base (the hosting base path).
// The Japanese site lives at <base>, the English one at <base>en/, with the same paths below them.
(function () {
  var script = document.currentScript;
  var lang = script.getAttribute("data-lang") === "en" ? "en" : "ja";
  var base = script.getAttribute("data-base");
  var enBase = base + "en/";

  // The same page in the other language. Computed when used, because DocC changes pages without reloading.
  function counterpart() {
    var path = location.pathname;
    var from = lang === "en" ? enBase : base;
    var to = lang === "en" ? base : enBase;
    var rest = path.indexOf(from) === 0 ? path.slice(from.length) : "";
    return to + rest + location.search + location.hash;
  }

  // DocC's renderer sets <html lang> itself; keep it on the page's real language.
  var root = document.documentElement;
  function keepLang() {
    if (root.getAttribute("lang") !== lang) root.setAttribute("lang", lang);
  }
  keepLang();
  new MutationObserver(keepLang).observe(root, { attributes: true, attributeFilter: ["lang"] });

  var style = document.createElement("style");
  style.textContent =
    ".docc-language-switch{position:fixed;right:16px;bottom:16px;z-index:10000;" +
    "display:inline-flex;align-items:center;gap:6px;padding:8px 14px;border-radius:999px;" +
    "font:500 14px/1.2 -apple-system,BlinkMacSystemFont,'Hiragino Sans','Helvetica Neue',sans-serif;" +
    "text-decoration:none;color:#1d1d1f;background:rgba(255,255,255,.92);" +
    "border:1px solid rgba(0,0,0,.15);box-shadow:0 2px 8px rgba(0,0,0,.12);" +
    "-webkit-backdrop-filter:blur(8px);backdrop-filter:blur(8px)}" +
    ".docc-language-switch:hover{text-decoration:none;background:#fff}" +
    ".docc-language-switch:focus-visible{outline:2px solid #0071e3;outline-offset:2px}" +
    "@media (prefers-color-scheme:dark){.docc-language-switch{color:#f5f5f7;" +
    "background:rgba(29,29,31,.92);border-color:rgba(255,255,255,.2)}" +
    ".docc-language-switch:hover{background:#2c2c2e}}" +
    "@media print{.docc-language-switch{display:none}}";

  var link = document.createElement("a");
  link.className = "docc-language-switch";
  link.lang = lang === "en" ? "ja" : "en";
  link.hreflang = link.lang;
  link.textContent = lang === "en" ? "日本語" : "English";
  link.setAttribute("aria-label", lang === "en" ? "日本語で読む" : "Read in English");
  link.href = counterpart();
  ["pointerenter", "focus", "mousedown", "touchstart", "contextmenu"].forEach(function (type) {
    link.addEventListener(type, function () { link.href = counterpart(); }, { passive: true });
  });
  link.addEventListener("click", function () { link.href = counterpart(); });

  function mount() {
    document.head.appendChild(style);
    document.body.appendChild(link);
  }
  if (document.body) mount();
  else document.addEventListener("DOMContentLoaded", mount);
})();
