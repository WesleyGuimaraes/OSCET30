/* Ponto de entrada: carrega os casos, fia os eventos da UI e o diagnóstico
   de conexão. Importa os módulos do jogo (sessão, estação, conexão). */

import { state, loadCases, casesGuard, isEvaluator, getCases, casesReadyPromise } from "./store.js";
import { $, $$, show } from "./util.js";
import {
  startHost, startSession, startGuest,
  hostStartNext, hostEndSession, checkAdvance,
} from "./session.js";
import { startTimer, pauseTimer, resetTimer, computeResult, storeAndShow } from "./station.js";
import { sendMsg, testRealtime } from "./connection.js";

// começa a carregar os casos publicados do Supabase logo de cara
loadCases();

// ---------- CONFIGURAR TREINO (host) ----------
// A tela de config é a entrada do app. O host escolhe modo, conteúdos e
// tempo aqui mesmo e clica em "Iniciar treino" para criar a sala.
let selMode = "conteudos";
let selTime = "8";            // minutos (string; "custom" abre input)
const selTags = new Set();

// chips de conteúdo vêm dos casos publicados (não são fixos)
function renderConteudosChips() {
  const tags = [...new Set(getCases().map((c) => c.conteudos[0]).filter(Boolean))].sort();
  const box = $("#chips");
  box.innerHTML = "";
  tags.forEach((t) => {
    const el = document.createElement("span");
    el.className = "chip";
    el.dataset.topic = t;
    el.innerHTML = `<span class="ck">✓</span>${t}`;
    el.onclick = () => {
      if (selTags.has(t)) selTags.delete(t); else selTags.add(t);
      el.classList.toggle("sel");
      updateTopicsCount();
    };
    box.appendChild(el);
  });
  updateTopicsCount();
}

function updateTopicsCount() {
  const el = $("#topicsCount");
  if (selMode !== "conteudos") { el.textContent = "Sorteio automático"; return; }
  const n = selTags.size;
  el.textContent = n === 0 ? "Nenhum selecionado" : n + (n === 1 ? " selecionado" : " selecionados");
}

function applyModeUI() {
  const enabled = selMode === "conteudos";
  $("#chips").classList.toggle("hidden", !enabled);
  $("#autoNote").classList.toggle("hidden", enabled);
  if (!enabled) {
    $("#autoNoteText").textContent = selMode === "aleatoria"
      ? "Uma estação sorteada por vez, com conteúdos aleatórios, sem fim."
      : "Todas as estações, sem repetir, com conteúdos sorteados, até acabarem.";
  }
  updateTopicsCount();
}

$$("#modes .mode").forEach((el) => {
  el.onclick = () => {
    selMode = el.dataset.mode;
    $$("#modes .mode").forEach((m) => m.classList.toggle("sel", m === el));
    applyModeUI();
  };
});

$$("#times .time").forEach((el) => {
  el.onclick = () => {
    selTime = el.dataset.time;
    $$("#times .time").forEach((t) => t.classList.toggle("sel", t === el));
    $("#customTimeWrap").classList.toggle("hidden", selTime !== "custom");
  };
});

$("#btnIniciar").onclick = () => {
  if (!casesGuard()) return;
  if (selMode === "conteudos" && selTags.size === 0) {
    $("#cfgMsg").textContent = "Selecione ao menos um conteúdo.";
    return;
  }
  let mins = selTime;
  if (selTime === "custom") {
    mins = parseInt($("#customTime").value, 10);
    if (!mins || mins < 1) { $("#cfgMsg").textContent = "Informe um tempo válido (em minutos)."; return; }
  }
  $("#cfgMsg").textContent = "";
  startSession(selMode, [...selTags], Number(mins));
};

// inicializa o setup (papel host + aviso de casos) e renderiza os chips
// quando os casos publicados terminarem de carregar
startHost();
casesReadyPromise.then(() => { startHost(); renderConteudosChips(); applyModeUI(); });

