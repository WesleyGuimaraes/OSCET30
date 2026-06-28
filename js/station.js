/* Renderização da estação (papéis avaliador/estudante), timer e resultado. */

import { state, isEvaluator } from "./store.js";
import { $, escapeHtml, nl, show } from "./util.js";
import { sendMsg } from "./connection.js";

// ---------- estação ----------
export function startStation() {
  clearInterval(state.timer.intervalId); // limpa timer da estação anterior
  state.timer.running = false;
  const c = state.caseObj;
  $("#stProgress").textContent = state.prog.total
    ? `Estação ${state.prog.n} de ${state.prog.total}`
    : `Estação ${state.prog.n}`;
  $("#stCaseTitle").textContent = c.titulo;
  // a especialidade/conteúdo é uma dica do diagnóstico — só o avaliador vê
  $("#stCaseSub").textContent = isEvaluator() ? c.especialidade : "";
  if (!state.timer.remaining) state.timer.remaining = c.tempo;
  renderTimer();

  // layout conforme o papel: avaliador vê roteiro + checklist (2 colunas);
  // estudante vê só as instruções em coluna única
  const isEval = isEvaluator();
  $("#sideChecklistPanel").classList.toggle("hidden", !isEval);
  $(".station-grid").classList.toggle("single", !isEval);

  renderRolePanel();
  $("#timerCtrls").style.display = isEval ? "flex" : "none";
  $("#btnFinish").classList.toggle("hidden", !isEval);
  // só quem criou a sala controla a fila de estações
  $("#skipCtrls").classList.toggle("hidden", state.role !== "host");

  // abas (celular): só o avaliador (roteiro + checklist) tem; começa no Roteiro
  $("#stationTabs").classList.toggle("hidden", !isEval);
  if (isEval) {
    setStationTab("roteiro");
    updateChecklistTabCount();
  } else {
    $(".station-grid").classList.remove("show-roteiro", "show-checklist");
  }
  show("station");
}

// alterna qual painel aparece no celular (Roteiro ⇄ Checklist) + estado das abas
export function setStationTab(which) {
  const grid = $(".station-grid");
  grid.classList.toggle("show-roteiro", which === "roteiro");
  grid.classList.toggle("show-checklist", which === "checklist");
  $("#tabRoteiro").classList.toggle("active", which === "roteiro");
  $("#tabChecklist").classList.toggle("active", which === "checklist");
}

// atualiza o contador "marcados/total" no rótulo da aba Checklist
export function updateChecklistTabCount() {
  const total = (state.caseObj && state.caseObj.checklist.length) || 0;
  const done = Object.values(state.scores).filter(Boolean).length;
  const el = $("#tabChkCount");
  if (el) el.textContent = total ? `${done}/${total}` : "";
}

function renderRolePanel() {
  const c = state.caseObj;
  const p = $("#rolePanel");
  if (!isEvaluator()) {
    const dica = "Conduza pessoalmente ou por chamada de voz com o avaliador: apresente-se, colha a história, levante hipóteses e oriente.";
    p.innerHTML = `<h3>Instruções ao estudante</h3>
      <div class="block queixa-principal"><div class="label">Queixa principal</div>${escapeHtml(c.queixaPrincipal)}</div>
      <div class="block">${nl(c.resumo)}</div>
      <div class="block"><div class="label">Dica</div>${dica}</div>`;
  } else {
    const pac = c.paciente;
    // o checklist agora sempre fica no painel ao lado (#sideChecklist),
    // nunca embutido aqui — coluna própria em qualquer modo
    p.innerHTML = `<h3>Roteiro do paciente — confidencial</h3>
      <div class="block queixa-principal"><div class="label">Queixa principal</div>${escapeHtml(c.queixaPrincipal)}</div>
      <div class="block"><div class="label">Personagem</div>${escapeHtml(pac.personagem)}<br>${nl(pac.contexto)}</div>
      <div class="block"><div class="label">O que revelar (conforme perguntado)</div>
        <ul>${pac.roteiro.map((r) => `<li>${escapeHtml(r)}</li>`).join("")}</ul></div>
      <div class="block"><div class="label">Achados de exame (se solicitado)</div>
        <div class="achados">${escapeHtml(pac.examesAchados)}</div></div>`;
    renderChecklist("#sideChecklist");
  }
}

function renderChecklist(targetSel) {
  const box = $(targetSel);
  if (!box) return;
  box.innerHTML = "";
  state.caseObj.checklist.forEach((item, i) => {
    const row = document.createElement("div");
    row.className = "chk";
    row.innerHTML = `<input type="checkbox" id="chk${i}">
      <label for="chk${i}">${escapeHtml(item.item)}</label>
      <span class="pts">${item.peso} pt</span>`;
    row.querySelector("input").onchange = (e) => { state.scores[i] = e.target.checked; updateChecklistTabCount(); };
    box.appendChild(row);
  });
}

