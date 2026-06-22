/* Helpers de DOM e utilidades puras, sem estado nem dependências. */

export const $ = (s) => document.querySelector(s);
export const $$ = (s) => document.querySelectorAll(s);

// navegação entre as telas (.screen)
export function show(id) {
  $$(".screen").forEach((s) => s.classList.remove("active"));
  $("#" + id).classList.add("active");
}

export function setStatus(text, cls) {
  const el = $("#status");
  el.textContent = text;
  el.className = "status " + cls;
}

export function shuffle(arr) {
  const a = arr.slice();
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

export function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, (m) =>
    ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[m]));
}

export function nl(s) {
  return escapeHtml(s).replace(/\n/g, "<br>");
}

// código de sala legível (sem caracteres ambíguos)
export function makeCode() {
  const c = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  let s = "";
  for (let i = 0; i < 5; i++) s += c[Math.floor(Math.random() * c.length)];
  return s;
}