// ---------- estudante: revelar e entrar com código ----------
$("#linkStudent").onclick = () => {
  const box = $("#joinBox");
  box.classList.toggle("hidden");
  if (!box.classList.contains("hidden")) $("#joinCode").focus();
};

$("#btnJoin").onclick = () => {
  const code = $("#joinCode").value.trim().toUpperCase();
  if (code.length < 4) { $("#lobbyMsg").textContent = "Digite o código da sala."; return; }
  startGuest(code);
};
$("#joinCode").addEventListener("keydown", (e) => { if (e.key === "Enter") $("#btnJoin").click(); });

// ---------- copiar código / link ----------
$("#btnCopy").onclick = () => {
  navigator.clipboard.writeText($("#roomCode").textContent);
  $("#btnCopy").textContent = "copiado!";
  setTimeout(() => ($("#btnCopy").textContent = "copiar"), 1500);
};
$("#btnCopyLink").onclick = () => {
  navigator.clipboard.writeText($("#inviteLink").href);
  $("#btnCopyLink").textContent = "copiado!";
  setTimeout(() => ($("#btnCopyLink").textContent = "copiar link"), 1500);
};

// abriu via link de convite (?sala=CODE): pré-preenche o código para o estudante
(() => {
  const code = new URLSearchParams(location.search).get("sala");
  if (code) {
    $("#joinBox").classList.remove("hidden");
    $("#joinCode").value = code.toUpperCase();
    $("#lobbyMsg").textContent = "Código preenchido — toque em \"Entrar\" para conectar.";
    $("#joinCode").scrollIntoView({ behavior: "smooth", block: "center" });
  }
})();

// ---------- timer (avaliador) ----------
$("#btnStart").onclick = startTimer;
$("#btnPause").onclick = pauseTimer;
$("#btnReset").onclick = resetTimer;

// ---------- encerrar e avaliar ----------
$("#btnFinish").onclick = () => {
  if (!isEvaluator()) return;
  pauseTimer();
  const r = computeResult();
  sendMsg({ t: "finish", total: r.total, max: r.max, items: r.items });
  storeAndShow(r.total, r.max, r.items); // host guarda; guest só mostra
};

// host pula a estação atual sem aguardar avaliação/"prontos" dos dois lados
$("#btnSkipKeep").onclick = () => {
  if (state.role !== "host") return;
  hostStartNext("keep");
};
$("#btnSkipAlt").onclick = () => {
  if (state.role !== "host") return;
  hostStartNext("toggle");
};

// "pronto para a próxima"
$("#btnReady").onclick = () => {
  $("#btnReady").disabled = true;
  document.querySelector(".ready-box").classList.add("done");
  if (state.role === "host") {
    state.ready.host = true;
    $("#readyMsg").textContent = state.ready.guest ? "Iniciando…" : "Aguardando o estudante…";
    checkAdvance();
  } else {
    state.ready.self = true;
    $("#readyMsg").textContent = "Aguardando o avaliador iniciar a próxima…";
    sendMsg({ t: "ready" });
  }
};

// host encerra a sessão manualmente (sobretudo no modo aleatório)
$("#btnRestart").onclick = () => hostEndSession();
$("#btnNewSession").onclick = () => location.reload();

// ---------- diagnóstico de conexão ----------
// Verifica se o Realtime do Supabase (o transporte da sessão) está acessível
// nesta rede — é o que precisa funcionar na faculdade.
function testConnection() {
  const out = $("#connResult");
  out.className = "conn-result show";
  out.innerHTML = "⏳ Testando conexão… (uns segundos)";
  testRealtime((ok) => {
    out.className = "conn-result show " + (ok ? "ok" : "bad");
    out.innerHTML = ok
      ? "✅ <b>Conexão OK</b> — o servidor de tempo real está acessível nesta rede. O jogo deve funcionar normalmente."
      : "❌ <b>Esta rede está bloqueando a conexão</b> com o servidor. Tente os dados móveis (4G/5G) do celular ou outra rede.";
  });
}
$("#btnTestConn").onclick = testConnection;