// ---------- timer ----------
export function renderTimer() {
  const t = state.timer.remaining;
  const m = String(Math.floor(t / 60)).padStart(2, "0");
  const s = String(t % 60).padStart(2, "0");
  const el = $("#timer");
  el.textContent = `${m}:${s}`;
  el.classList.toggle("low", t <= 60);
}

function tick() {
  if (state.timer.remaining > 0) {
    state.timer.remaining--;
    renderTimer();
    broadcastTimer();
    if (state.timer.remaining === 0) pauseTimer();
  }
}

export function broadcastTimer() {
  sendMsg({ t: "timer", remaining: state.timer.remaining, running: state.timer.running });
}

// contagem local do ALUNO entre as sincronizações do professor (resiliente a
// perda de pacotes): inicia/para conforme o último estado recebido.
export function studentTimerSync() {
  clearInterval(state.timer.intervalId);
  if (state.timer.running && state.timer.remaining > 0) {
    state.timer.intervalId = setInterval(() => {
      if (state.timer.remaining > 0) {
        state.timer.remaining--;
        renderTimer();
      } else {
        clearInterval(state.timer.intervalId);
      }
    }, 1000);
  }
}

export function startTimer() {
  if (state.timer.running) return;
  state.timer.running = true;
  state.timer.intervalId = setInterval(tick, 1000);
  broadcastTimer();
}

export function pauseTimer() {
  state.timer.running = false;
  clearInterval(state.timer.intervalId);
  broadcastTimer();
}

export function resetTimer() {
  pauseTimer();
  state.timer.remaining = state.caseObj.tempo;
  renderTimer();
  broadcastTimer();
}

// ---------- resultado da estação ----------
export function computeResult() {
  const items = state.caseObj.checklist.map((it, i) => ({
    item: it.item, peso: it.peso, ok: !!state.scores[i],
  }));
  const max = items.reduce((a, b) => a + b.peso, 0);
  const total = items.reduce((a, b) => a + (b.ok ? b.peso : 0), 0);
  return { items, max, total };
}

export function veredito(pct) {
  return pct >= 70 ? "Aprovado" : pct >= 50 ? "Limítrofe" : "Insuficiente";
}

// mostra o resultado e, se eu for o HOST (dono da sessão), guarda no resumo —
// independentemente de quem avaliou a estação (host ou guest).
export function storeAndShow(total, max, items) {
  if (state.role === "host") {
    state.session.results.push({ titulo: state.caseObj.titulo, total, max });
  }
  showStationResult(total, max, items);
}

function showStationResult(total, max, items) {
  const pct = max ? Math.round((total / max) * 100) : 0;
  $("#resultBody").innerHTML =
    `<div class="score-big">${total}/${max} <span style="font-size:1.1rem;color:var(--muted)">(${pct}%) — ${veredito(pct)}</span></div>
     <div style="margin-top:14px">` +
    items.map((it) =>
      `<div class="res-row"><span>${escapeHtml(it.item)}</span>
       <span class="${it.ok ? "ok" : "no"}">${it.ok ? "✓ " + it.peso : "✗ 0"}</span></div>`).join("") +
    `</div>`;

  // prepara o handshake de "pronto"
  state.ready.self = false;
  const box = document.querySelector(".ready-box");
  box.classList.remove("done");
  $("#btnReady").disabled = false;
  $("#readyMsg").textContent = "";
  $("#btnRestart").classList.toggle("hidden", state.role !== "host");
  show("result");
}

// ---------- resumo da sessão ----------
export function showSummary(results) {
  const body = $("#summaryBody");
  if (!results || !results.length) {
    body.innerHTML = "<p>Nenhuma estação concluída.</p>";
  } else {
    const total = results.reduce((a, r) => a + r.total, 0);
    const max = results.reduce((a, r) => a + r.max, 0);
    const pct = max ? Math.round((total / max) * 100) : 0;
    body.innerHTML =
      results.map((r, i) => {
        const p = r.max ? Math.round((r.total / r.max) * 100) : 0;
        return `<div class="sum-row"><span>${i + 1}. ${escapeHtml(r.titulo)}</span>
          <span class="sum-score">${r.total}/${r.max} (${p}%)</span></div>`;
      }).join("") +
      `<div class="sum-total">Total: ${total}/${max} (${pct}%) — ${veredito(pct)}</div>`;
  }
  show("summary");
}
